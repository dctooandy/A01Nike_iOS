//
//  Live800ChatLib.h
//  Pods
//
//  Created by peng zhu on 16/10/14.
//
//

#import <UIKit/UIKit.h>
#import "LIVUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface Live800ChatLib : NSObject

/**
 SDK初始化，必须在startService之前调用，推荐在程序启动时调用。此方法不会进行网络连接。如果调用处在非主线程，回调函数会在主线程中调用。如果调用处已处于主线程队列，则直接返回。

 @param successBlock 主线程中成功回调
 @param failedBlock 主线程中失败回调
 */
+ (void)setupLive800ChatWithSuccessBlock:(void(^)())successBlock
                             failedBlock:(void(^)(NSError * error))failedBlock;


/**
 切换用户，当用户登录成功时可调用此方法，以便SDK使用该用户的信息与客服沟通

 @param user 信任访客的信息,如果需要切换到匿名访客（即用户登出了当前用户，进入无登陆状态），则传nil
 @param error 错误输出
 */
+ (void)switchUser:(LIVUserInfo * _Nullable)user error:(NSError *__autoreleasing *)error;


/**
 开始服务，进入客服聊天页面

 @param userAvator  访客头像，如果无头像，可以为空
 @param superVC     弹出聊天页面父页面
 @param operatorId  客服id
 @param skillId     分组id
 @param subchannel  渠道细分参数
 */
+ (void)startService:(UIImage * _Nullable)userAvator
             superVC:(UIViewController *)superVC
          operatorId:(NSString * _Nullable)operatorId
             skillId:(NSString * _Nullable)skillId
          subchannel:(NSString * _Nullable)subchannel;


/**
 删除指定用户的所有历史消息

 @param userAccount 需要删除历史消息的用户的id，如果需要删除的是匿名访客，则传nil
 @param successBlock 异步成功回调
 @param failedBlock 异步失败回调
 */
+ (void)removeMessagesForUserAccount:(NSString * _Nullable)userAccount
                        successBlock:(void(^)())successBlock
                         failedBlock:(void(^)(NSError * error))failedBlock;

@end

NS_ASSUME_NONNULL_END
