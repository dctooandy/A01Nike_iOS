//
//  GradientImage.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/5/11.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "GradientImage.h"

@implementation GradientImage
SingletonImplementation(GradientImage);
- (UIImage *)layerImage:(BTTGradientOrientationType)orien colors:(nullable NSArray*)colors bounds:(CGRect)bounds
{
    UIColor *fromColor = [self HEX2Color:0x133469 inAlpha:1.0f];
    UIColor *toColor = [self HEX2Color:0x24212A inAlpha:1.0f];
    if ([colors count] > 1 && [colors.firstObject isKindOfClass:[UIColor class]])
    {
        fromColor = [colors firstObject];
        toColor = [colors lastObject];
    }
    CGRect tempFrame = bounds;
    CAGradientLayer *layer = [self gradientImageWithBounds:tempFrame
                                                 andColors:@[(id)fromColor.CGColor,(id)toColor.CGColor]
                                                  andOrien:orien];
    UIGraphicsBeginImageContext(layer.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (UIColor *)HEX2Color:(NSInteger)hexCode inAlpha:(CGFloat)alpha
{
    float red   = ((hexCode >> 16) & 0x000000FF)/255.0f;
    float green = ((hexCode >> 8) & 0x000000FF)/255.0f;
    float blue  = ((hexCode) & 0x000000FF)/255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
- (CAGradientLayer*)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray*)colors andOrien:(BTTGradientOrientationType)orien{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = bounds;
    CGFloat startX = (orien == RightToLeft ? 1 : (orien == LeftToRight ? 0 : 0.5));
    CGFloat startY = (orien == TopToBottom ? 0 : (orien == BottomToTop ? 1 : 0.5));
    CGFloat endX = (orien == RightToLeft ? 0 : (orien == LeftToRight ? 1 : 0.5));
    CGFloat endY = (orien == TopToBottom ? 1 : (orien == BottomToTop ? 0 : 0.5));
    layer.startPoint = CGPointMake(startX, startY);
    layer.endPoint = CGPointMake(endX, endY);
//    layer.locations = @[@0.5, @1.0];
    layer.colors = colors;
    return layer;
}
@end
