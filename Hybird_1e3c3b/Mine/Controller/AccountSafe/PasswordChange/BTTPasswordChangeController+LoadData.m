//
//  BTTPasswordChangeController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 7/4/2021.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTPasswordChangeController+LoadData.h"
#import "BTTBindingMobileController.h"

@implementation BTTPasswordChangeController (LoadData)
//-(void)sendCodeByPhone {
//    [self.view endEditing:YES];
//    NSMutableDictionary *params = @{}.mutableCopy;
//    params[@"use"] = @"3";
//    NSString *phone = [self getPhoneTF].text;
//    params[@"mobileNo"] = [IVRsaEncryptWrapper encryptorString:phone];
//    weakSelf(weakSelf)
//    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
//    [IVNetwork requestPostWithUrl:BTTSendMsgCode paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
//        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
//        IVJResponseObject *result = response;
//        if ([result.head.errCode isEqualToString:@"0000"]) {
//            [MBProgressHUD showSuccess:@"验证码已发送, 请注意查收" toView:nil];
//            self.messageId = result.body[@"messageId"];
//            [[weakSelf getCodeTF] setEnabled:true];
//            [[weakSelf getVerifyCell] countDown];
//        }else{
//            [[weakSelf getCodeTF] setEnabled:false];
//            [MBProgressHUD showError:result.head.errMsg toView:weakSelf.view];
//        }
//
//    }];
//}

-(void)sendCode {
    [self.view endEditing:YES];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"use"] = @"20";
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    weakSelf(weakSelf)
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    [IVNetwork requestPostWithUrl:BTTStepOneSendCode paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"验证码已发送, 请注意查收" toView:nil];
            weakSelf.messageId = result.body[@"messageId"];
            [[weakSelf getCodeTF] setEnabled:true];
            [[weakSelf getVerifyCell] countDown];
        }else{
            [[weakSelf getCodeTF] setEnabled:false];
            [MBProgressHUD showError:result.head.errMsg toView:weakSelf.view];
        }
        
    }];
}

-(void)submitVerifySmsCode {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"messageId"] = self.messageId;
    params[@"smsCode"] = [self getCodeTF].text;
    params[@"use"] = @"20";
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:BTTVerifySmsCode paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"验证成功!" toView:nil];
            weakSelf.messageId = result.body[@"messageId"];
            weakSelf.validateId = result.body[@"validateId"];
            weakSelf.isVerifySuccess = true;
            [weakSelf getSubmitBtn].enabled = false;
            [weakSelf changeSheetDatas:BTTChangeWithdrawPwd];
            [weakSelf getSubmitBtnCell].warningLabel.hidden = true;
        }else{
            weakSelf.isVerifySuccess = false;
            [MBProgressHUD showError:result.head.errMsg toView:weakSelf.view];
        }
    }];
}

-(void)submitChange {
    NSMutableDictionary *params = @{}.mutableCopy;
    BOOL isPT = [self getPwdChangeBtnCell].PTPwdBtn.selected;
    BOOL isWithdraw = [self isWithdrawPwd];
    
    NSString *loginPwd = [self getLoginPwd];
    NSString *new = [self getNewPwd];
    if (isWithdraw) {
        if ([self haveWithdrawPwd]) {
            NSString *again = [self getAgainNewPwd];
            if (![PublicMethod isValidateWithdrawPwdNumber:loginPwd]) {
                [MBProgressHUD showError:@"输入的旧资金密码格式有误！"toView:self.view];
                return;
            }
            if (![PublicMethod isValidateWithdrawPwdNumber:new]) {
                [MBProgressHUD showError:@"输入的新资金密码格式有误！"toView:self.view];
                return;
            }
            if (![again isEqualToString:new]) {
                [MBProgressHUD showError:@"再次输入资金密码与资金密码不一致！"toView:self.view];
                return;
            }
        } else {
            if (![PublicMethod isValidateWithdrawPwdNumber:loginPwd]) {
                [MBProgressHUD showError:@"输入的资金密码格式有误！"toView:self.view];
                return;
            }
            if (![loginPwd isEqualToString:new]) {
                [MBProgressHUD showError:@"再次输入资金密码与资金密码不一致！"toView:self.view];
                return;
            }
        }
        
        
    } else {
        if (![PublicMethod isValidatePwd:loginPwd]) {
            [MBProgressHUD showError:@"输入的登录密码格式有误！"toView:self.view];
            return;
        }
        if (![PublicMethod isValidatePwd:new]) {
            [MBProgressHUD showError:@"输入的新密码格式有误！"toView:self.view];
            return;
        }
    }
    
    params[@"newPassword"] = [IVRsaEncryptWrapper encryptorString:new];
    params[@"oldPassword"] = [IVRsaEncryptWrapper encryptorString:loginPwd];
    
    NSInteger type = 1;
    if (isPT) {
        type = 2;
    } else if (isWithdraw) {
        type = [self haveWithdrawPwd] ? 3:4;
        params[@"use"]= @20;
        params[@"messageId"] = self.messageId;
        params[@"validateId"] = self.validateId;
    }
    params[@"type"]= @(type);
    
    weakSelf(weakSelf)
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    [IVNetwork requestPostWithUrl:BTTModifyLoginPwd paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [BTTHttpManager fetchUserInfoCompleteBlock:^(id  _Nullable response, NSError * _Nullable error) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                if (isWithdraw && ![weakSelf haveWithdrawPwd]) {
                    [MBProgressHUD showSuccess:@"新增资金密码成功!" toView:nil];
                } else {
                    [MBProgressHUD showSuccess:@"密码修改成功!" toView:nil];
                }
                
                if (weakSelf.isGoToMinePage) {
                    [self.navigationController popToRootViewControllerAnimated:true];
                } else {
                    [self.navigationController popViewControllerAnimated:true];
                }
            }];
        }else{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [MBProgressHUD showError:result.head.errMsg toView:weakSelf.view];
        }
    }];
}

@end
