//
//  IVWebViewUtility.m
//  IVWebViewLibrary
//
//  Created by Key on 2018/10/19.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "IVWebViewUtility.h"
#import "BridgeProtocolExternal.h"
#import "MBProgressHUD+Add.h"


@implementation IVWebViewUtility
- (NSDictionary *)appTheme
{
    return App_Theme;
}
- (UIStatusBarStyle)statusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (NSArray *)gateways
{
    return [IVNetwork gateways];
}
- (NSString *)h5Domain
{
    return [IVNetwork h5Domain];
}
- (NSString *)userName
{
    return [IVNetwork userInfo].loginName;
}
- (NSString *)userToken
{
    return [IVNetwork userInfo].userToken;
}
- (NSString *)appToken
{
    return [IVNetwork appToken];
}
- (NSString *)deviceId
{
    return [IVNetwork getDeviceId];
}
- (NSString *)sessionId
{
    return [UIDevice uuidForSession];
}
- (NSString *)parentId
{
    return [IVNetwork parentId];
}
- (NSString *)productId
{
    return [IVNetwork productId];
}
- (NSDictionary *)exteranlArguments
{
    return @{@"newApi" : @1};
}
- (Class)bridgeProtocolExternalClass
{
    return [BridgeProtocolExternal class];
}
- (BOOL)hiddenDefaultActivity
{
    return YES;
}
- (void)showLoadingInView:(UIView *)view animated:(BOOL)animated
{
    [MBProgressHUD showLoadingSingleInView:view animated:animated];
}
- (void)hideHUDForView:(UIView *)view animated:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:view animated:animated];
}
- (void)gameTransferWithGameid:(NSString *)gameId
{
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setValue:gameId forKey:@"game_id"];
    [IVNetwork sendRequestWithSubURL:@"game/transfer" paramters:paramters.copy completionBlock:^(IVRequestResultModel *result, id response) {
        if (result.status) {
            NSLog(@"额度刷新成功");
        } else {
            NSLog(@"额度刷新失败");
        }
    }];
}
- (void)sendRequestWithSubURL:(NSString *)url paramters:(NSDictionary *)paramters completionBlock:(void(^)(BOOL status, NSDictionary *response))completionBlock
{
    [IVNetwork sendRequestWithSubURL:url paramters:paramters completionBlock:^(IVRequestResultModel *result, id response) {
        completionBlock(result.status,response);
    }];
}
- (void)forwardToTabBarControllerWithDictionary:(NSDictionary *)dict
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BackTabBarRootViewNotification object:dict];
}

- (BOOL)clearCache
{
    return [[IVCacheManager sharedInstance] clearCache];
}
- (BOOL)writeJSONString:(NSString*)jsonString forKey:(NSString*)key isSaveFile:(BOOL)isSaveFile
{
    return [[IVCacheManager sharedInstance] writeJSONString:jsonString forKey:key isSaveFile:isSaveFile];
}
- (NSString*)readJSONStringForKey:(NSString*)key requestId:(NSString*)requestId
{
    return [[IVCacheManager sharedInstance] readJSONStringForKey:key requestId:requestId];
}
- (id)nativeReadDictionaryForKey:(NSString*)key
{
    return [[IVCacheManager sharedInstance] nativeReadDictionaryForKey:key];
}
- (void)sendDeviceInfo
{
    [IVNetwork sendDeviceInfo];
}
- (void)loginSuccess
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotification object:nil userInfo:nil];
}

@end
