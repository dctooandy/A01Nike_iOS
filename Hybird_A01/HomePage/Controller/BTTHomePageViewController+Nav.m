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
#import "BTTVideoGamesListController.h"
#import "BTTLoginAccountSelectView.h"
#import "BTTJayPopView.h"


static const char *BTTHeaderViewKey = "headerView";

static const char *BTTLoginAndRegisterKey = "lgoinOrRegisterBtnsView";

@implementation BTTHomePageViewController (Nav)





- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess:) name:LogoutSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(versionUpdate:) name:IVCheckUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSuccessGotoHomePageNotification:) name:BTTRegisterSuccessGotoHomePageNotification object:nil];
}

- (void)registerSuccessGotoHomePageNotification:(NSNotification *)notif {
    if ([notif.object isEqualToString:@"gotoOnlineChat"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([IVNetwork userInfo]) {
                weakSelf(weakSelf);
                [self getLive800InfoDataWithResponse:^(NSString * _Nonnull info) {
                    strongSelf(strongSelf);
                    NSString *url = [NSString stringWithFormat:@"%@&info=%@",@"https://www.why918.com/chat/chatClient/chatbox.jsp?companyID=8990&configID=21&k=1&codeType=custom",info];
                    BTTLive800ViewController *live800 = [[BTTLive800ViewController alloc] init];
                    live800.webConfigModel.url = url;
                    live800.webConfigModel.newView = YES;
                    [strongSelf.navigationController pushViewController:live800 animated:YES];
                }];
            } else {
                NSString *url = @"https://www.why918.com/chat/chatClient/chatbox.jsp?companyID=8990&configID=21&k=1&codeType=custom";
                BTTLive800ViewController *live800 = [[BTTLive800ViewController alloc] init];
                live800.webConfigModel.url = url;
                live800.webConfigModel.newView = YES;
                [self.navigationController pushViewController:live800 animated:YES];
            }
        });
    }
}

- (void)versionUpdate:(NSNotification *)notifi {
    if ([notifi.userInfo isKindOfClass:[NSDictionary class]]) {
        if ([notifi.userInfo[@"is_remaind"] integerValue] && ![notifi.userInfo[@"is_update"] integerValue]) {
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:BTTVerisionUpdateKey];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:BTTVerisionUpdateKey];
        }
        
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:BTTVerisionUpdateKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loginSuccess:(NSNotification *)notifi {
    self.isLogin = YES;
    [IN3SAnalytics setUserName:[IVNetwork userInfo].loginName];
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self updateUI];
        self.loginAndRegisterBtnsView.hidden = YES;
        [[IVGameManager sharedManager] reloadCacheGame];
    });
}



- (void)logoutSuccess:(NSNotification *)notifi {
    self.isLogin = NO;
    self.isVIP = NO;
    [IN3SAnalytics setUserName:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self updateUI];
        self.loginAndRegisterBtnsView.hidden = NO;
        [[IVGameManager sharedManager] reloadCacheGame];
    });
}

//- (void)updateUI {
//    self.headerView.isLogin = self.isLogin;
//    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.isLogin ? BTTNavHeightLogin : BTTNavHeightNotLogin);
//    self.collectionView.frame = CGRectMake(0,  self.isLogin ? BTTNavHeightLogin : BTTNavHeightNotLogin, SCREEN_WIDTH, SCREEN_HEIGHT - (self.isLogin ? BTTNavHeightLogin : BTTNavHeightNotLogin));
//}

- (void)setupLoginAndRegisterBtnsView {
    self.loginAndRegisterBtnsView = [BTTLoginOrRegisterBtsView viewFromXib];
    self.loginAndRegisterBtnsView.hidden = [IVNetwork userInfo] ? YES : NO;
    [self.view addSubview:self.loginAndRegisterBtnsView];
    self.loginAndRegisterBtnsView.frame = CGRectMake(0, SCREEN_HEIGHT - (KIsiPhoneX ? 83 : 49) - 87, SCREEN_WIDTH, 87);
    weakSelf(weakSelf);
    self.loginAndRegisterBtnsView.btnClickBlock = ^(UIButton * _Nullable btn) {
        strongSelf(strongSelf);
        if (btn.tag == 1000) {
            BTTLoginOrRegisterViewController *loginAndRegister = [[BTTLoginOrRegisterViewController alloc] init];
            loginAndRegister.registerOrLoginType = BTTRegisterOrLoginTypeLogin;
            [strongSelf.navigationController pushViewController:loginAndRegister animated:YES];
        } else {
            BTTLoginOrRegisterViewController *loginAndRegister = [[BTTLoginOrRegisterViewController alloc] init];
            loginAndRegister.registerOrLoginType = BTTRegisterOrLoginTypeRegisterNormal;
            [strongSelf.navigationController pushViewController:loginAndRegister animated:YES];
        }
    };
}

- (void)setupNav {
    [self.navigationController setNavigationBarHidden:YES];
    self.headerView = [[BTTHomePageHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BTTNavHeightLogin) withNavType:BTTNavTypeHomePage];
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
        if ([IVNetwork userInfo]) {
            weakSelf(weakSelf);
            [self getLive800InfoDataWithResponse:^(NSString * _Nonnull info) {
                strongSelf(strongSelf);
                NSString *url = [NSString stringWithFormat:@"%@&info=%@",@"https://www.why918.com/chat/chatClient/chatbox.jsp?companyID=8990&configID=21&k=1&codeType=custom",info];
                BTTLive800ViewController *live800 = [[BTTLive800ViewController alloc] init];
                live800.webConfigModel.url = url;
                live800.webConfigModel.newView = YES;
                [strongSelf.navigationController pushViewController:live800 animated:YES];
            }];
        } else {
            NSString *url = @"https://www.why918.com/chat/chatClient/chatbox.jsp?companyID=8990&configID=21&k=1&codeType=custom";
            BTTLive800ViewController *live800 = [[BTTLive800ViewController alloc] init];
            live800.webConfigModel.url = url;
            live800.webConfigModel.newView = YES;
            [self.navigationController pushViewController:live800 animated:YES];
        }
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
    
    int currentHour = [PublicMethod hour:[NSDate date]];
    BOOL isNormalUser = (![IVNetwork userInfo] || [IVNetwork userInfo].customerLevel < 5 || ((currentHour >= 0 && currentHour < 12) || (currentHour > 21 && currentHour <= 23)));
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
    
    
    NSString *phoneValue = [IVNetwork getPublicConfigWithKey:@"APP_400_HOTLINE"];
    NSString *normalPhone = nil;
    NSString *vipPhone = nil;
    if (phoneValue.length) {
        NSArray *phonesArr = [phoneValue componentsSeparatedByString:@"|"];
        normalPhone = phonesArr[1];
        vipPhone = phonesArr[3];
    }
    if (!normalPhone.length) {
        normalPhone = @"400-120-3618";
    }
    if (!vipPhone.length) {
        vipPhone = @"400-120-3616";
    }
    NSString *telUrl = isNormalUser ? [NSString stringWithFormat:@"tel://%@",normalPhone]  : [NSString stringWithFormat:@"tel://%@",vipPhone];
    NSString *title = isNormalUser ? normalPhone : vipPhone;
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

- (void)showJay {
    
    BTTJayPopView *customView = [BTTJayPopView viewFromXib];
    customView.frame = CGRectMake(0, 0, 296, 528);
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleScale dismissStyle:BTTAnimationDismissStyleNO];
    [popView pop];
    weakSelf(weakSelf);
    customView.dismissBlock = ^{
       [popView dismiss];
    };
   
    customView.btnBlock = ^(UIButton *btn) {
       strongSelf(strongSelf);
        [popView dismiss];
        NSString *url = [NSString stringWithFormat:@"%@jays_concert_2.htm",[IVNetwork h5Domain]];
        BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
        vc.webConfigModel.url = url;
        vc.webConfigModel.newView = YES;
        vc.webConfigModel.theme = @"outside";
        [strongSelf.navigationController pushViewController:vc animated:YES];
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

- (void)showPopViewWithNum:(NSString *)num {
    BTTLuckyWheelCoinView *customView = [BTTLuckyWheelCoinView viewFromXib];
    customView.coinLabel.text = [NSString stringWithFormat:@"您还拥有%@博币!",num];
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
        [popView dismiss];
        [strongSelf loadLuckyWheelCoinChange];
    };
}

- (void)bannerToGame:(BTTBannerModel *)model {
    if ([model.action.detail hasSuffix:@".htm"] ) {
        BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
        vc.webConfigModel.url = [model.action.detail stringByReplacingOccurrencesOfString:@" " withString:@""];
        vc.webConfigModel.newView = YES;
        vc.webConfigModel.theme = @"outside";
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSRange gameIdRange = [model.action.detail rangeOfString:@"gameId"];
        if (gameIdRange.location != NSNotFound) {
            NSArray *arr = [model.action.detail componentsSeparatedByString:@":"];
            NSString *gameid = arr[1];
            UIViewController *vc = nil;
            if ([gameid isEqualToString:@"A01003"]) {
                vc = [BTTAGQJViewController new];
                [[CNTimeLog shareInstance] startRecordTime:CNEventAGQJLaunch];
                [self.navigationController pushViewController:vc animated:YES];
            } else if ([gameid isEqualToString:@"A01026"]) {
                vc = [BTTAGGJViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        NSRange andRange = [model.action.detail rangeOfString:@"&"];
        if (andRange.location != NSNotFound) {
            NSArray *andArr = [model.action.detail componentsSeparatedByString:@"&"];
            NSArray *providerArr = [andArr[0] componentsSeparatedByString:@":"];
            NSString *provider = providerArr[1];
            NSArray *gameKindArr = [andArr[1] componentsSeparatedByString:@":"];
            NSString *gameKind = gameKindArr[1];
            IVGameModel *model = [[IVGameModel alloc] init];
            if ([provider isEqualToString:@"AGIN"] && [gameKind isEqualToString:@"8"]) { // 捕鱼王
                model = [[IVGameModel alloc] init];
                model.cnName =  kFishCnName;
                model.enName =  kFishEnName;
                model.provider = kAGINProvider;
                model.gameId = model.gameCode;
                model.gameType = kFishType;
                [[IVGameManager sharedManager] forwardToGameWithModel:model controller:self];
            } else if ([provider isEqualToString:@"SHAB"] && [gameKind isEqualToString:@"1"]) { // 沙巴体育
                model = [[IVGameModel alloc] init];
                model.cnName = @"沙巴体育";
                model.enName =  kASBEnName;
                model.provider =  kShaBaProvider;
            } else if ([provider isEqualToString:@"BTI"] && [gameKind isEqualToString:@"1"]) {  // BTIi体育
                model = [[IVGameModel alloc] init];
                model.cnName = @"BTI体育";
                model.enName =  @"SBT_BTI";
                model.provider =  @"SBT";
            } else if ([provider isEqualToString:@"MG"] ||
                       [provider isEqualToString:@"AGIN"] ||
                       [provider isEqualToString:@"PT"] ||
                       [provider isEqualToString:@"TTG"] ||
                       [provider isEqualToString:@"PP"]) {
                BTTVideoGamesListController *videoGamesVC = [BTTVideoGamesListController new];
                NSString *subProvider = nil;
                if ([provider isEqualToString:@"AGIN"]) {
                    subProvider = @"AG";
                } else {
                    subProvider = provider;
                }
                videoGamesVC.provider = subProvider;
                [self.navigationController pushViewController:videoGamesVC animated:YES];
            }
        } else {
            NSRange providerRange = [model.action.detail rangeOfString:@"provider"];
            if (providerRange.location != NSNotFound) {
                NSArray *arr = [model.action.detail componentsSeparatedByString:@":"];
                NSString *provider = arr[1];
                UIViewController *vc = nil;
                if ([provider isEqualToString:@"AGQJ"]) {
                    vc = [BTTAGQJViewController new];
                    [[CNTimeLog shareInstance] startRecordTime:CNEventAGQJLaunch];
                    [self.navigationController pushViewController:vc animated:YES];
                } else if ([provider isEqualToString:@"AGIN"]) {
                    vc = [BTTAGGJViewController new];
                    [self.navigationController pushViewController:vc animated:YES];
                } else if ([provider isEqualToString:@"AS"]) {
                    IVGameModel *model = [[IVGameModel alloc] init];
                    model.cnName = @"AS真人棋牌";
                    model.enName =  kASSlotEnName;
                    model.provider = kASSlotProvider;
                }
            }
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

- (void)setLoginAndRegisterBtnsView:(BTTLoginOrRegisterBtsView *)loginAndRegisterBtnsView {
    objc_setAssociatedObject(self, &BTTLoginAndRegisterKey, loginAndRegisterBtnsView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BTTLoginOrRegisterBtsView *)loginAndRegisterBtnsView {
    return objc_getAssociatedObject(self, &BTTLoginAndRegisterKey);
}


@end
