//
//  CNMFastPayStatusVC.h
//  Hybird_1e3c3b
//
//  Created by cean on 2/17/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNPayBaseVC.h"
#import "CNMBankModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 页面 UI 状态区分
typedef NS_ENUM(NSUInteger, CNMPayUIStatus) {
    CNMPayUIStatusSubmit,  //已提交
    CNMPayUIStatusPaying,  //等待支付
    CNMPayUIStatusConfirm, //已确认
    CNMPayUIStatusSuccess  //已完成
};

@interface CNMFastPayStatusVC : CNPayBaseVC
@property (nonatomic, assign) CNMPayUIStatus status;
@property (nonatomic, strong) CNMBankModel *bankModel;
@end

NS_ASSUME_NONNULL_END
