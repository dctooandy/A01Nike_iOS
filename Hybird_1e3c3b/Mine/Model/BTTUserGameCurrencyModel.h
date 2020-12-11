//
//  BTTUserGameCurrencyModel.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 27/11/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTUserGameCurrencyModel : BTTBaseModel
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *gameKey;

@property (nonatomic, copy) NSString *currency;
@end

NS_ASSUME_NONNULL_END
