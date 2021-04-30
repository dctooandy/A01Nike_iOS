//
//  BTTLiCaiRecordCell.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/27/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTLiCaiRecordCell.h"

@interface BTTLiCaiRecordCell()

@property (weak, nonatomic) IBOutlet UILabel *timeTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *statusTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *amountTitleLab;

@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;

@end

@implementation BTTLiCaiRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed: 0.19 green: 0.20 blue: 0.24 alpha: 1.00];
}

-(void)setTitleArr:(NSArray *)titleArr {
    _titleArr = titleArr;
    self.timeTitleLab.text = titleArr[0];
    self.orderNumberTitleLab.text = titleArr[1];
    self.statusTitleLab.text = titleArr[2];
    self.amountTitleLab.text = titleArr[3];
}

-(void)setModel:(BTTLiCaiTransferRecordItemModel *)model {
    _model = model;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [dateFormatter dateFromString:model.createdTime];
    [dateFormatter setDateFormat:@"MM-dd"];
    
    NSString * dateStr = [dateFormatter stringFromDate:date];
    self.dateLab.text = dateStr;
    
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString * timeStr = [dateFormatter stringFromDate:date];
    self.timeLab.text = timeStr;
    self.orderNumberLab.text = self.model.billno;
    self.statusLab.text = [self statusToStr:[self.model.status integerValue]];
    self.amountLab.text = self.model.amount;
}

-(NSString *)statusToStr:(NSInteger)status {
    NSString * str = @"";
    switch (status) {
        case 0:
            str = @"受理中";
            break;
        case 1:
            str = @"成功";
            break;
        case -1:
        case 2:
            str = @"失败";
            break;
            
        default:
            break;
    }
    return str;
}

@end
