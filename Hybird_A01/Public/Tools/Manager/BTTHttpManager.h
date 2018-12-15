//
//  BTTHttpManager.h
//  Hybird_A01
//
//  Created by Key on 2018/11/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTTHttpManager : NSObject

@property (nonatomic, assign) NSInteger unreadNum;

+ (void)sendRequestWithUrl:(NSString *)url paramters:(NSDictionary *)paramters completionBlock:(IVRequestCallBack)completionBlock;

+ (void)sendRequestUseCacheWithUrl:(NSString *)url paramters:(NSDictionary *)paramters completionBlock:(IVRequestCallBack)completionBlock;
/**
 新的登录游戏接口
 
 @param params 参数
 @param isTry yes为试玩，no为真钱
 */
+ (void)publicGameLoginWithParams:(NSDictionary *)params isTry:(BOOL)isTry completeBlock:(IVRequestCallBack)completeBlock;

/**
 新的转账到游戏接口
 
 @param provider 游戏商
 */
+ (void)publicGameTransferWithProvider:(NSString *)provider completeBlock:(IVRequestCallBack)completeBlock;
//获取银行卡列表
+ (void)fetchBankListWithUseCache:(BOOL)useCache completion:(IVRequestCallBack)completion;
//获取手机、邮箱、银行卡、比特币钱包绑定状态
+ (void)fetchBindStatusWithUseCache:(BOOL)useCache completionBlock:(IVRequestCallBack)completionBlock;
/**
 添加、修改银行卡
 */
+ (void)updateBankCardWithUrl:(NSString *)url params:(NSDictionary *)params completion:(IVRequestCallBack)completion;
//获取人工服务时需要验证的手机和银行卡
+ (void)fetchHumanBankAndPhoneWithCompletion:(IVRequestCallBack)completion;
//验证人工服务的手机号和银行卡号
+ (void)verifyHumanBankAndPhoneWithParams:(NSDictionary *)params completion:(IVRequestCallBack)completion;
//添加比特比钱包
+ (void)addBTCCardWithUrl:(NSString *)url params:(NSDictionary *)params completion:(IVRequestCallBack)completion;
/**
 删除银行卡或比特币钱包
 @param isBTC 是否为比特币
 @param isAuto 是否自动审批
 */
+ (void)deleteBankOrBTC:(BOOL)isBTC isAuto:(BOOL)isAuto completion:(IVRequestCallBack)completion;
//人工服务更换手机号
+ (void)updatePhoneHumanWithParams:(NSDictionary *)params completion:(IVRequestCallBack)completion;
//获取比特币汇率
+ (void)fetchBTCRateWithUseCache:(BOOL)useCache;
//取款
+ (void)submitWithdrawWithUrl:(NSString *)url params:(NSDictionary *)params completion:(IVRequestCallBack)completion;

+ (void)getOpenAccountStatusCompletion:(IVRequestCallBack)completion;
//刷新用户信息
+ (void)fetchUserInfoCompleteBlock:(IVRequestCallBack)completeBlock;

// 请求未读消息的数量
+ (void)requestUnReadMessageNum:(IVRequestCallBack)completeBlock;
// 获取游戏厅列表
+ (void)fetchGamePlatformsWithCompletion:(IVRequestCallBack)completion;
@end
