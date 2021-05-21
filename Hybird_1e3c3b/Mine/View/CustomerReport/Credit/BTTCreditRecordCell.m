//
//  BTTCreditRecordCell.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 22/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTCreditRecordCell.h"

@interface BTTCreditRecordCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *sourceLab;
@property (weak, nonatomic) IBOutlet UILabel *cashLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameLab;
@property (weak, nonatomic) IBOutlet UILabel *referenceIdLab;

@property (nonatomic, copy) NSString * referenceIdStr;

@end

@implementation BTTCreditRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeSingleLine;
    self.backgroundColor = [UIColor clearColor];
    self.cashLabel.adjustsFontSizeToFitWidth = true;
    self.gameLab.adjustsFontSizeToFitWidth = true;
    self.referenceIdLab.adjustsFontSizeToFitWidth = true;
}

-(void)setData:(BTTCreditRecordItemModel *)model {
    [self transDateStringToLabeText:model.beginDate];
    self.sourceLab.text = model.title;
    
    self.cashLabel.text = [NSString stringWithFormat:@"现金：支出%@，余额%@", [PublicMethod transferNumToThousandFormat:[model.amount doubleValue]], [PublicMethod transferNumToThousandFormat:[model.destAmount doubleValue]]];
    self.gameLab.text = [NSString stringWithFormat:@"游戏：支出%@，余额%@", [PublicMethod transferNumToThousandFormat:[model.gameAmount doubleValue]], [PublicMethod transferNumToThousandFormat:[model.gameDestAmount doubleValue]]];
    
    self.referenceIdStr = model.referenceId;
    self.referenceIdLab.text = [NSString stringWithFormat:@"订单：%@", model.referenceId];
}

-(void)setXmTransferData:(BTTXmTransferRecordItemModel *)model {
    [self.checkBtn setImage:[UIImage imageNamed:@"ic_all_check_default"] forState:UIControlStateNormal];
    self.checkBtn.enabled = false;
    [self transDateStringToLabeText:model.createdDate];
    NSString * cashStr = @"";
    NSString * gameStr = @"";
    if ([[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"]) {
        self.sourceLab.text = @"CNY洗码转入";
        cashStr = [NSString stringWithFormat:@"转入%@", [PublicMethod transferNumToThousandFormat:[model.targetCredit doubleValue]]];
        gameStr = [NSString stringWithFormat:@"转入%@", [PublicMethod transferNumToThousandFormat:[model.targetCredit doubleValue]]];
    } else {
        self.sourceLab.text = @"CNY至USDT";
        cashStr = [NSString stringWithFormat:@"支出%@", [PublicMethod transferNumToThousandFormat:[model.sourceCredit doubleValue]]];
        gameStr = [NSString stringWithFormat:@"支出%@", [PublicMethod transferNumToThousandFormat:[model.sourceCredit doubleValue]]];
    }
    self.cashLabel.text = [NSString stringWithFormat:@"现金：%@，状态：%@", cashStr, [self transFlagToStr:model.flag]];
    self.gameLab.text = [NSString stringWithFormat:@"游戏：%@，状态：%@", gameStr, [self transFlagToStr:model.flag]];
    
    self.referenceIdLab.text = [NSString stringWithFormat:@"订单：%@", model.requestId];
}

-(void)transDateStringToLabeText:(NSString *)str {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [dateFormatter dateFromString:str];
    
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString * dateStr = [dateFormatter stringFromDate:date];
    self.dateLab.text = dateStr;
    
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString * timeStr = [dateFormatter stringFromDate:date];
    self.timeLab.text = timeStr;
}

-(NSString *)transFlagToStr:(NSInteger)flag {
    NSString * str = @"";
    switch (flag) {
        case 0:
            str = @"处理中";
            break;
        case 2:
            str = @"已到账";
            break;
        case -3:
            str = @"被拒绝";
            break;
        default:
            str = @"处理中";
            break;
    }
    return str;
}

-(IBAction)btnAction:(id)sender {
    self.checkBtn.selected = !self.checkBtn.selected;
    if (self.checkBtnClickBlock) {
        self.checkBtnClickBlock(self.referenceIdStr, self.checkBtn.selected);
    }
}

@end
