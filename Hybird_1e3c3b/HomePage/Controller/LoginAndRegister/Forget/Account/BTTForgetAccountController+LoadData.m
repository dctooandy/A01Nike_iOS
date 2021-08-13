//
//  BTTForgetAccountController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/12/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTForgetAccountController+LoadData.h"
#import "BTTMeMainModel.h"

@implementation BTTForgetAccountController (LoadData)

-(void)checkCustomerBySmsCode:(NSString *)code {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"smsCode"] = code;
    params[@"messageId"] = self.messageId;
    params[@"use"] = @11;
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTCheckCustomerBySmsCode paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

-(void)sendCodeByPhone:(NSString *)phone {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"mobileNo"] = [IVRsaEncryptWrapper encryptorString:phone];
    params[@"use"] = @11;
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTSendMsgCode paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"验证码已发送, 请注意查收" toView:nil];
            [[self getForgetPhoneCell] countDown:60];
            self.messageId = result.body[@"messageId"];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

-(void)loadMainData {
    NSString * str = @"";
    NSString * strPlacehold = @"";
    if (self.findType == BTTFindWithPhone) {
        str = @"ic_forget_phone_logo";
        strPlacehold = @"请输入您的手机号";
    } else if (self.findType == BTTFindWithEmail) {
        str = @"ic_forget_email_logo";
        strPlacehold = @"请输入您的邮箱地址";
    }
    NSArray *iconNames = @[str,@"ic_forget_captcha_logo"];
    NSArray *placeholds = @[strPlacehold,@"请输入验证码"];
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
