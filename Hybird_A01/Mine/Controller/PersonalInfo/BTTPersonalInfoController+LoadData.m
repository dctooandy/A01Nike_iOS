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
    NSArray *names = @[@"预留信息",@"真实姓名",@"性别",@"出生日期",@"邮箱地址",@"地址",@"备注"];
    NSArray *placeholders = @[@"1-16位数字, 字母或文字",@"需与持卡人姓名相同",@"请选择性别",@"请选择出生日期",@"请填写邮箱地址",@"请填写地址",@"请填写备注"];
    NSString *verifyCode = [IVNetwork userInfo].verify_code ? [IVNetwork userInfo].verify_code : @"";
    NSString *realName = [IVNetwork userInfo].real_name ? [IVNetwork userInfo].real_name : @"";
    NSString *sex = [[IVNetwork userInfo].sex isEqualToString:@"M"] ? @"男" : @"女";
    NSString *birthDay = [IVNetwork userInfo].birthday ? [[IVNetwork userInfo].birthday substringWithRange:NSMakeRange(0, 10)] : @"";
    NSString *email = [IVNetwork userInfo].email ? [IVNetwork userInfo].email : @"";
    NSString *address = [IVNetwork userInfo].address ? [IVNetwork userInfo].address : @"";
    NSString *remark = [IVNetwork userInfo].remarks ? [IVNetwork userInfo].remarks : @"";
    NSArray *values = @[verifyCode,realName,sex,birthDay,email,address,remark];
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
