//
//  CNMFastPayStatusVC.h
//  Hybird_1e3c3b
//
//  Created by cean on 2/17/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNPayBaseVC.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, CNMPayStatus) {
    CNMPayStatusSubmit,  //已提交
    CNMPayStatusPaying,  //等待支付
    CNMPayStatusConfirm, //已确认
    CNMPayStatusSuccess  //已完成
};

@interface CNMFastPayStatusVC : CNPayBaseVC
@property (nonatomic, assign) CNMPayStatus status;
@end

NS_ASSUME_NONNULL_END
