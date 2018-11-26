//
//  CNPayVC.h
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HABaseViewController.h"
#import "CNPayChannelModel.h"

@interface CNPayVC : HABaseViewController
/** 渠道选中图标名称  */
@property (nonatomic, copy) NSString *selectedIcon;

/**
 支付模块

 @param channel 传入默认渠道，默认第一个
 @return 支付控制器实例
 */
- (instancetype)initWithChannel:(CNPayChannel)channel;
- (void)setContentViewHeight:(CGFloat)height fullScreen:(BOOL)full;
@end
