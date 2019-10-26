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
#import "FCUUID.h"
#import "UIDevice+IVInfo.h"
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
    return [IVHttpManager shareManager].gateways;
}
- (NSString *)h5Domain
{
    return [IVHttpManager shareManager].domain;
}
- (NSString *)userName
{
    return [IVHttpManager shareManager].loginName;
}
- (NSString *)userToken
{
    return [IVHttpManager shareManager].userToken;
}
- (NSString *)appToken
{
    return [IVHttpManager shareManager].appToken;
}
- (NSString *)deviceId
{
    return [FCUUID uuidForDevice];
}
- (NSString *)sessionId
{
    return [UIDevice uuidForSession];
}
- (NSString *)parentId
{
    return [IVHttpManager shareManager].productId;
}
- (NSString *)productId
{
    return [IVHttpManager shareManager].productId;
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
    [[IVHttpManager shareManager] sendRequestWithUrl:@"game/transfer" parameters:paramters.copy callBack:^(id  _Nullable response, NSError * _Nullable error) {
#warning 调试接口
//        if (result.status) {
//            NSLog(@"额度刷新成功");
//        } else {
//            NSLog(@"额度刷新失败");
//        }
    }];
}
- (void)sendRequestWithSubURL:(NSString *)url paramters:(NSDictionary *)paramters completionBlock:(void(^)(BOOL status, NSDictionary *response))completionBlock
{
    [[IVHttpManager shareManager] sendRequestWithUrl:url parameters:paramters callBack:^(id  _Nullable response, NSError * _Nullable error) {
#warning 调试接口
//        completionBlock(result.status,response);
    }];
}
- (void)forwardToTabBarControllerWithDictionary:(NSDictionary *)dict
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BackTabBarRootViewNotification object:dict];
}

- (BOOL)clearCache
{
    return [IVCacheWrapper clearCache];
}
- (BOOL)writeJSONString:(NSString*)jsonString forKey:(NSString*)key isSaveFile:(BOOL)isSaveFile
{
    return [IVCacheWrapper writeJSONString:jsonString forKey:key isSaveFile:isSaveFile];
}
- (NSString*)readJSONStringForKey:(NSString*)key requestId:(NSString*)requestId
{
    return [IVCacheWrapper readJSONStringForKey:key requestId:requestId];
}

//- (void)sendDeviceInfo
//{
//    [IVNetwork sendDeviceInfo];
//}
- (void)loginSuccess
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotification object:nil userInfo:nil];
}

@end
