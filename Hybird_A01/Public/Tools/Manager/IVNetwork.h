//
//  IVNetwork.h
//  Hybird_A01
//
//  Created by Levy on 12/20/19.
//  Copyright © 2019 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IVUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IVNetwork : NSObject

/**
 获取获取渠道ID
 */
+ (NSString *)parentId;


+ (NSString *)appToken;
/**
 获取缓存的手机站域名
 */
+ (NSString *)h5Domain;

/**
 注册异常处理
 */
+ (void)registException;

/**
 设置默认手机站域名
 */
+ (void)setDefaultH5Domian:(NSString *)defaultH5Domain;
/**
 设置默认CDN
 */
+ (void)setDefaultCDN:(NSString *)defaultCDN;
/**
 更新缓存的手机站域名
 */
+ (void)setH5Domain:(NSString *)h5Domain;
/**
 获取缓存的所有手机站域名
 */
+ (NSArray *)h5Domains;
/**
 获取缓存存的cdn
 */
+ (NSString *)cdn;
/**
 获取缓存存的publicConfig所有配置
 */
+ (NSString *)getPublicConfigWithKey:(NSString *)key;
/**
 获取当前用户信息
 */
+ (IVUserInfoModel *)userInfo;
/**
 更新用户信息
 */
+ (void)updateUserInfo:(NSDictionary *)userInfo;
/**
 清除用户信息
 */
+ (void)cleanUserInfo;

/**
 开始启动流程
 */
+ (void)startLaunchProcessWithFinished:(void(^)(void))finished;

/**
 检查更新
 */
+ (void)checkAppUpdate;

/**
 检测当前网络状态

 @param type 类型
 @param window 当前app的window
 @param block 网络诊断按钮点击事件
 */
//+ (void)startCheckWithType:(IVCheckNetworkType)type appWindow:(UIWindow *)window detailBtnClickedBlock:(void(^)(void))block;
//+ (void)checkNetworkWithOccasion:(IVCheckNetworkOccasion)occasion;
+ (void)setDetailCheckCompletionBlock:(void(^)(NSString *log))completionBlock;
+ (void)setDetailCheckProgressBlock:(void(^)(double progress))progressBlock;


/**
 获取当前网络类型
 */
+ (NSString *)getNetworkType;

/**
 获取设备ID
 */
+ (NSString *)getDeviceId;
/**
 发送设备信息
 */
+ (void)sendDeviceInfo;
/**
 网络请求，常用
 * post，baseurl为网关，自动拼接apptoken和usertoken
 * requestSerializer，responseSerializer为http，
 * timeoutInterval 为20秒
 * requestAuthorizationHeaderFieldArray为nil
 * requestHeaderFieldValueDictionary为nil
 */
+ (id)sendRequestWithSubURL:(NSString *)url paramters:(NSDictionary * __nullable)paramters completionBlock:(KYHTTPCallBack)completionBlock;
/**
 网络请求，常用, 使用缓存
 * post，baseurl为网关，自动拼接apptoken和usertoken
 * requestSerializer，responseSerializer为http，
 * timeoutInterval 为20秒
 * requestAuthorizationHeaderFieldArray为nil
 * requestHeaderFieldValueDictionary为nil
 */
+ (id)sendUseCacheRequestWithSubURL:(NSString *)url paramters:(NSDictionary * __nullable)paramters completionBlock:(KYHTTPCallBack)completionBlock;

+ (void)requestWithUseCache:(BOOL)useCache url:(NSString *)url paramters:(NSDictionary *__nullable)paramters completionBlock:(KYHTTPCallBack)completionBlock;

/**
 网络请求，通用
 @param configure 配置
 isOutside, 是否为与网关无关的请求
 baseUrl,默认为网关
 method 默认为POST
 timeout 请求超时
 requestSerializerType 默认为HTTP
 responseSerializerType 默认为HTTP
 headerFieldArray 默认为nil
 headerFieldValueDictionary 默认nil
 @param completionBlock 回调
 */
//+ (id)sendRequestWithConfigure:(IVRequestConfigure *)configure url:(NSString *)url paramters:(NSDictionary *)paramters completionBlock:(KYHTTPCallBack)completionBlock;
/**
 网络请求，通用, 使用缓存
 @param configure 配置
 isOutside, 是否为与网关无关的请求
 baseUrl,默认为网关
 method 默认为POST
 timeout 请求超时
 requestSerializerType 默认为HTTP
 responseSerializerType 默认为HTTP
 headerFieldArray 默认为nil
 headerFieldValueDictionary 默认nil
 @param completionBlock 回调
 */
//+ (id)sendRequestUseCacheWithConfigure:(IVRequestConfigure *)configure url:(NSString *)url paramters:(NSDictionary *)paramters completionBlock:(KYHTTPCallBack)completionBlock ;

/**
 取消某个网络请求

 @param request request
 */
+ (void)cancelRequest:(id)request;
/**
 显示提示框
 
 @param message message
 */
+ (void)showToastWithMessage:(NSString *)message;
/**
 进入后台
 */
+ (void)applicationDidEnterBackground:(UIApplication *)application;

/**
 进入前台
 */
+ (void)applicationWillEnterForeground:(UIApplication *)application;

+ (void)requestPostWithUrl:(NSString *)url paramters:(NSDictionary * __nullable)paramters completionBlock:(KYHTTPCallBack)completionBlock;


@end

NS_ASSUME_NONNULL_END
