//
//  BTTMeInfoCell.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/17.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTMeInfoCell.h"
#import "BTTMeMainModel.h"

@interface BTTMeInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation BTTMeInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor =  COLOR_RGBA(36, 40, 49, 1);
    [self setSelectedBackgroundView:backgroundView];
}

- (void)setModel:(BTTMeMainModel *)model {
    _model = model;
    self.iconImg.image = ImageNamed(model.iconName);
    self.nameLabel.text = model.name;
}

@end
