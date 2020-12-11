//
//  BTTXmRecordCell.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 22/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTXmRecordCell.h"

@interface BTTXmRecordCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *sourceLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *betAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *requestIdLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;

@property (nonatomic, copy) NSString *requestId;
@end

@implementation BTTXmRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeSingleLine;
    self.backgroundColor = [UIColor clearColor];
    self.amountLab.adjustsFontSizeToFitWidth = true;
    self.betAmountLab.adjustsFontSizeToFitWidth = true;
    self.requestIdLab.adjustsFontSizeToFitWidth = true;
}

-(void)setData:(BTTXmRecordItemModel *)model {
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
    
    NSString * sourceStr = model.platformName;
    if (model.gameKind.length != 0) {
        sourceStr = [NSString stringWithFormat:@"%@%@", model.platformName, model.gameKindName];
    }
    self.sourceLab.text = sourceStr;
    
    NSString * unitStr = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"USDT":@"元";
    NSString * amountStr = [PublicMethod transferNumToThousandFormat:[model.amount floatValue]];
    NSString * str = [NSString stringWithFormat:@"金额：%@%@", amountStr, unitStr];
    NSString * colorString = [NSString stringWithFormat:@"%@%@", amountStr, unitStr];
    NSRange range = [str rangeOfString:colorString];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed: 0.88 green: 0.78 blue: 0.58 alpha: 1.00],NSFontAttributeName:kFontSystem(12)} range:range];
    self.amountLab.attributedText = attStr;
    
    NSString * betAmountStr = [PublicMethod transferNumToThousandFormat:[model.bettingAmount floatValue]];
    str = [NSString stringWithFormat:@"投注额：%@", betAmountStr];
    colorString = [NSString stringWithFormat:@"%@", betAmountStr];
    range = [str rangeOfString:colorString];
    attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed: 0.88 green: 0.78 blue: 0.58 alpha: 1.00],NSFontAttributeName:kFontSystem(12)} range:range];
    self.betAmountLab.attributedText = attStr;
    
    self.requestId = model.requestId;
    self.requestIdLab.text = model.requestId;
    
    self.typeLab.text = model.flagDesc;
}

-(IBAction)btnAction:(id)sender {
    if (self.checkBtn.enabled) {
        self.checkBtn.selected = !self.checkBtn.selected;
        if (self.checkBtnClickBlock) {
            self.checkBtnClickBlock(self.requestId, self.checkBtn.selected);
        }
    }
}

@end
