//
//  BTTNotCompleteInfoController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by Domino on 23/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTNotCompleteInfoController+LoadData.h"
#import "BTTMeMainModel.h"

@implementation BTTNotCompleteInfoController (LoadData)


- (void)loadMainData {
    NSArray *names = @[@"真实姓名"];
    NSArray *placeholders = @[@"需与取款银行卡持卡人姓名相同"];
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
