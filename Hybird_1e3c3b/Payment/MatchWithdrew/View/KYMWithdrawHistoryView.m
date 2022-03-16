//
//  KYMWithdrawHistoryView.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/3/16.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrawHistoryView.h"

@interface KYMWithdrawHistoryView ()
@property (weak, nonatomic) IBOutlet UILabel *orderNoLB;
@property (weak, nonatomic) IBOutlet UILabel *amountLB;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *noConfirmBtn;

@end
@implementation KYMWithdrawHistoryView

- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    if (self) {
        [self intSetup];
    }
    return self;
}


- (void)intSetup
{
    self.confirmBtn.layer.borderWidth = 1.0;
    self.confirmBtn.layer.cornerRadius = 4;
    self.confirmBtn.layer.borderColor = [UIColor colorWithRed:0xFF / 255.0 green:0xEB / 255.0 blue:0x3B / 255.0 alpha:0.2].CGColor;
    self.noConfirmBtn.layer.borderWidth = 1.0;
    self.noConfirmBtn.layer.cornerRadius = 4;
    self.noConfirmBtn.layer.borderColor = [UIColor colorWithRed:0xFF / 255.0 green:0xEB / 255.0 blue:0x3B / 255.0 alpha:0.2].CGColor;
    self.amountLB.text = _amount;
    self.orderNoLB.text = _orderNo;
}
- (IBAction)confirmBtnClicked:(id)sender {
    self.confirmBtnHandler();
}
- (IBAction)noConfirmBtnClicked:(id)sender {
    self.noConfirmBtnHandler();
}
- (void)setAmount:(NSString *)amount
{
    _amount = amount;
    self.amountLB.text = amount;
}
- (void)setOrderNo:(NSString *)orderNo
{
    _orderNo = orderNo;
    self.orderNoLB.text = orderNo;
}
@end
