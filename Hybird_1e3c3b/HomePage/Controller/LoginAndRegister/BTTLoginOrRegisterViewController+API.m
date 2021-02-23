//
//  BTTLoginOrRegisterViewController+API.m
//  Hybird_1e3c3b
//
//  Created by Domino on 14/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTLoginOrRegisterViewController+API.h"
#import "BTTLoginOrRegisterViewController+UI.h"
#import "BTTLoginCell.h"
#import "BTTLoginCodeCell.h"
#import "BTTRegisterNormalCell.h"
#import "BTTRegisterQuickAutoCell.h"
#import "BTTRegisterQuickManualCell.h"
#import "BTTRegisterSuccessController.h"
#import "BTTUserStatusManager.h"
#import "BTTLoginAccountSelectView.h"
#import "IVRsaEncryptWrapper.h"
#import "BTTNormalRegisterSuccessController.h"
#import "OneKeyPhoneController.h"
#import "IVPushManager.h"
#import "AppDelegate.h"
#import "HAInitConfig.h"
#import "IVWebViewManager.h"

static const char *confirmKey = "confirmKey";
static const char *exModelKey = "exModelKey";

@implementation BTTLoginOrRegisterViewController (API)


#pragma mark - 登录-----

- (void)loginWithAccount:(NSString *)account pwd:(NSString *)pwd isSmsCode:(BOOL)isSmsCode codeStr:(NSString *)codeStr{
    
    BTTLoginAPIModel *model = [[BTTLoginAPIModel alloc] init];
    model.timestamp = [PublicMethod timeIntervalSince1970];
    NSString *regex = @"^[a-zA-Z0-9]{4,11}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = NO;
    model.login_name = account;
    model.password = pwd;
    if (![codeStr isEqualToString:@""]) {
        model.code = codeStr;
    }
    isValid = [predicate evaluateWithObject:model.login_name];
    if (!model.login_name.length) {
        [MBProgressHUD showError:@"请输入账号" toView:self.view];
        return;
    }
    

    if (![model.login_name hasPrefix:@"g"] && ![PublicMethod isValidatePhone:model.login_name]) {
        [MBProgressHUD showError:@"请输入正确账号" toView:self.view];
        return;
    }

    if (!model.password.length && ![PublicMethod isValidatePhone:model.login_name]) {
        [MBProgressHUD showError:@"请输入密码" toView:self.view];
        return;
    }



    if (!model.code.length && self.loginCellType == BTTLoginCellTypeCode) {
        [MBProgressHUD showError:@"请输入验证码" toView:self.view];
        return;
    }
    [self showLoading];
    [self loginWithLoginAPIModel:model isBack:YES];
}

- (void)showPopViewWithAccounts:(NSArray *)accounts withPhone:(NSString *)codePhone withValidateId:(NSString *)validateId messageId:(NSString *)messageId smsCode:(NSString *)smsCode isBack:(BOOL)isback{
    BTTLoginAccountSelectView *customView = [BTTLoginAccountSelectView viewFromXib];
    if (SCREEN_WIDTH == 320) {
        customView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 50, 260 + accounts.count * 30);
    } else {
        customView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 50, 260 + accounts.count * 40);
    }
    customView.phone = codePhone;
    customView.accounts = accounts;
    weakSelf(weakSelf);
   
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleScale dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = NO;
    [popView pop];
    customView.dismissBlock = ^{
        [popView dismiss];
    };
    customView.callBackBlock = ^(NSString *phone,NSString *captcha,NSString *captchaId) {
        [popView dismiss];
        strongSelf(strongSelf);
        [strongSelf loginByMobileNo:phone withValidateId:validateId messageId:messageId smsCode:smsCode isBack:isback];

    };
}

- (void)loginByMobileNo:(NSString*)loginName withValidateId:(NSString *)validateId messageId:(NSString *)messageId smsCode:(NSString *)smsCode isBack:(BOOL)isback{
    [self showLoading];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"messageId"] = messageId;
    params[@"smsCode"] = smsCode;
    params[@"validateId"] = validateId;
    params[@"loginName"] = loginName;
//    NSDictionary *params = @{
//        @"messageId":messageId,
//        @"smsCode":smsCode,
//        @"validateId":validateId,
//        @"loginName":loginName
//    };
    [IVHttpManager shareManager].userToken = @"";
    [IVNetwork requestPostWithUrl:BTTUserLoginByMobileNo paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [IVHttpManager shareManager].loginName = result.body[@"loginName"];
            [IVHttpManager shareManager].userToken = result.body[@"token"];
            [[NSUserDefaults standardUserDefaults]setObject:result.body[@"token"] forKey:@"userToken"];
            [self getCustomerInfoByLoginNameWithName:result.body[@"loginName"] isBack:isback];
            
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:self.view];
        }
    }];
}


// 登录逻辑处理
- (void)loginWithLoginAPIModel:(BTTLoginAPIModel *)model isBack:(BOOL)isback {
    if (self.isDifferentLoc && [self.exModel.login_name isEqualToString:model.login_name] && [self.exModel.password isEqualToString:model.password]) {
        [self sendSmsCodeAgain:model.login_name model:model isBack:isback show:true];
        return;
    }
    NSInteger loginType = [PublicMethod isValidatePhone:model.login_name] ? 1 : 0;
    NSString *loginUrl = loginType==0 ? BTTUserLoginAPI : BTTUserLoginEXAPI;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:model.login_name forKey:BTTLoginName];
    if (loginType==0) {
        [parameters setValue:[IVRsaEncryptWrapper encryptorString:model.password] forKey:BTTPassword];
        [parameters setValue:model.timestamp forKey:BTTTimestamp];
        [parameters setValue:@(loginType) forKey:@"loginType"];
    }else{
        [parameters setValue:model.password forKey:@"verifyStr"];
        [parameters setValue:self.messageId forKey:@"messageId"];
        [parameters setValue:@"" forKey:@"captcha"];
        [parameters setValue:@"" forKey:@"captchaId"];
    }
    if (model.code.length) {
        [parameters setValue:model.code forKey:@"captcha"];
    }
    if (self.captchaId.length) {
        [parameters setValue:self.captchaId forKey:@"captchaId"];
    }
    [IVHttpManager shareManager].userToken = @"";
    
    [self showLoading];
    [IVNetwork requestPostWithUrl:loginUrl paramters:parameters completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        
        [[NSUserDefaults standardUserDefaults] setObject:model.login_name forKey:BTTCacheAccountName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            self.uuid = @"";
            self.wrongPwdNum = 0;
            
            if (result.body[@"samePhoneLoginNames"]!=nil) {
                NSArray *loginArray = result.body[@"samePhoneLoginNames"];
                NSString *messageId = result.body[@"messageId"];
                NSString *validateId = result.body[@"validateId"];
                [self showPopViewWithAccounts:loginArray withPhone:model.login_name withValidateId:validateId messageId:messageId smsCode:model.password isBack:isback];
            }else{
                [[NSUserDefaults standardUserDefaults]setObject:result.body[@"customerId"] forKey:@"pushcustomerid"];
//                [IVPushManager sharedManager].customerId = result.body[@"customerId"];
                AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate reSendIVPushRequestIpsSuperSign:result.body[@"customerId"]];
                [IVHttpManager shareManager].loginName = model.login_name;
                [IVHttpManager shareManager].userToken = result.body[@"token"];
                [[NSUserDefaults standardUserDefaults]setObject:result.body[@"token"] forKey:@"userToken"];
                NSString *loginName = [NSString stringWithFormat:@"%@",result.body[@"loginName"]];
                [self getCustomerInfoByLoginNameWithName:loginName isBack:isback];
            }
            
        }else{
            [self hideLoading];
            if ([result.head.errCode isEqualToString:@"GW_100002"]) {
                self.isDifferentLoc = true;
                self.exModel = model;
                [self showAlert:result.body model:model isBack:isback];
                return;
            }
            self.isDifferentLoc = false;
            [self.pressLocationArr removeAllObjects];
            [self checkChineseCaptchaAgain];
            if ([result.head.errMsg isEqualToString:@""]) {
                [MBProgressHUD showError:@"请输入正确验证码" toView:nil];
                return;
            }
            if ([result.head.errCode isEqualToString:@"WS_202020"]) {
                [self showAlertWithLoginName:model.login_name];
                return;
            }
            if ([result.head.errCode isEqualToString:@"GW_800510"]) {
                NSArray *loginArray = result.body[@"samePhoneLoginNames"];
                if (loginArray!=nil) {
                    NSString *messageId = result.body[@"messageId"];
                    NSString *validateId = result.body[@"validateId"];
                    [self showPopViewWithAccounts:loginArray withPhone:model.login_name withValidateId:validateId messageId:messageId smsCode:model.password isBack:isback];
                }
                return;
            }
            [MBProgressHUD showError:result.head.errMsg toView:nil];
            
//            if ([result.head.errCode isEqualToString:@"GW_800408"]) {
//                self.wrongPwdNum++;
//                if (self.wrongPwdNum >= 2) {
//                    self.loginCellType = BTTLoginCellTypeCode;
//                    [self loadVerifyCode];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [self setupElements];
//                    });
//                }
//            }else if ([result.head.errCode isEqualToString:@"GW_800101"]){
//                self.loginCellType = BTTLoginCellTypeCode;
//                [self loadVerifyCode];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self setupElements];
//                });
//            }
        }
        
    }];
}

-(void)loginWith2FA:(NSDictionary *)resultDic smsCode:(NSString *)smsCode model:(BTTLoginAPIModel *)model isBack:(BOOL)isback {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"messageId"] = resultDic[@"messageId"];
    params[@"loginName"] = resultDic[@"loginName"];
    params[@"phase"] = @2;
    params[@"smsCode"] = smsCode;
    params[@"type"] = @1;
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTUserLoginWith2FA paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (result.body[@"samePhoneLoginNames"]!=nil) {
                NSArray *loginArray = result.body[@"samePhoneLoginNames"];
                NSString *messageId = result.body[@"messageId"];
                NSString *validateId = result.body[@"validateId"];
                [self showPopViewWithAccounts:loginArray withPhone:model.login_name withValidateId:validateId messageId:messageId smsCode:model.password isBack:isback];
            }else{
                [[NSUserDefaults standardUserDefaults]setObject:result.body[@"customerId"] forKey:@"pushcustomerid"];
                AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate reSendIVPushRequestIpsSuperSign:result.body[@"customerId"]];
                [IVHttpManager shareManager].loginName = model.login_name;
                [IVHttpManager shareManager].userToken = result.body[@"token"];
                [[NSUserDefaults standardUserDefaults]setObject:result.body[@"token"] forKey:@"userToken"];
                NSString *loginName = [NSString stringWithFormat:@"%@",result.body[@"loginName"]];
                [self getCustomerInfoByLoginNameWithName:loginName isBack:isback];
            }
        } else {
            [self hideLoading];
            [self.pressLocationArr removeAllObjects];
            [self checkChineseCaptchaAgain];
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

-(void)sendSmsCodeAgain:(NSString *)loginName model:(BTTLoginAPIModel *)model isBack:(BOOL)isback show:(BOOL)show {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"use"] = @2;
    params[@"loginName"] = loginName;
    if (!show) {
        [[IVWebViewManager sharaManager].delegate showLoadingInView:self.differentLocPopView animated:YES];
    }
    [IVNetwork requestPostWithUrl:BTTStepOneSendCode paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (show) {
                [self showAlert:result.body model:model isBack:isback];
            } else {
                [[IVWebViewManager sharaManager].delegate hideHUDForView:self.differentLocPopView animated:YES];
                [MBProgressHUD showSuccess:@"验证码已发送, 请注意查收" toView:nil];
                [self.differentLocPopView countDown:60];
            }
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

- (void)showAlertWithLoginName:(NSString *)loginName {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"很抱歉!" message:@"多次密码输入错误, 已被锁住!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"五分钟再试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancel];
    UIAlertAction *unlock = [UIAlertAction actionWithTitle:@"立即解锁" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showPopViewWithAccount:loginName];
        });
    }];
    [alertVC addAction:unlock];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - 注册


- (void)createRealAccountWithModel:(BTTCreateAPIModel *)model{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:model.login_name forKey:@"loginName"];
    
    [params setValue:[IVRsaEncryptWrapper encryptorString:model.password] forKey:@"password"];
    
    [self showLoading];

    [IVNetwork requestPostWithUrl:BTTUserRegister paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (![result.body isKindOfClass:[NSNull class]] && [result.body isKindOfClass:[NSDictionary class]]) {
                if (![result.body[@"loginName"] isKindOfClass:[NSNull class]] && result.body[@"loginName"]) {
                    [MBProgressHUD showSuccess:@"开户成功" toView:nil];
                    BTTNormalRegisterSuccessController *vc = [[BTTNormalRegisterSuccessController alloc] init];
                    vc.account = result.body[@"loginName"];
                    vc.pwd = model.password;
                    [self.navigationController pushViewController:vc animated:YES];

                    BTTLoginAPIModel *loginModel = [[BTTLoginAPIModel alloc] init];
                    loginModel.login_name = result.body[@"loginName"];
                    loginModel.password = model.password;
                    loginModel.timestamp = [PublicMethod timeIntervalSince1970];
                    [self loginWithLoginAPIModel:loginModel isBack:NO];
                }
            }
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

- (void)onekeyRegisteAccount{
    [self showLoading];
    NSDictionary * params = @{@"randomStr":[PublicMethod getRandomTimeString]};
    [IVNetwork requestPostWithUrl:BTTOneKeyRegister paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSDictionary *json = result.body;
            NSString *account = json[@"loginName"];
            NSString *mainAccountName = json[@"mainAccountName"];
            NSString *pwd = json[@"password"];
            [IVHttpManager shareManager].userToken = result.body[@"token"];
            [[NSUserDefaults standardUserDefaults]setObject:result.body[@"token"] forKey:@"userToken"];
            [MBProgressHUD showSuccess:@"开户成功" toView:nil];
            BTTRegisterSuccessController *vc = [[BTTRegisterSuccessController alloc] init];
            vc.registerOrLoginType = self.registerOrLoginType;
            vc.account = account;
            vc.mainAccountName = mainAccountName;
            vc.pwd = pwd;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else{
            if ([result.head.errCode isEqualToString:@"GWX_1005"]) {
                OneKeyPhoneController *vc = [[OneKeyPhoneController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
               [MBProgressHUD showError:result.head.errMsg toView:nil];
            }
            
        }
    }];
}


- (void)verifySmsCodeCorrectWithAccount:(NSString *)account code:(NSString *)code{
    if (self.messageId==nil||[self.messageId isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入正确的验证码" toView:nil];
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.messageId forKey:@"messageId"];
    [params setValue:code forKey:@"smsCode"];
    [params setValue:@1 forKey:@"use"];
    [params setValue:@"" forKey:@"loginName"];
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTVerifySmsCode paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            self.validateId = result.body[@"validateId"];
            BTTCreateAPIModel *model = [[BTTCreateAPIModel alloc]init];
            model.login_name = [self getRandomNameWithPhone:account];
            model.password = [self getRandomPassword];
            model.phone = account;
            [self checkAccountInfoWithCreateModel:model];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:self.view];
        }
    }];
}


//
- (void)registerWithAccount:(NSString *)account imgCode:(NSString *)imgCode isFastRegister:(BOOL)isFastRegister {
    BTTCreateAPIModel *model = [[BTTCreateAPIModel alloc] init];
    if (isFastRegister) {
        model.phone = account;
        model.catpcha = imgCode;

        if (!model.phone.length) {
            [MBProgressHUD showError:@"请输入手机号" toView:self.view];
            return;
        }

        if (model.phone.length) {
            NSString *phoneregex = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
            NSPredicate *phonepredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneregex];
            BOOL isphone = [phonepredicate evaluateWithObject:model.phone];
            if (!isphone) {
                [MBProgressHUD showError:@"请填写正确的手机号" toView:self.view];
                return;
            }
        }
        if (!model.catpcha.length) {
            [MBProgressHUD showError:@"请输入验证码" toView:self.view];
            return;
        }
        model.v = @"check";
        [self createAccountNormalWithAPIModel:model];
    } else if (self.registerOrLoginType == BTTRegisterOrLoginTypeRegisterNormal) {
        if (self.qucikRegisterType == BTTQuickRegisterTypeAuto) {
//            BTTRegisterQuickAutoCell *cell = (BTTRegisterQuickAutoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
//            model.phone = cell.phoneTextField.text;
//            model.verify_code = cell.verifyTextField.text;
            model.login_name = [self getRandomNameWithPhone:model.phone];
            if (!model.phone.length) {
                [MBProgressHUD showError:@"请输入手机号" toView:self.view];
                return;
            }
            if (![PublicMethod isValidatePhone:model.phone]) {
                [MBProgressHUD showError:@"请填写正确的手机号" toView:self.view];
                return;
            }
            if (!model.verify_code.length) {
                [MBProgressHUD showError:@"请输入验证码" toView:self.view];
                return;
            }
            model.v = @"check";
            [self verifySmsCodeWithModel:model];
        } else {
//            BTTRegisterQuickManualCell *cell = (BTTRegisterQuickManualCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
//            model.phone = cell.phoneTextField.text;
//            model.verify_code = cell.codeField.text;
//            model.login_name = [NSString stringWithFormat:@"g%@",cell.accountField.text];
//            model.parent_id = [IVNetwork parentId];

            if (!model.phone.length) {
                [MBProgressHUD showError:@"请输入手机号" toView:self.view];
                return;
            }
            if (![PublicMethod isValidatePhone:model.phone]) {
                [MBProgressHUD showError:@"请填写正确的手机号" toView:self.view];
                return;
            }

            NSString *regex = @"^[a-zA-Z0-9]{4,11}$";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            BOOL isAccount = [predicate evaluateWithObject:model.login_name];
            if (!isAccount) {
                [MBProgressHUD showError:@"用户名为4-9位的数字或字母" toView:self.view];
                return;
            }

            if (!model.login_name.length) {
                [MBProgressHUD showError:@"请输入账号" toView:self.view];
                return;
            }
            if (!model.verify_code.length) {
                [MBProgressHUD showError:@"请输入验证码" toView:self.view];
                return;
            }
            model.v = @"check";
            [self verifySmsCodeWithModel:model];

        }
    }
}

- (void)verifySmsCodeWithModel:(BTTCreateAPIModel *)model{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.messageId forKey:@"messageId"];
    [params setValue:model.verify_code forKey:@"smsCode"];
    [params setValue:@1 forKey:@"use"];
    [params setValue:@"" forKey:@"loginName"];
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTVerifySmsCode paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            self.validateId = result.body[@"validateId"];
            [self checkAccountInfoWithCreateModel:model];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:self.view];
        }
    }];
}

- (void)checkAccountInfoWithCreateModel:(BTTCreateAPIModel *)model{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:model.phone forKey:@"checkValue"];
    [params setValue:@2 forKey:@"checkType"];
    [params setValue:self.validateId forKey:@"validateId"];
    [params setValue:self.messageId forKey:@"messageId"];
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTCheckAccountInfo paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [self MobileNoAndCodeRegisterAPIModel:model];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:self.view];
        }
    }];
}

- (void)createAccountNormalWithAPIModel:(BTTCreateAPIModel *)model {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[self getRandomNameWithPhone:model.phone] forKey:@"loginName"];
    if (model.password) {
        [params setValue:[IVRsaEncryptWrapper encryptorString:model.password] forKey:@"password"];
    }else{
        NSString *psd = [self getRandomPassword];
        model.password = psd;
        [params setValue:[IVRsaEncryptWrapper encryptorString:psd] forKey:@"password"];
    }
    
    if (model.catpcha) {
        [params setObject:model.catpcha forKey:@"catpcha"];
    }
    if (self.captchaId.length) {
        [params setObject:self.captchaId forKey:@"captchaId"];
    }
    if (model.parent_id.length) {
        [params setObject:model.parent_id forKey:BTTParentID];
    }
    if (model.phone.length) {
        [params setObject:[IVRsaEncryptWrapper encryptorString:model.phone] forKey:@"mobileNo"];
    }
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTUserRegister paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            self.uuid = @"";
            if ([result.body isKindOfClass:[NSDictionary class]]) {
                BTTRegisterSuccessController *vc = [[BTTRegisterSuccessController alloc] init];
                vc.registerOrLoginType = BTTRegisterOrLoginTypeRegisterQuick;
                vc.account = result.body[@"loginName"];
                vc.pwd = model.password;
                [self.navigationController pushViewController:vc animated:YES];

                BTTLoginAPIModel *loginModel = [[BTTLoginAPIModel alloc] init];
                loginModel.login_name = result.body[@"loginName"];
                loginModel.password = model.password;
                loginModel.timestamp = [PublicMethod timeIntervalSince1970];
                [self loginWithLoginAPIModel:loginModel isBack:NO];
            }
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

- (NSString *)getRandomNameWithPhone:(NSString *)phone{
    NSString *randomName = @"g";
    int len = 2;
    NSString *letters = @"abcdefghijklmnopqrstuvwxyz0123456789";
    int letterLength = (int)[letters length];
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (NSInteger i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform(letterLength)]];
    }
    randomName = [randomName stringByAppendingString:randomString];
    NSString *phoneTie = [phone substringWithRange:NSMakeRange(phone.length-6, 6)];
    randomName = [randomName stringByAppendingString:phoneTie];
    return randomName;
    
}

- (NSString *)getRandomPassword{
    int len = 8;
    NSString *letters = @"abcdefghijklmnopqrstuvwxyz0123456789";
    int letterLength = (int)[letters length];
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (NSInteger i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform(letterLength)]];
    }
    return randomString;
}


// 手机号验证码注册
- (void)MobileNoAndCodeRegisterAPIModel:(BTTCreateAPIModel *)model {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[IVRsaEncryptWrapper encryptorString:model.phone] forKey:@"mobileNo"];
    [params setValue:model.login_name forKey:@"loginName"];
    
    [params setValue:self.messageId forKey:@"messageId"];
    NSString *pwd = [self getRandomPassword];
    [params setValue:[IVRsaEncryptWrapper encryptorString:pwd] forKey:@"password"];
    
    if (self.validateId!=nil) {
        [params setValue:self.validateId forKey:@"validateId"];
    }
    [self showLoading];

    [IVNetwork requestPostWithUrl:BTTUserRegister paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (![result.body isKindOfClass:[NSNull class]] && [result.body isKindOfClass:[NSDictionary class]]) {
                if (![result.body[@"loginName"] isKindOfClass:[NSNull class]] && result.body[@"loginName"]) {
                    [MBProgressHUD showSuccess:@"开户成功" toView:nil];
                    [IVHttpManager shareManager].userToken = result.body[@"token"];
                    [[NSUserDefaults standardUserDefaults]setObject:result.body[@"token"] forKey:@"userToken"];
                    BTTRegisterSuccessController *vc = [[BTTRegisterSuccessController alloc] init];
                    vc.registerOrLoginType = self.registerOrLoginType;
                    vc.account = result.body[@"loginName"];
                    vc.mainAccountName = result.body[@"mainAccountName"];
                    vc.pwd = pwd;
                    [self.navigationController pushViewController:vc animated:YES];

                    
                }
            }
        } else {
            [MBProgressHUD showErrorWithTime:result.head.errMsg toView:nil duration:4.0];
        }
    }];
}


// 图形验证码
- (void)loadVerifyCode {
    [self showLoading];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    dict[@"use"] = @2;
    [IVNetwork requestPostWithUrl:BTTChineseVerifyCaptcha paramters:dict completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        NSLog(@"%@",result.body);
        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (result.body && ![result.body isKindOfClass:[NSNull class]]) {
                if (result.body[@"image"] && ![result.body[@"image"] isKindOfClass:[NSNull class]]) {
                    NSString *base64Str = result.body[@"image"];
                    // 将base64字符串转为NSData
                    NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:base64Str options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
                    // 将NSData转为UIImage
                    UIImage *decodedImage = [UIImage imageWithData: decodeData];
                    self.codeImage = decodedImage;
                    //获取到验证码ID
                    self.captchaId = result.body[@"captchaId"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.loginView.isHidden) {
                            
                        }else{
                            self.specifyWordArr = [[NSMutableArray alloc] initWithArray:result.body[@"specifyWord"]];
                            self.specifyWordNum = [result.body[@"specifyWordNum"] integerValue];
                            self.imgCodeImg = decodedImage;
                        }
                        
                    });
                }
            }
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
        
    }];
}

// 驗證漢字圖片驗證碼
-(void)checkChineseCaptcha:(NSString *)captchaStr {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"use"] = @2;
    params[@"captcha"] = captchaStr;
    params[@"captchaId"] = self.captchaId;
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTCheckChineseCaptcha paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSNumber * validateResult = result.body[@"validateResult"];
            if ([validateResult integerValue] == 1) {
                self.loginView.ticketStr = result.body[@"ticket"];
                [self checkChineseCaptchaSuccess];
            } else {
                [self.pressLocationArr removeAllObjects];
                [self removeLocationView];
                [self loadVerifyCode];
            }
        } else {
            if ([result.head.errCode isEqualToString:@"GW_800105"]) {
                [self.pressLocationArr removeAllObjects];
                [self removeLocationView];
                [self loadVerifyCode];
            }
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

- (void)getCustomerInfoByLoginNameWithName:(NSString *)name isBack:(BOOL)isBack{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"loginName"] = name;
    params[@"inclAddress"] = @1;
    params[@"inclBankAccount"] = @1;
    params[@"inclBtcAccount"] = @1;
    params[@"inclCredit"] = @1;
    params[@"inclEmail"] = @1;
    params[@"inclEmailBind"] = @1;
    params[@"inclMobileNo"] = @1;
    params[@"inclMobileNoBind"] = @1;
    params[@"inclPwdExpireDays"] = @1;
    params[@"inclRealName"] = @1;
    params[@"inclVerifyCode"] = @1;
    params[@"inclXmFlag"] = @1;
    params[@"verifyCode"] = @1;
    params[@"inclNickNameFlag"] = @1;
    params[@"inclXmTransferState"] = @1;
    [IVNetwork requestPostWithUrl:BTTGetLoginInfoByName paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (result.body!=nil) {
                [IVHttpManager shareManager].loginName = result.body[@"loginName"];
                [BTTUserStatusManager loginSuccessWithUserInfo:result.body isBackHome:true];
                
                if (self.isWebIn) {
                    [MBProgressHUD showSuccess:@"登录成功" toView:nil];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else if (isBack) {
                    [MBProgressHUD showSuccess:@"登录成功" toView:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }

    }];
}

// 手机验证码
- (void)loadMobileVerifyCodeWithPhone:(NSString *)phone use:(NSInteger)use{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"use"] = @(use);
    params[@"productId"] = [HAInitConfig appId];
    params[@"mobileNo"] = [IVRsaEncryptWrapper encryptorString:phone];
    
//    NSDictionary *params = @{@"use":@(use),@"productId":@"A01APP02",@"mobileNo":[IVRsaEncryptWrapper encryptorString:phone]};
    [IVNetwork requestPostWithUrl:BTTSendMsgCode paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",response);
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"验证码已发送, 请注意查收" toView:nil];
            self.messageId = result.body[@"messageId"];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
        
    }];
}

- (void)sendCodeWithPhone:(NSString *)phone use:(NSInteger)use{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"use"] = @(use);
    params[@"productId"] = [HAInitConfig appId];
    params[@"mobileNo"] = [IVRsaEncryptWrapper encryptorString:phone];
//    NSDictionary *params = @{@"use":@(use),@"productId":@"A01APP02",@"mobileNo":[IVRsaEncryptWrapper encryptorString:phone]};
   [IVNetwork requestPostWithUrl:BTTSendMsgCode paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        self.messageId = result.body[@"messageId"];
    }];
}

- (UIAlertAction *)confirm {
    return objc_getAssociatedObject(self, &confirmKey);
}

-(void)setConfirm:(UIAlertAction *)confirm {
    objc_setAssociatedObject(self, &confirmKey, confirm, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BTTLoginAPIModel *)exModel {
    return objc_getAssociatedObject(self, &exModelKey);
}

-(void)setExModel:(BTTLoginAPIModel *)exModel {
    objc_setAssociatedObject(self, &exModelKey, exModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
