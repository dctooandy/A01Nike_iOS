//
//  BTTWithdrawRecordCell.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 05/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTWithdrawRecordCell.h"

@interface BTTWithdrawRecordCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *sourceLab;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *requestIdLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@end

@implementation BTTWithdrawRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeSingleLine;
    self.backgroundColor = [UIColor clearColor];
    self.requestIdLab.adjustsFontSizeToFitWidth = true;
}

-(void)setData:(BTTWithdrawRecordItemModel *)model {
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
    
    self.sourceLab.text = model.bankName;
    
    NSArray * arr = [model.accountNo componentsSeparatedByString:@" "];
    NSMutableString * replaceStr = [[NSMutableString alloc] initWithString:arr[arr.count-1]];
    [replaceStr replaceCharactersInRange:NSMakeRange(0, 2) withString:@"**"];
    self.cardNumberLab.text = [NSString stringWithFormat:@"尾号(%@)", replaceStr];
    
    NSString * unitStr = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"USDT":@"元";
    self.moneyLab.text = [NSString stringWithFormat:@"%@%@", [PublicMethod transferNumToThousandFormat:[model.amount floatValue]], unitStr];
    self.requestIdLab.text = model.requestId;
    self.typeLab.text = model.flagDesc;
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