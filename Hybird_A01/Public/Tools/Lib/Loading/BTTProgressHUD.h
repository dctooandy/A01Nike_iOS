//
//  BTTProgressHUD.h
//  Hybird_A01
//
//  Created by Domino on 2018/7/27.
//  Copyright © 2018年 Domino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTTProgressHUD;
/**
 样式
 */
typedef NS_ENUM(NSUInteger, BTTProgressHUDShowType) {
    BTTProgressHUDLoadingIndicator = 0,//加载(指示器)
    BTTProgressHUDLoadingCircle = 1,//加载（圆环）
    BTTProgressHUDProgressCircle = 2,//进度(圆饼)
    BTTProgressHUDStatusSuccess = 3,//状态(成功)
    BTTProgressHUDStatusFail = 4,//状态(失败)
    BTTProgressHUDCustom = 5 //自定义
};
/**
 模式
 */
typedef NS_ENUM(NSUInteger, BTTProgressHUDModeType) {
    BTTProgressHUDModeHudOrCustom = 0,//显示所有
    BTTProgressHUDModeOnlyText = 1,//只显示文本
    BTTProgressHUDModeOnlyHudOrCustom = 2,//不显示文本
};
/**
 显示效果
 */
typedef NS_ENUM(NSUInteger, BTTProgressHUDAnimationType) {
    BTTProgressHUDAnimationNormal = 0,//普通效果
    BTTProgressHUDAnimationBTTring = 1//弹簧效果
};
/**
 背景颜色
 */
typedef NS_ENUM(NSInteger, BTTProgressHUDStyleType) {
    BTTProgressHUDStyleDark = 0,//背景颜色Dark
    BTTProgressHUDStyleLight = 1,//背景颜色Light
    BTTProgressHUDStyleClear     // 无背景
};
/**
 遮罩
 */
typedef NS_ENUM(NSInteger, BTTProgressHUDMaskType) {
    BTTProgressHUDMaskTypeNone = 0,//没有遮罩
    BTTProgressHUDMaskTypeClear = 1,//透明遮罩
    BTTProgressHUDMaskTypeGray = 2//灰色遮罩
};


@interface BTTProgressHUD : UIView
/**
 样式
 */
@property (nonatomic,assign) BTTProgressHUDShowType showType;
/**
 模式
 */
@property (nonatomic,assign) BTTProgressHUDModeType modeType;
/**
 显示效果
 */
@property (nonatomic,assign) BTTProgressHUDAnimationType animationType;
/**
 背景颜色
 */
@property (nonatomic,assign) BTTProgressHUDStyleType styleType;
/**
 遮罩
 */
@property (nonatomic,assign) BTTProgressHUDMaskType maskType;
//文本
@property (nonatomic,copy) NSString *text;
//图片宽度
@property (nonatomic,assign) CGFloat width;
//图片高度
@property (nonatomic,assign) CGFloat height;
//图片数组
@property (nonatomic,copy) NSArray *images;
//进度
@property (nonatomic,assign) CGFloat progress;
//结束时间
@property (nonatomic,assign) CGFloat dissmissTime;

@property (nonatomic,strong) UIImageView *iconImageView;

#pragma mark - init

+ (instancetype)shareInstance;

+ (instancetype)progressHUD;

#pragma mark - show

/**
 加载（指示器）样式
 */
+ (BTTProgressHUD *)showLoadingIndicatorText:(NSString *)text toView:(UIView *)view;
/**
 加载（圆环）样式
 */
+ (BTTProgressHUD *)showLoadingCircleText:(NSString *)text toView:(UIView *)view;

/**
 加载（圆环）样式, 只显示转圈
 */
+ (BTTProgressHUD *)showLoadingCircletoView:(UIView *)view;

/**
 进度（圆饼）样式
 */
+ (BTTProgressHUD *)showProgressCircleText:(NSString *)text toView:(UIView *)view;
/**
 状态（成功）样式
 */
+ (void)showSuccessText:(NSString *)text toView:(UIView *)view;
/**
 状态（失败）样式
 */
+ (void)showFailText:(NSString *)text toView:(UIView *)view;
/**
 自定义（图片或动态图不指定宽高）样式
 */
+ (BTTProgressHUD *)showCustomText:(NSString *)text images:(NSArray *)images toView:(UIView *)view;
/**
 自定义（图片或动态图指定宽高）样式
 */
+ (BTTProgressHUD *)showCustomText:(NSString *)text images:(NSArray *)images width:(CGFloat)width height:(CGFloat)height toView:(UIView *)view;
/**
 只有文本 样式
 */
+ (void)showOnlyText:(NSString *)text toView:(UIView *)view;
/**
 只有HUD或图片或动态图 样式
 */
+ (BTTProgressHUD *)showOnlyHUDOrCustom:(BTTProgressHUDShowType)showType images:(NSArray *)images toView:(UIView *)view;
/**
 实例方法 方便
 */
- (void)setCustomText:(NSString *)text images:(NSArray *)images width:(CGFloat)width height:(CGFloat)height;

/**
 显示方法（不指定view在Window上显示）
 */
- (void)showToView:(UIView *)view;

#pragma mark - dismiss
/**
 隐藏方法
 */
- (void)dismiss;

@end

