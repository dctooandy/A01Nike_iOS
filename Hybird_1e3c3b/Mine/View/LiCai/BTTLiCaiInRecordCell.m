//
//  BTTLiCaiInRecordCell.m
//  Hybird_1e3c3b
//
//  Created by JerryHU on 2021/5/20.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTLiCaiInRecordCell.h"

@interface BTTLiCaiInRecordCell()

@property (weak, nonatomic) IBOutlet UILabel *timeTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *statusTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *inAmountTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *balanceTitleLab;

@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *inAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;

@end

@implementation BTTLiCaiInRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed: 0.19 green: 0.20 blue: 0.24 alpha: 1.00];
}

-(void)setTitleArr:(NSArray *)titleArr {
    _titleArr = titleArr;
    self.timeTitleLab.text = titleArr[0];
    self.orderNumberTitleLab.text = titleArr[1];
    self.statusTitleLab.text = titleArr[2];
    self.inAmountTitleLab.text = [NSString stringWithFormat:@"%@(%@)", titleArr[3], [IVNetwork savedUserInfo].uiMode];
    self.balanceTitleLab.text = [NSString stringWithFormat:@"%@(%@)", titleArr[4], [IVNetwork savedUserInfo].uiMode];;
}

-(void)setModel:(BTTLiCaiTransferRecordItemModel *)model {
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
    self.orderNumberLab.text = self.model.billno;
    self.statusLab.text = [self statusToStr:[self.model.status integerValue]];
    
    double amount = [self.model.yebOriginalAmount doubleValue] > 0.00 ? [self.model.yebOriginalAmount doubleValue]:[self.model.amount doubleValue];
    self.inAmountLab.text = [PublicMethod transferNumToThousandFormat:[PublicMethod calculateTwoDecimals:amount]];
    
    self.balanceLab.text = [PublicMethod transferNumToThousandFormat:[PublicMethod calculateTwoDecimals:[self.model.amount doubleValue]]];
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
        case -9:
            str = @"失败";
            break;
            
        default:
            break;
    }
    return str;
}

@end
