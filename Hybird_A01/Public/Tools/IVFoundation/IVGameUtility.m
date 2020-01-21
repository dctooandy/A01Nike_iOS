//
//  AMGameUtility.m
//  HybirdApp
//
//  Created by Key on 2018/9/17.
//  Copyright © 2018年 AM-DEV. All rights reserved.
//

#import "IVGameUtility.h"
#import "NSString+Expand.h"
//#import "BTTHttpManager.h"
#import "AppDelegate.h"
#import "BTTWithdrawalController.h"
#import "CNPayVC.h"
#import "BTTTabbarController.h"
#import "BTTLoginOrRegisterViewController.h"
#import "CLive800Manager.h"
#import "BTTCardInfosController.h"
#import "BTTPersonalInfoController.h"
@implementation IVGameUtility
- (UIColor *)IVGameGetNavigationTitleColor {
    return [UIColor whiteColor];
}
- (UIStatusBarStyle)IVGameStatusBarStyle {
    return StatusBarStyle;
}
- (NSString *)IVGameGetProductId
{
    return [IVHttpManager shareManager].productId;
}
- (UIImage *)IVGameGetNavigationBarBackgroundImage
{
    return [UIImage imageNamed:@"navbg"];
}
- (NSString *)IVGameGetH5Domain
{
    return [IVHttpManager shareManager].domain;
}
- (NSString *)IVGameGetGameDomain
{
    return [IVHttpManager shareManager].gameDomain;
}
- (NSArray *)IVGameGetGateways
{
    return [IVHttpManager shareManager].gateways;
}

- (void)reloadGameWithProvider:(NSString *)provider
{
    if ([provider isEqualToString:kAGQJProvider]) {
        [IVGameManager sharedManager].agqjVC.loadStatus = IVGameLoadStatusLoading;
        [[CNTimeLog shareInstance] AGQJReLoad];
    }
}

- (NSString *)IVGameAppendingUserInfoWithUrl:(NSString *)url parameters:(NSDictionary *)parameters {
    NSString *resultUrl = [NSString getURL:url queryParameters:[PublicMethod commonH5ArgumentWithUserParameters:@{}]];
    return resultUrl;
}
- (NSString *)IVGameAppendingParamtersWithUrl:(NSString *)url parameters:(NSDictionary *)parameters
{
    NSString *resultUrl = [NSString getURL:url queryParameters:parameters];
    return resultUrl;
}

- (BOOL)IVGameShouldForwardToGame {

    if ([[UIDevice networkType] isEqualToString:@"notReachable"]) {
        [MBProgressHUD showError:@"似乎已断开与互联网的连接!" toView:nil];
        return NO;
    }
    return YES;
}

- (void)IVGameGetUrlWithParamters:(NSDictionary *)paramters gameController:(IVWKGameViewController *)gameController completion:(void (^)(BOOL,NSString *))completion
{
    BOOL isTry = ![IVHttpManager shareManager].userToken.length;
    [BTTHttpManager publicGameLoginWithParams:paramters isTry:isTry completeBlock:^(IVRequestResultModel *result, id response) {
        if (result.code_http==200&&[result.message isEqualToString:@"游戏维护中"]) {
            if (completion) {
                completion(YES,@"");
            }
        }else{
            if (completion) {
                completion(result.status,response);
            }
        }
        
    }];
}
- (void)IVGameTransferWithProvider:(NSString *)provider
{

//    if (![IVNetwork userInfo]) {
//        return;
//    }
//
//
//    [BTTHttpManager publicGameTransferWithProvider:provider completeBlock:nil];
}
- (void)IVGameForwardToPageWithType:(IVGameForwardPageType)type gameController:(IVWKGameViewController *)gameController {
    //转为竖屏
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];

    WebConfigModel *configModel = [[WebConfigModel alloc] init];
    configModel.newView = YES;
    UIViewController *controller = nil;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BTTTabbarController *tabVC = (BTTTabbarController *)app.window.rootViewController;
    switch (type) {
        case IVGameForwardPageTypeWithdrawal:{
            UIViewController *vc = nil;
//            if ([IVNetwork userInfo].real_name && [IVNetwork userInfo].verify_code) {
//                if ([IVNetwork userInfo].isBankBinded) {
//                    vc = [[BTTWithdrawalController alloc] init];
//                } else {
//                    [MBProgressHUD showMessagNoActivity:@"请先绑定银行卡" toView:nil];
//                    vc = [[BTTCardInfosController alloc] init];
//                }
//            } else {
//                [MBProgressHUD showMessagNoActivity:@"请先完善个人信息" toView:nil];
//                vc = [[BTTPersonalInfoController alloc] init];
//            }
            controller = vc;
        }
            break;
        case IVGameForwardPageTypeDeposit:
            controller = [[CNPayVC alloc] init];
            break;
        case IVGameForwardPageTypeCustomerService:
            [[CLive800Manager sharedInstance] startLive800Chat:gameController];
            return;
        case IVGameForwardPageTypeBJLDetails:
            configModel.url = @"gameRule/table_baccarat.htm";
            configModel.title = @"包桌百家乐";
            return;
        case IVGameForwardPageTypeExit: {
            return;
        }
            break;
        case IVGameForwardPageTypeForum:
            return;
            break;
        case IVGameForwardPageTypePromotions:{
            [gameController.navigationController popToRootViewControllerAnimated:YES];
            tabVC.selectedIndex = 3;
            return;
        }
            break;
        case IVGameForwardPageTypeRegister:{
            BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
            vc.registerOrLoginType = BTTRegisterOrLoginTypeRegisterNormal;
            controller = vc;
        }
            break;
        case IVGameForwardPageTypeGoHome: {
            [gameController.navigationController popToRootViewControllerAnimated:YES];
            tabVC.selectedIndex = 0;
            return;
        }
        case IVGameForwardPageTypeGameHall: {
            [gameController.navigationController popToRootViewControllerAnimated:YES];
            tabVC.selectedIndex = 0;
            return;
        }
        default:
            break;
    }
    if (!controller) {
        HAWebViewController *vc = [[HAWebViewController alloc] init];
        vc.webConfigModel = configModel;
        controller = vc;
    }
    
    [gameController.navigationController pushViewController:controller animated:YES];
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    UIViewController *vc =  (UIViewController *)webView.navigationDelegate;
    if ([navigationAction.request.URL.absoluteString containsString:@"nbapp://"]) {
        if ([[navigationAction.request.URL.absoluteString URLDecodedString] containsString:@"https://www.why918.com"]) {
            [[CLive800Manager sharedInstance] startLive800Chat:(UIViewController *)webView.navigationDelegate];
        } else if ([[navigationAction.request.URL.absoluteString URLDecodedString] containsString:@"/deposit_xunjie.htm"]) {
            
            [vc.navigationController pushViewController:[[CNPayVC alloc] init] animated:YES];
        } else if ([[navigationAction.request.URL.absoluteString URLDecodedString] containsString:@"/login.htm"]) {
            BTTLoginOrRegisterViewController *loginAndRegister = [[BTTLoginOrRegisterViewController alloc] init];
            loginAndRegister.registerOrLoginType = BTTRegisterOrLoginTypeLogin;
            [vc.navigationController pushViewController:loginAndRegister animated:YES];
        }
    }
//    else if ([navigationAction.request.URL.absoluteString isEqualToString:@"http://m.xjcbet.com/#/"]) {
//        [vc.navigationController popToRootViewControllerAnimated:YES];
//    }
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    return nil;
}

@end
