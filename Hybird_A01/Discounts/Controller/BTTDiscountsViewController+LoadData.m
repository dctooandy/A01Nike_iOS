//
//  BTTDiscountsViewController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 19/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTDiscountsViewController+LoadData.h"
#import "BTTPromotionModel.h"

@implementation BTTDiscountsViewController (LoadData)


- (void)loadMainData {
    if (self.discountsVCType == BTTDiscountsVCTypeDetail) {
        [self showLoading];
    }
    [IVNetwork sendRequestWithSubURL:BTTPromotionList paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        [self hideLoading];
        if (result.code_http == 200) {
            if (![result.data isKindOfClass:[NSNull class]]) {
                [self.sheetDatas removeAllObjects];
                NSLog(@"%@",response);
                [self endRefreshing];
                for (NSDictionary *dict in result.data) {
                    BTTPromotionModel *model = [BTTPromotionModel yy_modelWithDictionary:dict];
                    [self.sheetDatas addObject:model];
                }
                [self setupElements];
            }
        }
    }];
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
