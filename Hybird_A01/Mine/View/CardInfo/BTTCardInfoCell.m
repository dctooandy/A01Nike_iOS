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
    NSString *bgImageDefault = model.isBTC ? @"BTC-bg" : @"card_bg";
    NSString *bgURLStr = model.bankimage;
    if ([NSString isBlankString:bgURLStr]) {
        bgURLStr = @"";
    } else {
        if (![bgURLStr hasPrefix:@"http"]) {

            bgURLStr = [PublicMethod nowCDNWithUrl:bgURLStr];
        }
    }
    NSURL *bgUrl = [NSURL URLWithString:bgURLStr];
    [self.cardBgImageView sd_setImageWithURL:bgUrl placeholderImage:[UIImage imageNamed:bgImageDefault]];
    self.modifyBtn.hidden = self.isChecking || model.isBTC;
    self.deleteBtn.hidden = self.isChecking || self.isOnlyOneCard;
    self.setDefaultBtn.hidden = model.isBTC;
    self.setDefaultBtn.userInteractionEnabled = !model.isDefault;
    if (model.flag == 9) {
        self.deleteBtn.hidden = NO;
        self.deleteBtn.enabled = NO;
        [self.deleteBtn setImage:nil forState:UIControlStateNormal];
        [self.deleteBtn setTitle:@"正在审核" forState:UIControlStateNormal];
    }
    if (model.isBTC) {
        self.bankIcon.image = [UIImage imageNamed:@"BTC"];
    } else {
        NSString *iconURLStr = model.banklogo;
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
    NSString *setDefaultImageName = model.isDefault ? @"defaultCard" : @"unDefaultCard";
    [self.setDefaultBtn setImage:[UIImage imageNamed:setDefaultImageName] forState:UIControlStateNormal];
    self.bankNameLabel.text = model.bankName;
    self.classLabel.text = model.isBTC ? @"" : [NSString stringWithFormat:@"%@|%@%@",model.bankType,model.province,model.city];
    self.adressLabel.text = model.isBTC ? @"" : [NSString stringWithFormat:@"%@%@%@",model.province,model.city,model.branchName];
    self.cardNumLabel.text = model.bankSecurityAccount;
    self.cardNoLabel.text = [NSString stringWithFormat:@"银行卡(%ld)",self.indexPath.row + 1];
}


@end
