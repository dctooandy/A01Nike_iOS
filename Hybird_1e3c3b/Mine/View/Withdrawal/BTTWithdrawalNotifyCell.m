//
//  BTTWithdrawalNotifyCell.m
//  Hybird_1e3c3b
//
//  Created by Key on 2018/12/13.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTWithdrawalNotifyCell.h"
#import "BTTBetInfoModel.h"
#import "BTTMeMainModel.h"
@implementation BTTWithdrawalNotifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(BTTMeMainModel *)model
{
    _model = model;
    self.nameLB.text = model.name;
}
- (void)setBetInfoModel:(BTTBetInfoModel *)betInfoModel
{
    _betInfoModel = betInfoModel;
    if ([self.betInfoModel.differenceBet doubleValue] > 0.0) {
        self.successImageView.hidden = YES;
        self.contentLB.hidden = NO;
        self.contentLB.attributedText = self.betInfoModel.notiyStr;
    } else {
        self.successImageView.hidden = NO;
        self.contentLB.hidden = YES;
    }
}

@end
