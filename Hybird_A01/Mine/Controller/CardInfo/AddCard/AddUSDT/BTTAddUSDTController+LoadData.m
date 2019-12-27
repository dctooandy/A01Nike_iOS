//
//  BTTAddUSDTController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 24/12/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTAddUSDTController+LoadData.h"
#import "CNPayRequestManager.h"

@implementation BTTAddUSDTController (LoadData)

- (void)loadUSDTData {
    [CNPayRequestManager getUSDTTypeWithCompleteHandler:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",result);
        NSArray *array = result.data[@"usdtTypes"];
        [self.usdtDatas addObjectsFromArray:array];
        [self.collectionView reloadData];
    }];
    
}

- (NSMutableArray *)usdtDatas {
    NSMutableArray *usdtDatas = objc_getAssociatedObject(self, _cmd);
    if (!usdtDatas) {
        usdtDatas = [NSMutableArray array];
        [self setUsdtDatas:usdtDatas];
    }
    return usdtDatas;
}

- (void)setUsdtDatas:(NSMutableArray *)usdtDatas{
    objc_setAssociatedObject(self, @selector(usdtDatas), usdtDatas, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
