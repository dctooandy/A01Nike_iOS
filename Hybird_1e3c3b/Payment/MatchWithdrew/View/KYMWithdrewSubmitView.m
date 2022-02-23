//
//  KYMWithdrewSubmitView.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/20.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrewSubmitView.h"

@interface KYMWithdrewSubmitView ()

@property (weak, nonatomic) IBOutlet UIButton *notReceivedBtn;
@property (weak, nonatomic) IBOutlet UILabel *textLB;
@end
@implementation KYMWithdrewSubmitView

- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    if (self) {
        self.notReceivedBtn.layer.cornerRadius = 8;
        self.notReceivedBtn.layer.masksToBounds = YES;
        self.notReceivedBtn.layer.borderWidth = 1;
        self.notReceivedBtn.layer.borderColor = [UIColor colorWithRed:0xF2 / 255.0 green:0xDA / 255.0 blue:0x0F / 255.0 alpha:1].CGColor;
    }
    return self;
}
- (void)setStatus:(KYMWithdrewStatus)status
{
    _status = status;
    switch (status) {
        case KYMWithdrewStatusSubmit:
            [self.submitBtn setTitle:@"取消取款" forState:UIControlStateNormal];
            self.notReceivedBtn.hidden = YES;
            self.textLB.hidden = YES;
            break;
        case KYMWithdrewStatusWaiting:
            [self.submitBtn setTitle:@"取消取款" forState:UIControlStateNormal];
            self.notReceivedBtn.hidden = YES;
            self.textLB.hidden = YES;
            break;
        case KYMWithdrewStatusConfirm:
            [self.submitBtn setTitle:@"确认到账" forState:UIControlStateNormal];
            self.notReceivedBtn.hidden = NO;
            self.textLB.hidden = NO;
            break;
        case KYMWithdrewStatusNotReceived:
            [self.submitBtn setTitle:@"取消取款" forState:UIControlStateNormal];
            self.notReceivedBtn.hidden = YES;
            self.textLB.hidden = YES;
            break;
        case KYMWithdrewStatusTimeout:
            [self.submitBtn setTitle:@"返回首页" forState:UIControlStateNormal];
            self.notReceivedBtn.hidden = YES;
            self.textLB.hidden = YES;
            break;
        case KYMWithdrewStatusSuccessed:
            [self.submitBtn setTitle:@"返回首页" forState:UIControlStateNormal];
            self.notReceivedBtn.hidden = YES;
            self.textLB.hidden = YES;
            break;
            
        default:
            break;
    }
}
- (IBAction)submitBtnClicked:(id)sender {
    self.submitBtnHandle();
}
- (IBAction)notReceivedBtnClicked:(id)sender {
}

@end
