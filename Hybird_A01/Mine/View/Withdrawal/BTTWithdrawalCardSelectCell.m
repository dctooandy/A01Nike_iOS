//
//  BTTWithdrawalCardSelectCell.m
//  Hybird_A01
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTWithdrawalCardSelectCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation BTTWithdrawalCardSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineArrowsType = BTTMineArrowsTypeNoHidden;
}
- (void)setModel:(BTTBankModel *)model
{
    _model = model;
    self.detailLabel.text = model.withdrawText;
    if (model.isBTC) {
        self.bankIcon.image = [UIImage imageNamed:@"BTC"];
    } else {
        NSURL *url = [NSURL URLWithString:model.banklogo];
        [self.bankIcon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultCardIcon"]];
    }
    
}
@end
