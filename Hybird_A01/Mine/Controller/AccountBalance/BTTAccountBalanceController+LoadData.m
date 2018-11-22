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

@implementation BTTAccountBalanceController (LoadData)

- (void)loadMainData {
    NSArray *names = @[@"本地额度(元)",@"各厅额度(元)"];
    NSArray *icons = @[@"blance_local",@"blance_hall"];
    
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = icons[index];
        [self.sheetDatas addObject:model];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)loadLocalAmount:(dispatch_group_t)group {
    [self showLoading];
    [IVNetwork sendRequestWithSubURL:BTTCreditsLocal paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
       
        NSLog(@"%@",response);
        if (result.code_http == 200) {
            if (result.data && ![result.data isKindOfClass:[NSNull class]]) {
                self.amount = result.data[@"val"];
                self.localAmount = [NSString stringWithFormat:@"%.2f",[result.data[@"val"] floatValue]];
                dispatch_group_leave(group);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            }
        }
    }];
}

- (void)loadGamesListAndGameAmount {
    [self loadMainData];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self loadLocalAmount:group];
    });
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self loadGameshallList:group];
    });
    dispatch_group_notify(group, queue, ^{
        [self hideLoading];
        for (BTTGamesHallModel *model in self.games) {
            [self loadGameAmountWithModel:model];
        }
    });
}

- (void)loadGameshallList:(dispatch_group_t)group{
    [IVNetwork sendRequestWithSubURL:BTTGamePlatforms paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (result.code_http == 200) {
            if (result.data && [result.data isKindOfClass:[NSDictionary class]] && ![result.data isKindOfClass:[NSNull class]]) {
                if (result.data[@"platforms"] && [result.data[@"platforms"] isKindOfClass:[NSArray class]] && ![result.data[@"platforms"] isKindOfClass:[NSNull class]]) {
                    for (NSDictionary *dict in result.data[@"platforms"]) {
                        BTTGamesHallModel *model = [BTTGamesHallModel yy_modelWithDictionary:dict];
                        [self.games addObject:model];
                    }
                }
                dispatch_group_leave(group);
                [self setupElements];
            }
        }
        
        if (result.message.length) {
            [MBProgressHUD showError:result.message toView:nil];
        }
    }];
}

- (void)loadTransferAllMoneyToLocal {
    [IVNetwork sendRequestWithSubURL:BTTTransferAllMoneyToLocal paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        if (result.code_http == 200) {
            self.amount = @"-";
            self.localAmount = @"-";
            self.hallAmount = @"-";
            [self loadGamesListAndGameAmount];
        }
    }];
}

- (void)loadGameAmountWithModel:(BTTGamesHallModel *)model {
    NSDictionary *params = @{@"game_name":model.gameName};
    [IVNetwork sendRequestWithSubURL:BTTCreditsGame paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (result.code_http == 200 && result.data && ![result.data isKindOfClass:[NSNull class]] && [result.data isKindOfClass:[NSDictionary class]]) {
            model.amount = [NSString stringWithFormat:@"%.2f",[result.data[@"val"] floatValue]];
            self.amount = [NSString stringWithFormat:@"%.2f",self.amount.floatValue + model.amount.floatValue];
            self.hallAmount = [NSString stringWithFormat:@"%.2f",self.hallAmount.floatValue + model.amount.floatValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
        if (result.message.length) {
            [MBProgressHUD showError:result.message toView:nil];
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
