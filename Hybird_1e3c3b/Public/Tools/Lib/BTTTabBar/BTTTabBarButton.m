//
//  BTTTabBarButton.m
//  Hybird_1e3c3b
//
//  Created by Domino on 18/10/1.
//  Copyright © 2018年 Domino. All rights reserved.
//

#import "BTTTabBarButton.h"
#import "BTTBadgeView.h"

@interface BTTTabBarButton ()
/**
 *  提醒数字
 */
@property (strong, nonatomic) BTTBadgeView *badgeView;

@property (nonatomic, strong) UIImageView *titleImage;

@property (nonatomic, strong) UILabel *titleImageLabel;

@property (nonatomic, strong) UIImageView *hotImageView;

@end

@implementation BTTTabBarButton
/**
 *  小红点
 */
- (BTTBadgeView *)badgeView {
    if (!_badgeView) {
        BTTBadgeView *badgeView = [[BTTBadgeView alloc] init];
        [self addSubview:badgeView];
        self.badgeView = badgeView;
    }
    return _badgeView;
}

- (UILabel *)titleImageLabel {
    if (!_titleImageLabel) {
        _titleImageLabel = [UILabel new];
        _titleImageLabel.textAlignment = NSTextAlignmentCenter;
        _titleImageLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_titleImageLabel];
    }
    return _titleImageLabel;
}

- (UIImageView *)hotImageView {
    if (!_hotImageView) {
        _hotImageView = [UIImageView new];
        _hotImageView.image = ImageNamed(@"hot");
        [self addSubview:_hotImageView];
    }
    return _hotImageView;
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
    self.badgeView.badgeValue = item.badgeValue;
    self.titleImage.image = _item.image;
    self.titleImageLabel.text = _item.title;
    
    if ([item.title isEqualToString:@"抽奖"]) {
//        [self.titleImageLabel setTextColor:COLOR_RGBA(248, 211, 75, 1)];
        [self.titleImageLabel setTextColor:COLOR_RGBA(128, 135, 146, 1)];
        self.hotImageView.hidden = NO;
    } else {
        [self.titleImageLabel setTextColor:COLOR_RGBA(128, 135, 146, 1)];
        self.hotImageView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.titleImage.image = _item.selectedImage;
        [self.titleImageLabel setTextColor:COLOR_RGBA(248, 211, 75, 1)];
    } else {
        self.titleImage.image = _item.image;
//        if (![self.titleImageLabel.text isEqualToString:@"抽奖"]) {
        [self.titleImageLabel setTextColor:COLOR_RGBA(128, 135, 146, 1)];
//        }
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleImage.frame = CGRectMake((self.frame.size.width - 25) / 2, 2.5, 25, 25);
    self.titleImageLabel.frame = CGRectMake(0, 27.5, self.frame.size.width, 20);
    self.hotImageView.frame = CGRectMake(self.titleImage.frame.origin.x + 25, 0, 21, 21);

    // 小红点位置
    self.badgeView.x = CGRectGetMaxX(self.titleImage.frame) - 5;
    self.badgeView.y = 2;
}

- (void)setHighlighted:(BOOL)highlighted {
    
}

@end
