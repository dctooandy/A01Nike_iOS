//
//  BTTPopoverView.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/3.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTPopoverAction.h"

// 弹窗箭头的样式
typedef NS_ENUM(NSUInteger, BTTPopoverViewArrowStyle) {
    BTTPopoverViewArrowStyleRound = 0, // 圆角
    BTTPopoverViewArrowStyleTriangle   // 菱角
};

@interface BTTPopoverView : UIView

/**
 是否开启点击外部隐藏弹窗, 默认为YES.
 */
@property (nonatomic, assign) BOOL hideAfterTouchOutside;

/**
 是否显示阴影, 如果为YES则弹窗背景为半透明的阴影层, 否则为透明, 默认为NO.
 */
@property (nonatomic, assign) BOOL showShade;

/**
 弹出窗风格, 默认为 BTTPopoverViewStyleDefault(白色).
 */
@property (nonatomic, assign) BTTPopoverViewStyle style;

/**
 箭头样式, 默认为 BTTPopoverViewArrowStyleRound.
 如果要修改箭头的样式, 需要在显示先设置.
 */
@property (nonatomic, assign) BTTPopoverViewArrowStyle arrowStyle;

+ (instancetype)PopoverView;

/**
 指向指定的View来显示弹窗

 @param pointView 箭头指向的View
 @param actions 动作对象集合<BTTPopoverAction>
 */
- (void)showToView:(UIView *)pointView withActions:(NSArray<BTTPopoverAction *> *)actions;

/**
 指向指定的点来显示弹窗

 @param toPoint 箭头指向的点(这个点的坐标需按照keyWindow的坐标为参照)
 @param actions 动作对象集合<BTTPopoverAction>
 */
- (void)showToPoint:(CGPoint)toPoint withActions:(NSArray<BTTPopoverAction *> *)actions;

@end
