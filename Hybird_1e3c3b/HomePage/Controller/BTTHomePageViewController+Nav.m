//
//  BTTHomePageViewController+Nav.m
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/17.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTHomePageViewController+Nav.h"
#import <objc/runtime.h>
#import "BTTPopoverView.h"
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
#import "BTTNewAccountGuidePopView.h"
#import "UIImage+GIF.h"
#import <IVCacheLibrary/IVCacheWrapper.h>
#import "BTTActionSheet.h"
#import "BTTBiBiCunPopView.h"
#import "AppDelegate.h"
#import "BTTYueFenHongPopView.h"
#import "BTTDragonBoatPopView.h"

static const char *BTTHeaderViewKey = "headerView";

static const char *BTTLoginAndRegisterKey = "lgoinOrRegisterBtnsView";

@implementation BTTHomePageViewController (Nav)

-(void)setUpAssistiveButton {
    UIImage * image = [UIImage imageNamed:@"ic_918_assistive_btn_bg"];
    CGFloat assistiveBtnHeight = image.size.height + [UIImage imageNamed:@"ic_918_assistive_close_btn"].size.height;
    CGFloat loginBtnViewHeight = 87;
    CGFloat postionY = SCREEN_HEIGHT - kTabbarHeight - assistiveBtnHeight/2 - loginBtnViewHeight;
    self.assistiveButton = [[AssistiveButton alloc] initMainBtnWithBackgroundImage:image highlightImage:nil position:CGPointMake(SCREEN_WIDTH - image.size.width/2 - 10, postionY)];
    //主按鈕可移動或不可移動
    self.assistiveButton.positionMode = SpreadPositionModeTouchBorder;
    weakSelf(weakSelf);
    [self.assistiveButton setMainButtonClickActionBlock:^{
        weakSelf.assistiveButton.hidden = true;
        BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
        vc.webConfigModel.url = @"/activity_pages/ag_crads918";
        vc.webConfigModel.newView = YES;
        vc.webConfigModel.theme = @"outside";
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.assistiveButton setCloseBtnActionBlock:^{
        [weakSelf.assistiveButton removeFromSuperview];
    }];
}

-(void)showAssistiveButton {
    if (self.assistiveButton.hidden) {
        self.assistiveButton.hidden = false;
    }
}

- (void)setupFloatWindow {
//    UIImageView *floatWindow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 61, SCREEN_HEIGHT / 2 + 120, 68.8, 66)];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"qhb" ofType:@"gif"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    UIImage *image = [UIImage sd_animatedGIFWithData:data];
//    [floatWindow sd_setImageWithURL:nil placeholderImage:image];
//    [self.view addSubview:floatWindow];
//    floatWindow.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//    [floatWindow addGestureRecognizer:tap];
}

- (void)tapAction {
//    monthly_activity.htm
    BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
    vc.webConfigModel.url = @"monthly_activity.htm";
    vc.webConfigModel.newView = YES;
    vc.webConfigModel.theme = @"outside";
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess:) name:LogoutSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(versionUpdate:) name:IVCheckUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSuccessGotoHomePageNotification:) name:BTTRegisterSuccessGotoHomePageNotification object:nil];
}

- (void)registerSuccessGotoHomePageNotification:(NSNotification *)notif {
    if ([notif.object isEqualToString:@"gotoOnlineChat"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [LiveChat startKeFu:self csServicecompleteBlock:^(CSServiceCode errCode) {
                if (errCode != CSServiceCode_Request_Suc) {//异常处理
                    [[CLive800Manager sharedInstance] startLive800Chat:self];
                }
            }];
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
    [CNTimeLog setUserName:[IVNetwork savedUserInfo].loginName];
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self updateUI];
        self.loginAndRegisterBtnsView.hidden = YES;
        [[IVGameManager sharedManager] reloadCacheGame];
    });
}

- (void)showNewAccountGrideView {
    BTTNewAccountGuidePopView *customView = [BTTNewAccountGuidePopView viewFromXib];
    customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    customView.dismissBlock = ^{
        [popView dismiss];
    };
}

-(void)showBiBiCunPopView:(NSString *)contentStr {
    BTTBiBiCunPopView *customView = [BTTBiBiCunPopView viewFromXib];
    customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    customView.contentStr = contentStr;
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    customView.dismissBlock = ^{
        [popView dismiss];
    };
    customView.btnBlock = ^(UIButton * _Nullable btn) {
        AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate jumpToTabIndex:BTTMine];
        [popView dismiss];
    };
}

//月分紅
- (void)showYueFenHong:(BTTYenFenHongModel *)model {
    BTTYueFenHongPopView * customView = [BTTYueFenHongPopView viewFromXib];
    customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    customView.model = model;
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    customView.dismissBlock = ^{
        [popView dismiss];
    };
    
    customView.btnBlock = ^(UIButton * _Nullable btn) {
        [popView dismiss];
        BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
        vc.title = @"博天堂股东 分红月月领～第二季";
        vc.webConfigModel.url = @"/activity_pages/withdraw_gift";
        vc.webConfigModel.newView = YES;
        [self.navigationController pushViewController:vc animated:YES];
    };
}

//龍舟
- (void)showDragonBoat {
    
    BTTDragonBoatPopView * customView = [BTTDragonBoatPopView viewFromXib];
    customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    customView.dismissBlock = ^{
        [popView dismiss];
    };

    customView.btnBlock = ^(UIButton * _Nullable btn) {
        [popView dismiss];
        BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
        vc.title = @"迎端午 赛龙舟 领奖券 300万热力回馈";
        vc.webConfigModel.url = @"/activity_pages/lantern-fest";
        vc.webConfigModel.newView = YES;
        [self.navigationController pushViewController:vc animated:YES];
    };
   
}
- (void)logoutSuccess:(NSNotification *)notifi {
    self.isLogin = NO;
    self.isVIP = NO;
    [CNTimeLog setUserName:nil];
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
    self.loginAndRegisterBtnsView.hidden = [IVNetwork savedUserInfo] ? YES : NO;
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
                if (![IVNetwork savedUserInfo]) {
                    [MBProgressHUD showError:@"请先登录" toView:nil];
                    BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                    return;
                }
                //站內信
                BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
                vc.webConfigModel.newView = YES;
                vc.webConfigModel.url = @"mailApp?type=mail/inbox";
                vc.webConfigModel.theme = @"outside";
                vc.title = @"站內信";
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
    
    BTTPopoverAction *action1 = [BTTPopoverAction actionWithImage:ImageNamed(@"onlineService") title:@"在线客服      " handler:^(BTTPopoverAction *action) {
        [LiveChat startKeFu:self csServicecompleteBlock:^(CSServiceCode errCode) {
            if (errCode != CSServiceCode_Request_Suc) {//异常处理
                BTTActionSheet *actionSheet = [[BTTActionSheet alloc] initWithTitle:@"请选择问题类型" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"存款问题",@"其他问题"] actionSheetBlock:^(NSInteger buttonIndex) {
                    if (buttonIndex == 0) {
                        [[CLive800Manager sharedInstance] startLive800ChatSaveMoney:self];
                    }else if (buttonIndex == 1){
                        [[CLive800Manager sharedInstance] startLive800Chat:self];
                    }
                }];
                [actionSheet show];
            }
        }];
    }];
    
    BTTPopoverAction *action2 = [BTTPopoverAction actionWithImage:ImageNamed(@"voiceCall") title:@"APP语音通信" handler:^(BTTPopoverAction *action) {
        BTTTabbarController *tabbar = (BTTTabbarController *)self.tabBarController;
        BOOL isLogin = [IVNetwork savedUserInfo] ? YES : NO;
        weakSelf(weakSelf);
        [MBProgressHUD showLoadingSingleInView:tabbar.view animated:YES];
        [tabbar loadVoiceCallNumWithIsLogin:isLogin makeCall:^(NSString *uid) {
            [MBProgressHUD hideHUDForView:tabbar.view animated:YES];
            if (uid == nil || uid.length == 0) {
                [MBProgressHUD showError:@"拨号失败请重试" toView:nil];
            } else {
                strongSelf(strongSelf);
                [strongSelf registerUID:uid];
            }
        }];
    }];
    
    int currentHour = [PublicMethod hour:[NSDate date]];
    BOOL isNormalUser = (![IVNetwork savedUserInfo] || [IVNetwork savedUserInfo].starLevel < 5 || ((currentHour >= 0 && currentHour < 12) || (currentHour > 21 && currentHour <= 23)));
    NSString *callTitle = isNormalUser ? @"电话回拨" : @"VIP经理回拨";
    BTTPopoverAction *action3 = [BTTPopoverAction actionWithImage:ImageNamed(@"callBack") title:callTitle handler:^(BTTPopoverAction *action) {
        if ([IVNetwork savedUserInfo]) {
            [self showCallBackViewLogin];
        } else {
            [self showCallBackViewNoLogin:BTTAnimationPopStyleScale];
        }
    }];
    
//    BTTPopoverAction *action4 = [BTTPopoverAction actionWithImage:ImageNamed(@"onlineVoice") title:@"语音聊天" handler:^(BTTPopoverAction *action) {
//        [[CLive800Manager sharedInstance] startLive800Chat:self];
//    }];
    
    
    NSString *phoneValue = [IVCacheWrapper objectForKey:@"APP_400_HOTLINE"];
    NSString *normalPhone = nil;
    NSString *vipPhone = nil;
    if (phoneValue.length) {
        NSArray *phonesArr = [phoneValue componentsSeparatedByString:@";"];
        normalPhone = phonesArr[0];
        vipPhone = phonesArr[1];
    }
    if (!normalPhone.length) {
        normalPhone = @"400-120-3611";
    }
    if (!vipPhone.length) {
        vipPhone = @"400-120-3612";
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
//    [popView showToPoint:CGPointMake(SCREEN_WIDTH - 27, KIsiPhoneX ? 88 : 64) withActions:@[action1,action2,action3,action5]];
    [popView showToPoint:CGPointMake(SCREEN_WIDTH - 27, KIsiPhoneX ? 88 : 64) withActions:@[action1,action3,action5]];
    
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
    customView.callBackBlock = ^(NSString *phone,NSString *captcha,NSString *captchaId) {
        strongSelf(strongSelf);
        [popView dismiss];
        [strongSelf makeCallWithPhoneNum:phone captcha:captcha captchaId:captchaId];
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
    customView.callBackBlock = ^(NSString * _Nullable phone, NSString * _Nullable captcha, NSString * _Nullable captchaId) {
        strongSelf(strongSelf);
        if (![IVNetwork savedUserInfo].mobileNo.length) {
            [MBProgressHUD showError:@"您未绑定手机, 请选择其他电话" toView:nil];
            return;
        }
        [popView dismiss];
        [strongSelf makeCallWithPhoneNum:[IVNetwork savedUserInfo].mobileNo captcha:captcha captchaId:captchaId];
    };
    customView.btnBlock = ^(UIButton *btn) {
        [popView dismiss];
        [self showCallBackViewNoLogin:BTTAnimationPopStyleNO];
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
        [strongSelf loadLuckyWheelCoinChangeWithAmount:num];
    };
}

- (void)bannerToGame:(BTTBannerModel *)model {
    if ([model.action.type isEqualToString:@"1"] ) {
        BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
        vc.title = model.title;
        vc.webConfigModel.url = [model.action.detail stringByReplacingOccurrencesOfString:@" " withString:@""];
        vc.webConfigModel.newView = YES;
        vc.webConfigModel.theme = @"outside";
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSRange gameIdRange = [model.action.detail rangeOfString:@"gameId"];
        if (gameIdRange.location != NSNotFound) {
            NSArray *arr = [model.action.detail componentsSeparatedByString:@":"];
            NSString *gameid = arr[1];
            if ([gameid isEqualToString:BTTAGQJKEY]) {
                if ([IVNetwork savedUserInfo]) {
                    BTTAGQJViewController *vc = [BTTAGQJViewController new];
                    vc.platformLine = [IVNetwork savedUserInfo].uiMode;
                    [CNTimeLog startRecordTime:CNEventAGQJLaunch];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    [self showTryAlertViewWithBlock:^(UIButton * _Nonnull btn) {
                        if (btn.tag == 1090) {
                            BTTAGQJViewController *vc = [BTTAGQJViewController new];
                            vc.platformLine = @"CNY";
                            [CNTimeLog startRecordTime:CNEventAGQJLaunch];
                            [self.navigationController pushViewController:vc animated:YES];
                        } else {
                            [MBProgressHUD showError:@"请先登录" toView:nil];
                            BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }];
                }
            } else if ([gameid isEqualToString:BTTAGGJKEY]) {
                BTTAGGJViewController *vc = [BTTAGGJViewController new];
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
                    [CNTimeLog startRecordTime:CNEventAGQJLaunch];
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
