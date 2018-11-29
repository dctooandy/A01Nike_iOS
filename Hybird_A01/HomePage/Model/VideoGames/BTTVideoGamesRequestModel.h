//
//  BTTVideoGamesRequestModel.h
//  Hybird_A01
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

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *order;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger limit;

@end

NS_ASSUME_NONNULL_END
