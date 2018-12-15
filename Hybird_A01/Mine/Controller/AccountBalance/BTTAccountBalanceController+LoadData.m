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

- (void)loadGamesListAndGameAmount:(UIButton *)button {
    [self loadMainData];
    dispatch_queue_t queue = dispatch_queue_create("accountBlance.data", DISPATCH_QUEUE_CONCURRENT);
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
        [self loadEachGameHall:button];
    });
}

- (void)loadEachGameHall:(UIButton *)button {
    dispatch_queue_t queue = dispatch_queue_create("accountBlance.eachhall", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    for (BTTGamesHallModel *model in self.games) {
        NSInteger index = [self.games indexOfObject:model];
        dispatch_group_enter(group);
        [self loadGameAmountWithModel:model index:index group:group];
    }
    
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            button.enabled = YES;
            [self.collectionView reloadData];
        });
    });
}

- (void)loadGameshallList:(dispatch_group_t)group{
    [BTTHttpManager fetchGamePlatformsWithCompletion:^(IVRequestResultModel *result, id response) {
        if (self.games.count) {
            [self.games removeAllObjects];
        }
        if (result.code_http == 200) {
            if (result.data && [result.data isKindOfClass:[NSDictionary class]] && ![result.data isKindOfClass:[NSNull class]]) {
                if (result.data[@"platforms"] && [result.data[@"platforms"] isKindOfClass:[NSArray class]] && ![result.data[@"platforms"] isKindOfClass:[NSNull class]]) {
                    for (NSDictionary *dict in result.data[@"platforms"]) {
                        BTTGamesHallModel *model = [BTTGamesHallModel yy_modelWithDictionary:dict];
                        model.isLoading = YES;
                        [self.games addObject:model];
                    }
                }
            }
        }
        [self setupElements];
        dispatch_group_leave(group);
        if (result.message.length) {
            [MBProgressHUD showError:result.message toView:nil];
        }
    }];
}

- (void)loadTransferAllMoneyToLocal:(UIButton *)button {
    [IVNetwork sendRequestWithSubURL:BTTTransferAllMoneyToLocal paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        if (result.code_http == 200) {
            self.amount = @"-";
            self.localAmount = @"-";
            self.hallAmount = @"-";
            [self loadGamesListAndGameAmount:button];
        }
    }];
}

- (void)loadGameAmountWithModel:(BTTGamesHallModel *)model index:(NSInteger)index group:(dispatch_group_t)group{
    NSDictionary *params = @{@"game_name":model.gameName};
    [IVNetwork sendRequestWithSubURL:BTTCreditsGame paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (result.code_http == 200 && result.data && ![result.data isKindOfClass:[NSNull class]] && [result.data isKindOfClass:[NSDictionary class]]) {
            model.amount = [NSString stringWithFormat:@"%.2f",[result.data[@"val"] floatValue]];
            model.isLoading = NO;
            self.amount = [NSString stringWithFormat:@"%.2f",self.amount.floatValue + model.amount.floatValue];
            self.hallAmount = [NSString stringWithFormat:@"%.2f",self.hallAmount.floatValue + model.amount.floatValue];
        }
        dispatch_group_leave(group);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
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
