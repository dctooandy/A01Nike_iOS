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
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"系统检测到您的账号在异地登入，为了确保您的账户安全需要进行短信验证" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入短信验证码";
        [textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    }];
    self.confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertVC.textFields.firstObject;
        NSString * inputeStr = textField.text;
        [self loginWith2FA:resultDic smsCode:inputeStr model:model isBack:isback];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.pressLocationArr removeAllObjects];
        [self checkChineseCaptchaAgain];
        [self hideLoading];
    }];
    [self.confirm setEnabled:false];
    [alertVC addAction:cancel];
    [alertVC addAction:self.confirm];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)textChanged:(UITextField *)textField {
    NSString * str = textField.text;
    if (str.length != 0) {
        [self.confirm setEnabled:true];
    }
}

@end
