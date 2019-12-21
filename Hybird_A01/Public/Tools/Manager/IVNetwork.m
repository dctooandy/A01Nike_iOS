//
//  IVNetwork.m
//  Hybird_A01
//
//  Created by Levy on 12/20/19.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "IVNetwork.h"

@implementation IVNetwork

+ (IVUserInfoModel *)userInfo
{
    return NULL;
}

+ (id)sendUseCacheRequestWithSubURL:(NSString *)url paramters:(NSDictionary *)paramters completionBlock:(KYHTTPCallBack)completionBlock{
    [self requestWithUseCache:TRUE url:url paramters:paramters completionBlock:completionBlock];
    return @"";
}

+ (void)requestWithUseCache:(BOOL)useCache url:(NSString *)url paramters:(NSDictionary *)paramters completionBlock:(KYHTTPCallBack)completionBlock
{
//    IVBaseRequest *api = [self createRequestWithConfigure:configure url:url paramters:paramters useCache:useCache];
//
//    __weak typeof(self)weakSelf = self;
//    [api startWithCompletionBlock:^(IVRequestResultModel *result, id response) {
//        //apptoken过期
//        if (result.code_http == IVHttpResponseCodeTokenExpired) {
//            [weakSelf appTokenExpiredWithConfigure:configure useCache:useCache url:url paramters:paramters completionBlock:completionBlock];
//        } else {
//            if (completionBlock) {
//                completionBlock(result,response);
//            }
//        }
//        //如果获取的是缓存数据，继续请求远程服务器更新缓存
//        if ([api isDataFromCache]) {
//            [weakSelf requestWithConfigure:configure useCache:NO url:url paramters:paramters completionBlock:nil];
//        }
//    }];
//    return api;
    [[IVHttpManager shareManager] sendRequestWithMethod:KYHTTPMethodPOST
               url:url
        parameters:paramters
           headers:nil
          progress:nil
             cache:useCache
      cacheTimeout:3600 * 24
      denyRepeated:YES
          callBack:^(BOOL isCache, id  _Nullable response,
                     NSError * _Nullable error) {
                   if (isCache) {
                       NSLog(@"从缓存获取");
                   } else {
                       NSLog(@"从远程获取");
                   }
               }
    originCallBack:^(id  _Nullable response,
                     NSError * _Nullable error) {
                   NSLog(@"从远程获取");
               }];
}
//appToken过期处理
//+ (void)appTokenExpiredWithUseCache:(BOOL)useCache url:(NSString *)url paramters:(NSDictionary *)paramters completionBlock:(IVRequestCallBack)completionBlock
//{
//    __weak typeof(self)weakSelf = self;
    //获取apptoken
//    GetAppTokenApi *appTokenApi = [GetAppTokenApi getApiWithArgument:nil];
//    [appTokenApi startWithCompletionBlock:^(IVRequestResultModel *result1, id response1) {
//        if (result1.status) {
//            //获取成功，重新发起上次请求
//            [weakSelf requestWithConfigure:configure useCache:useCache url:url paramters:paramters completionBlock:completionBlock];
//        } else {
//            if (completionBlock) {
//                completionBlock(result1, response1);
//            }
//        }
//    }];
//}


@end
