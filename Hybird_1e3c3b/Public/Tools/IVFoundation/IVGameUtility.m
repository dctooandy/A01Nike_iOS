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
        [CNTimeLog AGQJReLoad];
    }
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
- (void)IVGameGetUrlWithParamters:(NSDictionary *)paramters gameController:(IVWKGameViewController *)gameController completion:(void (^)(BOOL, NSString *))completion
{
    __weak typeof(self)weakSelf = self;
    [[IVHttpManager shareManager] sendRequestWithUrl:@"game/inGame" parameters:paramters.copy callBack:^(IVJResponseObject * _Nullable response, NSError * _Nullable error) {
        
        if ([response.head.errCode isEqualToString:@"GW_801607"]) {
            completion(YES,nil);
            return;
        }
        if (![response.head.errCode isEqualToString:@"0000"]) {
            completion(NO,nil);
            return;
        }
        
        NSString *url = [response.body valueForKey:@"url"];
        

        if ([gameController.gameModel.provider isEqualToString:kPTProvider]) {
            NSDictionary *postMap = [response.body valueForKey:@"postMapNew"];
            url = [NSString stringWithFormat:@"%@game_pt.html?",[IVHttpManager shareManager].domain] ;
            url = [weakSelf appendingURLString:url parameters:postMap];
        }
        
        completion(YES,url);
        
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
        {
            [CSVisitChatmanager startWithSuperVC:gameController finish:^(CSServiceCode errCode) {
                if (errCode != CSServiceCode_Request_Suc) {
                    [MBProgressHUD showErrorWithTime:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持" toView:nil duration:3];
                } else {

                }
            }];
        }
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
            [CSVisitChatmanager startWithSuperVC:(UIViewController *)webView.navigationDelegate finish:^(CSServiceCode errCode) {
                if (errCode != CSServiceCode_Request_Suc) {
                    [MBProgressHUD showErrorWithTime:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持" toView:nil duration:3];
                } else {

                }
            }];
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
- (NSString *)appendingURLString:(NSString *)urlString parameters:(NSDictionary *)parameters
{
    //拼接其他参数
    NSString *url = urlString.copy;
    NSMutableDictionary *mQuery = @{}.mutableCopy;
    if (parameters && [parameters isKindOfClass:[NSDictionary class]]) {
        [mQuery setValuesForKeysWithDictionary:parameters];
    }
   
    if (mQuery.count == 0) {
        return url;
    }
    NSDictionary *query = mQuery.copy;
    NSURLComponents *components = [NSURLComponents componentsWithString:url];
    if (!components) {
        return url;
    }
    NSMutableArray<NSURLQueryItem *> *queryItems = [[NSMutableArray<NSURLQueryItem *> alloc] init];
    if (components.queryItems.count > 0) {
        [queryItems addObjectsFromArray:components.queryItems];
    }
    for (NSString *key in query.allKeys) {
        NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:key value:query[key]];
        [queryItems addObject:queryItem];
    }
    [components setQueryItems:queryItems.copy];
    return components.URL.absoluteString;
}

@end

