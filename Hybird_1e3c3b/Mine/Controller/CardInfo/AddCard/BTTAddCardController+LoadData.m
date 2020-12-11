//
//  BTTAddCardController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTAddCardController+LoadData.h"
#import "BTTMeMainModel.h"


@implementation BTTAddCardController (LoadData)

- (void)loadMainData {
    NSArray *names = @[@"持卡人姓名",@"开户行",@"卡片类别",@"卡号",@"开户省份",@"开户城市",@"开户网点"];
    NSArray *placeholders = @[@"**子",@"请选择收款银行",@"请选择卡片类别",@"请输入银行卡号",@"请选择省份",@"请选择城市",@"请填写具体开户地点"];
    NSArray *vals = @[[IVNetwork savedUserInfo].realName.length ? [IVNetwork savedUserInfo].realName : @"",@"",@"",@"",@"",@"",@""];
    NSMutableArray *sheetDatas = [NSMutableArray array];
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = placeholders[index];
        model.desc = vals[index];
        [sheetDatas addObject:model];
    }
    self.sheetDatas = sheetDatas.mutableCopy;
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
