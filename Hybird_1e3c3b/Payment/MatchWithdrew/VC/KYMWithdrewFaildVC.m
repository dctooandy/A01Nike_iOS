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

@interface KYMWithdrewSuccessVC ()

@property (weak, nonatomic) IBOutlet UILabel *amountLB;
@property (weak, nonatomic) IBOutlet UILabel *notifyLB;

@end

@implementation KYMWithdrewSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"取款申请";
    CGFloat amount = [self.amountStr doubleValue];
    self.amountLB.text = [KYMWidthdrewUtility getMoneyString:amount];
    self.notifyLB.text = [NSString stringWithFormat:@"您将获得%0.2lf元取款礼金，24小时到账",amount * 0.005];
   
}
- (IBAction)submitBtnClicked:(id)sender {
    KYMWithdrawAlertVC *vc = [KYMWithdrawAlertVC new];
    __weak typeof(self)weakSelf = self;
    vc.confirmBtnHandler = ^{
        
    };
    vc.noConfirmBtnHandler = ^{
        [weakSelf customerBtnClicked:nil];
    };
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)customerBtnClicked:(id)sender {
}

- (void)goToBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
