//
//  GradientImage.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/5/11.
//  Copyright © 2021 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GradientImage : NSObject
SingletonInterface(GradientImage);
// 製作漸層Image
// orien 四個方向
// colors 顏色數組 兩個
// bounds 範圍
- (UIImage *)layerImage:(BTTGradientOrientationType)orien colors:(nullable NSArray*)colors bounds:(CGRect)bounds;
- (UIColor *)HEX2Color:(NSInteger)hexCode inAlpha:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
