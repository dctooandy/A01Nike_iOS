//
//  BTTLiCaiOutRecordCell.m
//  Hybird_1e3c3b
//
//  Created by JerryHU on 2021/5/20.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTLiCaiOutRecordCell.h"

@interface BTTLiCaiOutRecordCell()

@property (weak, nonatomic) IBOutlet UILabel *timeTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *statusTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *outAmountTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *balanceTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *interestTitleLab;

@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *outAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *interestLab;


@end


@implementation BTTLiCaiOutRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed: 0.19 green: 0.20 blue: 0.24 alpha: 1.00];
}

-(void)setTitleArr:(NSArray *)titleArr {
    _titleArr = titleArr;
    self.timeTitleLab.text = titleArr[0];
    self.orderNumberTitleLab.text = titleArr[1];
    self.statusTitleLab.text = titleArr[2];
    
    self.outAmountTitleLab.text = [NSString stringWithFormat:@"%@(%@)", titleArr[3], [IVNetwork savedUserInfo].uiMode];
    self.balanceTitleLab.text = [NSString stringWithFormat:@"%@(%@)", titleArr[4], [IVNetwork savedUserInfo].uiMode];
    self.interestTitleLab.text = [NSString stringWithFormat:@"%@(%@)", titleArr[5], [IVNetwork savedUserInfo].uiMode];
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
    
    double amount = [self.model.amount doubleValue];
    double finalInterestAmt = [self.model.finalInterestAmt doubleValue];
    double total = amount + finalInterestAmt;
    self.outAmountLab.text = [PublicMethod transferNumToThousandFormat:[PublicMethod calculateTwoDecimals:total]];
    
    self.balanceLab.text = self.model.amount;
    self.interestLab.text = self.model.finalInterestAmt;
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
