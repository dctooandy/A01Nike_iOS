//
//  BTTBindEmailController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBindEmailController+LoadData.h"
#import "BTTMeMainModel.h"

@implementation BTTBindEmailController (LoadData)


- (void)loadMainData {
    NSString *emailTitle = @"邮箱地址";
    NSString *email = @"";
    switch (self.codeType) {
        case BTTSafeVerifyTypeBindEmail:
            emailTitle = @"邮箱地址 ";
            email = [IVNetwork savedUserInfo].email ? [IVNetwork savedUserInfo].email : @"" ;
            break;
        case BTTSafeVerifyTypeVerifyEmail:
            emailTitle = @"已绑定邮箱地址";
            email = [IVNetwork savedUserInfo].email;
            break;
        case BTTSafeVerifyTypeChangeEmail:
            emailTitle = @"新邮箱地址 ";
        default:
            break;
    }
    NSArray *names = @[emailTitle,@"验证码"];
    NSArray *placeholders = @[@"请输入邮箱地址",@"请输入验证码"];
    NSArray *vals = @[email,@""];
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = placeholders[index];
        model.desc = vals[index];
        [self.sheetDatas addObject:model];
    }
    [self setupElements];
}

- (NSMutableArray *)sheetDatas {
    NSMutableArray *sheetDatas = objc_getAssociatedObject(self, _cmd);
    if (!sheetDatas) {
        sheetDatas = [NSMutableArray array];
        [self setSheetDatas:sheetDatas];
    }
    return sheetDatas;
}

- (void)setSheetDatas:(NSMutableArray *)sheetDatas {
    objc_setAssociatedObject(self, @selector(sheetDatas), sheetDatas, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
