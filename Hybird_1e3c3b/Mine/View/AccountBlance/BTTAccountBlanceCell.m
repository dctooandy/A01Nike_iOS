//
//  BTTAccountBlanceCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTAccountBlanceCell.h"
#import "BTTMeMainModel.h"

@implementation BTTAccountBlanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor =  COLOR_RGBA(36, 40, 49, 1);
    [self setSelectedBackgroundView:backgroundView];
}

- (void)setModel:(BTTMeMainModel *)model {
    _model = model;
    self.iconImageView.image = ImageNamed(model.iconName);
    self.nameLabel.text = model.name;
}

@end
