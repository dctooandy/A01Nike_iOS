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

@implementation BTTForgetPasswordStepThreeController (LoadData)

- (void)modifyPasswordWithPwd:(NSString *)pwd account:(NSString *)account validateId:(NSString *)validateId messageId:(NSString *)messageId{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:[IVRsaEncryptWrapper encryptorString:pwd] forKey:@"newPassword"];
    [params setValue:account forKey:@"loginName"];
    [params setValue:messageId forKey:@"messageId"];
    [params setValue:validateId forKey:@"validateId"];
    [params setValue:@2 forKey:@"type"];
    [IVNetwork requestPostWithUrl:BTTStepThreeUpdatePassword paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showSuccess:result.head.errMsg toView:nil];
        }
    }];
}

- (void)loadMainData {
    NSArray *names = @[@"新密码"];
    NSArray *placeholds = @[@"请输入新密码"];
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
