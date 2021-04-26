//
//  BTTMineViewController+Nav.m
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/18.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTMineViewController+Nav.h"
#import "BTTPopoverView.h"
#import "BTTLive800ViewController.h"
#import "CLive800Manager.h"
#import "BTTTabbarController+VoiceCall.h"
#import "BTTVoiceCallViewController.h"
#import "BTTLoginOrRegisterViewController.h"
#import "BTTMakeCallNoLoginView.h"
#import "BTTMakeCallLoginView.h"
#import "BTTMineViewController+LoadData.h"
#import "BTTCardInfosController.h"
#import "BTTShareNoticeView.h"
#import "BTTPromotionDetailController.h"
#import "BTTActionSheet.h"
#import "BTTShowErcodePopview.h"
#import "BTTWithdrawalController.h"
#import "BTTCustomerReportController.h"

static const char *BTTHeaderViewKey = "headerView";


@implementation BTTMineViewController (Nav)


- (void)showShareNoticeView {
    BTTShareNoticeView *customView = [BTTShareNoticeView viewFromXib];
    customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    customView.dismissBlock = ^{
        [popView dismiss];
    };
    weakSelf(weakSelf);
    customView.btnBlock = ^(UIButton * _Nullable btn) {
        [popView dismiss];
        strongSelf(strongSelf);
        BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
        vc.webConfigModel.url = [NSString stringWithFormat:@"%@activity_pages/recommendFriends",[IVNetwork h5Domain]];
        vc.webConfigModel.newView = YES;
        vc.webConfigModel.theme = @"outside";
        [strongSelf.navigationController pushViewController:vc animated:YES];
    };
}

- (void)showShareActionSheet {
    NSArray *names = @[@"复制链接",@"保存到相册",@"查看二维码"];
    NSArray *icons = @[@"me_shareCopy",@"me_shareDownload",@"me_shareCode"];
    BTTActionSheet *actionSheet = [[BTTActionSheet alloc] initWithShareHeadOprationWith:names andImageArry:icons andProTitle:@"" and:ShowTypeIsShareStyle];
    weakSelf(weakSelf);
    [actionSheet setBtnClick:^(NSInteger btnTag) {
        strongSelf(strongSelf);
        if (btnTag == 0) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.redirectModel.domainName.length ? [NSString stringWithFormat:@"%@%@",self.redirectModel.redirectUrl, self.redirectModel.domainName] : [NSString stringWithFormat:@"%@%@",self.redirectModel.redirectUrl, [IVNetwork h5Domain]];
            [MBProgressHUD showSuccess:@"已复制" toView:strongSelf.view];
        } else if (btnTag == 1) {
            NSString *urlStr = self.redirectModel.domainName.length ? [NSString stringWithFormat:@"%@%@",self.redirectModel.redirectUrl, self.redirectModel.domainName] : [NSString stringWithFormat:@"%@%@",self.redirectModel.redirectUrl, [IVNetwork h5Domain]];
            UIImage *image = [PublicMethod QRCodeMethod:urlStr];
            UIImageWriteToSavedPhotosAlbum(image, strongSelf, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        } else if (btnTag == 2) {
            [strongSelf showErcodePopView];
        }
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:actionSheet];
}

- (void)showErcodePopView {
    BTTShowErcodePopview *customView = [BTTShowErcodePopview viewFromXib];
    NSString *urlStr = self.redirectModel.domainName.length ? [NSString stringWithFormat:@"%@%@",self.redirectModel.redirectUrl, self.redirectModel.domainName] : [NSString stringWithFormat:@"%@%@",self.redirectModel.redirectUrl, [IVNetwork h5Domain]];
    customView.iconImageView.image = [PublicMethod QRCodeMethod:urlStr];
    customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    customView.dismissBlock = ^{
        [popView dismiss];
    };
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"已下载到本地相册" ;
    }
    [MBProgressHUD showSuccess:msg toView:self.view];
}


- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess:) name:LogoutSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(versionUpdate:) name:IVCheckUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMoneyTimes:) name:BTTSaveMoneyTimesNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoCardInfo:) name:@"gotoCardInfoNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoTakeMoney) name:@"gotoTakeMoneyNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoCustomerReport) name:@"gotoCustomerReportNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMode) name:@"changeModeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeModeEnterGame) name:@"changeModeEnterGameNotification" object:nil];
}

- (void)saveMoneyTimes:(NSNotification *)notifi {
    [self loadPaymentData];
}

- (void)versionUpdate:(NSNotification *)notifi {
    NSLog(@"%@",notifi.userInfo);
}

- (void)loginSuccess:(NSNotification *)notifi {
    [self setupElements];
}

- (void)logoutSuccess:(NSNotification *)notifi {
    
    
}

- (void)gotoCardInfo:(NSNotification *)notifi {
    NSDictionary * dic = notifi.object;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BTTCardInfosController *vc = [[BTTCardInfosController alloc] init];
        vc.showAlert = [[dic objectForKey:@"showAlert"] boolValue];
        vc.showToast = [[dic objectForKey:@"showToast"] boolValue];
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (void)gotoTakeMoney {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BTTWithdrawalController *vc = [[BTTWithdrawalController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    });
}

-(void)gotoCustomerReport {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BTTCustomerReportController * vc = [[BTTCustomerReportController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    });
}

-(void)changeMode {
    for (NSString * str in [IVNetwork savedUserInfo].uiModeOptions) {
        if (![str isEqualToString:[IVNetwork savedUserInfo].uiMode]) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:false];
            [self changeMode:str isInGame:false];
            break;
        }
    }
}

-(void)changeModeEnterGame {
    for (NSString * str in [IVNetwork savedUserInfo].uiModeOptions) {
        if (![str isEqualToString:[IVNetwork savedUserInfo].uiMode]) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:false];
            [self changeMode:str isInGame:true];
            break;
        }
    }
}

- (void)setupNav {
    [self.navigationController setNavigationBarHidden:YES];
    self.headerView = [[BTTHomePageHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BTTNavHeightLogin ) withNavType:BTTNavTypeMine];
    self.headerView.titleLabel.text = @"会员中心";
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
//                if (![IVNetwork savedUserInfo]) {
//                    [MBProgressHUD showError:@"请先登录" toView:nil];
//                    BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
//                    [strongSelf.navigationController pushViewController:vc animated:YES];
//                    return;
//                }
                [strongSelf showShareActionSheet];
            }
                break;
                
            default:
                break;
        }
    };
}

- (void)buttonClick:(UIButton *)button {
    
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


#pragma mark - 动态添加属性

- (void)setHeaderView:(BTTHomePageHeaderView *)headerView {
    objc_setAssociatedObject(self, &BTTHeaderViewKey, headerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BTTHomePageHeaderView *)headerView {
    return objc_getAssociatedObject(self, &BTTHeaderViewKey);
}



@end
