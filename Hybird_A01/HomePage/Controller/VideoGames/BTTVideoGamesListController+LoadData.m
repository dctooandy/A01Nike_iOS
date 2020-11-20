//
//  BTTVideoGamesListController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 27/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTVideoGamesListController+LoadData.h"

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
                    model.isFavority = YES;
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
    params[@"gameId"] = model.gameid;
    params[@"gameProvider"] = model.provider;
    params[@"actFlag"] = favorite ? @1 : @0;
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    [IVNetwork requestPostWithUrl:BTTAddFavotites paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [self loadCollectionData];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

- (void)chooseGameLine:(BTTVideoGameModel *)gameModel {
    NSString * currencyStr = [IVNetwork savedUserInfo].uiMode.length != 0 ? [IVNetwork savedUserInfo].uiMode:@"CNY";
    NSDictionary *params = @{@"currency": [IVNetwork savedUserInfo] ? currencyStr:@"CNY"};
    [self showLoading];
    [IVNetwork requestPostWithUrl:QUERYGames paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        NSString * gameCode = gameModel.gameCode;
        if ([gameModel.provider isEqualToString:@"PS"]) {
            gameCode = @"A01094";
        }
        NSArray *lineArray = result.body[gameCode];
        
        if (lineArray != nil && lineArray.count >= 2) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择游戏币种" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            for (int i = 0; i < lineArray.count; i++) {
                NSDictionary *json = lineArray[i];
                NSString *platformCurrency = json[@"platformCurrency"];
                NSString *title = [platformCurrency isEqualToString:@"USD"]||[platformCurrency isEqualToString:@"USDT"] ? @"数字币USDT" : @"人民币CNY";
                
                UIAlertAction *unlock = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self goToGame:gameModel currency:platformCurrency];
                }];
                [alertVC addAction:unlock];
                
                if (i == lineArray.count-1) {
                    UIAlertAction *closelock = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self goToGame:gameModel currency:@"USDT"];
                    }];
                    [alertVC addAction:closelock];
                    [self presentViewController:alertVC animated:YES completion:nil];
                }
            }
        }else{
            if (lineArray == nil) {
                [self goToGame:gameModel currency:@"CNY"];
            } else {
                NSDictionary *json = lineArray[0];
                NSString *platformCurrency = json[@"platformCurrency"];
                [self goToGame:gameModel currency:platformCurrency];
            }
        }
    }];
}

-(void)goToGame:(BTTVideoGameModel *)gameModel currency:(NSString *)currency {
    IVGameModel *model = [[IVGameModel alloc] init];
    model.cnName = gameModel.cnName;
    model.enName = gameModel.engName;
    model.provider = gameModel.provider;
    model.gameId = gameModel.gameid;
    model.gameType = [NSString stringWithFormat:@"%@",@(gameModel.gameType)];
    model.gameStyle = gameModel.gameStyle;
    model.platformCurrency = currency;
    if (gameModel.gameCode!=nil) {
        if ([gameModel.provider isEqualToString:@"PS"]) {
            model.gameCode = @"A01094";
        }else{
            model.gameCode = gameModel.gameCode;
        }
    }
    [[IVGameManager sharedManager] forwardToGameWithModel:model controller:self];
}

@end
