//
//  CNPayAmountRecommendView.h
//  A05_iPhone
//
//  Created by cean.q on 2018/10/2.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 视图点击回调处理
 
 @param value 点击处理回调返回数值
 @param index 点击位置的索引
 */
typedef void (^CNPayAmountRecommendViewBlock)(NSString *value, NSInteger index);

/**
 支付金额推荐视图
 */
@interface CNPayAmountRecommendView : UIView


/**
 视图数据源
 */
@property(nonatomic, copy) NSArray<NSString *> *dataSource;


/**
 当前选中值
 */
@property(nonatomic, strong) NSString *currentSelectRecommendValue;


/**
 点击回调handler
 */
@property(nonatomic, copy) CNPayAmountRecommendViewBlock clickHandler;
@end
