//
//  BridgeProtocol.m
//  MainHybird
//
//  Created by Key on 2018/6/8.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "BridgeProtocol.h"
#import "BridgeModel.h"
#import "WebConfigModel.h"
#import <SafariServices/SFSafariViewController.h>
#import "WebViewUserAgaent.h"
#import "AGQJWebViewController.h"
#import "NSString+Expand.h"

@interface BridgeProtocol ()
@end
@implementation BridgeProtocol

#pragma mark ----------bridge主体协议,后期扩展需要在每个项目的BridgeProtocolExternal类中添加相应方法----------

- (id)net_invoke:(BridgeModel *)bridgeModel {
    NSString *url = bridgeModel.data[@"apiUrl"];
    // 是否要显示loading框 YES 显示，NO 相反
    BOOL isLoading = [bridgeModel.data[@"loading"] boolValue];
    if (isLoading) {
        [self.controller showLoading];
    }
    HAWebViewController *webVC = (HAWebViewController *)self.controller;
    [IVNetwork sendRequestWithSubURL:url paramters:bridgeModel.data[@"params"] completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",result);
        NSMutableDictionary *dic = @{}.mutableCopy;
        dic[@"requestId"] = bridgeModel.requestId;
        dic[@"method"] = @"callback";
        NSDictionary *reponDic = response;
        reponDic = reponDic ? reponDic : @{};
        dic[@"data"] = [IVUtility dictionaryToJSONString:reponDic];
        [webVC nativeCallJSFunctionName:@"JSCallback" arguments:dic];
        [self.controller hideLoading];
    }];
    return @(YES);
}

- (id)forward_inside:(BridgeModel *)bridgeModel {
    WebConfigModel *webConfigModel = [[WebConfigModel alloc] initWithDictionary:bridgeModel.data error:nil];
    if (webConfigModel.newView) {
        if (self.controller.webConfigModel.newView) {
            self.controller.webConfigModel = webConfigModel;
            [self.controller loadWebView];
        } else {
            HAWebViewController *vc = webConfigModel.isAGQJ ? [AGQJWebViewController new] : [HAWebViewController new];
            vc.webConfigModel = webConfigModel;
            dispatch_main_async_safe((^{
                [self.controller.navigationController pushViewController:vc animated:YES];
            }));
        }
    } else {
        dispatch_main_async_safe((^{
            NSDictionary *tabBarDict = @{@"index" : @"", @"url" : webConfigModel.url};
            [[NSNotificationCenter defaultCenter] postNotificationName:BackTabBarRootViewNotification object:tabBarDict];
        }));
    }
    return @(YES);;
}
- (id)forward_outside:(BridgeModel *)bridgeModel {
    // 在浏览器中打开
    WebConfigModel *webConfigModel = [[WebConfigModel alloc] initWithDictionary:bridgeModel.data error:nil];
    if (webConfigModel.browser) {
        if ([webConfigModel.url hasPrefix:@"http"]) {
            NSURL *url = [[NSURL alloc] initWithString:webConfigModel.url];
            SFSafariViewController *controller = [[SFSafariViewController alloc] initWithURL:url];
            dispatch_main_async_safe((^{
                [self.controller presentViewController:controller animated:YES completion:nil];
            }));
        }
        else {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webConfigModel.url] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webConfigModel.url]];
            }
        }
    }
    // 在内部页面打开
    else {
        if (webConfigModel.newView) {
            if (self.controller.webConfigModel.newView) {
                [self.controller setWebConfigModel:webConfigModel];
                [self.controller loadWebView];
            }
            else {
                HAWebViewController  *webController = [[HAWebViewController alloc] init];
                webController.webConfigModel = webConfigModel;
                dispatch_main_async_safe((^{
                    [self.controller.navigationController pushViewController:webController animated:YES];
                }));
            }
        }
        else {
            [self.controller setWebConfigModel:webConfigModel];
            [self.controller loadWebView];
        }
    }
    return @(YES);
}
- (id)cache_clear:(BridgeModel *)bridgeModel {
    return  @([[IVCacheManager sharedInstance] clearCache]);
}

- (id)cache_get:(BridgeModel *)bridgeModel {
    NSString *key = bridgeModel.data[@"key"];
    return [[IVCacheManager sharedInstance] readJSONStringForKey:key requestId:bridgeModel.requestId];
}

- (id)cache_save:(BridgeModel *)bridgeModel {
    NSString *key = bridgeModel.data[@"key"];
    NSString *value = bridgeModel.data[@"value"];
    NSInteger expire = [bridgeModel.data[@"expire"] integerValue];
    BOOL isSaveFile = expire ? YES : NO;
    id result =  @([[IVCacheManager sharedInstance] writeJSONString:value forKey:key isSaveFile:isSaveFile]);
    return result;
}

- (id)cache_update:(BridgeModel *)bridgeModel {
    NSString *key = bridgeModel.data[@"key"];
    NSString *value = bridgeModel.data[@"value"];
    NSInteger expire = [bridgeModel.data[@"expire"] integerValue];
    BOOL isSaveFile = expire ? YES : NO;
    return  @([[IVCacheManager sharedInstance] writeJSONString:value forKey:key isSaveFile:isSaveFile]);
}

- (id)cache_delete:(BridgeModel *)bridgeModel {
    NSString *key = bridgeModel.data[@"key"];
    return  @([[IVCacheManager sharedInstance] writeJSONString:nil forKey:key isSaveFile:YES]);
}

- (id)driver_ui:(BridgeModel *)bridgeModel {
    if ([bridgeModel.method isEqualToString:@"topBar"]){
        BOOL show = [bridgeModel.data[@"show"] boolValue];
        self.controller.navigationController.navigationBarHidden = !show;
    }
    return nil;
}
- (id)isInstall_qq:(BridgeModel *)bridgeModel {
    BOOL isInstall = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"isInstall"] = [NSNumber numberWithBool:isInstall];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    result[@"requestId"] = bridgeModel.requestId;
    result[@"status"] = [NSNumber numberWithBool:YES];
    result[@"data"] = dict;
    return result;
}
- (id)isInstall_wx:(BridgeModel *)bridgeModel {
    BOOL isInstall = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"isInstall"] = [NSNumber numberWithBool:isInstall];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    result[@"requestId"] = bridgeModel.requestId;
    result[@"status"] = [NSNumber numberWithBool:YES];
    result[@"data"] = dict;
    return result;
}
- (id)isInstall_alipay:(BridgeModel *)bridgeModel {
    BOOL isInstall = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"isInstall"] = [NSNumber numberWithBool:isInstall];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    result[@"requestId"] = bridgeModel.requestId;
    result[@"status"] = [NSNumber numberWithBool:YES];
    result[@"data"] = dict;
    return result;
}
- (id)driver_IPSUnread:(BridgeModel *)bridgeModel {
    NSInteger applicationIconBadgeNumber = [bridgeModel.data[@"num"] integerValue];
    [UIApplication sharedApplication].applicationIconBadgeNumber = applicationIconBadgeNumber;
    return @(YES);
}

- (id)driver_clearCookie:(BridgeModel *)bridgeModel {
    [WebViewUserAgaent clearCookie];
    return @(YES);
}

- (id)driver_deviceInfo:(BridgeModel *)bridgeModel {
    /* 设备唯一标识码 Verge 2017-07-17 18:41 */
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *udid = [IVNetwork getDeviceId];
    dict[@"drice_id"] = udid;
    dict[@"drice_type"] = @"ios";
    dict[@"phone_board"] = @"Apple";
    dict[@"phone_model"] = [self replaceParamsSpace:@""];
    dict[@"phone_version"] = [self replaceParamsSpace:@""];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    result[@"requestId"] = bridgeModel.requestId;
    result[@"status"] = [NSNumber numberWithBool:YES];
    result[@"data"] = [IVUtility dictionaryToJSONString:dict];
    return [IVUtility dictionaryToJSONString:result];;
}

- (id)driver_game:(BridgeModel *)bridgeModel {
    WebConfigModel *webConfigModel = [[WebConfigModel alloc] initWithDictionary:bridgeModel.data error:nil];
    if (webConfigModel.isAGQJ) {
        webConfigModel.newView = YES;
        NSString *url = webConfigModel.isTry ? @"game/getLoginUrlByTryPlay" : @"game/getLoginUrl";
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"game_id"] = webConfigModel.gameCode;
        params[@"game_type"] = @"2";
        [self.controller showLoading];
        weakSelf(weakSelf)
        [IVNetwork sendRequestWithSubURL:url paramters:params.copy  completionBlock:^(IVRequestResultModel *result, id response) {
            strongSelf(strongSelf)
            [strongSelf.controller hideLoading];
            NSDictionary *dict = result.data;
            NSString *gameUrl = [dict valueForKey:@"url"];
            webConfigModel.url = gameUrl;
            webConfigModel.newView = YES;
            [strongSelf forwardAGQJControllWithConfig:webConfigModel];
        }];
    }
    return @(YES);
}

- (id)driver_getParentId:(BridgeModel *)bridgeModel {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"parentId"] = [IVNetwork parentId];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    result[@"requestId"] = bridgeModel.requestId;
    result[@"status"] = [NSNumber numberWithBool:YES];
    result[@"data"] = [IVUtility dictionaryToJSONString:dict];
    return result;
}

- (id)driver_getSessionId:(BridgeModel *)bridgeModel {
    NSString *temp = [UIDevice uuidForSession];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"sessionId"] = temp;
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    result[@"requestId"] = bridgeModel.requestId;
    result[@"status"] = [NSNumber numberWithBool:YES];
    result[@"data"] = [IVUtility dictionaryToJSONString:dict];
    return result;
}
- (id)driver_getVersion:(BridgeModel *)bridgeModel {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    result[@"requestId"] = bridgeModel.requestId;
    result[@"status"] = [NSNumber numberWithBool:YES];
    result[@"data"] = [IVUtility dictionaryToJSONString:@{@"version":app_version}];
    return [IVUtility dictionaryToJSONString:result];
}
- (id)driver_copy:(BridgeModel *)bridgeModel {
    NSDictionary *dict = bridgeModel.data;
    NSString *temp = [dict valueForKey:@"value"];
    if (![NSString isBlankString:temp]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIPasteboard *board = [UIPasteboard generalPasteboard];
            [board setString:temp];
        });
    }
    return @(YES);
}

- (id)notification_loginNotify:(BridgeModel *)bridgeModel {
    [IVNetwork sendDeviceInfo];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotification object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.controller.navigationController popViewControllerAnimated:YES];
        });
    });
    return @(YES);
}

- (id)notification_logoutNotify:(BridgeModel *)bridgeModel {
    return @(YES);
}

- (id)outside_updateUI:(BridgeModel *)bridgeModel {
    return @(YES);
}

- (id)outside_debug:(BridgeModel *)bridgeModel {
    return @(YES);
}

- (void)forwardAGQJControllWithConfig:(WebConfigModel *)config {
    weakSelf(weakSelf)
    dispatch_main_async_safe((^{
        strongSelf(strongSelf)
        AGQJWebViewController *vc = [[AGQJWebViewController alloc] init];
        vc.navigationItem.title = @"AG旗舰厅";
        vc.webConfigModel = config;
        [strongSelf.controller.navigationController pushViewController:vc animated:YES];
    }));
}

- (NSString *)replaceParamsSpace:(NSString *)param {
    return [param stringByReplacingOccurrencesOfString:@" " withString:@"-"];
}

@end
