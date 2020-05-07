//
//  BTTCardInfoCell.m
//  Hybird_A01
//
//  Created by Domino on 23/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCardInfoCell.h"

@interface BTTCardInfoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cardBgImageView;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bankIcon;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;
@property (weak, nonatomic) IBOutlet UIButton *setDefaultBtn;
@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomDefaultBtn;

@end

@implementation BTTCardInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
}


- (IBAction)modifyClick:(UIButton *)sender { // tag 6005
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)deleteClick:(UIButton *)sender { // tag 6006
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}
- (IBAction)setDefaultBtnClicked:(id)sender {// tag 6007
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}
- (void)setModel:(BTTBankModel *)model
{
    _model = model;
    NSString *bgImageDefault = @"card_bg";
    if ([model.accountType isEqualToString:@"BTC"]) {
        bgImageDefault = @"BTC-bg";
    }else if([model.bankName isEqualToString:@"USDT"]){
        bgImageDefault = @"USDT-bg";
    }else if ([model.bankName isEqualToString:@"BITOLL"]){
        bgImageDefault = @"bfb_card_bg";
    }
    self.cardBgImageView.image = [UIImage imageNamed:bgImageDefault];
//    [self.cardBgImageView sd_setImageWithURL:bgUrl placeholderImage:[UIImage imageNamed:bgImageDefault]];
    self.modifyBtn.hidden = self.isChecking || [model.accountType isEqualToString:@"BTC"] || [model.bankName isEqualToString:@"USDT"] || [model.bankName isEqualToString:@"BITOLL"];
    self.deleteBtn.hidden = self.isChecking || self.isOnlyOneCard;
    self.setDefaultBtn.hidden = [model.accountType isEqualToString:@"BTC"];
    self.bottomDefaultBtn.hidden = [model.accountType isEqualToString:@"BTC"];
    self.setDefaultBtn.userInteractionEnabled = !model.isDefault;
    self.bottomDefaultBtn.userInteractionEnabled = !model.isDefault;
    if (model.flag == 9) {
        self.deleteBtn.hidden = NO;
        self.deleteBtn.enabled = NO;
        [self.deleteBtn setImage:nil forState:UIControlStateNormal];
        [self.deleteBtn setTitle:@"正在审核" forState:UIControlStateNormal];
    }
    if ([model.accountType isEqualToString:@"BTC"]) {
        self.bankIcon.image = [UIImage imageNamed:@"BTC"];
    }else if ([model.bankName isEqualToString:@"USDT"]){
        if ([model.accountType isEqualToString:@"others"]) {
            self.bankIcon.image=[UIImage imageNamed:@"me_usdt_otherwallet"];
        }else{
            self.bankIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"me_usdt_%@",[model.accountType lowercaseString]]];
        }
    }else if ([model.bankName isEqualToString:@"BITOLL"]){
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
        NSString *webUrlIcon = [iconURLStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *iconUrl = [NSURL URLWithString:webUrlIcon];
        [self.bankIcon sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"defaultCardIcon"]];
    }
    NSString *setDefaultImageName = model.isDefault ? @"defaultCard" : @"unDefaultCard";
    [self.setDefaultBtn setImage:[UIImage imageNamed:setDefaultImageName] forState:UIControlStateNormal];
    [self.bottomDefaultBtn setImage:[UIImage imageNamed:setDefaultImageName] forState:UIControlStateNormal];
    if ([model.bankName isEqualToString:@"USDT"]) {
        NSString *resultStr=[model.accountType stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[model.accountType substringToIndex:1] capitalizedString]];
        if ([model.accountType isEqualToString:@"others"]) {
            self.bankNameLabel.text = @"其他钱包";
        }else{
            self.bankNameLabel.text = [NSString stringWithFormat:@"%@钱包",resultStr];
        }
    }else if ([model.bankName isEqualToString:@"BITOLL"]){
        self.bankNameLabel.text = @"币付宝钱包";
    }else{
        self.bankNameLabel.text = model.bankName;
    }
    self.classLabel.text = [model.accountType isEqualToString:@"BTC"]||[model.bankName isEqualToString:@"USDT"]||[model.bankName isEqualToString:@"BITOLL"]  ? @"" : [NSString stringWithFormat:@"%@|%@%@",model.accountType,model.province,model.city];
    self.adressLabel.text = [model.accountType isEqualToString:@"BTC"]||[model.bankName isEqualToString:@"USDT"]||[model.bankName isEqualToString:@"BITOLL"] ? @"" : [NSString stringWithFormat:@"%@%@%@",model.province,model.city,model.bankBranchName];
    self.cardNumLabel.text = model.accountNo;
    NSString *typeString = @"绑定银行卡";
    if ([model.accountType isEqualToString:@"BTC"]) {
        typeString = @"绑定比特币钱包";
    }else if ([model.bankName isEqualToString:@"USDT"]){
        typeString = @"绑定USDT钱包";
    }
    
    self.cardNoLabel.text = [NSString stringWithFormat:@"%@(%ld)",typeString,(long)(self.indexPath.row + 1)];
    
    if (!isNull(model.protocol)&&![model.protocol isEqualToString:@""]&&[model.bankName isEqualToString:@"USDT"]) {
        self.protocolLabel.text = [NSString stringWithFormat:@"USDT-%@",model.protocol];
        self.protocolLabel.hidden = NO;
        self.bottomDefaultBtn.hidden = [model.accountType isEqualToString:@"BTC"];
        self.setDefaultBtn.hidden = YES;
    }else{
        self.protocolLabel.hidden = YES;
        self.bottomDefaultBtn.hidden = YES;
    }
}

- (IBAction)bottomDefault_Click:(id)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

@end
