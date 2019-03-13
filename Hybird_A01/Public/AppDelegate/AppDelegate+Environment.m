//
//  AppDelegate+Environment.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/3.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "AppDelegate+Environment.h"
#import "CLive800Manager.h"
#import "BridgeProtocolExternal.h"
#import "BTTRedDotManager.h"
#import "WebViewUserAgaent.h"
#import "HAInitConfig.h"
#import "IVWebViewUtility.h"
#import "IVGameUtility.h"
#import "BTTRequestPrecache.h"


@implementation AppDelegate (Environment)

/**
 设置APP的启动环境, 第三方等
 */
- (void)setupAPPEnvironment {
    switch (EnvirmentType) {
        case 0:
            [IVNetwork setEnvironment:IVEnvironmentDebug];
            break;
        case 1:
            [IVNetwork setEnvironment:IVEnvironmentReleaseTest];
            break;
        default:
            [IVNetwork setEnvironment:IVEnvironmentRelease];
            break;
    }
    //设置初始数据
    [IVWebViewManager sharaManager].delegate = [IVWebViewUtility new];
    [IVGameManager sharedManager].delegate = [IVGameUtility new];
    [IVGameManager sharedManager].isPushAGQJ = YES;
//    [IVNetwork setOldApi:YES];
    [WebViewUserAgaent writeIOSUserAgent];
    [IVNetwork setBundleId:[HAInitConfig bundleId]];
    [IVNetwork setAppid:[HAInitConfig appId]];
    [IVNetwork setAppKey:[HAInitConfig appKey]];
    [IVNetwork setGateways:[HAInitConfig gateways]];
    [IVNetwork setProductId:[HAInitConfig productId]];
    [IVNetwork setDefaultH5Domian:[HAInitConfig defaultH5Domain]];
    [IVNetwork setDefaultCDN:[HAInitConfig defaultCDN]];
    [IVNetwork startLaunchProcessWithFinished:^{
        [BTTRequestPrecache startUpdateCache];
    }];
    [IN3SAnalytics debugEnable:YES];
    [IN3SAnalytics setUserName:[IVNetwork userInfo].loginName];
    [[CNTimeLog shareInstance] configProduct:@"A01"];
    
    [self setupRedDot];
    [self setupLive800];
}

- (void)setupRedDot {
    [GJRedDot registWithProfile:[BTTRedDotManager registerProfiles] defaultShow:YES];
    [GJRedDot setDefaultRadius:4];
    [GJRedDot setDefaultColor:[UIColor colorWithHexString:@"d13847"]];
}

- (void)setupLive800 {
    [[CLive800Manager sharedInstance] setUpLive800];
    if (![IVNetwork userInfo] || ![IVNetwork userInfo].customerId) {
        [CLive800Manager switchLive800UserWithCustomerId:@""];
    }else{
        [CLive800Manager switchLive800UserWithCustomerId:[NSString stringWithFormat:@"%ld",(long)[IVNetwork userInfo].customerId]];
    }
}

@end
