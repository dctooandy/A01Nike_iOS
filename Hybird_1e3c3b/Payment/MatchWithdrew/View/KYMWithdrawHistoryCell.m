//
//  KYMWithdrawHistoryCell.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/3/16.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrawHistoryCell.h"

@interface KYMWithdrawHistoryCell ()

@end
@implementation KYMWithdrawHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.historyView = [KYMWithdrawHistoryView new];
    [self addSubview:self.historyView];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.historyView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}
- (void)setIsManualStatus:(BOOL)isManualStatus
{
    _isManualStatus = isManualStatus;
    if (isManualStatus) {
        self.historyView.noConfirmBtn.hidden = YES;
        [self.historyView.confirmBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    }
}
@end
