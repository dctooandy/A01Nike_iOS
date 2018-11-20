//
//  BTTForgetPasswordStepThreeController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 15/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTForgetPasswordStepThreeController+LoadData.h"
#import "BTTMeMainModel.h"

@implementation BTTForgetPasswordStepThreeController (LoadData)

- (void)modifyPasswordWithPwd:(NSString *)pwd account:(NSString *)account accessID:(NSString *)accessID {
    NSDictionary *params = @{@"pwd":pwd, BTTLoginName: account, @"access_id":accessID};
    [IVNetwork sendRequestWithSubURL:BTTStepThreeUpdatePassword paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",result.message);
        if (result.code_http == 200) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [MBProgressHUD showSuccess:result.message toView:self.view];
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
