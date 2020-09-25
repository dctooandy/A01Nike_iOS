//
//  BTTDepositRecordCell.m
//  Hybird_A01
//
//  Created by Jairo on 21/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTDepositRecordCell.h"

@interface BTTDepositRecordCell()

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *requestIdLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;

@property (nonatomic, copy) NSString *requestIdStr;
@end

@implementation BTTDepositRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeSingleLine;
    self.backgroundColor = [UIColor clearColor];
    self.moneyLab.adjustsFontSizeToFitWidth = true;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAll:) name:@"SELECTALL" object:nil];
}

-(void)selectAll:(NSNotification *)notification {
    if (self.checkBtn.enabled) {
        [self.checkBtn setSelected:[notification.object isEqualToString:@"0"]? true:false];
    }
}

-(void)setData:(BTTDepositRecordItemModel *)model {
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
    
    self.iconImgView.image = [UIImage imageNamed:[self transIconImgStr:[model.transCode integerValue]]];
    
    NSString * unitStr = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"USDT":@"元";
    self.moneyLab.text = [NSString stringWithFormat:@"%@%@", model.arrivalAmount, unitStr];
    self.requestIdStr = model.requestId;
    self.requestIdLab.text = self.requestIdStr;
    self.typeLab.text = model.flagDesc;
}

-(NSString *)transIconImgStr:(NSInteger)transCode {
    NSString * str = @"";
    switch (transCode) {
        case 5:
            //支付寶掃碼
            str = @"me_aliSacn";
            break;
        case 6:
            //迅捷支付
            str = @"me_bank";
            break;
        case 9:
            //支付寶支付APP
        case 26:
            //支付宝转账
            str = @"me_alipaySecond";
            break;
        case 18:
        case 19:
            //網快
            str = @"me_quick";
            break;
        case 22:
            //微信支付 轉帳
            str = @"me_wechatsecond";
            break;
        case 25:
            //USDT支付
            str = @"me_usdt";
            break;
        case 43:
            //小金庫支付
            str = @"me_dcbox";
            break;
        case 45:
            //卡轉卡
            str = @"me_bankscan";
            break;
        default:
            str = @"me_bankscan";
            break;
    }
    return str;
}

-(IBAction)btnAction:(id)sender {
    if (self.checkBtn.enabled) {
        self.checkBtn.selected = !self.checkBtn.selected;
        if (self.checkBtnClickBlock) {
            self.checkBtnClickBlock(self.requestIdStr, self.checkBtn.selected);
        }
    }
}

@end
