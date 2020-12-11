//
//  BTTChangeMobileNextController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by Domino on 19/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTChangeMobileNextController+LoadData.h"
#import "BTTMeMainModel.h"

@implementation BTTChangeMobileNextController (LoadData)

- (void)loadMainData {
    NSArray *names = @[@"新手机号码",@"备注"];
    NSArray *placeholders = @[@"请输入新手机号码",@"选填"];
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
