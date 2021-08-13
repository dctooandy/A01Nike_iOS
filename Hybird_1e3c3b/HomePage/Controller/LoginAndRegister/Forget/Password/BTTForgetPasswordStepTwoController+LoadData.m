//
//  BTTForgetPasswordStepTwoController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by Domino on 15/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTForgetPasswordStepTwoController+LoadData.h"
#import "BTTMeMainModel.h"

@implementation BTTForgetPasswordStepTwoController (LoadData)

- (void)sendVerifyCodeWithAccount:(NSString *)account {
    if (!account.length) {
        return;
    }
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[BTTLoginName] = account;
    params[@"use"] = @4;
    params[@"validateId"] = self.validateId;
    NSString * url = self.findType == BTTFindWithPhone ? BTTStepOneSendCode:BTTEmailSendCodeLoginName;
    [self showLoading];
    [IVNetwork requestPostWithUrl:url paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"验证码已发送, 请注意查收" toView:nil];
            [[self getForgetPhoneCell] countDown:60];
            self.messageId = result.body[@"messageId"];
        }else{
            [MBProgressHUD showSuccess:result.head.errMsg toView:self.view];
        }
    }];
}

- (void)verifyCode:(NSString *)code account:(NSString *)account completeBlock:(KYHTTPCallBack)completeBlock {
    if (!code.length || !account.length) {
        return;
    }
    NSString * url = @"";
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[BTTLoginName] = account;
    if (self.findType == BTTFindWithPhone) {
        url = BTTVerifySmsCode;
        params[@"smsCode"] = code;
    } else if (self.findType == BTTFindWithEmail) {
        url = BTTEmailCodeVerify;
        params[@"emailCode"] = code;
    }
    params[@"messageId"] = self.messageId;
    params[@"use"] = @4;
     
    [IVNetwork requestPostWithUrl:url paramters:params completionBlock:completeBlock];
}

- (void)loadMainData {
    NSArray *iconNames = @[@"ic_forget_captcha_logo"];
    NSArray *placeholds = @[@"请输入验证码"];
    for (NSString *name in iconNames) {
        NSInteger index = [iconNames indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = placeholds[index];
        model.iconName = iconNames[index];
        [self.mainData addObject:model];
    }
    [self setupElements];
}

- (void)setMainData:(NSMutableArray *)mainData {
    objc_setAssociatedObject(self, @selector(mainData), mainData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)mainData {
    NSMutableArray *mainData = objc_getAssociatedObject(self, _cmd);
    if (!mainData) {
        mainData = [NSMutableArray array];
        [self setMainData:mainData];
    }
    return mainData;
}

@end
