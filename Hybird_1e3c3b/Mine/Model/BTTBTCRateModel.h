//
//  BTTBTCRateModel.h
//  Hybird_1e3c3b
//
//  Created by Levy on 1/20/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTBTCRateModel : BTTBaseModel

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *btcAmount;
@property (nonatomic, copy) NSString *btcRate;
@property (nonatomic, copy) NSString *btcUuid;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *payid;

@end

NS_ASSUME_NONNULL_END
