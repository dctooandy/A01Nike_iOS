//
//  BTTLoginOrRegisterViewController+API.m
//  Hybird_A01
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

@implementation BTTLoginOrRegisterViewController (API)

- (void)getAccountsByPhone {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[PublicMethod timeIntervalSince1970] forKey:BTTTimestamp];
    BTTLoginCell *cell = (BTTLoginCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [params setObject:cell.pwdTextField.text forKey:@"sms_code"];
    [params setObject:cell.accountTextField.text forKey:@"phone"];
    [self showLoading];
    [IVNetwork sendRequestWithSubURL:BTTGetCustromerByPhone paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        [self hideLoading];
        [[NSUserDefaults standardUserDefaults] setObject:cell.accountTextField.text forKey:BTTCacheAccountName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (result.status) {
            if ([result.data[@"list"] count] > 1) {
                [self showPopViewWithAccounts:result.data[@"list"] withPhone:cell.accountTextField.text withPhoneToken:result.data[@"phone_token"]];
            } else if ([result.data[@"list"] count] == 1) {
                [self loginWithSelectLoginName:result.data[@"list"][0] phoneToken:result.data[@"phone_token"]];
            }
        } else {
            if (result.message.length) {
                [MBProgressHUD showError:result.message toView:nil];
            }
        }
    }];
}


#pragma mark - 登录-----

- (void)login {
    
    BTTLoginAPIModel *model = [[BTTLoginAPIModel alloc] init];
    model.timestamp = [PublicMethod timeIntervalSince1970];
    NSIndexPath *loginCellIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    NSString *regex = @"^[a-zA-Z0-9]{4,11}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = NO;
    if (self.loginCellType == BTTLoginCellTypeNormal) {
        BTTLoginCell *cell = (BTTLoginCell *)[self.collectionView cellForItemAtIndexPath:loginCellIndexPath];
        model.login_name = [NSString stringWithFormat:@"%@",cell.accountTextField.text];
        if ([PublicMethod isValidatePhone:model.login_name]) {
            model.sms_code = cell.pwdTextField.text;
            [self getAccountsByPhone];
            return;
        } else {
            model.password = cell.pwdTextField.text;
        }
        
        isValid = [predicate evaluateWithObject:model.login_name];
    } else {
        BTTLoginCodeCell *cell = (BTTLoginCodeCell *)[self.collectionView cellForItemAtIndexPath:loginCellIndexPath];
        model.login_name = [NSString stringWithFormat:@"%@",cell.accountTextField.text];
        model.password = cell.pwdTextField.text;
        model.code = cell.codeTextField.text;
        isValid = [predicate evaluateWithObject:model.login_name];
        
    }
    if (!model.login_name.length) {
        [MBProgressHUD showError:@"请输入账号" toView:self.view];
        return;
    }
    
    if (![model.login_name hasPrefix:@"g"] && ![PublicMethod isValidatePhone:model.login_name]) {
        [MBProgressHUD showError:@"请输入以g开头真钱账号" toView:self.view];
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


// 登录逻辑处理
- (void)loginWithLoginAPIModel:(BTTLoginAPIModel *)model isBack:(BOOL)isback {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:model.login_name forKey:BTTLoginName];
    [parameters setObject:model.timestamp forKey:BTTTimestamp];
    
    [parameters setObject:model.password forKey:BTTPassword];
    if (model.code.length) {
        [parameters setObject:model.code forKey:@"code"];
    }
    if (self.uuid.length) {
        [parameters setObject:self.uuid forKey:@"uuid"];
    }
    [IVNetwork sendRequestWithSubURL:BTTUserLoginAPI paramters:parameters completionBlock:^(IVRequestResultModel *result, id response) {
        [self hideLoading];
        NSLog(@"%@",response);
        [[NSUserDefaults standardUserDefaults] setObject:model.login_name forKey:BTTCacheAccountName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (result.status) {
            self.wrongPwdNum = 0;
            if ([result.data isKindOfClass:[NSDictionary class]]) {
                self.uuid = @"";
                [BTTUserStatusManager loginSuccessWithUserInfo:result.data];
                if (isback) {
                    [MBProgressHUD showSuccess:@"登录成功" toView:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } else {
                if (result.message.length) {
                    [MBProgressHUD showError:result.message toView:nil];
                }
            }
        } else {
            if (result.code_system == 202020) {
                [self showAlertWithModle:nil];
            } else if(result.code_system == 202006 || result.code_system == 202018) {
                [MBProgressHUD showError:@"账号或密码错误,请重新输入" toView:self.view];
                self.wrongPwdNum++;
                if (self.wrongPwdNum >= 2) {
                    self.loginCellType = BTTLoginCellTypeCode;
                    [self loadVerifyCode];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self setupElements];
                    });
                }
            } else {
                if (result.message.length) {
                    [MBProgressHUD showError:result.message toView:nil];
                }
            }
        }
    }];
}

- (void)showPopViewWithAccounts:(NSArray *)accounts withPhone:(NSString *)codePhone withPhoneToken:(NSString *)phoneToken{
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
    customView.callBackBlock = ^(NSString *phone) {
        [popView dismiss];
        strongSelf(strongSelf);
        NSString *selectAccount = phone;
        [strongSelf loginWithSelectLoginName:selectAccount phoneToken:phoneToken];
    };
}

- (void)loginWithSelectLoginName:(NSString *)loginName phoneToken:(NSString *)phoneToken {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:loginName forKey:@"selected_login_name"];
    [params setObject:[PublicMethod timeIntervalSince1970] forKey:BTTTimestamp];
    BTTLoginCell *cell = (BTTLoginCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [params setObject:cell.accountTextField.text forKey:BTTLoginName];
    [params setObject:phoneToken forKey:@"phone_token"];
    [self showLoading];
    [IVNetwork sendRequestWithSubURL:BTTUserLoginAPI paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        [self hideLoading];
        if (result.status) {
            self.wrongPwdNum = 0;
            if ([result.data isKindOfClass:[NSDictionary class]]) {
                self.uuid = @"";
                [BTTUserStatusManager loginSuccessWithUserInfo:result.data];
                
                [MBProgressHUD showSuccess:@"登录成功" toView:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
            } else {
                if (result.message.length) {
                    [MBProgressHUD showError:result.message toView:nil];
                }
            }
        } else {
            if (result.code_system == 202020) {
                [self showAlertWithModle:nil];
            } else if(result.code_system == 202006 || result.code_system == 202018) {
                [MBProgressHUD showError:@"账号或密码错误,请重新输入" toView:self.view];
                self.wrongPwdNum++;
                if (self.wrongPwdNum >= 2) {
                    self.loginCellType = BTTLoginCellTypeCode;
                    [self loadVerifyCode];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self setupElements];
                    });
                }
            } else {
                if (result.message.length) {
                    [MBProgressHUD showError:result.message toView:nil];
                }
            }
        }
    }];
    
}

- (void)showAlertWithModle:(BTTLoginAPIModel *)model {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"很抱歉!" message:@"多次密码输入错误, 已被锁住!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"五分钟再试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancel];
    UIAlertAction *unlock = [UIAlertAction actionWithTitle:@"立即解锁" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showPopViewWithAccount:model.login_name];
        });
    }];
    [alertVC addAction:unlock];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - 注册

// 普通开户
- (void)registerAction {
    BTTCreateAPIModel *model = [[BTTCreateAPIModel alloc] init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    if (self.self.registerOrLoginType == BTTRegisterOrLoginTypeRegisterNormal) {
        BTTRegisterNormalCell *cell = (BTTRegisterNormalCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        model.login_name = [NSString stringWithFormat:@"g%@",cell.accountTextField.text];
        model.password = cell.pwdTextField.text;
        model.parent_id = [IVNetwork parentId];
        model.phone = cell.phoneTextField.text;
        model.catpcha = cell.verifyTextField.text;
        NSString *regex = @"^[a-zA-Z0-9]{4,11}$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isAccount = [predicate evaluateWithObject:model.login_name];
        if (!isAccount || cell.accountTextField.text.length < 4) {
            [MBProgressHUD showError:@"用户名为4-9位的数字或字母" toView:self.view];
            return;
        }
        
        if (!model.login_name.length) {
            [MBProgressHUD showError:@"请输入账号" toView:self.view];
            return;
        }
        NSString *pwdregex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9a-zA-Z]{8,10}$";
        NSPredicate *pwdpredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdregex];
        BOOL ispwd = [pwdpredicate evaluateWithObject:model.password];
        if (!ispwd) {
            [MBProgressHUD showError:@"密码为8~10位的数字和字母" toView:self.view];
            return;
        }
        if (!model.password.length) {
            [MBProgressHUD showError:@"请输入密码" toView:self.view];
            return;
        }
        
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
        [self createAccountNormalWithAPIModel:model];
    } else if (self.registerOrLoginType == BTTRegisterOrLoginTypeRegisterQuick) {
        if (self.qucikRegisterType == BTTQuickRegisterTypeAuto) {
            BTTRegisterQuickAutoCell *cell = (BTTRegisterQuickAutoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            model.phone = cell.phoneTextField.text;
            model.verify_code = cell.verifyTextField.text;
            model.parent_id = [IVNetwork parentId];
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
            [self fastRegisterAPIModel:model];
        } else {
            BTTRegisterQuickManualCell *cell = (BTTRegisterQuickManualCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            model.phone = cell.phoneTextField.text;
            model.verify_code = cell.codeField.text;
            model.login_name = [NSString stringWithFormat:@"g%@",cell.accountField.text];
            model.parent_id = [IVNetwork parentId];
            
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
            [self fastRegisterAPIModel:model];
        } 
    }
}

- (void)createAccountNormalWithAPIModel:(BTTCreateAPIModel *)model {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:model.login_name forKey:BTTLoginName];
    [params setObject:model.password forKey:BTTPassword];
    [params setObject:model.catpcha forKey:@"catpcha"];
    if (self.uuid.length) {
        [params setObject:self.uuid forKey:@"uuid"];
    }
    if (model.parent_id.length) {
        [params setObject:model.parent_id forKey:BTTParentID];
    }
    if (model.phone.length) {
        [params setObject:model.phone forKey:BTTPhone];
    }
    [self showLoading];
    [IVNetwork sendRequestWithSubURL:BTTUserCreateAPI paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        [self hideLoading];
        self.uuid = @"";
        if (result.status) {
            if (result.data && [result.data isKindOfClass:[NSDictionary class]]) {
                BTTRegisterSuccessController *vc = [[BTTRegisterSuccessController alloc] init];
                vc.registerOrLoginType = self.registerOrLoginType;
                vc.account = model.login_name;
                [self.navigationController pushViewController:vc animated:YES];
                BTTLoginAPIModel *loginModel = [[BTTLoginAPIModel alloc] init];
                loginModel.login_name = model.login_name;
                loginModel.password = model.password;
                loginModel.timestamp = [PublicMethod timeIntervalSince1970];
                [self loginWithLoginAPIModel:loginModel isBack:NO];
            }
        }
        if (result.message.length) {
            [MBProgressHUD showError:result.message toView:nil];
        }
    }];
}

// 极速开户
- (void)fastRegisterAPIModel:(BTTCreateAPIModel *)model {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (model.phone.length) {
        [params setObject:model.phone forKey:BTTPhone];
    }
    if (model.verify_code.length) {
        [params setObject:model.verify_code forKey:@"verify_code"];
    }
    if (model.parent_id.length) {
        [params setObject:model.parent_id forKey:BTTParentID];
    }
    if (model.login_name.length) {
        [params setObject:model.login_name forKey:BTTLoginName];
    }
    [self showLoading];
    [IVNetwork sendRequestWithSubURL:BTTUserFastRegister paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        [self hideLoading];
        if (result.status) {
            if (result.data && ![result.data isKindOfClass:[NSNull class]] && [result.data isKindOfClass:[NSDictionary class]]) {
                if (![result.data[@"login_name"] isKindOfClass:[NSNull class]] && result.data[@"login_name"]) {
                    if (result.message.length) {
                        [MBProgressHUD showSuccess:result.message toView:nil];
                    }
                    BTTRegisterSuccessController *vc = [[BTTRegisterSuccessController alloc] init];
                    vc.registerOrLoginType = self.registerOrLoginType;
                    vc.account = result.data[@"login_name"];
                    vc.pwd = result.data[@"password"];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    BTTLoginAPIModel *loginModel = [[BTTLoginAPIModel alloc] init];
                    loginModel.login_name = result.data[@"login_name"];
                    loginModel.password = result.data[@"password"];
                    loginModel.timestamp = [PublicMethod timeIntervalSince1970];
                    [self loginWithLoginAPIModel:loginModel isBack:NO];
                }
            }
        } else {
            if (result.message.length) {
                [MBProgressHUD showError:result.message toView:nil];
            }
        }
        
    }];
}


// 图形验证码
- (void)loadVerifyCode {
    [self showLoading];
    [IVNetwork sendRequestWithSubURL:BTTVerifyCaptcha paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        [self hideLoading];
        if (result.status) {
            if (result.data && ![result.data isKindOfClass:[NSNull class]]) {
                if (result.data[@"src"] && ![result.data[@"src"] isKindOfClass:[NSNull class]]) {
                    NSString *base64Str = result.data[@"src"];
                    // 将base64字符串转为NSData
                    NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:base64Str options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
                    // 将NSData转为UIImage
                    UIImage *decodedImage = [UIImage imageWithData: decodeData];
                    self.codeImage = decodedImage;
                    self.uuid = result.data[@"uuid"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView reloadData];
                    });
                }
            }
        }
        if (result.message.length) {
            [MBProgressHUD showError:result.message toView:nil];
        }
    }];
}

// 手机验证码
- (void)loadMobileVerifyCodeWithPhone:(NSString *)phone {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (phone.length) {
        [params setObject:phone forKey:@"send_to"];
    }
    [params setObject:@(1) forKey:@"type"];
    [params setObject:@(6) forKey:@"v_type"];
    [params setObject:[PublicMethod timeIntervalSince1970] forKey:BTTTimestamp];
    [IVNetwork sendRequestWithSubURL:BTTNoLoginMobileCodeAPI paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (result.status) {
            [MBProgressHUD showSuccess:@"验证码已发送, 请注意查收" toView:nil];
        } else {
            if (result.message.length) {
                [MBProgressHUD showError:result.message toView:nil];
            }
        }
    }];
}

- (void)sendCodeWithPhone:(NSString *)phone {
    NSDictionary *params = @{@"type":@"1",@"v_type":@"10",@"send_to":phone};
    [IVNetwork sendRequestWithSubURL:BTTNoLoginMobileCodeAPI paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (result.status) {
            if (result.message.length) {
                [MBProgressHUD showSuccess:result.message toView:nil];
            }
        } else {
            if (result.message.length) {
                [MBProgressHUD showError:result.message toView:nil];
            }
        }
    }];
}


@end
