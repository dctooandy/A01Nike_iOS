//
//  CNPayVC.h
//  Hybird_A01
//
//  Created by cean.q on 2018/11/29.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "HABaseViewController.h"
#import "CNPayChannelModel.h"

NS_ASSUME_NONNULL_BEGIN

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
- (void)addBankView;
- (void)removeBankView;
@end

NS_ASSUME_NONNULL_END
