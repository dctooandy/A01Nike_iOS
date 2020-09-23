//
//  BTTCreditRecordCell.m
//  Hybird_A01
//
//  Created by Jairo on 22/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTCreditRecordCell.h"

@interface BTTCreditRecordCell()
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAll:) name:@"SELECTALL" object:nil];
    self.cashLabel.adjustsFontSizeToFitWidth = true;
    self.gameLab.adjustsFontSizeToFitWidth = true;
    self.referenceIdLab.adjustsFontSizeToFitWidth = true;
}

-(void)selectAll:(NSNotification *)notification {
    [self.checkBtn setSelected:[notification.object isEqualToString:@"0"]? true:false];
}

-(void)setData:(BTTCreditRecordItemModel *)model {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [dateFormatter dateFromString:model.beginDate];
    
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString * dateStr = [dateFormatter stringFromDate:date];
    self.dateLab.text = dateStr;
    
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString * timeStr = [dateFormatter stringFromDate:date];
    self.timeLab.text = timeStr;
    
    self.sourceLab.text = model.title;
    
    self.cashLabel.text = [NSString stringWithFormat:@"现金：支出%@，余额%@", [PublicMethod transferNumToThousandFormat:[model.amount floatValue]], [PublicMethod transferNumToThousandFormat:[model.destAmount floatValue]]];
    self.gameLab.text = [NSString stringWithFormat:@"游戏：支出%@，余额%@", [PublicMethod transferNumToThousandFormat:[model.gameAmount floatValue]], [PublicMethod transferNumToThousandFormat:[model.gameDestAmount floatValue]]];
    
    self.referenceIdStr = model.referenceId;
    self.referenceIdLab.text = [NSString stringWithFormat:@"订单：%@", model.referenceId];
}

-(IBAction)btnAction:(id)sender {
    self.checkBtn.selected = !self.checkBtn.selected;
    if (self.checkBtnClickBlock) {
        self.checkBtnClickBlock(self.referenceIdStr, self.checkBtn.selected);
    }
}

@end
