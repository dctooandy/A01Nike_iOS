//
//  LiveChat.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 14/4/2021.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "LiveChat.h"
#import <CSCustomSerVice/CSCustomSerVice.h>
#import "HAInitConfig.h"

@implementation LiveChat

+(void)initOcssSDKNetWork {
    CSChatInfo *info = [[CSChatInfo alloc]init];
    info.title = @"在线客服";//导航栏标题
    info.productId = [HAInitConfig productId];//产品ID
    info.appid = [HAInitConfig appId];//AppID
    
    //网站登陆后的token
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
    if (userToken!=nil) {
        info.token = userToken;
    }
    //网站用户名
    if ([IVNetwork savedUserInfo]) {
        info.loginName = [IVNetwork savedUserInfo].loginName;
    }
    //请求头中的v,不穿默认取 CFBundleShortVersionString
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    info.v = appVersion;
    //网站域名
    NSString * gatewayStr = [[HAInitConfig gateways] objectAtIndex:(arc4random() % [HAInitConfig gateways].count)];
    NSURL *gatewayUrl = [NSURL URLWithString:gatewayStr];
    NSString *domainName = [NSString stringWithFormat:@"%@",gatewayUrl.host];
    info.domainName = domainName;
    //app网关地址
    info.baseUrl = gatewayStr;
    //设备id，不傳会默认生成
    info.uuid = [UIDevice uuidForDevice];
    
    //下面几个是标题栏具体参数设置，默认为系统样式，可以自定义
    info.backColor = [UIColor whiteColor];
    info.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    info.barTintColor = [UIColor colorWithRed: 0.13 green: 0.37 blue: 0.76 alpha: 1.00];
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    params[@"productId"] = [HAInitConfig productId];
    weakSelf(weakSelf);
    [IVNetwork requestPostWithUrl:@"liveChatAddressOCSS" paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        info.response = result.body;
        [weakSelf initTestSpeed:info.response chatInfo:info];
    }];
}

+(void)reloadSDK {
    CSChatInfo *info = [[CSChatInfo alloc]init];
    info.title = @"在线客服";//导航栏标题
    info.productId = [HAInitConfig productId];//产品ID
    info.appid = [HAInitConfig appId];//AppID
    
    //网站登陆后的token
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"userToken"];
    if (userToken!=nil) {
        info.token = userToken;
    }
    //网站用户名
    if ([IVNetwork savedUserInfo]) {
        info.loginName = [IVNetwork savedUserInfo].loginName;
    }
    //请求头中的v,不穿默认取 CFBundleShortVersionString
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    info.v = appVersion;
    //网站域名
    NSString * gatewayStr = [[HAInitConfig gateways] objectAtIndex:(arc4random() % [HAInitConfig gateways].count)];
    NSURL *gatewayUrl = [NSURL URLWithString:gatewayStr];
    NSString *domainName = [NSString stringWithFormat:@"%@",gatewayUrl.host];
    info.domainName = domainName;
    //app网关地址
    info.baseUrl = gatewayStr;
    //设备id，不傳会默认生成
    info.uuid = [UIDevice uuidForDevice];
    
    //下面几个是标题栏具体参数设置，默认为系统样式，可以自定义
    info.backColor = [UIColor whiteColor];
    info.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    info.barTintColor = [UIColor colorWithRed: 0.13 green: 0.37 blue: 0.76 alpha: 1.00];
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    params[@"productId"] = [HAInitConfig productId];
    weakSelf(weakSelf);
    [IVNetwork requestPostWithUrl:@"liveChatAddressOCSS" paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        info.response = result.body;
//        [CSVisitChatmanager reloadSDK:info finish:^(CSServiceCode errCode) {
//            NSLog(@"222222");
//        }];
        [weakSelf testSpeed:info.response chatInfo:info];
    }];
}

+(void)testSpeed:(NSDictionary *)response chatInfo:(CSChatInfo *)info {
    NSDictionary * body = response[@"body"];
    info.response = body;
    NSArray * domainBakList = body[@"domainBakList"];
    info.domainBakList = domainBakList;
    [CSVisitChatmanager reloadSDK:info finish:^(CSServiceCode errCode) {
        NSLog(@"222222");
    }];
}

//app进行速度测试
+(void)initTestSpeed:(NSDictionary *)response chatInfo:(CSChatInfo *)info{
    //取body里面的内容
    NSDictionary *body = response[@"body"];
    info.response = body;
    //app有域名测速功能就使用，没有直接注释domainBakList赋值即可
    NSArray *domainBakList = body[@"domainBakList"];
    //...测速代码，速度从快到慢
    info.domainBakList = domainBakList;//速度从快到慢。
    [CSVisitChatmanager initSDK:info finish:^(CSServiceCode errCode) {
        NSLog(@"222222");
    } appearblock:nil disbock:nil];
}


@end

