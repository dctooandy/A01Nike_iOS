//
//  BTTAccountBalanceController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 19/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTAccountBalanceController+LoadData.h"
#import "BTTGamesHallModel.h"
#import "BTTMeMainModel.h"
#import "BTTCustomerBalanceModel.h"

@implementation BTTAccountBalanceController (LoadData)

- (void)loadMainData {
    NSArray *names = @[@"本地额度(元)",@"各厅额度(元)"];
    NSArray *icons = @[@"blance_local",@"blance_hall"];
    NSMutableArray *sheetDatas = [NSMutableArray array];
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = icons[index];
        [sheetDatas addObject:model];
    }
    self.sheetDatas = [sheetDatas mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)loadLocalAmount{
    NSDictionary *params = @{@"loginName":[IVNetwork savedUserInfo].loginName,@"flag":@1};
    [IVNetwork requestPostWithUrl:BTTCreditsALL paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTCustomerBalanceModel *model = [BTTCustomerBalanceModel yy_modelWithJSON:result.body];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.amount = [PublicMethod stringWithDecimalNumber:model.balance];
                self.localAmount = [PublicMethod stringWithDecimalNumber:model.localBalance];
                self.hallAmount = model.platformTotalBalance;
                [self.games addObjectsFromArray:model.platformBalances];
                self.isLoadingData = NO;
                [self.collectionView reloadData];
                [self setupElements];
            });
        }
    }];
}

- (void)loadGamesListAndGameAmount:(UIButton *)button {
    [self loadMainData];
    [self loadLocalAmount];
}

- (void)loadTransferAllMoneyToLocal:(UIButton *)button {
    NSDictionary *params = @{@"loginName":[IVNetwork savedUserInfo].loginName};
    [IVNetwork requestPostWithUrl:BTTTransferAllMoneyToLocal paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            self.amount = @"-";
            self.localAmount = @"-";
            self.hallAmount = @"-";
            [self loadGamesListAndGameAmount:button];
        }
    }];
}


- (NSMutableArray *)games {
    NSMutableArray *games = objc_getAssociatedObject(self, _cmd);
    if (!games) {
        games = [NSMutableArray array];
        [self setGames:games];
    }
    return games;
}

- (void)setGames:(NSMutableArray *)games {
    objc_setAssociatedObject(self, @selector(games), games, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
