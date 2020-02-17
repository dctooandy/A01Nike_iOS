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

@end
