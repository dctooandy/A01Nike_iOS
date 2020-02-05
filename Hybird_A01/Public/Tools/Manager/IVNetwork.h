//
//  IVNetwork.h
//  Hybird_A01
//
//  Created by Levy on 12/20/19.
//  Copyright © 2019 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IVUserInfoModel.h"
#import "BTTCustomerInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IVNetwork : NSObject

/**
 获取缓存的手机站域名
 */
+ (NSString *)h5Domain;

/**
 获取缓存存的cdn
 */
+ (NSString *)cdn;

/**
 获取当前用户信息
 */
//+ (IVUserInfoModel *)userInfo;

+ (BTTCustomerInfoModel *)savedUserInfo;
/**
 更新用户信息
 */
+ (void)updateUserInfo:(NSDictionary *)userInfo;
/**
 清除用户信息
 */
+ (void)cleanUserInfo;


/**
 检查更新
 */
+ (void)checkAppUpdate;

+ (void)requestWithUseCache:(BOOL)useCache url:(NSString *)url paramters:(NSDictionary *__nullable)paramters completionBlock:(KYHTTPCallBack)completionBlock;

+ (void)requestPostWithUrl:(NSString *)url paramters:(NSDictionary * __nullable)paramters completionBlock:(KYHTTPCallBack)completionBlock;


@end

NS_ASSUME_NONNULL_END
