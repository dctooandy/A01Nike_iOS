//
//  BTTAddBTCController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTAddBTCController+LoadData.h"
#import "BTTMeMainModel.h"

@implementation BTTAddBTCController (LoadData)


- (void)loadMainData {
    NSArray *names = @[@"钱包地址",@"确认地址"];
    NSArray *placeholders = @[@"请输入钱包地址",@"请确认地址"];
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = placeholders[index];
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
