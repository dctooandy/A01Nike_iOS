//
//  BTTVideoGamesListController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by Domino on 27/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTVideoGamesListController+LoadData.h"
#import "BTTChooseCurrencyPopView.h"
#import "BTTUserGameCurrencyModel.h"

@implementation BTTVideoGamesListController (LoadData)

- (void)loadVideoGamesWithRequestModel:(BTTVideoGamesRequestModel *)requestModel complete:(nonnull KYHTTPCallBack)complete{
    self.isShowFooter = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (requestModel.type.length) {
        [params setValue:requestModel.type forKey:@"type"];
    }
    if (requestModel.line.length) {
        [params setValue:requestModel.line forKey:@"line"];
    }
    if (requestModel.platform.length) {
        [params setValue:requestModel.platform forKey:@"platform"];
    }
    if (requestModel.keyword.length) {
        [params setValue:requestModel.keyword forKey:@"keyword"];
    }
    if (requestModel.sequence.length) {
        [params setValue:requestModel.sequence forKey:@"sequence"];
    }
    if (requestModel.subscribe.length) {
        [params setValue:requestModel.subscribe forKey:@"subscribe"];
    }
    if (requestModel.page) {
        [params setValue:@(requestModel.page) forKey:@"page"];
    }
    if (requestModel.limit) {
        [params setValue:@(requestModel.limit) forKey:@"limit"];
    }
    if ([IVNetwork savedUserInfo]) {
        [params setValue:[IVNetwork savedUserInfo].loginName forKey:@"loginName"];
    }
    [IVNetwork requestPostWithUrl:BTTVideoGamesList paramters:params completionBlock:complete];
    
}

- (void)loadCollectionData {
    NSDictionary *params = @{@"loginName":[IVNetwork savedUserInfo].loginName,@"diffFlag":@1,@"pageNo":@1,@"pageSize":@999};
    [IVNetwork requestPostWithUrl:BTTFavotiteList paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (self.favorites.count) {
                [self.favorites removeAllObjects];
            }
            if (result.body[@"data"]!=nil&&[result.body[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in result.body[@"data"]) {
                    BTTVideoGameModel *model = [BTTVideoGameModel yy_modelWithDictionary:dict];
                    if (dict[@"enName"]) {
                        model.engName = dict[@"enName"];
                    }
                    [self.favorites addObject:model];
                }
                [self.favorites addObject:[BTTVideoGameModel new]];
            }
            [self setupElements];
        }
    }];
}

- (void)loadAddOrCancelFavorite:(BOOL)favorite gameModel:(BTTVideoGameModel *)model{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"gameId"] = model.gameId;
    params[@"gameProvider"] = model.provider;
    params[@"actFlag"] = favorite ? @1 : @0;
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    [IVNetwork requestPostWithUrl:BTTAddFavotites paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:result.body[@"msg"] toView:nil];
            [self loadCollectionData];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

- (void)chooseGameLine:(BTTVideoGameModel *)gameModel {
    if (![IVNetwork savedUserInfo]) {
        [self goToGame:gameModel currency:@"CNY"];
        return;
    }
    if (![[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT" ]) {
        [self goToGame:gameModel currency:[IVNetwork savedUserInfo].uiMode];
        return;
    }
    NSString * currencyStr = [IVNetwork savedUserInfo].uiMode.length != 0 ? [IVNetwork savedUserInfo].uiMode:@"CNY";
    NSDictionary *params = @{@"currency": [IVNetwork savedUserInfo] ? currencyStr:@"CNY"};
    
    NSString * gameCode = gameModel.gameCode;
    if ([gameModel.provider isEqualToString:@"PS"]) {
        gameCode = BTTPSKEY;
    }
    
    [self showLoading];
    [IVNetwork requestPostWithUrl:QUERYGames paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        NSArray *lineArray = result.body[gameCode];
        if (lineArray != nil && lineArray.count >= 2) {
            NSMutableArray * userCurrencysArr = [[NSMutableArray alloc] initWithArray:[NSArray bg_arrayWithName:BTTGameCurrencysWithName]];
            NSString * gameCurrency = @"";
            
            if (userCurrencysArr.count != 0) {
                for (BTTUserGameCurrencyModel * model in userCurrencysArr) {
                    if ([gameCode isEqualToString:model.gameKey]) {
                        gameCurrency = model.currency;
                        break;
                    }
                }
            }

            if (gameCurrency.length != 0) {
                [self goToGame:gameModel currency:gameCurrency];
            } else {
                BTTChooseCurrencyPopView *customView = [BTTChooseCurrencyPopView viewFromXib];
                customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleScale dismissStyle:BTTAnimationDismissStyleNO];
                [popView pop];
                weakSelf(weakSelf);
                customView.dismissBlock = ^{
                    strongSelf(strongSelf);
                    [popView dismiss];
//                    [strongSelf saveCurrencysArrToBGFMDB:@"USDT" userCurrencysArr:userCurrencysArr];
                    [strongSelf goToGame:gameModel currency:@"USDT"];
                };

                customView.btnBlock = ^(UIButton *btn) {
                    strongSelf(strongSelf);
                    [popView dismiss];
                    if (btn.tag == 1000) {
                        //cny
                        [strongSelf saveCurrencysArrToBGFMDB:@"CNY" userCurrencysArr:userCurrencysArr];
                        [strongSelf goToGame:gameModel currency:@"CNY"];
                    } else {
                        //usdt
                        [strongSelf saveCurrencysArrToBGFMDB:@"USDT" userCurrencysArr:userCurrencysArr];
                        [strongSelf goToGame:gameModel currency:@"USDT"];
                    }
                };
            }
            
        } else {
            if (nil == lineArray) {
                [self goToGame:gameModel currency:@"CNY"];
            } else {
                NSDictionary *json = lineArray[0];
                NSString *platformCurrency = json[@"platformCurrency"];
                [self goToGame:gameModel currency:platformCurrency];
            }
        }
    }];
}

-(void)saveCurrencysArrToBGFMDB:(NSString *)currency userCurrencysArr:(NSMutableArray *)userCurrencysArr {
    NSMutableArray * saveArr = [[NSMutableArray alloc] init];
    if (userCurrencysArr.count != 0) {
        for (BTTUserGameCurrencyModel * model in userCurrencysArr) {
            if (model.currency.length != 0) {
                [saveArr addObject:model];
            } else {
                model.currency = currency;
                [saveArr addObject:model];
            }
        }
    } else {
        NSArray *titles = @[@"AG旗舰厅", @"AG国际厅", @"AS真人棋牌", @"沙巴体育", @"AG彩票", @"PT", @"TTG", @"PP", @"PS"];
        NSArray *gameKeys = BTTGameKeysArr;
        for (NSString *gameKey in gameKeys) {
            NSInteger index = [gameKeys indexOfObject:gameKey];
            BTTUserGameCurrencyModel *model = [[BTTUserGameCurrencyModel alloc] init];
            model.title = titles[index];
            model.gameKey = gameKey;
            model.currency = currency;
            [saveArr addObject:model];
        }
    }
    [NSArray bg_clearArrayWithName:BTTGameCurrencysWithName];
    [saveArr bg_saveArrayWithName:BTTGameCurrencysWithName];
}

-(void)goToGame:(BTTVideoGameModel *)gameModel currency:(NSString *)currency {
    IVGameModel *model = [[IVGameModel alloc] init];
    model.cnName = gameModel.cnName;
    model.enName = gameModel.engName;
    model.provider = gameModel.provider;
    model.gameId = gameModel.gameId;
    model.gameType = [NSString stringWithFormat:@"%@",@(gameModel.gameType)];
    model.gameStyle = gameModel.gameStyle;
    model.platformCurrency = currency;
    if (gameModel.gameCode!=nil) {
        if ([gameModel.provider isEqualToString:@"PS"]) {
            model.gameCode = BTTPSKEY;
        }else{
            model.gameCode = gameModel.gameCode;
        }
    }
    [[IVGameManager sharedManager] forwardToGameWithModel:model controller:self];
}

@end
