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
#import "BTTLoginOrRegisterViewController.h"
#import "BTTMakeCallNoLoginView.h"
#import "BTTHomePageViewController+LoadData.h"
#import "BTTMakeCallLoginView.h"
#import "BTTLuckyWheelCoinView.h"
#import "BTTBannerModel.h"
#import "BTTPromotionDetailController.h"
#import "BTTAGQJViewController.h"
#import "BTTAGGJViewController.h"


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
                if (![IVNetwork userInfo]) {
                    [MBProgressHUD showError:@"请先登录" toView:nil];
                    BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                    return;
                }
                BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
                vc.webConfigModel.newView = YES;
                vc.webConfigModel.url = @"customer/letter.htm";
                vc.webConfigModel.theme = @"inside";
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            case 2003:
            {
                BTTLoginOrRegisterViewController *loginAndRegister = [[BTTLoginOrRegisterViewController alloc] init];
                loginAndRegister.registerOrLoginType = BTTRegisterOrLoginTypeLogin;
                [strongSelf.navigationController pushViewController:loginAndRegister animated:YES];
            }
                break;
                
            case 2004:
            {
                BTTLoginOrRegisterViewController *loginAndRegister = [[BTTLoginOrRegisterViewController alloc] init];
                loginAndRegister.registerOrLoginType = BTTRegisterOrLoginTypeRegisterNormal;
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
                [MBProgressHUD showError:@"拨号失败请重试" toView:nil];
            } else {
                strongSelf(strongSelf);
                [strongSelf registerUID:uid];
            }
        }];
    }];
    
    BOOL isNormalUser = (![IVNetwork userInfo] || [IVNetwork userInfo].customerLevel < 5);
    NSString *callTitle = isNormalUser ? @"电话回拨" : @"VIP经理回拨";
    BTTPopoverAction *action3 = [BTTPopoverAction actionWithImage:ImageNamed(@"callBack") title:callTitle handler:^(BTTPopoverAction *action) {
        if ([IVNetwork userInfo]) {
            [self showCallBackViewLogin];
        } else {
            [self showCallBackViewNoLogin:BTTAnimationPopStyleScale];
        }
    }];
    
    BTTPopoverAction *action4 = [BTTPopoverAction actionWithImage:ImageNamed(@"onlineVoice") title:@"语音聊天" handler:^(BTTPopoverAction *action) {
        [[CLive800Manager sharedInstance] startLive800Chat:self];
    }];
    
    NSString *telUrl = isNormalUser ? @"tel://4001203618" : @"tel://4001203616";
    NSString *title = isNormalUser ? @"400-120-3618" : @"400-120-3616";
    title = [NSString stringWithFormat:@"     客服热线\n%@",title];
    BTTPopoverAction *action5 = [BTTPopoverAction actionWithTitle:title detailTitle:title handler:^(BTTPopoverAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
    }];
    BTTPopoverView *popView = [BTTPopoverView PopoverView];
    popView.style = BTTPopoverViewStyleDark;
    popView.arrowStyle = BTTPopoverViewArrowStyleTriangle;
    popView.showShade = YES;
    [popView showToPoint:CGPointMake(SCREEN_WIDTH - 27, KIsiPhoneX ? 88 : 64) withActions:@[action1,action2,action3,action4,action5]];
    
}

- (void)showCallBackViewNoLogin:(BTTAnimationPopStyle)animationPopStyle {
    BTTMakeCallNoLoginView *customView = [BTTMakeCallNoLoginView viewFromXib];
    customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:animationPopStyle dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    customView.dismissBlock = ^{
        [popView dismiss];
    };
    weakSelf(weakSelf);
    customView.callBackBlock = ^(NSString *phone) {
        strongSelf(strongSelf);
        [popView dismiss];
        [strongSelf makeCallWithPhoneNum:phone];
    } ;
}

- (void)showCallBackViewLogin {
    BTTMakeCallLoginView *customView = [BTTMakeCallLoginView viewFromXib];
    customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleScale dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    weakSelf(weakSelf);
    customView.dismissBlock = ^{
        [popView dismiss];
    };
    customView.btnBlock = ^(UIButton *btn) {
        strongSelf(strongSelf);
        if (btn.tag == 50010) {
            if (![IVNetwork userInfo].phone.length) {
                [MBProgressHUD showError:@"您未绑定手机, 请选择其他电话" toView:nil];
                return;
            }
            [popView dismiss];
            [strongSelf makeCallWithPhoneNum:[IVNetwork userInfo].phone];
        } else {
            [popView dismiss];
            [self showCallBackViewNoLogin:BTTAnimationPopStyleNO];
        }
        
    };
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
        [MBProgressHUD showError:@"拨号失败请重试" toView:nil];
    }
}

- (void)showPopView {
    BTTLuckyWheelCoinView *customView = [BTTLuckyWheelCoinView viewFromXib];
    customView.frame = CGRectMake(0, 0, 313, 255);
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    customView.dismissBlock = ^{
        [popView dismiss];
    };
    weakSelf(weakSelf);
    customView.btnBlock = ^(UIButton *btn) {
        strongSelf(strongSelf);
        [strongSelf loadLuckyWheelCoinChange];
    };
}

- (void)bannerToGame:(BTTBannerModel *)model {
    if ([model.action.detail hasSuffix:@".htm"] ) {
        BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
        vc.webConfigModel.url = model.action.detail;
        vc.webConfigModel.newView = YES;
        vc.webConfigModel.theme = @"outside";
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSArray *arr = [model.action.detail componentsSeparatedByString:@":"];
        NSString *gameid = arr[2];
        NSLog(@"%@",gameid);
        UIViewController *vc = nil;
        if ([gameid isEqualToString:@"A01003"]) {
            vc = [BTTAGQJViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([gameid isEqualToString:@"A01026"]) {
            vc = [BTTAGGJViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            IVGameModel *model = [[IVGameModel alloc] init];
            model.cnName =  kFishCnName;
            model.enName =  kFishEnName;
            model.provider = kAGINProvider;
            model.gameId = model.gameCode;
            model.gameType = kFishType;
            [[IVGameManager sharedManager] forwardToGameWithModel:model controller:self];
        }
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
