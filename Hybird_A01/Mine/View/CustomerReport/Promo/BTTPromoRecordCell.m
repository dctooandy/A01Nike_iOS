//
//  BTTPromoRecordCell.m
//  Hybird_A01
//
//  Created by Jairo on 04/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTPromoRecordCell.h"

@interface BTTPromoRecordCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *sourceLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *requestIdLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@end

@implementation BTTPromoRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeSingleLine;
    self.backgroundColor = [UIColor clearColor];
}

-(void)setData:(BTTPromoRecordItemModel *)model {
    if (model.flag == 0 || model.flag == 9) {
        [self.checkBtn setImage:[UIImage imageNamed:@"ic_all_check_default"] forState:UIControlStateNormal];
        self.checkBtn.enabled = false;
    }
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [dateFormatter dateFromString:model.createDate];
    
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString * dateStr = [dateFormatter stringFromDate:date];
    self.dateLab.text = dateStr;
    
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString * timeStr = [dateFormatter stringFromDate:date];
    self.timeLab.text = timeStr;
    
    self.sourceLab.text = model.title;
    
    NSString * unitStr = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"USDT":@"元";
    self.moneyLab.text = [NSString stringWithFormat:@"%@%@", model.amount, unitStr];
    self.requestIdLab.text = model.requestId;
    self.typeLab.text = model.flagDesc;
//    switch (model.flag) {
//        case 0:
//            self.typeLab.text = @"受理中";
//            break;
//        case 2:
//            self.typeLab.text = @"已批准";
//            break;
//        case 9:
//            self.typeLab.text = @"待审核";
//            break;
//        case -2:
//            self.typeLab.text = @"取消";
//            break;
//        case -3:
//            self.typeLab.text = @"拒绝";
//            break;
//        default:
//            self.typeLab.text = @"拒绝";
//            break;
//    }
}

-(IBAction)btnAction:(id)sender {
    if (self.checkBtn.enabled) {
        self.checkBtn.selected = !self.checkBtn.selected;
        if (self.checkBtnClickBlock) {
            self.checkBtnClickBlock(self.requestIdLab.text, self.checkBtn.selected);
        }
    }
}

@end
