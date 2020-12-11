//
//  CNPayUSDTRateModel.h
//  Hybird_1e3c3b
//
//  Created by Levy on 12/26/19.
//  Copyright © 2019 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNPayUSDTRateModel : BTTBaseModel

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *rate;

@property (nonatomic, copy) NSString *srcCurrency;

@property (nonatomic, copy) NSString *tgtAmount;

@property (nonatomic, copy) NSString *tgtCurrency;

@property (nonatomic, copy) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
