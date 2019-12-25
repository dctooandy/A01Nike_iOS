//
//  BTTAddUSDTController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 24/12/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTAddUSDTController+LoadData.h"


@implementation BTTAddUSDTController (LoadData)

- (void)loadUSDTData {
    NSArray *usdts = @[@"Mobi",@"Huobi",@"Atoken",@"Bixin",@"Bitpie",@"Hicoin",@"Coldlar",@"Coincola",@"其他钱包"];
    
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
