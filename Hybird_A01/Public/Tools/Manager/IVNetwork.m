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
#import "Constants.h"
#import "HAInitConfig.h"
#import "IVCNetworkStatusView.h"
#import "IVCDetailViewController.h"
#import "IVKUpdateViewController.h"
#import "IVUzipWrapper.h"
#import "IVPublicAPIManager.h"

@implementation IVNetwork

+ (NSString *)cdn{
    return [HAInitConfig defaultCDN];
}

+ (IVUserInfoModel *)userInfo
{
    return [IVNetworkManager sharedInstance].userInfoModel;;
}

+ (void)checkAppUpdate{
    NSInteger h5Version = [[IVUzipWrapper getLocalH5Version] integerValue];
    [IVPublicAPIManager checkAppUpdateWithH5Version:h5Version callBack:^(IVPCheckUpdateModel * _Nonnull result, IVJResponseObject * _Nonnull response) {
        //模拟普通更新
        [IVKUpdateViewController showWithUrl:@"http://www.sdfsf.com" content:@"修复bug" originVersion:@"3.0.0" isForce:NO isManual:YES];
    }];
}


+ (NSString *)h5Domain
{
    NSString *h5Domain = [IVCacheWrapper objectForKey:IVCacheH5DomainKey] ? : [HAInitConfig defaultH5Domain];
    return h5Domain;
}

+ (NSString *)getPublicConfigWithKey:(NSString *)key
{
    NSArray *array = [IVCacheWrapper objectForKey:@"kCachePublicConfigs"];
    if (array && [array isKindOfClass:[NSArray class]] && array.count > 0) {
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"config MATCHES %@",key];
        if (!pre) {
            return @"";
        }
        NSArray *filterArray = [array filteredArrayUsingPredicate:pre];
        if (filterArray && filterArray.count > 0 && [filterArray[0] isKindOfClass:[NSDictionary class]]
            && [filterArray[0] valueForKey:@"value"]) {
            return  [filterArray[0] valueForKey:@"value"];
        }
    }
    return @"";
}

+(void)updateMobileNoWithMobileNo:(NSString *)mobileNo{
    NSMutableDictionary *json = [[NSMutableDictionary alloc]initWithDictionary:[IVCacheWrapper objectForKey:@"customer"]];
    if (json==nil) {
        return;
    }
    json[@"mobileNo"] = mobileNo;
    json[@"mobileNoBind"] = @1;
    NSDictionary *info = json;
    [IVCacheWrapper setValue:info forKey:@"customer"];
}

+ (BTTCustomerInfoModel *)savedUserInfo
{
    NSDictionary *json = [IVCacheWrapper objectForKey:@"customer"];
    if (json==nil) {
        return nil;
    }
    BTTCustomerInfoModel *model = [BTTCustomerInfoModel yy_modelWithJSON:json];
    return model;
}

+ (void)updateUserInfo:(NSDictionary *)userInfo
{
    if (!userInfo) {
        return;
    }
    [IVCacheWrapper setObject:userInfo forKey:@"customer"];
}

+ (void)cleanUserInfo{
    [IVCacheWrapper setObject:nil forKey:@"customer"];
}

+ (void)sendUseCacheRequestWithSubURL:(NSString *)url paramters:(NSDictionary * __nullable)paramters completionBlock:(KYHTTPCallBack)completionBlock{
    [self requestWithUseCache:TRUE url:url paramters:paramters completionBlock:completionBlock];
}

+ (void)requestPostWithUrl:(NSString *)url paramters:(NSDictionary * __nullable)paramters completionBlock:(KYHTTPCallBack)completionBlock{
    [[IVHttpManager shareManager]sendRequestWithUrl:url parameters:paramters callBack:completionBlock];
}

+ (void)requestWithUseCache:(BOOL)useCache url:(NSString *)url paramters:(NSDictionary *__nullable)paramters completionBlock:(KYHTTPCallBack)completionBlock
{
    [[IVHttpManager shareManager] sendRequestWithMethod:KYHTTPMethodPOST
                                                    url:url
                                             parameters:paramters
                                                headers:nil
                                               progress:nil
                                                  cache:useCache
                                           cacheTimeout:3600 * 24
                                           denyRepeated:YES
                                               callBack:^(BOOL isCache, id _Nullable response,
                                                          NSError *_Nullable error) {
        if (isCache) {
            NSLog(@"从缓存获取");
        } else {
            NSLog(@"从远程获取");
        }
        IVJResponseObject *result = response;
        completionBlock(result, error);
    }
                                         originCallBack:^(id _Nullable response,
                                                          NSError *_Nullable error) {
        NSLog(@"从远程获取");
        IVJResponseObject *result = response;
        completionBlock(result, error);
    }];
}


@end
