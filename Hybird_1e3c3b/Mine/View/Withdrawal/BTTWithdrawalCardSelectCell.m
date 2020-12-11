//
//  BTTWithdrawalCardSelectCell.m
//  Hybird_1e3c3b
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
    
    if (self.model!=nil) {
        NSArray *constrains = self.bfb_discount.constraints;
        for(NSLayoutConstraint *constraint in constrains){
            if(constraint.firstAttribute ==NSLayoutAttributeWidth){
                constraint.constant = [self.model.bankName isEqualToString:@"DCBOX"] ? 28.0 : 0.0;
                
            }
        }
    }
    
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
        self.detailLabel.text = model.accountId==nil ? @"币付宝钱包" : [NSString stringWithFormat:@"币付宝账号-%@",model.accountNo];
        self.bankIcon.image=[UIImage imageNamed:@"me_usdt_bitoll"];
    }else if ([model.bankName isEqualToString:@"DCBOX"]){
        self.detailLabel.text = model.accountId==nil ? @"小金库钱包" : [NSString stringWithFormat:@"小金库账号-%@",model.accountNo];
        self.bankIcon.image=[UIImage imageNamed:@"dcbox_nb"];
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

-(void)updateConstraints{
    [super updateConstraints];
}

@end
