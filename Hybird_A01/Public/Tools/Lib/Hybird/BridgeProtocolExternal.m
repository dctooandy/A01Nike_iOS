//
//  BridgeProtocolExternal.m
//  Hybird_test
//
//  Created by Key on 2018/6/8.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "BridgeProtocolExternal.h"
#import "CLive800Manager.h"
#import "BTTTabbarController.h"
#import "BTTVoiceCallViewController.h"
#import "JXRegisterManager.h"
#import "BTTTabbarController.h"
#import "AppDelegate.h"
#import "BTTPersonalInfoController.h"
#import "BTTBindingMobileController.h"
#import "BTTCardInfosController.h"
#import "BTTWithdrawalController.h"
#import "BTTLoginOrRegisterViewController.h"
@interface BridgeProtocolExternal ()<JXRegisterManagerDelegate>

@end

@implementation BridgeProtocolExternal

- (void)registerUID {
    
    JXRegisterManager *registerManager = [JXRegisterManager sharedInstance];
    registerManager.delegate = self;
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:BTTUIDKey];
    [registerManager registerWithUID:uid];
}

#pragma mark- JXRegisterManagerDelegate
- (void)didRegisterResponse:(NSDictionary *)response {

}

- (id)driver_live800:(BridgeModel *)bridgeModel {
    [[CLive800Manager sharedInstance] startLive800Chat:self.controller];
    return nil;
}
- (id)driver_live800ol:(BridgeModel *)bridgeModel {
//    NSString *url = @"https://www.why918.com/chat/chatClient/chatbox.jsp?companyID=8990&configID=21&k=1&codeType=custom";
//    HAWebViewController *temp = [[HAWebViewController alloc] init];
//    temp.webConfigModel.newView = YES;
//    temp.webConfigModel.url = url;
//    weakSelf(weakSelf)
//    dispatch_main_async_safe((^{
//        strongSelf(strongSelf)
//        temp.navigationItem.title = @"在线客服";
//        [strongSelf.controller.navigationController pushViewController:temp animated:YES];
//    }));
    return @(YES);
}
- (id)driver_game:(BridgeModel *)bridgeModel {
   
    return @(YES);
}

- (id)forward_inside:(BridgeModel *)bridgeModel
{
    WebConfigModel *webConfigModel = [[WebConfigModel alloc] initWithDictionary:bridgeModel.data error:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL isForwardNativePage = [self shouldForwardNatviePage:webConfigModel.url];
        if (!isForwardNativePage) {
            [super forward_inside:bridgeModel];
        }
    });
     return @(YES);
}
- (BOOL)shouldForwardNatviePage:(NSString *)url
{
    BOOL should = YES;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BTTTabbarController *tabVC = (BTTTabbarController *)app.window.rootViewController;
    if ([url containsString:@"customer/member_center.htm"]) {//会员中心
        tabVC.selectedIndex = 4;
        [self.controller.navigationController popToRootViewControllerAnimated:YES];
    }
    else if ([url containsString:@"customer/personal_info.htm"]){//完善个人资料
        [self.controller.navigationController pushViewController:[BTTPersonalInfoController new] animated:YES];
    }
    else if ([url containsString:@"customer/bind_mobile.htm"]){//绑定手机号
        BTTBindingMobileController *vc = [BTTBindingMobileController new];
        vc.mobileCodeType = BTTSafeVerifyTypeBindMobile;
        [self.controller.navigationController pushViewController:vc animated:YES];
    }
    else if ([url containsString:@"customer/bank_list.htm"]){//银行卡列表
        BTTCardInfosController *vc = [BTTCardInfosController new];
        [self.controller.navigationController pushViewController:vc animated:YES];
    }
    else if ([url containsString:@"promotions/promotion_list.htm"] ||
             [url containsString:@"common/promotion_list.htm"]){//优惠
        tabVC.selectedIndex = 3;
        [self.controller.navigationController popToRootViewControllerAnimated:YES];
    }
    else if ([url containsString:@"common/index.htm"]){//首页
        tabVC.selectedIndex = 0;
        [self.controller.navigationController popToRootViewControllerAnimated:YES];
    }
    else if ([url containsString:@"common/login.htm"]){//登录
        BTTLoginOrRegisterViewController *loginAndRegister = [[BTTLoginOrRegisterViewController alloc] init];
        loginAndRegister.registerOrLoginType = BTTRegisterOrLoginTypeLogin;
        [self.controller.navigationController pushViewController:loginAndRegister animated:YES];
    }
    else if ([url containsString:@"customer/withdrawl.htm"]){//提现
        [self.controller.navigationController pushViewController:[BTTWithdrawalController new] animated:YES];
    }
    else {
        should = NO;
    }
    return should;
}

- (id)forward_outside:(BridgeModel *)bridgeModel { // custom/VOIP
    WebConfigModel *webConfigModel = [[WebConfigModel alloc] initWithDictionary:bridgeModel.data error:nil];
    if ([webConfigModel.url isEqualToString:@"custom/VOIP"]) {
        [self registerUID];
        return @(YES);
    } else if ([webConfigModel.url isEqualToString:@"a01/versionUpdate"]) {
        [IVNetwork checkAppUpdate];
        return @(YES);
    } else {
        if (webConfigModel.newView) {
            BTTBaseWebViewController *webVC = [[BTTBaseWebViewController alloc] init];
            webVC.webConfigModel = webConfigModel;
            [self.controller.navigationController pushViewController:webVC animated:YES];
        } else {
            self.controller.webConfigModel = webConfigModel;
            [self.controller loadWebView];
        }
        return @(NO);
    }
}

- (id)driver_ui:(BridgeModel *)bridgeModel {
    NSLog(@"%@",bridgeModel.data);
    return [super driver_ui:bridgeModel];
}

- (id)outside_updateUI:(BridgeModel *)bridgeModel {
    [super outside_updateUI:bridgeModel];
    return nil;
}
@end
