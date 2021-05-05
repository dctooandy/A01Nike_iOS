//
//  BTTLiCaiOutDetailPopViewCell.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/28/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTLiCaiOutDetailPopViewCell.h"

@interface BTTLiCaiOutDetailPopViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestAmountLabel;

@end

@implementation BTTLiCaiOutDetailPopViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setEndDateStr:(NSString *)endDateStr{
    _endDateStr = endDateStr;
}

-(void)setModel:(BTTLiCaiTransferRecordItemModel *)model {
    _model = model;
    self.timeLabel.text = self.model.createdTime;
    self.amountLabel.text = self.model.amount;
    self.interestAmountLabel.text = [NSString stringWithFormat:@"%.6lf", [self.model.totalInterest floatValue]];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *beginDate = [dateFormatter dateFromString:model.transferInTime];
    NSDate *endDate = [dateFormatter dateFromString:self.endDateStr];
    NSInteger timeDistance= [endDate timeIntervalSinceDate:beginDate] / 60 / 60;
    self.durationLabel.text = [NSString stringWithFormat:@"%ld小时", timeDistance];
}

@end
