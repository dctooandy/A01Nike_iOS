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
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@property (weak, nonatomic) IBOutlet UIView *uView;

@end

@implementation BTTWithdrawalCardSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.uView.backgroundColor = kBlackBackgroundColor;
    self.mineArrowsType = BTTMineArrowsTypeNoHidden;
    [self SetUnderLine:self.contactButton setTitle:@"咨询客服"];
    self.mineArrowsType = BTTMineArrowsTypeHidden;
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

- (void)SetUnderLine:(UIButton*)btn setTitle:(NSString*)title
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:title];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]range:strRange];
    [btn setAttributedTitle:str forState:UIControlStateNormal];
}

- (IBAction)contactBtnClick:(id)sender {
    if (self.contactBtnTap) {
        self.contactBtnTap();
    }
}
@end
