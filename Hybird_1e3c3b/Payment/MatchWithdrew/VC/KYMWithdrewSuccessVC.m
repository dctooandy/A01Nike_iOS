//
//  KYMWithdrewSuccessVC.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/21.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrewSuccessVC.h"
#import "KYMWidthdrewUtility.h"
#import "KYMWithdrawAlertVC.h"
#import "KYMWithdrewRequest.h"

@interface KYMWithdrewSuccessVC ()

@property (weak, nonatomic) IBOutlet UILabel *amountLB;
@property (weak, nonatomic) IBOutlet UILabel *notifyLB;
@property (weak, nonatomic) IBOutlet UIButton *goBackBtn;

@end

@implementation KYMWithdrewSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"取款申请";
    CGFloat amount = [self.amountStr doubleValue];
    self.amountLB.text = [KYMWidthdrewUtility getMoneyString:amount];
    self.notifyLB.text = [NSString stringWithFormat:@"您将获得%0.2lf元取款礼金，24小时到账",amount * 0.005];
    
    self.goBackBtn.layer.cornerRadius = 6;
    self.goBackBtn.layer.masksToBounds = YES;
    self.goBackBtn.layer.borderWidth = 1;
    self.goBackBtn.layer.borderColor = [UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0x00 / 255.0 alpha:1].CGColor;
   
}
- (IBAction)goBackUserCenter:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)submitBtnClicked:(id)sender {
    KYMWithdrawAlertVC *vc = [KYMWithdrawAlertVC new];
    __weak typeof(self)weakSelf = self;
    vc.confirmBtnHandler = ^{
        [weakSelf showLoading];
        [KYMWithdrewRequest checkReceiveStats:NO transactionId:weakSelf.transactionId callBack:^(BOOL status, NSString *msg) {
            [weakSelf hideLoading];
            if (status) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [MBProgressHUD showError:msg toView:nil];
            }
        }];
    };
    vc.noConfirmBtnHandler = ^{
        [weakSelf noConfirmGetMathWithdraw];
    };
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)noConfirmGetMathWithdraw
{
    [self showLoading];
    [KYMWithdrewRequest checkReceiveStats:YES transactionId:self.transactionId callBack:^(BOOL status, NSString *msg) {
        [self hideLoading];
        if (status) {
            [self customerBtnClicked:nil];
        } else {
            [MBProgressHUD showError:msg toView:nil];
        }
    }];
}

- (IBAction)customerBtnClicked:(id)sender {
    [CSVisitChatmanager startWithSuperVC:self finish:^(CSServiceCode errCode) {
        if (errCode != CSServiceCode_Request_Suc) {
            [MBProgressHUD showErrorWithTime:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持" toView:nil duration:3];
        } else {

        }
    }];
}

- (void)goToBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
