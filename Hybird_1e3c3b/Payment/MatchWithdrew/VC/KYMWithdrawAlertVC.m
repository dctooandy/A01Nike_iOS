//
//  KYMWithdrawAlertVC.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/3/16.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrawAlertVC.h"

@interface KYMWithdrawAlertVC ()

@property (weak, nonatomic) IBOutlet UIButton *noGetMoneyBtn;
@end

@implementation KYMWithdrawAlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noGetMoneyBtn.layer.borderWidth = 1.0;
//    self.noGetMoneyBtn.layer.cornerRadius = 4;
    self.noGetMoneyBtn.layer.borderColor = [UIColor colorWithRed:0xF2 / 255.0 green:0xDA / 255.0 blue:0x0F / 255.0 alpha:1].CGColor;
}
- (IBAction)confirmBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        self.confirmBtnHandler();
    }];
    
}
- (IBAction)noGetMoneyBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        self.noConfirmBtnHandler();
    }];
}

- (IBAction)closeBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
