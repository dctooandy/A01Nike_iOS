//
//  BTTForgetPasswordStepTwoController+LoadData.m
//  Hybird_A01
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
    NSDictionary *params = @{BTTLoginName:account};
    [IVNetwork sendRequestWithSubURL:BTTStepOneSendCode paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        [MBProgressHUD showSuccess:result.message toView:self.view];
    }];
}

- (void)verifyCode:(NSString *)code account:(NSString *)account completeBlock:(CompleteBlock)completeBlock {
    if (!code.length || !account.length) {
        return;
    }
    NSDictionary *params = @{BTTLoginName: account, @"code":code};
    //TODO:
//    [IVNetwork sendRequestWithSubURL:BTTStepTwoCheckCode paramters:params completionBlock:completeBlock];
}

- (void)loadMainData {
    NSArray *names = @[@"验证码"];
    NSArray *placeholds = @[@"请输入验证码"];
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = placeholds[index];
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
