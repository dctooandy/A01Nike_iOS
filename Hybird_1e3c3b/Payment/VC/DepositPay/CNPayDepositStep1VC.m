//
//  CNPayDepositStep1VC.m
//  A05_iPhone
//
//  Created by cean.q on 2018/10/1.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayDepositStep1VC.h"
#import "BTTPaymentWarningPopView.h"

@interface CNPayDepositStep1VC ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet CNPayAmountRecommendView *nameView;
@property (weak, nonatomic) IBOutlet UIView *nameAreaView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameAreaViewHeight;
@end

@implementation CNPayDepositStep1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configRecommendView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:350 fullScreen:NO];
}

/// 推荐姓名
- (void)configRecommendView {
    //TODO:
//    if (self.paymentModel.depositor.length == 0) {
//        _nameAreaView.hidden = YES;
//        _nameAreaViewHeight.constant = 0;
//        return;
//    }
//    NSArray *array = [self.paymentModel.depositor componentsSeparatedByString:@";"];
//    if (array.count == 0) {
//        _nameAreaView.hidden = YES;
//        _nameAreaViewHeight.constant = 0;
//        return;
//    }
//    _nameTF.text = array.firstObject;
//    _nameView.dataSource = array;
//    __weak typeof(self) weakSelf = self;
//    _nameView.clickHandler = ^(NSString *value, NSInteger index) {
//        [weakSelf.view endEditing:YES];
//        weakSelf.nameTF.text = value;
//    };
}

- (IBAction)sumbitAction:(UIButton *)sender {
    if (self.nameTF.text.length == 0) {
        [self showError:@"请输入存款人姓名"];
        return;
    }
    [self depositGetBank:sender];
}

- (void)depositGetBank:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    __weak typeof(self) weakSelf = self;
    __weak typeof(sender) weakSender = sender;
    NSDictionary *params = @{@"type":@1,@"loginname":[IVNetwork savedUserInfo].loginName};
    [IVNetwork requestPostWithUrl:BTTQueryManualAccount paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        weakSender.selected = NO;
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSArray *array = result.body[@"bankAccounts"];
            NSArray *bankList = [CNPayBankCardModel arrayOfModelsFromDictionaries:array error:nil];
            if (bankList.count==0) {
                [self showError:result.head.errMsg];
                return;
            }
            weakSelf.writeModel.depositBy = weakSelf.nameTF.text;
            weakSelf.writeModel.bankList = bankList;
            weakSelf.writeModel.chooseBank = bankList.firstObject;
            [weakSelf goToStep:1];
        }else{
            if ([result.head.errCode isEqualToString:@"GW_800705"]) {
                BTTPaymentWarningPopView *pop = [BTTPaymentWarningPopView viewFromXib];
                pop.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                pop.contentStr = @"存款人姓名与绑定姓名不符，无法充值，请填写绑定姓名，或切换必多多账户买币存款";
                BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:pop popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
                popView.isClickBGDismiss = YES;
                [popView pop];
                pop.dismissBlock = ^{
                    [popView dismiss];
                };
                pop.btnBlock = ^(UIButton * _Nullable btn) {
                    //0=>kefu 1=>changeMode
                    [popView dismiss];
                    if (btn.tag == 0) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoKefu" object:nil];
                    } else {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoBack" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeModeNotification" object:nil];
                    }
                };
            } else {
                [weakSelf showError:result.head.errMsg];
            }
        }
    }];
}

@end
