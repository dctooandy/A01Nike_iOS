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

+(void)startKeFu:(UIViewController *)vc csServicecompleteBlock:(CSServiceCompleteBlock)csServicecompleteBlock {
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
    
    //隐藏log，默认不隐藏  隐藏 YES。不隐藏 NO
    //    info.hidenLog = YES;
    //    info.hidenLoading = YES;//隐藏网络请求时的转圈圈
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    params[@"productId"] = [HAInitConfig productId];
    [MBProgressHUD showLoadingSingleInView:vc.view animated:true];
    [IVNetwork requestPostWithUrl:@"liveChatAddressOCSS" paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [MBProgressHUD hideHUDForView:vc.view animated:true];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            info.response = result.body;
            [CSVisitChatmanager startWithSuperVC:vc chatInfo:info finish:^(CSServiceCode errCode) {
                csServicecompleteBlock(errCode);
            }];
        } else {
            csServicecompleteBlock(CSServiceCode_Request_Fail);
        }
    }];
}

@end

