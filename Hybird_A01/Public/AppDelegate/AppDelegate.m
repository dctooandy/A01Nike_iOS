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

@interface AppDelegate ()<UNUserNotificationCenterDelegate,OpenInstallDelegate>

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) UIWindow *areaLimitWindow;

@property (nonatomic, strong) BTTTabbarController *tabVC;

@end

@implementation AppDelegate


- (instancetype)init
{
    self = [super init];
    if (self) {
        //监听地区限制
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkAreaLimitNotification:) name:IVCheckAreaLimitNotification object:nil];
        //监听ips获取
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getIPSSuccessNotification:) name:IVGetIPSSuccessNotification object:nil];
        self.semaphore = dispatch_semaphore_create(0);
#if DEBUG
#else
        if (EnvirmentType == 2) {
            //监听网关切换
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gatewaySwitchNotification:) name:IVGatewaySwitchNotification object:nil];
        }
#endif
    }
    return self;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setupAPPEnvironment];
    [self setupTabbarController];
    [self.window makeKeyAndVisible];
//    [self setupADandWelcome];
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
    [IVNetwork applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [IVNetwork applicationWillEnterForeground:application];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        int uid = [@([IVNetwork userInfo].customerId) intValue];
        //配置心跳ip
        NSString *ip = [[IVCacheManager sharedInstance] nativeReadModelForKey:kCacheIpsAddress];
        NSString *port = [[IVCacheManager sharedInstance] nativeReadModelForKey:kCacheIpsPort];
        if (![NSString isBlankString:ip] && ![NSString isBlankString:port]) {//使用后台配置
            [IVHeartSocketManager configHeartSocketWithIpAddress:ip port:[port intValue] porductId:[IVNetwork productId]];
        } else {//使用默认
            [IVHeartSocketManager configHeartSocketWithEnvironment:EnvirmentType productId:[IVNetwork productId]];
        }
        //发送心跳
        [IVHeartSocketManager sendHeartPacketWithApnsToken:deviceToken userid:uid];
        self.semaphore = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:IVGetIPSSuccessNotification object:nil];
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
- (void)checkAreaLimitNotification:(NSNotification *)notification
{
    NSString *url = [notification.userInfo valueForKey:@"val"];
    WebConfigModel *model = [[WebConfigModel alloc] init];
    model.url = [[IVNetwork h5Domain] stringByAppendingString:url];
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
            if ([url.path isEqualToString:@"/lucky_wheel.htm"]) {
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
