//
//  BTTLiCaiInterestRateBillCell.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/27/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTLiCaiInterestRateBillCell.h"

@interface BTTLiCaiInterestRateBillCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *interestRateLab;
@property (weak, nonatomic) IBOutlet UILabel *calculateTimeLab;

@end

@implementation BTTLiCaiInterestRateBillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed: 0.19 green: 0.20 blue: 0.24 alpha: 1.00];
}

-(void)setModel:(BTTInterestRecordsItemModel *)model {
    _model = model;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [dateFormatter dateFromString:model.createdTime];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString * dateStr = [dateFormatter stringFromDate:date];
    self.dateLab.text = dateStr;
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString * timeStr = [dateFormatter stringFromDate:date];
    self.timeLab.text = timeStr;
    self.orderNumberLab.text = self.model.yebBillno;
    self.statusLab.text = @"成功";
    self.amountLab.text = self.model.interestAmount;
    self.interestRateLab.text = [NSString stringWithFormat:@"%@%%", self.model.yearRate];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *beginDate = [dateFormatter dateFromString:model.fromTime];
    NSDate *endDate = [dateFormatter dateFromString:model.toTime];
    NSInteger dayDistance = [endDate timeIntervalSinceDate:beginDate] / 60 / 60 / 24;
    NSInteger timeDistance = [endDate timeIntervalSinceDate:beginDate] / 60 / 60 - 24 * dayDistance;
    if (dayDistance == 0) {
        self.calculateTimeLab.text = [NSString stringWithFormat:@"%ld小时", timeDistance];
    } else if (timeDistance == 0) {
        self.calculateTimeLab.text = [NSString stringWithFormat:@"%ld天", dayDistance];
    } else {
        self.calculateTimeLab.text = [NSString stringWithFormat:@"%ld天%ld小时", dayDistance, timeDistance];
    }
}

@end
