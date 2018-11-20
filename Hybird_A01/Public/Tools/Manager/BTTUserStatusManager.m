//
//  BTTUserStatusManager.m
//  Hybird_A01
//
//  Created by Key on 2018/11/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTUserStatusManager.h"
#import "WebViewUserAgaent.h"
#import <tingyunApp/NBSAppAgent.h>
#import <IVHeartPacketLibrary/IVHeartSocketManager.h>
#import "CLive800Manager.h"
#import "BTTRequestPrecache.h"
@implementation BTTUserStatusManager
+ (void)loginSuccessWithUserInfo:(NSDictionary *)userInfo
{
    [IVNetwork updateUserInfo:userInfo];
    NSString *userId = [@([IVNetwork userInfo].customerId) stringValue];
    [NBSAppAgent setUserIdentifier:userId];
    [[IVGameManager sharedManager] userStatusChanged:YES];
    [IVHeartSocketManager loginSendHeartPacketWihUserid:[userId intValue]];
    [CLive800Manager switchLive800UserWithCustomerId:[NSString stringWithFormat:@"%ld",(long)[IVNetwork userInfo].customerId]];
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotification object:nil];
    [BTTRequestPrecache updateCacheNeedLoginRequest];
}
+ (void)logoutSuccess
{
    [IVNetwork cleanUserInfo];
    [WebViewUserAgaent clearCookie];
    [[IVGameManager sharedManager] userStatusChanged:NO];
    [IVHeartSocketManager exitLoginSendHearPacket];
    [CLive800Manager switchLive800UserWithCustomerId:@""];
    [NBSAppAgent setUserIdentifier:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:LogoutSuccessNotification object:nil];
}
@end
