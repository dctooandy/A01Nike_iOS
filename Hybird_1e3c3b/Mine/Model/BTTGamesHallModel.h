//
//  BTTGamesHallModel.h
//  Hybird_1e3c3b
//
//  Created by Domino on 20/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTGamesHallModel : BTTBaseModel

@property (nonatomic, copy) NSString *gameName;

@property (nonatomic, copy) NSString *zhName;

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, assign) BOOL isLoading;

@end

NS_ASSUME_NONNULL_END
