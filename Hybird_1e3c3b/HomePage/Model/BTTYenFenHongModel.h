//
//  BTTYenFenHongModel.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 1/8/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTYenFenHongModel : BTTBaseModel
@property (nonatomic, copy) NSNumber *show;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *prizeLevel;

@property (nonatomic, copy) NSString *per;

@property (nonatomic, copy) NSString *needMoney;

@end

NS_ASSUME_NONNULL_END
