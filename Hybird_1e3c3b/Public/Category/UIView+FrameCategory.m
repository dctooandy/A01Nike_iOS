//
//  UIView+FrameCategory.m
//  A02_iPhone
//
//  Created by Robert on 16/03/2018.
//  Copyright © 2018 robert. All rights reserved.
//

#import "UIView+FrameCategory.h"

@implementation UIView (FrameCategory)
- (CGFloat)newLeft {
    return self.frame.origin.x;
}

- (void)setNewLeft:(CGFloat)newLeft{
    CGRect frame = self.frame;
    frame.origin.x = newLeft;
    self.frame = frame;
}

- (CGFloat)newTop {
    return self.frame.origin.y;
}

- (void)setNewTop:(CGFloat)newTop {
    CGRect frame = self.frame;
    frame.origin.y = newTop;
    self.frame = frame;
}

- (CGFloat)newRight{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setNewRight:(CGFloat)newRight {
    CGRect frame = self.frame;
    frame.origin.x = newRight - frame.size.width;
    self.frame = frame;
}

- (CGFloat)newWidth{
    return self.frame.size.width;
}

- (void)setNewWidth:(CGFloat)newWidth {
    CGRect frame = self.frame;
    frame.size.width = newWidth;
    self.frame = frame;
}

- (CGFloat)newHeight{
    return self.frame.size.height;
}

- (void)setNewHeight:(CGFloat)newHeight {
    CGRect frame = self.frame;
    frame.size.height = newHeight;
    self.frame = frame;
}

- (CGFloat)newBottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setNewBottom:(CGFloat)newBottom {
    CGRect frame = self.frame;
    frame.origin.y = newBottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)newCenterX {
    return self.center.x;
}

- (void)setNewCenterX:(CGFloat)newCenterX {
    self.center = CGPointMake(newCenterX, self.center.y);
}

- (CGFloat)newCenterY {
    return self.center.y;
}

- (void)setNewCenterY:(CGFloat)newCenterY {
    self.center = CGPointMake(self.center.x, newCenterY);
}

- (CGFloat)autoScaleX {
    return [UIScreen mainScreen].bounds.size.width / 320;
}

- (CGFloat)autoScaleY {
    return [UIScreen mainScreen].bounds.size.height / 568;
}
@end
