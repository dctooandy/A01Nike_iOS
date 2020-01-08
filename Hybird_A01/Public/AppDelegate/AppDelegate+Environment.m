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
#import "IVCheckNetworkWrapper.h"


@implementation AppDelegate (Environment)

/**
 设置APP的启动环境, 第三方等
 */
- (void)setupAPPEnvironment {
    switch (EnvirmentType) {
        case 0:
            [IVHttpManager shareManager].environment = IVNEnvironmentDevelop; // 运行环境
            break;
        case 1:
            [IVHttpManager shareManager].environment = IVNEnvironmentPublishTest; // 运行环境
            break;
        default:
            [IVHttpManager shareManager].environment = IVNEnvironmentPublishTest; // 运行环境
            break;
    }
    //设置初始数据
    [IVWebViewManager sharaManager].delegate = [IVWebViewUtility new];
    [IVGameManager sharedManager].delegate = [IVGameUtility new];
    [IVGameManager sharedManager].isPushAGQJ = YES;
    [WebViewUserAgaent writeIOSUserAgent];
    
    [IVHttpManager shareManager].productId = [HAInitConfig productId]; // 产品标识
    [IVHttpManager shareManager].appId = [HAInitConfig appId];     // 应用ID
    [IVHttpManager shareManager].parentId = [HAInitConfig appKey];  // 渠道号
    [IVHttpManager shareManager].gateways = [HAInitConfig gateways];  // 网关列表
    [IVHttpManager shareManager].productCode = [HAInitConfig appKey]; // 产品码
    
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
    if (userToken!=nil) {
        [IVHttpManager shareManager].userToken = userToken;
    }

    // 所有手机站,先从缓存取，缓存没有使用默认配置
    [IVHttpManager shareManager].domains = [IVCacheWrapper objectForKey:IVCacheAllH5DomainsKey] ? : @[[HAInitConfig defaultH5Domain]];
    // 手机站,先从缓存取，缓存没有使用默认配置
    [IVHttpManager shareManager].domain = [IVCacheWrapper objectForKey:IVCacheH5DomainKey] ? : [HAInitConfig defaultH5Domain];
     //cdn,先从缓存取，缓存没有使用默认配置
    [IVHttpManager shareManager].cdn = [IVCacheWrapper objectForKey:IVCacheCDNKey] ? : [HAInitConfig defaultCDN];
    [IVHttpManager shareManager].globalHeaders = @{@"v" : @"1.0.0"};
    [IN3SAnalytics debugEnable:YES];
    [IN3SAnalytics setUserName:[IVHttpManager shareManager].loginName];
    [[CNTimeLog shareInstance] configProduct:@"A01"];
    
    [self setupRedDot];
    [self setupLive800];
    
    //获取最优的网关
    [IVCheckNetworkWrapper getOptimizeUrlWithArray:[IVHttpManager shareManager].gateways
                                            isAuto:YES
                                              type:IVKCheckNetworkTypeGateway
                                          progress:nil
                                        completion:nil
     ];
    //获取最优的手机站
    [IVCheckNetworkWrapper getOptimizeUrlWithArray:[IVHttpManager shareManager].domains
                                            isAuto:YES
                                              type:IVKCheckNetworkTypeDomain
                                          progress:nil
                                        completion:nil
     ];
}

- (void)setupRedDot {
    [GJRedDot registWithProfile:[BTTRedDotManager registerProfiles] defaultShow:YES];
    [GJRedDot setDefaultRadius:4];
    [GJRedDot setDefaultColor:[UIColor colorWithHexString:@"d13847"]];
}

- (void)setupLive800 {
    
    LIVUserInfo *userInfo = nil;
    if ([IVNetwork savedUserInfo]) {
        userInfo = [LIVUserInfo new];
        userInfo.userAccount = [NSString stringWithFormat:@"%@",[IVNetwork savedUserInfo].customerId];
        userInfo.grade = [NSString stringWithFormat:@"%@",@([IVNetwork savedUserInfo].starLevel)];;
        userInfo.loginName = [IVNetwork savedUserInfo].loginName;
        userInfo.name = [IVNetwork savedUserInfo].loginName;
    }
    [[CLive800Manager sharedInstance] setUpLive800WithUserInfo:userInfo];
}

@end
