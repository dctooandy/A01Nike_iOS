//
//  UIView+FrameCategory.h
//  A02_iPhone
//
//  Created by Robert on 16/03/2018.
//  Copyright © 2018 robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameCategory)
/** 左边距 */
@property (nonatomic) CGFloat newLeft;

/** 顶部边距 */
@property (nonatomic) CGFloat newTop;

/** 右边距 */
@property (nonatomic) CGFloat newRight;

/** 底部边距 */
@property (nonatomic) CGFloat newBottom;

/** 高度 */
@property (nonatomic) CGFloat newHeight;

/** 宽度 */
@property (nonatomic) CGFloat newWidth;

/** x中心坐标 */
@property (nonatomic) CGFloat newCenterX;

/** y中心坐标 */
@property (nonatomic) CGFloat newCenterY;

@property (readonly, nonatomic) CGFloat autoScaleX;

@property (readonly, nonatomic) CGFloat autoScaleY;

- (CGFloat)newWidth;

- (CGFloat)newHeight;

@end
