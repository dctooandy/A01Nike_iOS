//
//  BTTHttpManager.m
//  Hybird_A01
//
//  Created by Key on 2018/11/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTHttpManager.h"
#import "BTTBankModel.h"
@implementation BTTHttpManager
+ (void)sendRequestWithUrl:(NSString *)url paramters:(NSDictionary *)paramters completionBlock:(IVRequestCallBack)completionBlock
{
    [IVNetwork sendRequestWithSubURL:url paramters:paramters completionBlock:completionBlock];
}

+ (void)sendRequestUseCacheWithUrl:(NSString *)url paramters:(NSDictionary *)paramters completionBlock:(IVRequestCallBack)completionBlock
{
    [IVNetwork sendUseCacheRequestWithSubURL:url paramters:paramters completionBlock:completionBlock];
}
+ (void)publicGameLoginWithParams:(NSDictionary *)params isTry:(BOOL)isTry completeBlock:(IVRequestCallBack)completeBlock{
    NSString *subUrl = isTry ? @"public/game/tryPlay" : @"public/game/login";
    [self sendRequestWithUrl:subUrl paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        NSString *url = nil;
        if (result.status && [result.data isKindOfClass:[NSDictionary class]]) {
            url = [result.data valueForKey:@"url"];
        }
        if (completeBlock) {
            completeBlock(result,url);
        }
    }];
}

+ (void)publicGameTransferWithProvider:(NSString *)provider completeBlock:(IVRequestCallBack)completeBlock
{
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setValue:provider forKey:@"game_name"];
    [self sendRequestWithUrl: @"public/game/transfer" paramters:params.copy completionBlock:completeBlock];
}
+ (void)fetchBankListWithCompletion:(IVRequestCallBack)completion
{
    NSDictionary *params = @{
                           @"flag" : @"9;1",
                           @"order":@"PRIORITY_ORDER",
                           @"delete_flag":@"0"
                           };
    [self sendRequestWithUrl:@"public/bankcard/getList" paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        NSArray *bankList = result.data;
        if (isArrayWithCountMoreThan0(bankList)) {
            bankList = [BTTBankModel arrayOfModelsFromDictionaries:result.data error:nil];
        }
        if (completion) {
            completion(result,bankList);
        }
    }];
}
+ (void)fetchBindStatusWithCompletion:(IVRequestCallBack)completion
{
    NSString *typeList = @"phone;email;bank;btc";
    NSDictionary *pramas = @{@"typeList":typeList};
    [self sendRequestWithUrl:BTTIsBindStatusAPI paramters:pramas completionBlock:^(IVRequestResultModel *result, id response) {
        if (result.data && [result.data isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *userInfo = @{}.mutableCopy;
            userInfo[@"isPhoneBinded"] = [result.data valueForKey:@"phone"];
            userInfo[@"isEmailBinded"] = [result.data valueForKey:@"email"];
            userInfo[@"isBankBinded"] = [result.data valueForKey:@"bank"];
            userInfo[@"isBtcBinded"] = [result.data valueForKey:@"btc"];
            [IVNetwork updateUserInfo:userInfo];
        }
        if (completion) {
            completion(result,response);
        }
    }];
}
+ (void)addBankCardWithParams:(NSDictionary *)params completion:(IVRequestCallBack)completion
{
    [self sendRequestWithUrl:@"public/bankcard/add" paramters:params completionBlock:completion];
}
@end
