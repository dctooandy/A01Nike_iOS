//
//  BTTHomePageDiscountCell.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/11.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTHomePageDiscountCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BTTPromotionModel.h"


@interface BTTHomePageDiscountCell ()

@property (weak, nonatomic) IBOutlet UIImageView *discountIcon;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIButton *detailBtn;



@end

@implementation BTTHomePageDiscountCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
    [self.discountIcon sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:ImageNamed(@"")];
    self.titleLabel.text = model.name;
    self.detailLabel.text = model.desc;
}

- (void)setMineSparaterType:(BTTMineSparaterType)mineSparaterType {
    [super setMineSparaterType:mineSparaterType];
    if (mineSparaterType == BTTMineSparaterTypeSingleLine) {
        
    } else {
        
    }
}
@end
