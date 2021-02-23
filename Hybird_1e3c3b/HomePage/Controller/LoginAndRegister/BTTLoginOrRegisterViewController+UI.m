//
//  BTTLoginOrRegisterViewController+UI.m
//  Hybird_1e3c3b
//
//  Created by Domino on 13/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTLoginOrRegisterViewController+UI.h"
#import "BTTUnlockPopView.h"
#import "BTTAndroid88PopView.h"
#import "BTTRegisterCheckPopView.h"
#import "BTTCreateAPIModel.h"
#import "BTTLoginOrRegisterViewController+API.h"
#import "CLive800Manager.h"

@implementation BTTLoginOrRegisterViewController (UI)

- (void)showPopViewWithAccount:(NSString *)account {
    BTTUnlockPopView *customView = [BTTUnlockPopView viewFromXib];
    
    customView.account = account;
    customView.layer.cornerRadius = 5;
    customView.clipsToBounds = YES;
    customView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 50, 262);
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleScale dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    customView.dismissBlock = ^{
        [popView dismiss];
    };
}

- (void)showPopView {
    BTTAndroid88PopView *customView = [BTTAndroid88PopView viewFromXib];
    customView.frame = CGRectMake(0, 0, 320, 360);
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleScale dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    customView.dismissBlock = ^{
        [popView dismiss];
    };
    customView.btnBlock = ^(UIButton *btn) {
        
    };
}

- (void)showRegisterCheckViewWithModel:(BTTCreateAPIModel *)model {
    BTTRegisterCheckPopView *customView = [BTTRegisterCheckPopView viewFromXib];
    customView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 50, 310);
    __block BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleScale dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = NO;
    [popView pop];
    customView.dismissBlock = ^{
        [popView dismiss];
    };
    weakSelf(weakSelf);
    customView.btnBlock = ^(UIButton *btn) {
        strongSelf(strongSelf);
        [popView dismiss];
        if (btn.tag == 1001) {
            [[CLive800Manager sharedInstance] startLive800Chat:strongSelf];
        } else if (btn.tag == 1002) {
            [strongSelf MobileNoAndCodeRegisterAPIModel:model];
        }
    };
}

-(void)showAlert:(NSDictionary *)resultDic model:(BTTLoginAPIModel *)model isBack:(BOOL)isback {
    self.differentLocPopView = [BTTDifferentLocPopView viewFromXib];
    self.differentLocPopView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    NSString * countDownStr = resultDic[@"expire"];
    [self.differentLocPopView countDown:[countDownStr integerValue]];
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:self.differentLocPopView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    weakSelf(weakSelf);
    self.differentLocPopView.dismissBlock = ^{
        [weakSelf.pressLocationArr removeAllObjects];
        [weakSelf checkChineseCaptchaAgain];
        [weakSelf hideLoading];
        [popView dismiss];
    };
    self.differentLocPopView.sendCodeBtnAction = ^{
        [weakSelf sendSmsCodeAgain:model.login_name model:model isBack:isback show:false];
    };
    self.differentLocPopView.confirmBtnBlock = ^(NSString * _Nonnull str) {
        NSString * inputeStr = str;
        [weakSelf loginWith2FA:resultDic smsCode:inputeStr model:model isBack:isback];
        [popView dismiss];
    };
}

@end
