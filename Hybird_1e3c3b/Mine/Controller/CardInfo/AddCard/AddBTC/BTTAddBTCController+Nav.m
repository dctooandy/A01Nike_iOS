//
//  BTTAddBTCController+Nav.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/11/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTAddBTCController+Nav.h"
#import "BTTAddBTCController+LoadData.h"
#import "BTTMakeCallLoginView.h"
#import "BTTMakeCallNoLoginView.h"
#import "BTTMakeCallSuccessView.h"
#import "BTTCantBindCardPopView.h"

@implementation BTTAddBTCController (Nav)

-(void)showCantBindCardPopView {
    BTTCantBindCardPopView *customView = [BTTCantBindCardPopView viewFromXib];
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
        [popView dismiss];
        if (btn.tag == 0) {
            [LiveChat startKeFu:strongSelf];
//            [CSVisitChatmanager startWithSuperVC:strongSelf finish:^(CSServiceCode errCode) {
//                if (errCode != CSServiceCode_Request_Suc) {
//                    [MBProgressHUD showErrorWithTime:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持" toView:nil duration:3];
//                } else {
//
//                }
//            }];
        } else if (btn.tag == 1) {
            [strongSelf showCallBackViewLogin];
        }
    };
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
            [self showCallBackViewNoLogin:BTTAnimationPopStyleNO];
        } else if (btn.tag == 50012) {
            [LiveChat startKeFu:strongSelf];
//            [CSVisitChatmanager startWithSuperVC:strongSelf finish:^(CSServiceCode errCode) {
//                if (errCode != CSServiceCode_Request_Suc) {
//                    [MBProgressHUD showErrorWithTime:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持" toView:nil duration:3];
//                } else {
//
//                }
//            }];
        }
    };
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

- (void)showCallBackSuccessView {
    BTTMakeCallSuccessView *customView = [BTTMakeCallSuccessView viewFromXib];
    customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    customView.dismissBlock = ^{
        [popView dismiss];
    };
    customView.btnBlock = ^(UIButton *btn) {
        [popView dismiss];
    };
}
@end
