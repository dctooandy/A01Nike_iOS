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
@end

NS_ASSUME_NONNULL_END
