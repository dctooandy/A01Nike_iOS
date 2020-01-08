//
//  BTTWithdrawalCardSelectCell.m
//  Hybird_A01
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTWithdrawalCardSelectCell.h"
@implementation BTTWithdrawalCardSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineArrowsType = BTTMineArrowsTypeNoHidden;
}
- (void)setModel:(BTTBankModel *)model
{
    _model = model;
    self.detailLabel.text = model.withdrawText;
    if ([model.accountType isEqualToString:@"BTC"]) {
        self.bankIcon.image = [UIImage imageNamed:@"BTC"];
    }else if ([model.accountType isEqualToString:@"USDT"]){
//        if ([model.account isEqualToString:@"others"]) {
//            self.bankIcon.image=[UIImage imageNamed:@"me_usdt_otherwallet"];
//        }else{
//            self.bankIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"me_usdt_%@",model.bankType]];
//        }
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
@end
