//
//  BTTPersonalInfoController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 22/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTPersonalInfoController+LoadData.h"
#import "BTTMeMainModel.h"

@implementation BTTPersonalInfoController (LoadData)

- (void)loadMainData {
    NSArray *names = @[@"真实姓名",@"性别",@"出生日期",@"邮箱地址",@"地址",@"备注"];
    NSArray *placeholders = @[@"需与持卡人姓名相同",@"请选择性别",@"请选择出生日期",@"请填写邮箱地址",@"请填写地址",@"请填写备注"];
    NSString *realName = [IVNetwork savedUserInfo].realName ? [IVNetwork savedUserInfo].realName : @"";
    NSString *sex = [[IVNetwork savedUserInfo].gender isEqualToString:@"M"] ? @"男" : @"女";
    NSString *birthDay = [IVNetwork savedUserInfo].birthday ? [[IVNetwork savedUserInfo].birthday substringWithRange:NSMakeRange(0, 10)] : @"";
    NSString *email = [IVNetwork savedUserInfo].email ? [IVNetwork savedUserInfo].email : @"";
    NSString *address = [IVNetwork savedUserInfo].address ? [IVNetwork savedUserInfo].address : @"";
    NSString *remark = [IVNetwork savedUserInfo].remark ? [IVNetwork savedUserInfo].remark : @"";
    NSArray *values = @[realName,sex,birthDay,email,address,remark];
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = placeholders[index];
        model.desc = values[index];
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
