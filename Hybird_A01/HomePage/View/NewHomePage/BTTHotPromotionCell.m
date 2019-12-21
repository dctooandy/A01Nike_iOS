//
//  BTTHotPromotionCell.m
//  Hybird_A01
//
//  Created by Domino on 13/11/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTHotPromotionCell.h"
#import "BTTPromotionModel.h"

@interface BTTHotPromotionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *promotionIcon;

@end

@implementation BTTHotPromotionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
}

- (void)setModel:(BTTPromotionModel *)model {
    _model = model;
    [self.promotionIcon sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:ImageNamed(@"default_3")];
}

@end