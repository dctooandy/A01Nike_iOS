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

@interface AppDelegate ()<UNUserNotificationCenterDelegate,OpenInstallDelegate>

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) UIWindow *areaLimitWindow;
@property (nonatomic, strong) BTTTabbarController *tabVC;
@property (nonatomic, copy) NSString *ipsAdd;
@property (nonatomic, assign) NSInteger ipsPort;
@property (nonatomic, strong)dispatch_queue_t unzipQueue;

@end

@implementation AppDelegate


- (instancetype)init
{
    self = [super init];
    if (self) {
        _unzipQueue = dispatch_queue_create("com.IVLibraryDemo.unzipQueue", DISPATCH_QUEUE_SERIAL);
        self.semaphore = dispatch_semaphore_create(0);
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
            //ips逻辑
            if (result.ipsIp) {
                self.ipsAdd = result.ipsIp;
                self.ipsPort = result.ipsPort;
                if (self.semaphore) {
                    dispatch_semaphore_signal(self.semaphore);
                }
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
    [self initRemoteNotificationWithOptions:launchOptions];
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

/** 初始化 启动遠端推送通知 */
- (void)initRemoteNotificationWithOptions:(NSDictionary *)launchOptions
{
    //远程通知启动
    NSDictionary *remoteCotificationDic = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteCotificationDic) {
        NSDictionary *apsInfo = remoteCotificationDic[@"aps"];
        if (apsInfo) {
            [[PushManager sharedInstance] performActionDidReceiveRemoteNotification:remoteCotificationDic];
        }
    }
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        UNAuthorizationOptions options = (UNAuthorizationOptionBadge |
                                          UNAuthorizationOptionSound |
                                          UNAuthorizationOptionAlert);
        [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"获取推送权限成功!");
            }
        }];
    } else {
        UIUserNotificationType types = (UIUserNotificationTypeSound |
                                        UIUserNotificationTypeAlert |
                                        UIUserNotificationTypeBadge);
        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    }
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)getIPSSuccessNotification:(NSNotification *)notify
{
    if (self.semaphore) {
        dispatch_semaphore_signal(self.semaphore);
    }
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    if (deviceToken) {
        NSString * deviceTokenString = [deviceToken description];
        // 去掉<>字符
        deviceTokenString = [deviceTokenString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        // 去掉空格
        deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"註冊遠端推送通知成功：deviceToken為\n %@\n %@", deviceToken, deviceTokenString);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self startHeartPacket:deviceToken];
        });
    }
}
- (void)startHeartPacket:(NSData *)deviceToken
{
    
    if (self.semaphore) {
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        }
            dispatch_sync(dispatch_get_main_queue(), ^{
                int uid = [[IVNetwork savedUserInfo].customerId intValue]; //需要填写真实的用户id
                if (self.ipsAdd && self.ipsAdd.length > 0) {//使用后台配置
                    [IVHeartSocketManager configHeartSocketWithIpAddress:self.ipsAdd port:self.ipsPort porductId:[IVHttpManager shareManager].productId];
                } else {//使用默认
                    IVHeartPacketEnvironment env = IVHeartPacketLocalEnvironment;
                    switch ([IVHttpManager shareManager].environment) {
                        case IVNEnvironmentPublishTest:
                            env = IVHeartPacketGrayEnvironment;
                            break;
                        case IVNEnvironmentPublish:
                            env = IVHeartPacketPublishEnvironment;
                            break;
                        default:
                            break;
                    }
                    [IVHeartSocketManager configHeartSocketWithEnvironment:env productId:[IVHttpManager shareManager].productId];
                }
                //发送心跳
                [IVHeartSocketManager sendHeartPacketWithApnsToken:deviceToken userid:uid];
                self.semaphore = nil;
            });
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
    NSLog(@"註冊遠端推送通知失敗：%@", error);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [[PushManager sharedInstance] performActionDidReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"远端推送userInfo: %@", userInfo);
    [[PushManager sharedInstance] performActionDidReceiveRemoteNotification:userInfo];
}
#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler  API_AVAILABLE(ios(10.0)){
    UNNotificationPresentationOptions options = (UNNotificationPresentationOptionBadge |
                                                 UNNotificationPresentationOptionSound |
                                                 UNNotificationPresentationOptionAlert);
    completionHandler(options);
    
    NSDictionary *userInfo = notification.request.content.userInfo;
    [[PushManager sharedInstance] performActionDidReceiveRemoteNotification:userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    completionHandler();
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    [[PushManager sharedInstance] performActionDidReceiveRemoteNotification:userInfo];
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
