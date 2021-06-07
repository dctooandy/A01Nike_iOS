//
//  BTTHomePageDiscountCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/11.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTHomePageDiscountCell.h"
#import "BTTPromotionModel.h"


@interface BTTHomePageDiscountCell ()

@property (weak, nonatomic) IBOutlet UIImageView *discountIcon;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discountIconHeight;


@end

@implementation BTTHomePageDiscountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.detailBtn.userInteractionEnabled = NO;
    if (SCREEN_WIDTH == 320) {
        self.titleLabel.font = kFontSystem(16);
    } else {
        self.titleLabel.font = kFontSystem(18);
    }
}

- (IBAction)detailBtnClick:(UIButton *)sender {
}

- (void)setModel:(BTTPromotionModel *)model {
    _model = model;
    if (_model) {
        [self.discountIcon sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:ImageNamed(@"default_2")];
        self.titleLabel.text = model.name;
        self.detailLabel.text = model.desc;
    }
    if (self.frame.size.height > BTTDiscountDefaultCellHeight) {
        self.discountIconHeight.constant = 100;
    } else {
        self.discountIconHeight.constant = BTTDiscountDefaultIconHeight;
    }
}

- (void)setMineSparaterType:(BTTMineSparaterType)mineSparaterType {
    [super setMineSparaterType:mineSparaterType];
    if (mineSparaterType == BTTMineSparaterTypeSingleLine) {
        
    } else {
        
    }
}
@end
