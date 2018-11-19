//
//  AMGameUtility.m
//  HybirdApp
//
//  Created by Key on 2018/9/17.
//  Copyright © 2018年 AM-DEV. All rights reserved.
//

#import "IVGameUtility.h"
#import "NSString+Expand.h"
#import "BTTHttpManager.h"
#import "AppDelegate.h"
@implementation IVGameUtility
- (UIColor *)IVGameGetNavigationTitleColor {
    return [UIColor whiteColor];
}
- (UIStatusBarStyle)IVGameStatusBarStyle {
    return StatusBarStyle;
}
- (NSString *)IVGameGetProductId
{
    return [IVNetwork productId];
}
- (UIImage *)IVGameGetNavigationBarBackgroundImage
{
    return [UIImage imageNamed:@"home_nav_bg"];
}
- (NSString *)IVGameGetH5Domain
{
    return [IVNetwork h5Domain];
}
- (NSString *)IVGameGetGameDomain
{
    return [IVNetwork gameDomain];
}
- (NSArray *)IVGameGetGateways
{
    return [IVNetwork gateways];
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
    if ([IVNetwork getNetworkType] == kNetworkTypeNotReachable) {
        [IVNetwork showToastWithMessage:@"似乎已断开与互联网的连接!"];
        return NO;
    }
    return YES;
}

- (void)IVGameGetUrlWithParamters:(NSDictionary *)paramters gameController:(IVWKGameViewController *)gameController completion:(void (^)(BOOL,NSString *))completion
{
    BOOL isTry = ![IVNetwork userInfo];
    [BTTHttpManager publicGameLoginWithParams:paramters isTry:isTry completeBlock:^(IVRequestResultModel *result, id response) {
        if (completion) {
            completion(result.status,response);
        }
    }];
}
- (void)IVGameTransferWithProvider:(NSString *)provider
{

    if (![IVNetwork userInfo]) {
        return;
    }
    [BTTHttpManager publicGameTransferWithProvider:provider completeBlock:nil];
}
- (void)IVGameForwardToPageWithType:(IVGameForwardPageType)type gameController:(IVWKGameViewController *)gameController {
    //转为竖屏
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    /*
    ViewConfigModel *configModel = [[ViewConfigModel alloc] init];
    configModel.newView = YES;
    UIViewController *controller = nil;
    switch (type) {
        case IVGameForwardPageTypeWithdrawal:
            controller = [[AMWithdrawalVC alloc] init];
            break;
        case IVGameForwardPageTypeDeposit:
            controller = [[AMPayViewController alloc] init];
            break;
        case IVGameForwardPageTypeCustomerService:
            controller = [[AMKFViewController alloc] init];
            break;
        case IVGameForwardPageTypeBJLDetails:
            configModel.url = @"gameRule/table_baccarat.htm";
            configModel.title = @"包桌百家乐";
            break;
        case IVGameForwardPageTypeExit: {
            return;
        }
            break;
        case IVGameForwardPageTypeForum:
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.am8show.com/"]];
            return;
            break;
        case IVGameForwardPageTypePromotions:{
            AppDelegate *app = (AppDelegate *)APPDELEGATE;
            [app.tabbarController resetEnvironmentNavigationTabBarSelectedIndex:3 completion:nil];
            return;
        }
            break;
        case IVGameForwardPageTypeRegister:{
            AMRegisterViewController *regVC = [[AMRegisterViewController alloc] init];
            regVC.needShowLogin = YES;
            controller = regVC;
        }
            break;
        case IVGameForwardPageTypeGoHome: {
            AppDelegate *app = (AppDelegate *)APPDELEGATE;
            [app.tabbarController resetEnvironmentNavigationTabBarSelectedIndex:0 completion:nil];
            return;
        }
        case IVGameForwardPageTypeGameHall: {
            AppDelegate *app = (AppDelegate *)APPDELEGATE;
            [app.tabbarController resetEnvironmentNavigationTabBarSelectedIndex:2 completion:nil];
            return;
        }
        default:
            break;
    }
    if (!controller) {
        controller = [[HDWebController alloc] initWithViewConfigModel:configModel];
    }
    
    [gameController.navigationController pushViewController:controller animated:YES];
     */
}




@end
