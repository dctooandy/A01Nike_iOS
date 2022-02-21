//
//  KYMWithdrewAmountView.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/20.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrewAmountView.h"

@implementation KYMWithdrewAmountView

- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    if (self) {
    }
    return self;
}
- (void)setStatus:(KYMWithdrewStatus)status
{
    _status = status;
    switch (status) {
        case 0:
            self.amountStatusLB1.hidden = YES;
            self.amountStatusLB2.hidden = YES;
            break;
        case 1:
            self.amountStatusLB1.hidden = YES;
            self.amountStatusLB2.hidden = YES;
            break;
        case 2:
            self.amountStatusLB1.hidden = YES;
            self.amountStatusLB2.hidden = NO;
            self.amountStatusLB2Top.constant = 3;
            self.amountStatusLB2Height.constant = 20;
            self.amountStatusLB2.font = [UIFont fontWithName:@"PingFang SC Semibold" size:12];
            self.amountStatusLB2.text = @"在15分钟点击确认到账，可以获得0.5%取款返利金";
            break;
        case 3:
            self.amountStatusLB1.hidden = YES;
            self.amountStatusLB2.hidden = NO;
            self.amountStatusLB2Top.constant = 3;
            self.amountStatusLB2Height.constant = 20;
            self.amountStatusLB2.font = [UIFont fontWithName:@"PingFang SC Semibold" size:12];
            self.amountStatusLB2.text = @"在15分钟点击确认到账，可以获得0.5%取款返利金";
            break;
        case 4:
            self.amountStatusLB1.hidden = NO;
            self.amountStatusLB2.hidden = NO;
            self.amountStatusLB2Top.constant = 22;
            self.amountStatusLB2Height.constant = 40;
            self.amountStatusLB2.font = [UIFont fontWithName:@"PingFang SC Semibold" size:14];
            self.amountStatusLB2.text = @"由于您未在规定时间确认，系统判断您已确认到账\n如提现未到账或金额不符，请及时联系客服";
            break;
        case 5:
            self.amountStatusLB1.hidden = YES;
            self.amountStatusLB2.hidden = NO;
            self.amountStatusLB2Top.constant = 1;
            self.amountStatusLB2Height.constant = 40;
            self.amountStatusLB2.font = [UIFont fontWithName:@"PingFang SC Semibold" size:14];
            self.amountStatusLB2.text = @"恭喜老板！获得取款返利金2.5元\n每周一统一发放";
            break;
            
        default:
            break;
    }
}

@end
