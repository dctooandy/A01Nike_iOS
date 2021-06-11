//
//  CNPayRequestManager.h
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNPayWriteModel.h"


@class CNPayOrderModel;

/// 预设支付方式总个数
extern NSInteger const kPayTypeTotalCount;

@interface CNPayRequestManager : NSObject

/**
 总接口，查询支付方式是否可用及支付数据
 
 @param completeHandler 访问回调
 */
+ (void)queryAllChannelCompleteHandler:(KYHTTPCallBack)completeHandler;


/**
 支付form表单提交
 
 @param model      订单支付模型
 */
+ (NSString *)submitPayFormWithOrderModel:(CNPayOrderModel *)model;

+ (NSString *)submitPayFormWithOrderModelV2:(CNPayOrderModelV2 *)model;


@end

