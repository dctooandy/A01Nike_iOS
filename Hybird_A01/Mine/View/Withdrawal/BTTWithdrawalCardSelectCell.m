//
//  BTTWithdrawalCardSelectCell.m
//  Hybird_A01
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTWithdrawalCardSelectCell.h"
#import "CNPayConstant.h"

@interface BTTWithdrawalCardSelectCell()

@end

@implementation BTTWithdrawalCardSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.mineArrowsType = BTTMineArrowsTypeHidden;
}
- (void)setModel:(BTTBankModel *)model
{
    _model = model;
    self.detailLabel.text = [NSString stringWithFormat:@"%@-%@",model.bankName,model.accountNo];
    if ([model.accountType isEqualToString:@"BTC"]) {
        self.bankIcon.image = [UIImage imageNamed:@"BTC"];
    }else if ([model.bankName isEqualToString:@"USDT"]){
        self.detailLabel.text = [NSString stringWithFormat:@"%@-%@",model.accountType,model.accountNo];
        if ([model.accountType isEqualToString:@"others"]) {
            self.bankIcon.image=[UIImage imageNamed:@"me_usdt_otherwallet"];
        }else{
            self.bankIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"me_usdt_%@",[model.accountType lowercaseString]]];
        }
    }else if ([model.bankName isEqualToString:@"BITOLL"]){
        self.detailLabel.text = [NSString stringWithFormat:@"币付宝(USDT)-%@",model.accountNo];
        self.bankIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"me_usdt_%@",[model.accountType lowercaseString]]];
    } else {
        NSString *iconURLStr = model.bankIcon;
        if ([NSString isBlankString:iconURLStr]) {
            iconURLStr = @"";
        } else {
            if (![iconURLStr hasPrefix:@"http"]) {
                iconURLStr = [PublicMethod nowCDNWithUrl:iconURLStr];
            }
        }
        NSURL *iconUrl = [NSURL URLWithString:iconURLStr];
        [self.bankIcon sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"defaultCardIcon"]];
    }
    
}

- (void)SetUnderLine:(UIButton*)btn setTitle:(NSString*)title
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:title];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]range:strRange];
    [btn setAttributedTitle:str forState:UIControlStateNormal];
}

@end
