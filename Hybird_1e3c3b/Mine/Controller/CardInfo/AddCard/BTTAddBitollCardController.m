//
//  BTTAddBitollCardController.m
//  Hybird_1e3c3b
//
//  Created by Flynn on 2020/6/2.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTAddBitollCardController.h"
#import "CNPayConstant.h"
#import "IVRsaEncryptWrapper.h"
#import "BTTChangeMobileSuccessController.h"
#import "BTTKSAddBfbWalletController.h"
#import "HAInitConfig.h"

@interface BTTAddBitollCardController ()
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *oneKeyBtn;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (nonatomic, assign) BOOL isWithDraw;
@property (nonatomic, assign) BOOL isSave;

@end

@implementation BTTAddBitollCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isWithDraw = [[NSUserDefaults standardUserDefaults]boolForKey:@"bitollAddCard"];
    self.isSave = [[NSUserDefaults standardUserDefaults]boolForKey:@"bitollAddCardSave"];
    self.title = @"添加小金库钱包";
    [self setupViews];
}

- (void)setupViews{
    self.view.backgroundColor = kBlackBackgroundColor;
    self.infoView.backgroundColor = kBlackLightColor;
    
    self.confirmBtn.layer.cornerRadius = 6.0;
    self.confirmBtn.layer.borderColor = COLOR_RGBA(243, 130, 50, 1).CGColor;
    self.confirmBtn.layer.borderWidth = 0.5;
    self.confirmBtn.clipsToBounds = YES;
    self.confirmBtn.backgroundColor = COLOR_RGBA(243, 130, 50, 1);
    
    NSAttributedString *attrStringAccount = [[NSAttributedString alloc] initWithString:@"请输入小金库账号" attributes:
                                          @{ NSForegroundColorAttributeName: COLOR_RGBA(110, 115, 125, 1),
                                             NSFontAttributeName: self.accountField.font }];
    self.accountField.attributedPlaceholder = attrStringAccount;
    
}
- (IBAction)confirmBtn_click:(id)sender {
    [self.view endEditing:YES];
    NSInteger back = [[NSUserDefaults standardUserDefaults]integerForKey:@"BITOLLBACK"];
    
    NSString *url = BTTAddBankCard;
    NSString *firstChar = @"";
    NSString *firstTwochar = @"";
    
    if (_accountField.text.length<6||_accountField.text.length>100) {
        [MBProgressHUD showError:@"小金库ID只允许6-100位大小写英文字母+数字的组合" toView:self.view];
        return;
    }
    
    if (![_accountField.text isEqualToString:@""]) {
        firstChar = [_accountField.text substringWithRange:NSMakeRange(0, 1)];
        firstTwochar = [_accountField.text substringWithRange:NSMakeRange(0, 2)];
    }
    
    weakSelf(weakSelf)
    [self showLoading];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"accountNo"] = _accountField.text;
    params[@"accountType"] = @"DCBOX";
    params[@"bankName"] = @"DCBOX";
    params[@"expire"] = @0;
    params[@"messageId"] = self.messageId;
    params[@"validateId"] = self.validateId;
    
    [IVNetwork requestPostWithUrl:url paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self hideLoading];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [IVLAManager singleEventId:@"A01_bankcard_update" errorCode:@"" errorMsg:@"" customsData:@{}];

            [BTTHttpManager fetchUserInfoCompleteBlock:nil];
            if(self.isSave){
                [IVNetwork savedUserInfo].bfbNum = 1;
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"bitollAddCardSave"];
                [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -back)] animated:YES];

            
            }else{
                [BTTHttpManager fetchBindStatusWithUseCache:NO completionBlock:nil];
                [BTTHttpManager fetchBankListWithUseCache:NO completion:^(id  _Nullable response, NSError * _Nullable error) {
                    if ([IVNetwork savedUserInfo].bankCardNum > 0 || [IVNetwork savedUserInfo].usdtNum > 0||[IVNetwork savedUserInfo].bfbNum>0||[IVNetwork savedUserInfo].dcboxNum>0) {
                        BTTChangeMobileSuccessController *vc = [BTTChangeMobileSuccessController new];
                        vc.mobileCodeType = BTTSafeVerifyTypeMobileBindAddUSDTCard;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    } else {
                        [self.navigationController popToRootViewControllerAnimated:true];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoCardInfoNotification" object:@{@"showAlert":[NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults]boolForKey:@"pressWithdrawAddUSDTCard"]]}];
                    }
                }];
            }
            
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:weakSelf.view];
        }
    }];
}


- (IBAction)oneKeyBtn_click:(id)sender {
    weakSelf(weakSelf)
    BTTKSAddBfbWalletController *vc = [[BTTKSAddBfbWalletController alloc]init];
    vc.success = ^(NSString * _Nonnull accountNo) {
        weakSelf.accountField.text = accountNo;
    };
    [self.navigationController pushViewController:vc animated:YES];
}



@end
