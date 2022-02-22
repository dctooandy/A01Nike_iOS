//
//  CNMatchPayRequest.h
//  Hybird_1e3c3b
//
//  Created by cean on 2/19/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNMatchPayRequest : NSObject

/// 创建撮合订单
/// @param amount 撮合的金额
/// @param finish 完成回调
+ (void)createDepisit:(NSString *)amount finish:(KYHTTPCallBack)finish;

/// 确认撮合订单
/// @param billId  订单号
/// @param imgName  存款回执单图名字
/// @param imgNames  银行流水图名字数组
/// @param finish 完成回调
+ (void)commitDepisit:(NSString *)billId receiptImg:(NSString *)imgName transactionImg:(NSArray *)imgNames finish:(KYHTTPCallBack)finish;

/// 取消撮合订单
/// @param billId  订单号
/// @param finish 完成回调
+ (void)cancelDepisit:(NSString *)billId finish:(KYHTTPCallBack)finish;

/// 查询取款详情
/// @param billId  订单号
/// @param finish 完成回调
+ (void)queryDepisit:(NSString *)billId finish:(KYHTTPCallBack)finish;
@end

NS_ASSUME_NONNULL_END
