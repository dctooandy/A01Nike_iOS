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
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:@"1" forKey:@"walletType"];
    [IVNetwork requestPostWithUrl:BTTQueryUSDTWallet paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if ([result.body isKindOfClass:[NSArray class]]) {
                NSArray *array = result.body;
                CGFloat height = 96+(array.count-1)/3*36;
                [self.elementsHight replaceObjectAtIndex:0 withObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, height)]];
                [self.usdtDatas addObjectsFromArray:array];
                [self.collectionView reloadData];
            }
        }
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
