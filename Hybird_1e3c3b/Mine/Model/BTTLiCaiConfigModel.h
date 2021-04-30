//
//  BTTLiCaiConfigModel.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/29/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTLiCaiConfigModel : BTTBaseModel
//{
//    "maxHours" : "24",
//    "minAmount" : "1",
//    "minHours" : "1",
//    "rate" : "0.000273972602739726"
//}
@property (nonatomic, copy) NSString *maxHours;
@property (nonatomic, copy) NSString *minAmount;
@property (nonatomic, copy) NSString *minHours;
@property (nonatomic, copy) NSString *rate;
@end

NS_ASSUME_NONNULL_END
