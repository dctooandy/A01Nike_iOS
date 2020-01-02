//
//  IVNetwork.m
//  Hybird_A01
//
//  Created by Levy on 12/20/19.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "IVNetwork.h"
#import "IVNetworkManager.h"
#import <IVCacheLibrary/IVCacheWrapper.h>
#import <YYModel.h>


@implementation IVNetwork

+ (IVUserInfoModel *)userInfo
{
    return [IVNetworkManager sharedInstance].userInfoModel;;
}

+ (BTTUserInfoModel *)savedUserInfo
{
    NSDictionary *json = [IVCacheWrapper objectForKey:@"customer"];
    if (json==nil) {
        return nil;
    }
    BTTUserInfoModel *model = [BTTUserInfoModel yy_modelWithJSON:json];
    return model;
}

+ (void)updateUserInfo:(NSDictionary *)userInfo
{
    if (!userInfo) {
        return;
    }
    [IVCacheWrapper setObject:userInfo forKey:@"customer"];
}

+ (id)sendUseCacheRequestWithSubURL:(NSString *)url paramters:(NSDictionary * __nullable)paramters completionBlock:(KYHTTPCallBack)completionBlock{
    [self requestWithUseCache:TRUE url:url paramters:paramters completionBlock:completionBlock];
    return @"";
}

+ (void)requestPostWithUrl:(NSString *)url paramters:(NSDictionary * __nullable)paramters completionBlock:(KYHTTPCallBack)completionBlock{
    [[IVHttpManager shareManager]sendRequestWithUrl:url parameters:paramters callBack:completionBlock];
}

+ (void)requestWithUseCache:(BOOL)useCache url:(NSString *)url paramters:(NSDictionary * __nullable)paramters completionBlock:(KYHTTPCallBack)completionBlock
{
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
