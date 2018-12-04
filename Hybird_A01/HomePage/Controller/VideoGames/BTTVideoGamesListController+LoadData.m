//
//  BTTVideoGamesListController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 27/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTVideoGamesListController+LoadData.h"

@implementation BTTVideoGamesListController (LoadData)

- (void)loadVideoGamesWithRequestModel:(BTTVideoGamesRequestModel *)requestModel complete:(nonnull IVRequestCallBack)complete{
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
    if (requestModel.sort.length) {
        [params setValue:requestModel.sort forKey:@"sort"];
    }
    if (requestModel.order.length) {
        [params setValue:requestModel.order forKey:@"order"];
    }
    if (requestModel.page) {
        [params setValue:@(requestModel.page) forKey:@"page"];
    }
    if (requestModel.limit) {
        [params setValue:@(requestModel.limit) forKey:@"limit"];
    }
    if ([IVNetwork userInfo]) {
        [params setValue:[IVNetwork userInfo].loginName forKey:@"login_name"];
    }
    
    [IVNetwork sendUseCacheRequestWithSubURL:BTTVideoGamesList paramters:params completionBlock:complete];
}

- (void)loadCollectionData {
    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    NSDictionary *params = @{@"login_name":[IVNetwork userInfo].loginName};
    [IVNetwork sendUseCacheRequestWithSubURL:BTTFavotiteList paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (self.favorites.count) {
            [self.favorites removeAllObjects];
        }
        if (result.code_http == 200 && [result.data isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in result.data) {
                BTTVideoGameModel *model = [BTTVideoGameModel yy_modelWithDictionary:dict[@"remarks"]];
                model.isFavority = YES;
                [self.favorites addObject:model];
            }
        }
    }];
}

- (void)loadAddOrCancelFavorite:(BOOL)favorite gameModel:(BTTVideoGameModel *)model{
    NSString *API = @"";
    if (favorite) {
        API = BTTAddFavotites;
    } else {
        API = BTTCancelFavorites;
    }
    NSDictionary *params = @{@"game_id":model.gameid};
    [IVNetwork sendRequestWithSubURL:API paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (result.code_http == 200 && [result.data isKindOfClass:[NSDictionary class]]) {
            if (result.data[@"val"]) {
                if (favorite) {
                    [MBProgressHUD showSuccess:@"添加成功" toView:nil];
                } else {
                    [MBProgressHUD showSuccess:@"取消成功" toView:nil];
                }
                [self loadCollectionData];
            }
        } else {
            if (result.message.length) {
                [MBProgressHUD showError:result.message toView:nil];
            }
        }
    }];
}

@end
