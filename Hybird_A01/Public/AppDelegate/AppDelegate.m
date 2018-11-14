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
#import "HDSocketManager.h"
#import "PushManager.h"

@interface AppDelegate ()

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

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
    [self setupADandWelcome];
    return YES;
}

- (void)setupTabbarController {
    self.window.rootViewController = [[BTTTabbarController alloc] init];
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
        [[HDSocketManager shareInstance] setDeviceToken:deviceToken];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (self.semaphore) {
                dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
            }
            NSString *ip = [[IVCacheManager sharedInstance] nativeReadModelForKey:kCacheIpsAddress];
            NSString *port = [[IVCacheManager sharedInstance] nativeReadModelForKey:kCacheIpsPort];
            [HDSocketManager shareInstance].configIp = ip;
            [HDSocketManager shareInstance].configPort = port;
            [[HDSocketManager shareInstance] startConnect];
            self.semaphore = nil;
            [[NSNotificationCenter defaultCenter] removeObserver:self name:IVGetIPSSuccessNotification object:nil];
        });
    }
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


//远程通知启动
- (void)performActionDidReceiveRemoteNotificationWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *remoteCotificationDic = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(remoteCotificationDic){
        NSDictionary *apsInfo = remoteCotificationDic[@"aps"];
        if (apsInfo) {
            [[PushManager sharedInstance] performActionDidReceiveRemoteNotification:apsInfo];
        }
    }
}

- (void)gatewaySwitchNotification:(NSNotification *)notification
{
    [NBSAppAgent trackEvent:@"网关切换" withEventTag:@"gateway_change" withEventProperties:notification.userInfo];
}
- (void)checkAreaLimitNotification:(NSNotification *)notification
{
}

@end
