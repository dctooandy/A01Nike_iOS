//
//  BTTVideoGamesRequestModel.h
//  Hybird_1e3c3b
//
//  Created by Domino on 28/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTVideoGamesRequestModel : BTTBaseModel

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *line;

@property (nonatomic, copy) NSString *platform;

@property (nonatomic, copy) NSString *keyword;

@property (nonatomic, copy) NSString *sequence;

@property (nonatomic, copy) NSString *subscribe;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger limit;

@end

NS_ASSUME_NONNULL_END
