//
//  AppDelegate+Environment.m
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/3.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "AppDelegate+Environment.h"
#import "BridgeProtocolExternal.h"
#import "BTTRedDotManager.h"
#import "WebViewUserAgaent.h"
#import "HAInitConfig.h"
#import "IVWebViewUtility.h"
#import "IVGameUtility.h"
#import "BTTRequestPrecache.h"
#import "IVCheckNetworkWrapper.h"
#import "IVKUpdateViewController.h"
#import "IVPublicAPIManager.h"

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
    [IVGameManager sharedManager].isNew = YES;
    [IVGameManager sharedManager].isPushAGQJ = YES;
    [WebViewUserAgaent writeIOSUserAgent];
    
    [IVHttpManager shareManager].productId = [HAInitConfig productId]; // 产品标识
    [IVHttpManager shareManager].appId = [HAInitConfig appId];     // 应用ID
    [IVHttpManager shareManager].parentId = [HAInitConfig appKey];  // 渠道号
//    [IVHttpManager shareManager].gateways = [HAInitConfig gateways];  // 网关列表
    [IVHttpManager shareManager].productCode = [HAInitConfig appKey]; // 产品码
    [IVHttpManager shareManager].productCodeExt = [HAInitConfig productCodeExt];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    [IVHttpManager shareManager].globalHeaders = @{@"v": appVersion};
    
    NSURL *gatewayUrl = [NSURL URLWithString:[[HAInitConfig gateways] objectAtIndex:(arc4random() % [HAInitConfig gateways].count)]];
    NSString *domainName = [NSString stringWithFormat:@"%@",gatewayUrl.host];
    [IVHttpManager shareManager].globalHeaders = @{@"domainName": domainName};
    if ([IVNetwork savedUserInfo]) {
        [IVHttpManager shareManager].loginName = [IVNetwork savedUserInfo].loginName;
    }
    
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
    if (userToken!=nil) {
        [IVHttpManager shareManager].userToken = userToken;
    }

//    // 所有手机站,先从缓存取，缓存没有使用默认配置
//    [IVHttpManager shareManager].domains = [IVCacheWrapper objectForKey:IVCacheAllH5DomainsKey] ? : @[[HAInitConfig defaultH5Domain]];
//    // 手机站,先从缓存取，缓存没有使用默认配置
//    [IVHttpManager shareManager].domain = [IVCacheWrapper objectForKey:IVCacheH5DomainKey] ? : [HAInitConfig defaultH5Domain];
//     //cdn,先从缓存取，缓存没有使用默认配置
//    [IVHttpManager shareManager].cdn = [IVCacheWrapper objectForKey:IVCacheCDNKey] ? : [HAInitConfig defaultCDN];
    
//    [IVHttpManager shareManager].domains = [HAInitConfig websides];
    [IVHttpManager shareManager].domain = [HAInitConfig defaultH5Domain];
    [IVHttpManager shareManager].cdn = [HAInitConfig defaultCDN];
    [IVHttpManager shareManager].isSensitive = YES;
    [CNTimeLog debugEnable:YES];
    [CNTimeLog setUserName:[IVHttpManager shareManager].loginName];
    [CNTimeLog configProduct:[HAInitConfig product3SId]];
    
    [self setupRedDot];
    [LiveChat initOcssSDKNetWork];
    [IVCheckNetworkWrapper initSDK];
//    //获取最优的网关
//    [IVCheckNetworkWrapper getOptimizeUrlWithArray:[IVHttpManager shareManager].gateways
//                                            isAuto:YES
//                                              type:IVKCheckNetworkTypeGateway
//                                          progress:nil
//                                        completion:nil
//     ];
//    //获取最优的手机站
//    [IVCheckNetworkWrapper getOptimizeUrlWithArray:[IVHttpManager shareManager].domains
//                                            isAuto:YES
//                                              type:IVKCheckNetworkTypeDomain
//                                          progress:nil
//                                        completion:nil
//     ];
    
    [IVPublicAPIManager checkAppUpdateWithH5Version:1 callBack:^(IVPCheckUpdateModel * _Nonnull result, IVJResponseObject * _Nonnull response) {
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDic objectForKey: @"CFBundleShortVersionString"];
        if ([appVersion compare:result.versionCode options:NSNumericSearch] == NSOrderedDescending && result.versionCode) {
            return;
        }
        if (result.flag!=0) {
            [IVKUpdateViewController showWithUrl:result.appDownUrl content:result.upgradeDesc originVersion:result.versionCode isForce:result.flag==2 isManual:NO];
        }
    }];
}

- (void)setupRedDot {
    [GJRedDot registWithProfile:[BTTRedDotManager registerProfiles] defaultShow:YES];
    [GJRedDot setDefaultRadius:4];
    [GJRedDot setDefaultColor:[UIColor colorWithHexString:@"d13847"]];
}

@end
