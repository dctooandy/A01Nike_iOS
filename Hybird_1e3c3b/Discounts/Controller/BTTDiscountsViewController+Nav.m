//
//  BTTDiscountsViewController+Nav.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 9/6/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTDiscountsViewController+Nav.h"
#import "BTTDiscountsViewController+LoadData.h"
#import "BTTLoginOrRegisterViewController.h"

#import "BTTActionSheet.h"
#import "BTTPopoverView.h"
#import "BTTMakeCallNoLoginView.h"
#import "BTTMakeCallLoginView.h"

@implementation BTTDiscountsViewController (Nav)

-(void)setUpHistoryNav {
    [self.navigationController setNavigationBarHidden:false];
    self.nav.hidden = true;
    self.inProgressView.hidden = true;
    self.yearsScrollView.hidden = false;
    self.title = @"历史优惠";
    UIButton * leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 54, 44);
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yearsScrollView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
        make.width.offset(SCREEN_WIDTH);
    }];
}

-(void)backAction {
    [self.navigationController setNavigationBarHidden:YES];
    self.nav.hidden = false;
    self.inProgressView.hidden = false;
    self.yearsScrollView.hidden = true;
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inProgressView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
        make.width.offset(SCREEN_WIDTH);
    }];
    [self.sheetDatas removeAllObjects];
    for (BTTPromotionProcessModel *item in self.model.process) {
        [self.sheetDatas addObject:item];
    }
    [self setupElements];
}

- (void)setupNav {
    [self.navigationController setNavigationBarHidden:YES];
    self.nav = [[BTTHomePageHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KIsiPhoneX ? 88 : 64) withNavType:BTTNavTypeDiscount];
    self.nav.titleLabel.text = @"优惠";
    [self.view addSubview:self.nav];
    weakSelf(weakSelf);
    self.nav.btnClickBlock = ^(UIButton *button) {
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
                
            default:
                break;
        }
    };
}

- (void)rightClick:(UIButton *)btn {
    
    BTTPopoverAction *action1 = [BTTPopoverAction actionWithImage:ImageNamed(@"onlineService") title:@"在线客服      " handler:^(BTTPopoverAction *action) {
        [CSVisitChatmanager startWithSuperVC:self finish:^(CSServiceCode errCode) {
            if (errCode != CSServiceCode_Request_Suc) {
                [MBProgressHUD showErrorWithTime:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持" toView:nil duration:3];
            } else {

            }
        }];
    }];
    
//    BTTPopoverAction *action2 = [BTTPopoverAction actionWithImage:ImageNamed(@"voiceCall") title:@"APP语音通信" handler:^(BTTPopoverAction *action) {
//        BTTTabbarController *tabbar = (BTTTabbarController *)self.tabBarController;
//        BOOL isLogin = [IVNetwork savedUserInfo] ? YES : NO;
//        weakSelf(weakSelf);
//        [MBProgressHUD showLoadingSingleInView:tabbar.view animated:YES];
//        [tabbar loadVoiceCallNumWithIsLogin:isLogin makeCall:^(NSString *uid) {
//            [MBProgressHUD hideHUDForView:tabbar.view animated:YES];
//            if (uid == nil || uid.length == 0) {
//                [MBProgressHUD showError:@"拨号失败请重试" toView:nil];
//            } else {
//                strongSelf(strongSelf);
//                [strongSelf registerUID:uid];
//            }
//        }];
//    }];
    
    BOOL isVipUser = [PublicMethod isVipUser];
    NSString *callTitle = isVipUser ? @"VIP经理回拨":@"电话回拨";
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
    NSString *telUrl = isVipUser ? [NSString stringWithFormat:@"tel://%@",vipPhone]:[NSString stringWithFormat:@"tel://%@",normalPhone];
        NSString *title = isVipUser ? vipPhone:normalPhone;
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
        strongSelf(strongSelf);
        [popView dismiss];
        if (btn.tag == 50011) {
            [CSVisitChatmanager startWithSuperVC:strongSelf finish:^(CSServiceCode errCode) {
                if (errCode != CSServiceCode_Request_Suc) {
                    [MBProgressHUD showErrorWithTime:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持" toView:nil duration:3];
                } else {

                }
            }];
        }
    };
}

@end
