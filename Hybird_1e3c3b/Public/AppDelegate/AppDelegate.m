//
//  AppDelegate.m
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/9/29.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "AppDelegate.h"
#import "BTTTabbarController.h"
#import "AppDelegate+AD.h"
#import "AppDelegate+Environment.h"
//#import <tingyunApp/NBSAppAgent.h>
#import "PushManager.h"
#import "AppInitializeConfig.h"
#import <IVHeartPacketLibrary/IVHeartSocketManager.h>
#import <UserNotifications/UserNotifications.h>
#import "CNPreCacheMananger.h"
#import "BTTTabBar.h"
//#import "OpenInstallSDK.h"
#import "IVPublicAPIManager.h"
#import "IVCheckNetworkWrapper.h"
#import "IVUzipWrapper.h"
#import "IVKUpdateViewController.h"
#import "IVPushManager.h"
#import "HAInitConfig.h"
#import "BTTUserStatusManager.h"
#import "BTTFirstWinningListModel.h"
#import "BTTCheckDomainModel.h"
#import "AppdelegateManager.h"

@interface AppDelegate ()<IVPushDelegate>

@property (nonatomic, strong) UIWindow *areaLimitWindow;
@property (nonatomic, strong) BTTTabbarController *tabVC;
@property (nonatomic, strong) dispatch_queue_t unzipQueue;
@property (nonatomic, strong) NSDictionary *signPushDic;
@property (nonatomic, assign) BOOL getSpeedestDomain;
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
    [IVLAManager startWithProductId:@"A01" productName:@"btt" channelId:@"" appId:@"5308e20b" appKey:@"5308e20b" sessionTimeout:5000 environment:(EnvirmentType == 2 ? IVLA_Dis : IVLA_Dev) loginName:^NSString * _Nonnull{
        return [IVNetwork savedUserInfo].loginName==nil?@"":[IVNetwork savedUserInfo].loginName;
    }];
}
- (void)checkDomainHandler:(void (^)(void))handler  {
        // 启动时先去访问接口
    [self recheckDomain:handler];
    // 所有手机站,先从缓存取，缓存没有使用默认配置
//    if (![IVCacheWrapper objectForKey:IVCacheAllGatewayKey] ||
//        ![IVCacheWrapper objectForKey:IVCacheAllH5DomainsKey] )
//    {
//        [self recheckDomain:handler];
//    }else
//    {
//        [[AppdelegateManager shareManager] setGateways:[IVCacheWrapper objectForKey:IVCacheAllGatewayKey]];
//        [[AppdelegateManager shareManager] setWebsides:[IVCacheWrapper objectForKey:IVCacheAllH5DomainsKey]];
//        //获取最优的网关
//        self.getSpeedestDomain = NO;
//        [self testSpeed:[IVHttpManager shareManager].gateways Handler:handler];
////        handler();
//    }
}
- (void)testSpeed:(NSArray*)domailArr Handler:(void (^)(void))handler
{
//    [IVCheckNetworkWrapper initSDK];
    //app有域名测速功能就使用，没有直接注释domainBakList赋值即可
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    for (NSString * str in domailArr) {
        if ([[str substringFromIndex:str.length-1] isEqualToString:@"/"]) {
            [arr addObject:str];
        } else {
            [arr addObject:[NSString stringWithFormat:@"%@/", str]];
        }
    }
//    [IVCheckNetworkWrapper getOptimizeUrlSynWithArray:[IVHttpManager shareManager].gateways
//                                               isAuto:YES
//                                                 type:IVKCheckNetworkTypeGateway
//                                             progress:nil
//                                           completion:^(IVCheckDetailModel * _Nonnull model) {
//        if (model != nil) {
//            handler();
//        }else
//        {
//            [[AppdelegateManager shareManager] setGateways:nil];
//            [[AppdelegateManager shareManager] setWebsides:nil];
//            [IVCacheWrapper setObject:nil forKey:IVCacheAllGatewayKey];
//            [IVCacheWrapper setObject:nil forKey:IVCacheAllH5DomainsKey];
//            [self recheckDomain:handler];
//        }
//    }];
    //...测速代码，速度从快到慢
    weakSelf(weakSelf)
    [IVCheckNetworkWrapper getOptimizeUrlWithArray:[IVHttpManager shareManager].gateways
                                            isAuto:YES
                                              type:IVKCheckNetworkTypeGateway
                                          progress:^(IVCheckDetailModel * _Nonnull respone) {
        [weakSelf checkProgressWithTableViewWithRespone:respone Handler:handler];
    }
                                        completion:^(IVCheckDetailModel * _Nonnull model) {
//        if (model != nil) {
//            handler();
//        }else
//        {
//            [[AppdelegateManager shareManager] setGateways:nil];
//            [[AppdelegateManager shareManager] setWebsides:nil];
//            [IVCacheWrapper setObject:nil forKey:IVCacheAllGatewayKey];
//            [IVCacheWrapper setObject:nil forKey:IVCacheAllH5DomainsKey];
//            [self recheckDomain:handler];
//        }
    }];
}
- (void)checkProgressWithTableViewWithRespone:(IVCheckDetailModel *)respone Handler:(void (^)(void))handler
{
    NSInteger index = 0;
    BOOL exit = NO;
    weakSelf(weakSelf)
    for (NSString *domainString in [IVHttpManager shareManager].gateways) {
        NSInteger i = [[IVHttpManager shareManager].gateways indexOfObject:domainString];
        NSURL *url = [NSURL URLWithString:domainString];
        NSURL *url1 = [NSURL URLWithString:respone.url];
        if ([url.host isEqualToString:url1.host] ) {
            if (weakSelf.getSpeedestDomain == NO)
            {
                weakSelf.getSpeedestDomain = YES;
                index = i;
                exit = YES;
            }
        }
    }
    if (exit) {
        [[IVHttpManager shareManager] setGateway:[IVHttpManager shareManager].gateways[index]];
        handler();
    }else
    {
        if (self.getSpeedestDomain == NO)
        {
            [[AppdelegateManager shareManager] setGateways:nil];
            [[AppdelegateManager shareManager] setWebsides:nil];
            [IVCacheWrapper setObject:nil forKey:IVCacheAllGatewayKey];
            [IVCacheWrapper setObject:nil forKey:IVCacheAllH5DomainsKey];
            [self recheckDomain:handler];
        }
    }
    
}
- (void)recheckDomain:(void (^)(void))handler  {
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [IVHttpManager shareManager].appId = [HAInitConfig appId];     // 应用ID
    [IVHttpManager shareManager].productId = [HAInitConfig productId]; // 产品标识
    [IVHttpManager shareManager].isSensitive = YES;
    [IVHttpManager shareManager].gateways = [HAInitConfig gateways];  // 网关列表
    params[@"productId"] = [IVHttpManager shareManager].productId;
    params[@"productCodeExt"] = @"FM";
    params[@"productCode"] = @"";
    [IVNetwork requestPostWithUrl:BTTAppSetting paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTCheckDomainModel *model = [BTTCheckDomainModel yy_modelWithDictionary:result.body];
            NSMutableArray * tempGetArr = [NSMutableArray new];
            NSMutableArray * tempWebArr = [NSMutableArray new];
            for (NSString *getway in model.getways) {
                if ([[getway substringFromIndex:getway.length-1] isEqualToString:@"/"]) {
                    [tempGetArr addObject:[NSString stringWithFormat:@"%@_glaxy_1e3c3b_/", getway]];
                } else {
                    [tempGetArr addObject:[NSString stringWithFormat:@"%@/_glaxy_1e3c3b_/", getway]];
                }
            }
           
            for (NSString *websit in model.websides) {
                if ([[websit substringFromIndex:websit.length-1] isEqualToString:@"/"]) {
                    [tempWebArr addObject:websit];
                } else {
                    [tempWebArr addObject:[NSString stringWithFormat:@"%@/", websit]];
                }
            }
            [[AppdelegateManager shareManager] setGateways:tempGetArr];
            [[AppdelegateManager shareManager] setWebsides:tempWebArr];
        }else
        {
            [[AppdelegateManager shareManager] setGateways:nil];
            [[AppdelegateManager shareManager] setWebsides:nil];
        }
        [IVHttpManager shareManager].gateways = [HAInitConfig gateways];  // 网关列表
        [IVHttpManager shareManager].domains = [HAInitConfig websides];
        handler();
    }];
}

-(void)setDynamicQuery {
    [IVLAManager needUploadWithNewDomain:YES];
    NSDictionary * params = @{@"bizCode":@"SKYNET_SDK_CONFIG"};
    [IVNetwork requestPostWithUrl:BTTDynamicQuery paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSArray * arr = result.body[@"data"];
            NSString * PROD_DID = @"";
            NSString * PROD_GATHER = @"";
            NSString * NEW_PROD_GATHER = @"";
            if (arr.count > 0) {
                PROD_DID = arr[0][@"PROD_DID"] != nil ? arr[0][@"PROD_DID"]:@"";
                PROD_GATHER = arr[0][@"PROD_GATHER"] != nil ? arr[0][@"PROD_GATHER"]:@"";
                NEW_PROD_GATHER = arr[0][@"NEW_PROD_GATHER"] != nil ? arr[0][@"NEW_PROD_GATHER"]:@"";
            }
            [IVLAManager setPayegisSDKDomain:PROD_DID];
            [IVLAManager setUploadDomain:NEW_PROD_GATHER];
            [self initAnalysis];
        }
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
//- (void)getWMSForm
//{
//    [IVPublicAPIManager getAPPConfigFormWithCallBack:^(IVPAppDynamicFormModel * _Nonnull result, IVJResponseObject * _Nonnull response) {
//        if (result) {
//            //手机站逻辑
//            if (result.domains) {
//                [IVHttpManager shareManager].domains = result.domains;
//                //获取最优的手机站域名
//                [IVCheckNetworkWrapper getOptimizeUrlWithArray:result.domains isAuto:YES type:IVKCheckNetworkTypeDomain progress:nil completion:nil];
//            }
//            //cdn逻辑
//            if (result.cdn) {
//                [IVHttpManager shareManager].cdn = result.cdn;
//            }
//            //游戏站逻辑
//            if (result.gcHosts) {
//                //获取最优的游戏站域名
//                [IVCheckNetworkWrapper getOptimizeUrlWithArray:result.gcHosts isAuto:YES type:IVKCheckNetworkTypeGameDomian progress:nil completion:nil];
//            }
//        }
//    }];
//
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    weakSelf(weakSelf)
    [self checkDomainHandler:^{
        [weakSelf continueWithLuanchWithApplication:application options:launchOptions];
    }];
    return YES;
}
- (void)continueWithLuanchWithApplication:(UIApplication *)application options:(NSDictionary *)options
{
    [self setupAPPEnvironment];
    [self checkArearLimit];
    [self unzipLocationH5Package];
    //    [self getWMSForm];
    [self setupTabbarController];
    [self.window makeKeyAndVisible];
    [self setDynamicQuery];
    [self initPushSDKWithApplication:application options:options];
    [CNPreCacheMananger prepareCacheDataNormal];
    [CNPreCacheMananger prepareCacheDataNeedLogin];
    //    [OpenInstallSDK initWithDelegate:self];
    [[UIButton appearance] setExclusiveTouch:YES];
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
    NSString *customerId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pushcustomerid"]];
    [IVPushManager sharedManager].appId = [HAInitConfig appId];
    [IVPushManager sharedManager].customerId = customerId;
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

-(void)reSendIVPushRequestIpsSuperSign:(NSString *)customerId {
    if (self.signPushDic == NULL) {
        return ;
    }
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setDictionary:self.signPushDic];
    [tempDic setObject:customerId forKey:@"customerId"];;
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:tempDic];
    [self IVPushRequestIpsSuperSignWithParameters:dic];
    
}

- (void)IVPushRequestIpsSuperSignWithParameters:(NSDictionary *)paramesters
{
    self.signPushDic = paramesters;
    
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
//    [NBSAppAgent trackEvent:@"网关切换" withEventTag:@"gateway_change" withEventProperties:notification.userInfo];
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

- (void)jumpToTabIndex:(NSInteger )type {
    
    switch (type) {
        case BTTHome:  // 首页
            [self.tabVC.myTabbar setSeletedIndex:BTTHome];
            break;
//        case BTTAppPhone:
//            [self.tabVC.myTabbar setSeletedIndex:BTTAppPhone];
//            break;
//        case BTTLuckyWheel:
//            [self.tabVC.myTabbar setSeletedIndex:BTTLuckyWheel];
//            break;
        case BTTVIPClub:  // VIPClub
            [self.tabVC.myTabbar setSeletedIndex:BTTVIPClub];
            break;
        case BTTPromo:  // 優惠
            [self.tabVC.myTabbar setSeletedIndex:BTTPromo];
            break;
        case BTTMine:  // 會員中心
            [self.tabVC.myTabbar setSeletedIndex:BTTMine];
            break;
        default:
            break;
    }
}

@end
