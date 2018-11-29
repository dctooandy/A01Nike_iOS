//
//  BTTVideoGamesListController+LoadData.h
//  Hybird_A01
//
//  Created by Domino on 27/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTVideoGamesListController.h"
#import "BTTVideoGamesRequestModel.h"
#import "BTTVideoGameModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTVideoGamesListController (LoadData)

- (void)loadVideoGamesWithRequestModel:(BTTVideoGamesRequestModel *)requestModel complete:(IVRequestCallBack)complete;

- (void)loadCollectionData;

- (void)loadAddOrCancelFavorite:(BOOL)favorite gameModel:(BTTVideoGameModel *)model;

@end

NS_ASSUME_NONNULL_END
