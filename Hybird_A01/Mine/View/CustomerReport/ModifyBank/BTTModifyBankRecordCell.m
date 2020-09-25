//
//  BTTModifyBankRecordCell.m
//  Hybird_A01
//
//  Created by Jairo on 22/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTModifyBankRecordCell.h"

@interface BTTModifyBankRecordCell()
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *bankNoLab;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@end

@implementation BTTModifyBankRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeSingleLine;
    self.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAll:) name:@"SELECTALL" object:nil];
    self.bankNoLab.adjustsFontSizeToFitWidth = true;
    self.infoLab.adjustsFontSizeToFitWidth = true;
}

-(void)selectAll:(NSNotification *)notification {
    [self.checkBtn setSelected:[notification.object isEqualToString:@"0"]? true:false];
}

-(void)setData:(BTTModifyBankRecordItemModel *)model {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [dateFormatter dateFromString:model.lastUpdate];
    
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString * dateStr = [dateFormatter stringFromDate:date];
    self.dateLab.text = dateStr;
    
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString * timeStr = [dateFormatter stringFromDate:date];
    self.timeLab.text = timeStr;
    
    self.bankNoLab.text = model.accountNo;
    NSArray*array = [model.remarks componentsSeparatedByString:@"."];
    self.infoLab.text = array[0];
    switch (model.flag) {
        case 0:
            self.typeLab.text = @"等待处理";
            break;
        case 2:
            self.typeLab.text = @"已到账";
            break;
        case 1:
        case 9:
            self.typeLab.text = @"处理中";
            break;
        case -1:
            self.typeLab.text = @"客户取消";
            break;
        case -2:
            self.typeLab.text = @"后台取消";
            break;
        case -3:
            self.typeLab.text = @"被拒绝";
            break;
        default:
            self.typeLab.text = @"被拒绝";
            break;
    }
}

@end
