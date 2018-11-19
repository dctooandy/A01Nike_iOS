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
+ (void)fetchBankListWithCompletion:(IVRequestCallBack)completion;
//获取手机、邮箱、银行卡、比特币钱包绑定状态
+ (void)fetchBindStatusWithCompletion:(IVRequestCallBack)completion;
//添加银行卡
+ (void)addBankCardWithParams:(NSDictionary *)params completion:(IVRequestCallBack)completion;
@end
