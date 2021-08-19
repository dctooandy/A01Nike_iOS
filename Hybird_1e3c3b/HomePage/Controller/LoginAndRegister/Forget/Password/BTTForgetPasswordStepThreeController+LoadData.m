//
//  BTTForgetPasswordStepThreeController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by Domino on 15/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTForgetPasswordStepThreeController+LoadData.h"
#import "BTTMeMainModel.h"
#import "IVRsaEncryptWrapper.h"
#import "BTTForgetFinalController.h"

@implementation BTTForgetPasswordStepThreeController (LoadData)

- (void)modifyPasswordWithPwd:(NSString *)pwd account:(NSString *)account validateId:(NSString *)validateId messageId:(NSString *)messageId{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:[IVRsaEncryptWrapper encryptorString:pwd] forKey:@"newPassword"];
    [params setValue:account forKey:@"loginName"];
    [params setValue:messageId forKey:@"messageId"];
    [params setValue:validateId forKey:@"validateId"];
    [params setValue:@2 forKey:@"type"];
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTStepThreeUpdatePassword paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"修改密码成功" toView:nil];
            BTTForgetFinalController * vc = [[BTTForgetFinalController alloc] init];
            vc.title = @"完成重置密码";
            vc.btnTitleArr = @[@"立即登录"];
            if (self.forgetType == BTTForgetBoth) {
                vc.accountStr = account;
                vc.isBothLastStep = true;
            }
            [self.navigationController pushViewController:vc animated:true];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

- (void)loadMainData {
    NSArray *iconNames = @[@"ic_forget_reset_pwd_logo", @"ic_forget_reset_again_pwd_logo"];
    NSArray *placeholds = @[@"请输入新密码", @"请再次输入新密码"];
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
