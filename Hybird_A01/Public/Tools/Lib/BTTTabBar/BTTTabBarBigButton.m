//
//  BTTTabBarBigButton.m
//  Hybird_A01
//
//  Created by Domino on 18/10/1.
//  Copyright © 2018年 Domino. All rights reserved.
//

#import "BTTTabBarBigButton.h"

@interface BTTTabBarBigButton ()
/**
 *  背景
 */
@property(nonatomic, weak) UIView *bgView;

@property (nonatomic, strong) UIImageView *titleImage;

@property (nonatomic, strong) UILabel *titleImageLabel;

@end

@implementation BTTTabBarBigButton

- (UILabel *)titleImageLabel {
    if (!_titleImageLabel) {
        _titleImageLabel = [UILabel new];
        _titleImageLabel.textAlignment = NSTextAlignmentCenter;
        _titleImageLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_titleImageLabel];
    }
    return _titleImageLabel;
}

- (UIImageView *)titleImage {
    if (!_titleImage) {
        _titleImage = [UIImageView new];
        [self addSubview:_titleImage];
    }
    return _titleImage;
}

- (void)setItem:(UITabBarItem *)item {
    _item = item;
    self.titleImage.image = _item.image;
    self.titleImageLabel.text = _item.title;
    [self.titleImageLabel setTextColor:COLOR_RGBA(128, 135, 146, 1)];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.titleImage.image = _item.selectedImage;
        [self.titleImageLabel setTextColor:COLOR_RGBA(248, 211, 75, 1)];
    } else {
        self.titleImage.image = _item.image;
        [self.titleImageLabel setTextColor:COLOR_RGBA(128, 135, 146, 1)];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleImage.frame = CGRectMake((self.frame.size.width - 60) / 2, -5, 60, 60);
    self.titleImageLabel.frame = CGRectMake(0, 50, self.frame.size.width, 10);
}


- (void)setHighlighted:(BOOL)highlighted {

}
@end
