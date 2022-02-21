//
//  KYMWidthdrewUtility.h
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/20.
//  Copyright © 2022 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KYMWithdrewStatus) {
    KYMWithdrewStatusChecking = 0, //审核中
    KYMWithdrewStatusChecked = 1, //审核通过，付款中
    KYMWithdrewStatusPaid = 2, //已付款，等待到账
    KYMWithdrewStatusFaild = 3, //订单异常
    KYMWithdrewStatusTimeout = 4, //确认超时
    KYMWithdrewStatusSuccessed = 5, //成功
};

@interface KYMWidthdrewUtility : NSObject

@end

NS_ASSUME_NONNULL_END
