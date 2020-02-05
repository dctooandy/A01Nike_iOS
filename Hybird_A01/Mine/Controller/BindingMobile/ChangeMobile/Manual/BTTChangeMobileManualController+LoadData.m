//
//  BTTChangeMobileManualController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 19/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTChangeMobileManualController+LoadData.h"
#import "BTTMeMainModel.h"

@implementation BTTChangeMobileManualController (LoadData)

- (void)loadMainData {

    NSMutableArray *names = [NSMutableArray array];
    NSString *firstStr = [NSString stringWithFormat:@"请输入%@的完整号码",[IVNetwork savedUserInfo].mobileNo];
    [names addObject:firstStr];
    [names addObject:@"原手机号码"];
    
    NSString *thirdStr = [NSString stringWithFormat:@"请输入%@的完整银行卡号",@"(这里需要一个接口获取原来的银行卡)"];
    [names addObject:thirdStr];
    [names addObject:@"原银行卡号"];
    
    for (NSString *name in names) {
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
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
