//
//  AppDelegate.m
//  Hybird_A01
//
//  Created by Domino on 2018/9/29.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "AppDelegate.h"
#import "BTTTabbarController.h"
#import "AppDelegate+AD.h"
#import "AppDelegate+Environment.h"
#import <tingyunApp/NBSAppAgent.h>
#import "PushManager.h"
#import "AppInitializeConfig.h"
#import <IVHeartPacketLibrary/IVHeartSocketManager.h>
#import <UserNotifications/UserNotifications.h>
#import "CNPreCacheMananger.h"
#import "BTTTabBar.h"
#import "OpenInstallSDK.h"
#import "IVPublicAPIManager.h"
#import "IVCheckNetworkWrapper.h"
#import "IVUzipWrapper.h"
#import "IVKUpdateViewController.h"
#import "IVPushManager.h"
#import "HAInitConfig.h"

@interface AppDelegate ()<OpenInstallDelegate,IVPushDelegate>

@property (nonatomic, strong) UIWindow *areaLimitWindow;
@property (nonatomic, strong) BTTTabbarController *tabVC;
@property (nonatomic, strong)dispatch_queue_t unzipQueue;

@end

@implementation AppDelegate


- (instancetype)init
{
    self = [super init];
    if (self) {
        _unzipQueue = dispatch_queue_create("com.IVLibraryDemo.unzipQueue", DISPATCH_QUEUE_SERIAL);
#if DEBUG
#else
        if (EnvirmentType == 2) {
            
            //监听网关切换
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gatewaySwitchNotification:) name:IVNGatewaySwitchNotification object:nil];
        }
#endif
    }
    return self;
}

- (void)initAnalysis{
    [IVLAManager setLogEnabled:YES];
    [IVLAManager startWithProductId:@"A01" productName:@"btt" channelId:@"" appId:@"5308e20b" appKey:@"5308e20b" sessionTimeout:5000 environment:IVLA_Dis loginName:^NSString * _Nonnull{
        return [IVNetwork savedUserInfo].loginName==nil?@"":[IVNetwork savedUserInfo].loginName;
    }];
}


#pragma mark ---------------------检测地区限制--------------------------------------------
- (void)checkArearLimit
{
    [IVPublicAPIManager checkAreaLimitWithCallBack:^(IVPCheckAreaLimitModel * _Nonnull result, IVJResponseObject * _Nonnull response) {
        if (result && !result.allowAccess) {
            NSLog(@"拒绝访问");
            [self showAreaLimitWithCountry:result.country goCode:result.goCode];
        } else {
            NSLog(@"允许访问");
        }
    }];
}

- (void)unzipLocationH5Package
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"app" ofType:@"zip"];
    [IVUzipWrapper unzipLocationH5PackageWithQueue:self.unzipQueue path:path completion:^(NSInteger errorCode, NSString * _Nonnull errorMsg) {
        if (errorCode == 0) {
            NSLog(@"本地h5全量包解压成功！");
        } else {
            NSLog(@"本地h5全量包解压失败！错误码：%@,错误信息：%@",@(errorCode),errorMsg);
        }
    }];
}

#pragma mark ---------------------获取WMS自定义表单配置--------------------------------------------
- (void)getWMSForm
{
    [IVPublicAPIManager getAPPConfigFormWithCallBack:^(IVPAppDynamicFormModel * _Nonnull result, IVJResponseObject * _Nonnull response) {
        if (result) {
            //手机站逻辑
            if (result.domains) {
                [IVHttpManager shareManager].domains = result.domains;
                //获取最优的手机站域名
                [IVCheckNetworkWrapper getOptimizeUrlWithArray:result.domains isAuto:YES type:IVKCheckNetworkTypeDomain progress:nil completion:nil];
            }
            //cdn逻辑
            if (result.cdn) {
                [IVHttpManager shareManager].cdn = result.cdn;
            }
            //游戏站逻辑
            if (result.gcHosts) {
                //获取最优的游戏站域名
                [IVCheckNetworkWrapper getOptimizeUrlWithArray:result.gcHosts isAuto:YES type:IVKCheckNetworkTypeGameDomian progress:nil completion:nil];
            }
        }
    }];

}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setupAPPEnvironment];
    [self checkArearLimit];
    [self unzipLocationH5Package];
    [self getWMSForm];
    [self setupTabbarController];
    [self.window makeKeyAndVisible];
    [self initAnalysis];
    [self initPushSDKWithApplication:application options:launchOptions];
    [CNPreCacheMananger prepareCacheDataNormal];
    [CNPreCacheMananger prepareCacheDataNeedLogin];
    [OpenInstallSDK initWithDelegate:self];
    
    return YES;
}

// open install delegate

- (void)getInstallParamsFromOpenInstall:(nullable NSDictionary *)params withError:(nullable NSError *)error {
    
}

- (void)setupTabbarController {
    self.tabVC = [[BTTTabbarController alloc] init];
    self.window.rootViewController = self.tabVC;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [IVNetwork applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [IVNetwork applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark --------------------------推送相关-----------------------------------------------
- (void)initPushSDKWithApplication:(UIApplication *)application options:(NSDictionary *)options
{
    [IVPushManager sharedManager].appId = [HAInitConfig appId];
    [IVPushManager sharedManager].customerId = [IVNetwork savedUserInfo].customerId;
    [IVPushManager sharedManager].delegate = self;
    [[IVPushManager sharedManager] application:application didFinishLaunchingWithOptions:options];
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    [[IVPushManager sharedManager] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
    [[IVPushManager sharedManager] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
   [[IVPushManager sharedManager] application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[IVPushManager sharedManager] application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}
- (void)IVPushRequestIpsSuperSignWithParameters:(NSDictionary *)paramesters
{
    [IVNetwork requestPostWithUrl:@"ips/ipsSuperSignSend" paramters:paramesters completionBlock:^(IVJResponseObject *  _Nullable response, NSError * _Nullable error) {
        if ([response.head.errCode isEqualToString:@"0000"]) {
            NSLog(@"send ipsSuperSign success");
        }
    }];
}

- (void)IVPushForwardWithUrl:(NSString *)url messageId:(NSString *)messageId
{
    if (url != nil && url.length > 0) {
        if (![url hasPrefix:@"http"]) {
            url = [NSString stringWithFormat:@"%@%@",[IVHttpManager shareManager].domain,url];
        }
    } else {
        if (messageId != nil && messageId.length > 0) {
            url = [NSString stringWithFormat:@"customer/letter_detail.htm?id=%@",messageId];
        } else {
            return;
        }
    }
    UIViewController *topVC = [PublicMethod currentViewController];
    if ([topVC isKindOfClass:[BTTBaseWebViewController class]]) {
        BTTBaseWebViewController *topWebVC = (BTTBaseWebViewController *)topVC;
        if (topWebVC.webConfigModel.newView) {
            topWebVC.webConfigModel.url = url;
            [topWebVC loadWebView];
            return;
        }
    }
    BTTBaseWebViewController  *webController = [[BTTBaseWebViewController alloc] init];
    webController.webConfigModel.url = url;
    webController.webConfigModel.newView = YES;
    [webController loadWebView];
    [topVC.navigationController pushViewController:webController animated:YES];
}
- (void)gatewaySwitchNotification:(NSNotification *)notification
{
    [NBSAppAgent trackEvent:@"网关切换" withEventTag:@"gateway_change" withEventProperties:notification.userInfo];
}
- (void)showAreaLimitWithCountry:(NSString *)country goCode:(NSString *)goCode
{
    NSString *url = goCode;
    WebConfigModel *model = [[WebConfigModel alloc] init];
    //需要获取到h5Domain
    model.url = [[IVHttpManager shareManager].domain stringByAppendingString:url];
    HAWebViewController *webVC = [[HAWebViewController alloc] init];
    webVC.webConfigModel = model;
    self.areaLimitWindow.rootViewController = webVC;
    [self.areaLimitWindow makeKeyAndVisible];
}
- (UIWindow *)areaLimitWindow{
    if (!_areaLimitWindow) {
        _areaLimitWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _areaLimitWindow.backgroundColor = [UIColor whiteColor];
        _areaLimitWindow.windowLevel = UIWindowLevelAlert + 1;
    }
    return _areaLimitWindow;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"测试赛%@",url);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([url.host isEqualToString:@"webMobile"] || [url.host isEqualToString:@"webmobile"]) {
            if ([url.path isEqualToString:@"/lucky_wheel_2020.htm"]) {
                [self.tabVC.myTabbar setSeletedIndex:2];
            }
            
        } else {
            if ([url.path isEqualToString:@""]) {
                
            } else if ([url.path isEqualToString:@""]) {
                
            } else if ([url.path isEqualToString:@""]) {
                
            } else {
                
            }
        }
        
    });
    return YES;
}

@end
