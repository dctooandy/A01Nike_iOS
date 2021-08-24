//
//  BTTUserStatusManager.m
//  Hybird_1e3c3b
//
//  Created by Key on 2018/11/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTUserStatusManager.h"
#import "WebViewUserAgaent.h"
#import <tingyunApp/NBSAppAgent.h>
#import <IVHeartPacketLibrary/IVHeartSocketManager.h>
#import "BTTRequestPrecache.h"
#import "CNPreCacheMananger.h"
#import "IVPushManager.h"
@implementation BTTUserStatusManager
+ (void)loginSuccessWithUserInfo:(NSDictionary *)userInfo isBackHome:(BOOL)isBackHome
{
    [IVNetwork updateUserInfo:userInfo];
    NSString *userId = [IVNetwork savedUserInfo].rfCode;
    [NBSAppAgent setUserIdentifier:userId];
    [[IVGameManager sharedManager] userStatusChanged:YES];
    [IVPushManager sharedManager].customerId = [IVNetwork savedUserInfo].rfCode;
    [[IVPushManager sharedManager] sendIpsSuperSign];
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotification object:@{@"isBackHome":[NSNumber numberWithBool:isBackHome]}];
    [BTTRequestPrecache updateCacheNeedLoginRequest];
    [CNPreCacheMananger prepareCacheDataNeedLogin];
    [LiveChat reloadSDK];
}
+ (void)logoutSuccess
{
    [IVNetwork cleanUserInfo];
    [WebViewUserAgaent clearCookie];
    [[IVGameManager sharedManager] userStatusChanged:NO];
    [IVHeartSocketManager exitLoginSendHearPacket];
    [NBSAppAgent setUserIdentifier:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:LogoutSuccessNotification object:nil];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:BTTAlreadyShowNoDesposit];
    [LiveChat reloadSDK];
}
@end
