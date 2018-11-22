//
//  BTTHttpManager.h
//  Hybird_A01
//
//  Created by Key on 2018/11/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTTHttpManager : NSObject
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
+ (void)fetchBindStatusWithUseCache:(BOOL)useCache;
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
@end
