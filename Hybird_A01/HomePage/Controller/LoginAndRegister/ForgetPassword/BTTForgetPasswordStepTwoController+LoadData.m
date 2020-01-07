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
    NSDictionary *params = @{BTTLoginName:account,@"use":@4,@"validateId":self.validateId};
    [IVNetwork requestPostWithUrl:BTTStepOneSendCode paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"验证码已发送, 请注意查收" toView:nil];
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
    NSDictionary *params = @{BTTLoginName: account, @"smsCode":code,@"messageId":self.messageId,@"use":@4};
    [IVNetwork requestPostWithUrl:BTTVerifySmsCode paramters:params completionBlock:completeBlock];
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
