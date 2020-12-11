//
//  BTTChooseCurrencyCell.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 27/11/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTChooseCurrencyCell.h"

@interface BTTChooseCurrencyCell()
@property (weak, nonatomic) IBOutlet UILabel *gameTitleLab;
@property (weak, nonatomic) IBOutlet UIButton *cnyBtn;
@property (weak, nonatomic) IBOutlet UILabel *cnyLab;
@property (weak, nonatomic) IBOutlet UIButton *usdtBtn;
@property (weak, nonatomic) IBOutlet UILabel *usdtLab;

@end

@implementation BTTChooseCurrencyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cnyLab.adjustsFontSizeToFitWidth = true;
    self.usdtLab.adjustsFontSizeToFitWidth = true;
}

-(void)setModel:(BTTUserGameCurrencyModel *)model {
    _model = model;
    BOOL isCny = [_model.currency isEqualToString:@"CNY"];
    if (_model.currency.length == 0) {
        [self.cnyBtn setImage:[UIImage imageNamed:@"ic_choose_currency_btn_default"] forState:UIControlStateNormal];
        [self.usdtBtn setImage:[UIImage imageNamed:@"ic_choose_currency_btn_default"] forState:UIControlStateNormal];
    } else {
        self.cnyBtn.selected = isCny;
        self.usdtBtn.selected = !isCny;
    }
}

-(void)setGameTitleStr:(NSString *)gameTitleStr {
    _gameTitleStr = gameTitleStr;
    self.gameTitleLab.text = _gameTitleStr;
}

- (IBAction)btnAction:(UIButton *)sender {
    if (sender.tag == 0) {
        [self.usdtBtn setImage:[UIImage imageNamed:@"ic_choose_currency_btn"] forState:UIControlStateNormal];
        self.usdtBtn.selected = false;
    } else {
        [self.cnyBtn setImage:[UIImage imageNamed:@"ic_choose_currency_btn"] forState:UIControlStateNormal];
        self.cnyBtn.selected = false;
    }
    if (!sender.selected) {
        sender.selected = !sender.selected;
        if (self.btnActionBlock) {
            self.btnActionBlock(sender.tag == 0 ? @"CNY":@"USDT");
        }
    }
}

@end
