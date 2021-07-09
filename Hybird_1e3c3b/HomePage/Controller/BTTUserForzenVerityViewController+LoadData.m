//
//  BTTUserForzenVerityViewController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/7/9.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTUserForzenVerityViewController+LoadData.h"

@implementation BTTUserForzenVerityViewController (LoadData)
-(void)sendCode {
    [self.view endEditing:YES];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"use"] = @22;
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


@end
