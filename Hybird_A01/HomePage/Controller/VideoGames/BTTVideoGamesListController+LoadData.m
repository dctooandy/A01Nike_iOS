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
    
//    [IVNetwork sendUseCacheRequestWithSubURL:BTTVideoGamesList paramters:params completionBlock:complete];
}

- (void)loadCollectionData {
//    NSDictionary *params = @{@"login_name":[IVNetwork userInfo].loginName};
//    [IVNetwork sendRequestWithSubURL:BTTFavotiteList paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
//        NSLog(@"%@",response);
//        if (self.favorites.count) {
//            [self.favorites removeAllObjects];
//        }
//        if (result.status && [result.data isKindOfClass:[NSArray class]]) {
//            for (NSDictionary *dict in result.data) {
//                BTTVideoGameModel *model = [BTTVideoGameModel yy_modelWithDictionary:dict[@"remarks"]];
//                model.isFavority = YES;
//                [self.favorites addObject:model];
//            }
//            [self.favorites addObject:[BTTVideoGameModel new]];
//        }
//        [self setupElements];
//    }];
}

- (void)loadAddOrCancelFavorite:(BOOL)favorite gameModel:(BTTVideoGameModel *)model{
//    NSString *API = @"";
//    if (favorite) {
//        API = BTTAddFavotites;
//    } else {
//        API = BTTCancelFavorites;
//    }
//    NSDictionary *params = @{@"game_id":[NSString stringWithFormat:@"%@%@",model.provider,model.gameid]};
//    [IVNetwork sendRequestWithSubURL:API paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
//        NSLog(@"%@",response);
//        if (result.status && [result.data isKindOfClass:[NSDictionary class]]) {
//            if (result.data[@"val"]) {
//                [self loadCollectionData];
//            }
//        } else {
//            if (result.message.length) {
//                [MBProgressHUD showError:result.message toView:nil];
//            }
//        }
//    }];
}

@end
