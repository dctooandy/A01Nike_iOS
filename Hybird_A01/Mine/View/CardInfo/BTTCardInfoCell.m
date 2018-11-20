//
//  BTTCardInfoCell.m
//  Hybird_A01
//
//  Created by Domino on 23/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCardInfoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface BTTCardInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bankIcon;

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *classLabel;

@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;

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

- (void)setModel:(BTTBankModel *)model
{
    _model = model;
    NSURL *iconUrl = [NSURL URLWithString:model.banklogo];
    [self.bankIcon sd_setImageWithURL:iconUrl placeholderImage:nil];
    self.bankNameLabel.text = model.bankName;
    self.classLabel.text = [NSString stringWithFormat:@"%@|%@%@",model.bankType,model.province,model.city];
    self.adressLabel.text = [NSString stringWithFormat:@"%@%@%@",model.province,model.city,model.branchName];
    self.cardNumLabel.text = model.bankSecurityAccount;
}

@end
