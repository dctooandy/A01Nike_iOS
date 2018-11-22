//
//  BTTWithdrawalController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTWithdrawalController+LoadData.h"
#import "BTTMeMainModel.h"

@implementation BTTWithdrawalController (LoadData)

- (void)loadMainData {
    [self.sheetDatas removeAllObjects];
    NSMutableArray *names = @[@"",@"",@"金额(元)",@"比特币",@"取款至",@"登录密码"].mutableCopy;
    NSString *btcrate = [[NSUserDefaults standardUserDefaults] valueForKey:BTTCacheBTCRateKey];
    NSString *rateStr = [NSString stringWithFormat:@"¥%.2lf=1BTC(实时汇率)",[btcrate doubleValue]];
    NSMutableArray *placeholders = @[@"",@"",@"取款限额:10-100万RMB",rateStr,@"***银行-尾号*****",@"请输入游戏账号的登录密码"].mutableCopy;
    if (!self.bankList[self.selectIndex].isBTC) {
        [names removeObjectAtIndex:3];
        [placeholders removeObjectAtIndex:3];
    }
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = placeholders[index];
        [self.sheetDatas addObject:model];
    }
    [self setupElements];
}


- (void)loadCreditsTotalAvailable {
    [self showLoading];
    [IVNetwork sendRequestWithSubURL:BTTCreditsTotalAvailable paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        [self hideLoading];
        NSLog(@"%@",response);
        if (result.message.length) {
            [MBProgressHUD showError:result.message toView:nil];
        }
        if (result.code_http == 200) {
            if (result.data) {
                self.totalAvailable = result.data[@"val"];
            }
        }
        [self.collectionView reloadData];
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
