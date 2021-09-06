//
//  BTTHotPromotionCell.m
//  Hybird_1e3c3b
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

- (void)setModel:(BTTPromotionProcessModel *)model {
    _model = model;
    [self.promotionIcon sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:ImageNamed(@"default_3")];
}

@end
