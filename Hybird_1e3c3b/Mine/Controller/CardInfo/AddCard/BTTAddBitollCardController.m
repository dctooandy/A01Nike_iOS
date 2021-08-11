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
#import "BTTCardInfosController.h"
#import "BTTAddBitollCardController+Nav.h"

@interface BTTAddBitollCardController ()
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *withdrawPwdField;
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
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"6位数数字组合" attributes:
                                   @{ NSForegroundColorAttributeName: COLOR_RGBA(110, 115, 125, 1),
                                      NSFontAttributeName: self.accountField.font }];
    self.withdrawPwdField.attributedPlaceholder = attrStr;
    
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
    
    if (![PublicMethod isValidateWithdrawPwdNumber:self.withdrawPwdField.text]) {
        [MBProgressHUD showError:@"输入的资金密码格式有误" toView:self.view];
        return;
    }
    
    weakSelf(weakSelf)
    [self showLoading];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"accountNo"] = _accountField.text;
    params[@"password"] = [IVRsaEncryptWrapper encryptorString:self.withdrawPwdField.text];
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
//                [BTTHttpManager fetchBindStatusWithUseCache:NO completionBlock:nil];
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
            if ([result.head.errCode isEqualToString:@"GW_601596"]) {
                IVActionHandler confirm = ^(UIAlertAction *action){
                };
                NSString *title = @"温馨提示";
                NSString *message = @"资金密码错误，请重新输入！";
                [IVUtility showAlertWithActionTitles:@[@"确认"] handlers:@[confirm] title:title message:message];
                return;
            } else if ([result.head.errCode isEqualToString:@"GW_601640"]) {
                strongSelf(strongSelf);
                [strongSelf showCantBindCardPopView];
                return;
            }
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

- (IBAction)showClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.withdrawPwdField.secureTextEntry = NO;
    } else {
        self.withdrawPwdField.secureTextEntry = YES;
    }
}

- (void)makeCallWithPhoneNum:(NSString *)phone captcha:(NSString *)captcha captchaId:(NSString *)captchaId {
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setValue:captcha forKey:@"captcha"];
    [params setValue:captchaId forKey:@"captchaId"];
    if ([phone containsString:@"*"]) {
        [params setValue:@1 forKey:@"type"];
    } else {
        [params setValue:@0 forKey:@"type"];
    }
    if ([IVNetwork savedUserInfo]) {
        [params setValue:[IVNetwork savedUserInfo].mobileNo forKey:@"mobileNo"];
        [params setValue:[IVNetwork savedUserInfo].loginName forKey:@"loginName"];
    } else {
        [params setValue:phone forKey:@"mobileNo"];
    }
    
    [IVNetwork requestPostWithUrl:BTTCallBackAPI paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [self showCallBackSuccessView];
        }else{
            NSString *errInfo = [NSString stringWithFormat:@"申请失败,%@",result.head.errMsg];
            [MBProgressHUD showError:errInfo toView:nil];
        }
    }];
}

- (void)goToBack {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[BTTCardInfosController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

@end
