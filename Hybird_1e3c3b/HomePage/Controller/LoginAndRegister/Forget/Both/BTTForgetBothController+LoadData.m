//
//  BTTForgetBothController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/12/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTForgetBothController+LoadData.h"
#import "BTTForgetAccountStepTwoController.h"
#import "BTTMeMainModel.h"
#import "BTTMakeCallSuccessView.h"

@implementation BTTForgetBothController (LoadData)

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
            BTTCheckCustomerModel * model = [BTTCheckCustomerModel yy_modelWithJSON:result.body];
            BTTForgetAccountStepTwoController * vc = [[BTTForgetAccountStepTwoController alloc] init];
            NSArray * newItemArr = [self filterFAccountsWithArray:model.loginNames];
            vc.itemArr = newItemArr;
            vc.forgetType = self.forgetType;
            vc.messageId = result.body[@"messageId"];
            vc.validateId = result.body[@"validateId"];
            [self.navigationController pushViewController:vc animated:true];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}
- (NSArray *)filterFAccountsWithArray:(NSArray *)array
{
    NSMutableArray * newAccounts = [array mutableCopy];
    if (array && array.count > 0) {
        for (BTTCheckCustomerItemModel * subDis in array) {
            
            if ([subDis.loginName hasPrefix:@"f"] == YES)
            {
                NSLog(@"string contains f");
                [newAccounts removeObject:subDis];
//                return [newAccounts copy];
//                break;
            }else
            {
                NSLog(@"string does not contain f");
                
            }
        }
        return newAccounts;
    }else
    {
        return @[];
    }
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

- (void)makeCallWithPhoneNum:(NSString *)phone captcha:(NSString *)captcha captchaId:(NSString *)captchaId {
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setValue:captcha forKey:@"captcha"];
    [params setValue:captchaId forKey:@"captchaId"];
    if ([phone containsString:@"*"]) {
        [params setValue:@1 forKey:@"type"];
    } else {
        [params setValue:@0 forKey:@"type"];
    }
    if ([IVNetwork savedUserInfo]) {
            [params setValue:[IVNetwork savedUserInfo].mobileNo forKey:@"mobileNo"];
            [params setValue:[IVNetwork savedUserInfo].loginName forKey:@"loginName"];
        } else {
            [params setValue:phone forKey:@"mobileNo"];
        }
    
        [IVNetwork requestPostWithUrl:BTTCallBackAPI paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
            IVJResponseObject *result = response;
            if ([result.head.errCode isEqualToString:@"0000"]) {
                [self showCallBackSuccessView];
            }else{
                NSString *errInfo = [NSString stringWithFormat:@"申请失败,%@",result.head.errMsg];
                [MBProgressHUD showError:errInfo toView:nil];
            }
        }];
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

- (void)loadMainData {
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
