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
    KYMWithdrewStatusSubmit = 1, //取款提交
    KYMWithdrewStatusWaiting = 2, //取款等待
    KYMWithdrewStatusNotMatch = 3, //取款未匹配
    KYMWithdrewStatusTimeout = 4, //取款超时
    KYMWithdrewStatusConfirm = 5, //取款确认
    KYMWithdrewStatusFaild = 6, //取款失败
    KYMWithdrewStatusNotReceived = 7, //取款未到账
    KYMWithdrewStatusSuccessed = 100, //取款成功
};

@interface KYMWidthdrewUtility : NSObject

@end

NS_ASSUME_NONNULL_END
