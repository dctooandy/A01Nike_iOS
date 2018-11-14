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


@implementation BTTLoginOrRegisterViewController (API)


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
        model.login_name = [NSString stringWithFormat:@"g%@",cell.accountTextField.text];
        model.password = cell.pwdTextField.text;
        isValid = [predicate evaluateWithObject:model.login_name];
    } else {
        BTTLoginCodeCell *cell = (BTTLoginCodeCell *)[self.collectionView cellForItemAtIndexPath:loginCellIndexPath];
        model.login_name = [NSString stringWithFormat:@"g%@",cell.accountTextField.text];
        model.password = cell.pwdTextField.text;
        isValid = [predicate evaluateWithObject:model.login_name];
    }
    if (model.login_name.length == 1) {
        [MBProgressHUD showMessagNoActivity:@"请输入账号" toView:self.view];
        return;
    }
    if (!model.password.length) {
        [MBProgressHUD showMessagNoActivity:@"请输入密码" toView:self.view];
        return;
    }
    [self loginWithLoginAPIModel:model];
}


// 登录逻辑处理
- (void)loginWithLoginAPIModel:(BTTLoginAPIModel *)model {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:model.login_name forKey:BTTLoginName];
    [parameters setObject:model.password forKey:BTTPassword];
    [parameters setObject:model.timestamp forKey:BTTTimestamp];
    [self showLoading];
    [IVNetwork sendRequestWithSubURL:BTTUserLoginAPI paramters:parameters completionBlock:^(IVRequestResultModel *result, id response) {
        [self hideLoading];
        NSLog(@"%@",response);
        if (result.code_http == 200) {
            [self.navigationController popViewControllerAnimated:YES];
            [[IVCacheManager sharedInstance] nativeWriteValue:result.data[@"WSCustomers"] forKey:KCacheUserInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotification object:nil];
        } else {
            if (result.code_system == 202020) {
                [self showAlert];
            } else if(result.code_system == 202006 || result.code_system == 202018) {
                [MBProgressHUD showMessagNoActivity:@"账号或密码错误,请重新输入" toView:self.view];
            }
        }
    }];
}

- (void)showAlert {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"很抱歉!" message:@"多次密码输入错误, 已被锁住!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"五分钟再试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancel];
    UIAlertAction *unlock = [UIAlertAction actionWithTitle:@"立即解锁" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showPopView];
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
        if (!isAccount) {
            [MBProgressHUD showMessagNoActivity:@"用户名为4-9位的数字或字母" toView:self.view];
            return;
        }
        
        if (!model.login_name.length) {
            [MBProgressHUD showMessagNoActivity:@"请输入账号" toView:self.view];
            return;
        }
        NSString *pwdregex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9a-zA-Z]{8,10}$";
        NSPredicate *pwdpredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdregex];
        BOOL ispwd = [pwdpredicate evaluateWithObject:model.password];
        if (!ispwd) {
            [MBProgressHUD showMessagNoActivity:@"密码为8~10位的数字和字母" toView:self.view];
            return;
        }
        if (!model.password.length) {
            [MBProgressHUD showMessagNoActivity:@"请输入密码" toView:self.view];
            return;
        }
        if (model.phone.length) {
            NSString *phoneregex = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
            NSPredicate *phonepredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneregex];
            BOOL isphone = [phonepredicate evaluateWithObject:model.phone];
            if (!isphone) {
                [MBProgressHUD showMessagNoActivity:@"请填写正确的手机号" toView:self.view];
                return;
            }
        }
        if (!model.catpcha.length) {
            [MBProgressHUD showMessagNoActivity:@"请输入验证码" toView:self.view];
            return;
        }
        [self createAccountNormalWithAPIModel:model];
    } else if (self.registerOrLoginType == BTTRegisterOrLoginTypeRegisterQuick) {
        if (self.qucikRegisterType == BTTQuickRegisterTypeAuto) {
            BTTRegisterQuickAutoCell *cell = (BTTRegisterQuickAutoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        } else {
            BTTRegisterQuickManualCell *cell = (BTTRegisterQuickManualCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        }
    }
}

- (void)createAccountNormalWithAPIModel:(BTTCreateAPIModel *)model {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:model.login_name forKey:BTTLoginName];
    [params setObject:model.password forKey:BTTPassword];
    [params setObject:model.catpcha forKey:@"catpcha"];
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
        if (result.code_http == 200) {
            BTTLoginAPIModel *loginModel = [[BTTLoginAPIModel alloc] init];
            loginModel.login_name = model.login_name;
            loginModel.password = model.password;
            loginModel.timestamp = [PublicMethod timeIntervalSince1970];
            [self loginWithLoginAPIModel:loginModel];
            
        }
    }];
}


// 极速开户
- (void)fastRegisterAutoWithAPIModel:(BTTCreateAPIModel *)model {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:model.phone forKey:BTTPhone];
    [params setObject:model.verify_code forKey:@"verify_code"];
    [params setObject:model.parent_id forKey:BTTParentID];
    [IVNetwork sendRequestWithSubURL:BTTUserFastRegister paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        if (result.code_http == 200) {
            
        }
    }];
}

// 图形验证码
- (void)loadVerifyCode {
    [self showLoading];
    [IVNetwork sendRequestWithSubURL:BTTVerifyCaptcha paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        [self hideLoading];
        if (result.code_http == 200) {
            NSString *base64Str = result.data[@"src"];
            // 将base64字符串转为NSData
            NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:base64Str options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
            // 将NSData转为UIImage
            UIImage *decodedImage = [UIImage imageWithData: decodeData];
            self.codeImage = decodedImage;
            [self.collectionView reloadData];
        }
    }];
}


@end