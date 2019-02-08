//
//  BTTCardModifyVerifyController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCardModifyVerifyController+LoadData.h"
#import "BTTMeMainModel.h"


@implementation BTTCardModifyVerifyController (LoadData)


- (void)loadMainData {
    NSArray *names = nil;
    if (self.safeVerifyType == 0) {
        names = @[@"原绑定电话",@"获取中...",@"核对原来绑定电话",@"输入绑定的手机号",@"原绑定银行卡",@"获取中...",@"核对原来绑定银行卡",@"输入绑定的银行卡号"];
    } else {
        names = @[@"原绑定银行卡",@"获取中...",@"核对原来绑定银行卡",@"输入绑定的银行卡号"];
    }
    
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
