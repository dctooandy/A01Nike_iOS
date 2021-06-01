//
//  BTTHttpManager.m
//  Hybird_1e3c3b
//
//  Created by Key on 2018/11/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTHttpManager.h"
#import "BTTBankModel.h"
#import <IVCacheLibrary/IVCacheWrapper.h>
@implementation BTTHttpManager
+ (void)sendRequestWithUrl:(NSString *)url paramters:(NSDictionary *)paramters completionBlock:(KYHTTPCallBack)completionBlock
{
    [[IVHttpManager shareManager] sendRequestWithUrl:url parameters:paramters callBack:completionBlock];
}

+ (void)sendRequestUseCacheWithUrl:(NSString *)url paramters:(NSDictionary *)paramters completionBlock:(KYHTTPCallBack)completionBlock
{
    [[IVHttpManager shareManager] sendRequestWithMethod:KYHTTPMethodPOST url:url parameters:paramters cache:YES cacheTimeout:3600 * 24 callBack:^(BOOL isCache, id  _Nullable response, NSError * _Nullable error) {
        if (isCache) {
            completionBlock(response,error);
        }else{
            completionBlock(response,error);
        }
    } originCallBack:completionBlock];
   
}
+ (void)publicGameLoginWithParams:(NSDictionary *)params isTry:(BOOL)isTry completeBlock:(KYHTTPCallBack)completeBlock{
    
    NSString *subUrl = isTry ? @"public/game/tryPlay" : @"public/game/login";
    [IVNetwork requestPostWithUrl:subUrl paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        NSString *url = @"";
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if ([result.body isKindOfClass:[NSDictionary class]]) {
                url = [result.body valueForKey:@"url"];
            }
        }
        if (completeBlock) {
            completeBlock(result,error);
        }
    }];
}

+ (void)publicGameTransferWithProvider:(NSString *)provider completeBlock:(KYHTTPCallBack)completeBlock
{
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setValue:provider forKey:@"game_name"];
    [self sendRequestWithUrl: @"public/game/transfer" paramters:params.copy completionBlock:completeBlock];
}
+ (void)fetchBankListWithUseCache:(BOOL)useCache completion:(KYHTTPCallBack)completion
{
    NSMutableDictionary *params = @{
                             @"loginName" : [IVNetwork savedUserInfo].loginName,
                             }.mutableCopy;
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:BTTAccountQuery paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [weakSelf fetchBankListResult:result.body completion:completion];
        }
    }];
}
+ (void)fetchGamePlatformsWithCompletion:(KYHTTPCallBack)completion
{
    [self sendRequestUseCacheWithUrl:BTTGamePlatforms paramters:nil completionBlock:completion];
}
//处理银行卡列表获取结果
+ (void)fetchBankListResult:(NSDictionary *)result completion:(KYHTTPCallBack)completion
{
    if (result!=nil) {
        [IVCacheWrapper setObject:result forKey:BTTCacheBankListKey];
    }
    if (completion) {
        completion(result,nil);
    }
}
//处理绑定状态获取结果
+ (void)fetchBindStatusWithUseCache:(BOOL)useCache completionBlock:(KYHTTPCallBack)completionBlock
{
//    NSString *typeList = @"phone;email;bank;btc";
//    NSDictionary *params = @{@"typeList":typeList};
//    NSString *url = BTTIsBindStatusAPI;
//    weakSelf(weakSelf)
//    if (useCache) {
//        [self sendRequestUseCacheWithUrl:url paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
//            [weakSelf fetchBindStatusResult:response completionBlock:completionBlock];
//        }];
//    } else {
//        [self sendRequestWithUrl:url paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
//            [weakSelf fetchBindStatusResult:response completionBlock:completionBlock];
//        }];
//    }
}
+ (void)fetchBindStatusResult:(NSDictionary *)result completionBlock:(KYHTTPCallBack)completionBlock {
}

+ (void)getOpenAccountStatusCompletion:(KYHTTPCallBack)completion {
    weakSelf(weakSelf)
    [self sendRequestWithUrl:BTTOpenAccountStatus paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [weakSelf fetchBindStatusResult:response completionBlock:completion];
    }];
}

+ (void)updateBankCardWithUrl:(NSString *)url params:(NSDictionary *)params completion:(KYHTTPCallBack)completion
{
    [self sendRequestWithUrl:url paramters:params completionBlock:completion];
}
+ (void)fetchHumanBankAndPhoneWithBankId:(NSString *)bankId Completion:(KYHTTPCallBack)completion
{
    NSDictionary *params = nil;
    if (bankId.length) {
        params = @{@"login_name":[IVNetwork savedUserInfo].loginName,@"customer_bank_id":bankId};
    } else {
        params = @{@"login_name":[IVNetwork savedUserInfo].loginName};
    }
    [self sendRequestWithUrl:@"public/forgot/getBanknoAndPhone" paramters:params completionBlock:completion];
}
+ (void)verifyHumanBankAndPhoneWithParams:(NSDictionary *)params completion:(KYHTTPCallBack)completion
{
    [self sendRequestWithUrl:BTTModifyBankRequests paramters:params completionBlock:completion];
}
+ (void)addBTCCardWithUrl:(NSString *)url params:(NSDictionary *)params completion:(KYHTTPCallBack)completion
{
    [self sendRequestWithUrl:url paramters:params completionBlock:completion];
}
+ (void)deleteBankOrBTC:(BOOL)isBTC isAuto:(BOOL)isAuto completion:(KYHTTPCallBack)completion
{
    NSString *url = nil;
    if (isBTC) {
        url = isAuto ? @"public/bankcard/delBtcAuto" : @"public/bankcard/delBtc";
    } else {
        url = isAuto ? @"public/bankcard/delAuto" : @"public/bankcard/del";
    }
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"customer_bank_id"] = [[NSUserDefaults standardUserDefaults] valueForKey:BTTSelectedBankId];
    [self sendRequestWithUrl:url paramters:params.copy completionBlock:completion];
}
+ (void)updatePhoneHumanWithParams:(NSDictionary *)params completion:(KYHTTPCallBack)completion
{
    [self sendRequestWithUrl:@"users/updatePhone" paramters:params completionBlock:completion];
}
+ (void)fetchBTCRateWithUseCache:(BOOL)useCache
{
//    NSDictionary *params = @{@"amount":@"1",@"querytype" : @"01"};
//    NSString *url = @"public/payment/btcRate";
//    weakSelf(weakSelf)
//    if (useCache) {
//        [self sendRequestUseCacheWithUrl:url paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
//            [weakSelf fetchBTCRateResult:response];
//        }];
//    } else {
//        [self sendRequestWithUrl:url paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
//            [weakSelf fetchBTCRateResult:response];
//        }];
//    }
}
+ (void)fetchBTCRateResult:(IVJResponseObject *)result {
    if (result.body && [result.body isKindOfClass:[NSDictionary class]] && [result.body valueForKey:@"btcrate"]) {
        NSString *rate = [result.body valueForKey:@"btcrate"];
        [[NSUserDefaults standardUserDefaults] setValue:rate forKey:BTTCacheBTCRateKey];
    }
}
+ (void)submitWithdrawWithUrl:(NSString *)url params:(NSDictionary *)params completion:(KYHTTPCallBack)completion
{
    [self sendRequestWithUrl:url paramters:params completionBlock:completion];
}
+ (void)fetchUserInfoCompleteBlock:(KYHTTPCallBack)completeBlock{
    if (![IVNetwork savedUserInfo]) {
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    params[@"inclAddress"] = @1;
    params[@"inclBankAccount"] = @1;
    params[@"inclBtcAccount"] = @1;
    params[@"inclCredit"] = @1;
    params[@"inclEmail"] = @1;
    params[@"inclEmailBind"] = @1;
    params[@"inclMobileNo"] = @1;
    params[@"inclMobileNoBind"] = @1;
    params[@"inclPwdExpireDays"] = @1;
    params[@"inclRealName"] = @1;
    params[@"inclVerifyCode"] = @1;
    params[@"inclXmFlag"] = @1;
    params[@"verifyCode"] = @1;
    params[@"inclNickNameFlag"] = @1;
    params[@"inclXmTransferState"] = @1;
    params[@"inclUnBondPhoneCount"] = @1;
    params[@"inclExistsWithdralPwd"] = @1;
    [IVNetwork requestPostWithUrl:BTTGetLoginInfoByName paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (result.body!=nil) {
                [IVNetwork updateUserInfo:result.body];
            }
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
        if (completeBlock) {
            completeBlock(response, error);
        }
    }];
}


+ (void)requestUnReadMessageNum:(KYHTTPCallBack)completeBlock {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    [IVNetwork requestPostWithUrl:BTTIsUnviewedAPI paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"] && [result.body isKindOfClass:[NSDictionary class]]) {
            [[NSUserDefaults standardUserDefaults] setObject:result.body[@"val"] forKey:BTTUnreadMessageNumKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if ([result.body[@"val"] integerValue]) {
                [self resetRedDotState:YES forKey:BTTHomePageMessage]; // BTTMineCenterMessage
                [self resetRedDotState:YES forKey:BTTMineCenterMessage];
                [self resetRedDotState:YES forKey:BTTDiscountMessage];
                [self resetRedDotState:YES forKey:BTTMineCenterNavMessage];
            } else {
                [self resetRedDotState:NO forKey:BTTHomePageMessage];
                [self resetRedDotState:NO forKey:BTTMineCenterMessage];
                [self resetRedDotState:NO forKey:BTTDiscountMessage];
                [self resetRedDotState:NO forKey:BTTMineCenterNavMessage];
            }
        }
    }];

}

@end
