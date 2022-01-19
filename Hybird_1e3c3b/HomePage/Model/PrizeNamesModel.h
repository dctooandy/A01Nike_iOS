//
//  PrizeNamesModel.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2022/1/19.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrizeNamesModel : BTTBaseModel
@property (nonatomic, copy) NSString *prizeName;//奖品名
@property (nonatomic, copy) NSArray *users;//用户名
@end

NS_ASSUME_NONNULL_END
