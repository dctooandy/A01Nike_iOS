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
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [dateFormatter dateFromString:self.model.createdTime];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString * dateStr = [dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString * timeStr = [dateFormatter stringFromDate:date];
    self.timeLabel.text = [NSString stringWithFormat:@"%@\n%@", dateStr, timeStr];
    self.amountLabel.text = [PublicMethod transferNumToThousandFormat:[self.model.amount doubleValue]];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *beginDate = [dateFormatter dateFromString:self.model.transferInTime];
    NSDate *endDate = [dateFormatter dateFromString:self.endDateStr];
    NSInteger dayDistance = [endDate timeIntervalSinceDate:beginDate] / 60 / 60 / 24;
    NSInteger timeDistance = [endDate timeIntervalSinceDate:beginDate] / 60 / 60 - 24 * dayDistance;
    self.durationLabel.text = [NSString stringWithFormat:@"%ld天%ld小时", dayDistance, timeDistance];
    if (dayDistance == 0) {
        self.durationLabel.text = [NSString stringWithFormat:@"%ld小时", timeDistance];
    } else if (timeDistance == 0) {
        self.durationLabel.text = [NSString stringWithFormat:@"%ld天", dayDistance];
    } else {
        self.durationLabel.text = [NSString stringWithFormat:@"%ld天%ld小时", dayDistance, timeDistance];
    }
}

@end
