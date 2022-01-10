//
//  UIColor+Util.h
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/7/27.
//  Copyright © 2018年 Key. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Util)

/* 从十六进制字符串获取颜色 */
+ (UIColor *)colorWithHexString:(NSString *)color;

/* 从十六进制字符串获取颜色 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor*)jk_gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;
@end
