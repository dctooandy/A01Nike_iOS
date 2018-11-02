//
//  BTTBadgeView.m
//  Hybird_A01
//
//  Created by Domino on 18/10/1.
//  Copyright © 2018年 Domino. All rights reserved.
//

#import "BTTBadgeView.h"
#import "UIView+Frame.h"

@implementation BTTBadgeView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setBackgroundImage:[self resizedImage:@"main_badge"] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 按钮的高度就是背景图片的高度
        self.height = self.currentBackgroundImage.size.height;
    }
    return self;
}

- (UIImage *)resizedImage:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = [badgeValue copy];
    
    self.hidden = NO;
    if ([badgeValue integerValue] > 99) {
        badgeValue = @"...";
    } else if ([badgeValue integerValue] <= 0) {
        badgeValue = nil;
        self.hidden = YES;
    }
    // 设置文字
    [self setTitle:badgeValue forState:UIControlStateNormal];
    
    // 根据文字计算自己的尺寸
    CGFloat bgW = self.currentBackgroundImage.size.width;
   
    self.width = bgW;
    if (badgeValue.length > 1) {
        self.width = 26;
    }
}

@end
