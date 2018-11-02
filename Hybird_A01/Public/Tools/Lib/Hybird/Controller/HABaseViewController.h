//
//  HABaseViewController.h
//  MainHybird
//
//  Created by Key on 2018/7/6.
//  Copyright © 2018年 Key. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTProgressHUD.h"

@interface HABaseViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic, strong) BTTProgressHUD *hud;

@property(nonatomic, assign) BOOL hideBackItem;
/**
 显示加载框
 */
- (void)showLoading;
/**
 隐藏加载框
 */
- (void)hideLoading;

/**
 导航栏返回按钮事件，可以由每个controller重写实现差异化
 */
- (void)goToBack;

@end
