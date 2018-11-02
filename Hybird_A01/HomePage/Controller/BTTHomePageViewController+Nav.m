//
//  BTTHomePageViewController+Nav.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/17.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTHomePageViewController+Nav.h"
#import <objc/runtime.h>
#import "BTTPopoverView.h"
#import "BTTLoginAndRegisterViewController.h"
#import "BTTLive800ViewController.h"
#import "CLive800Manager.h"
#import "BTTTabbarController+VoiceCall.h"
#import "BTTVoiceCallViewController.h"

static const char *BTTHeaderViewKey = "headerView";

@implementation BTTHomePageViewController (Nav)

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess:) name:LogoutSuccessNotification object:nil];
}

- (void)loginSuccess:(NSNotification *)notifi {
    self.isLogin = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUI];
    });
}

- (void)logoutSuccess:(NSNotification *)notifi {
    self.isLogin = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUI];
    });
}

- (void)updateUI {
    self.headerView.isLogin = self.isLogin;
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.isLogin ? BTTNavHeightLogin : BTTNavHeightNotLogin);
    self.collectionView.frame = CGRectMake(0,  self.isLogin ? BTTNavHeightLogin : BTTNavHeightNotLogin, SCREEN_WIDTH, SCREEN_HEIGHT - (self.isLogin ? BTTNavHeightLogin : BTTNavHeightNotLogin));
}

- (void)setupNav {
    [self.navigationController setNavigationBarHidden:YES];
    self.headerView = [[BTTHomePageHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.isLogin ? BTTNavHeightLogin : BTTNavHeightNotLogin) withNavType:BTTNavTypeHomePage];
    self.headerView.isLogin = self.isLogin;
    [self.view addSubview:self.headerView];
    weakSelf(weakSelf);
    self.headerView.btnClickBlock = ^(UIButton *button) {
        strongSelf(strongSelf);
        switch (button.tag) {
            case 2001:
            {
                [strongSelf rightClick:button];
            }
                break;
                
            case 2002:
            {
                
            }
                break;
                
            case 2003:
            {
                BTTLoginAndRegisterViewController *loginAndRegister = [[BTTLoginAndRegisterViewController alloc] init];
                loginAndRegister.webConfigModel.url = @"common/login.htm"; // common/register.htm
                loginAndRegister.webConfigModel.newView = YES;
                [strongSelf.navigationController pushViewController:loginAndRegister animated:YES];
            }
                break;
                
            case 2004:
            {
                BTTLoginAndRegisterViewController *loginAndRegister = [[BTTLoginAndRegisterViewController alloc] init];
                loginAndRegister.webConfigModel.url = @"common/register.htm";
                loginAndRegister.webConfigModel.newView = YES;
                [strongSelf.navigationController pushViewController:loginAndRegister animated:YES];
            }
                break;
                
            default:
                break;
        }
    };
}


- (void)rightClick:(UIButton *)btn {
    
    BTTPopoverAction *action1 = [BTTPopoverAction actionWithImage:ImageNamed(@"onlineService") title:@"在线客服" handler:^(BTTPopoverAction *action) {
        NSString *url = @"https://www.why918.com/chat/chatClient/chatbox.jsp?companyID=8990&configID=21&k=1&codeType=custom";
        BTTLive800ViewController *live800 = [[BTTLive800ViewController alloc] init];
        live800.webConfigModel.url = url;
        live800.webConfigModel.newView = YES;
        [self.navigationController pushViewController:live800 animated:YES];
    }];
    
    BTTPopoverAction *action2 = [BTTPopoverAction actionWithImage:ImageNamed(@"voiceCall") title:@"APP语音通信" handler:^(BTTPopoverAction *action) {
        BTTTabbarController *tabbar = (BTTTabbarController *)self.tabBarController;
        BOOL isLogin = [IVNetwork userInfo] ? YES : NO;
        weakSelf(weakSelf);
        [tabbar loadVoiceCallNumWithIsLogin:isLogin makeCall:^(NSString *uid) {
            if (uid == nil || uid.length == 0) {
                [BTTProgressHUD showOnlyText:@"拨号失败请重试" toView:[UIApplication sharedApplication].delegate.window];
            } else {
                strongSelf(strongSelf);
                [strongSelf registerUID:uid];
            }
        }];
    }];
    
    BTTPopoverAction *action3 = [BTTPopoverAction actionWithImage:ImageNamed(@"callBack") title:@"VIP经理回拨" handler:^(BTTPopoverAction *action) {
        
    }];
    
    BTTPopoverAction *action4 = [BTTPopoverAction actionWithImage:ImageNamed(@"onlineVoice") title:@"语音聊天" handler:^(BTTPopoverAction *action) {
        [[CLive800Manager sharedInstance] startLive800Chat:self];
    }];
    
    BTTPopoverAction *action5 = [BTTPopoverAction actionWithTitle:@"     客服热线\n400-120-3618" detailTitle:@"400-120-3618" handler:^(BTTPopoverAction *action) {
        
    }];
    BTTPopoverView *popView = [BTTPopoverView PopoverView];
    popView.style = BTTPopoverViewStyleDark;
    popView.arrowStyle = BTTPopoverViewArrowStyleTriangle;
    [popView showToPoint:CGPointMake(SCREEN_WIDTH - 27, KIsiPhoneX ? 88 : 64) withActions:@[action1,action2,action3,action4,action5]];
    
}

#pragma mark - JXRegisterManagerDelegate

- (void)registerUID:(NSString *)uid {
    JXRegisterManager *registerManager = [JXRegisterManager sharedInstance];
    registerManager.delegate = self;
    [registerManager registerWithUID:uid];
}

- (void)didRegisterResponse:(NSDictionary *)response {
    NSInteger statusCode = [response[@"code"] integerValue];
    if (statusCode == 200 || statusCode == 409) {//当注册成功或者这个号码在别的手机上注册过
        BTTVoiceCallViewController *vc = (BTTVoiceCallViewController *)[BTTVoiceCallViewController getVCFromStoryboard];
        [self.navigationController pushViewController:vc animated:NO];
    } else {
        NSLog(@"VOIP注册失败");
        [BTTProgressHUD showOnlyText:@"拨号失败请重试" toView:[UIApplication sharedApplication].delegate.window];
    }
}



#pragma mark - 动态添加属性

- (void)setHeaderView:(BTTHomePageHeaderView *)headerView {
    objc_setAssociatedObject(self, &BTTHeaderViewKey, headerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BTTHomePageHeaderView *)headerView {
    return objc_getAssociatedObject(self, &BTTHeaderViewKey);
}


@end
