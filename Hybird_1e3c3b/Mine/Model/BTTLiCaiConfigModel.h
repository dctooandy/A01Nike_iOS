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
//   "minAmount" : "1",
//   "configId" : "4",
//   "supportMulti" : "0",
//   "maxHours" : "8760",
//   "value" : "ALL",
//   "code" : "ALL",
//   "maxAmount" : "1000000",
//   "minHours" : "1",
//   "rate" : "0.000219178082191781",
//   "currency" : "USDT",
//   "periodHours" : "24",
//   "yearRate" : "8"
//}
@property (nonatomic, copy) NSString *minAmount;
@property (nonatomic, copy) NSString *configId;
@property (nonatomic, copy) NSString *supportMulti;
@property (nonatomic, copy) NSString *maxHours;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *maxAmount;
@property (nonatomic, copy) NSString *minHours;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *periodHours;
@property (nonatomic, copy) NSString *yearRate;
@property (nonatomic, copy) NSString *yebAmount;
@property (nonatomic, copy) NSString *yebInterest;
@end

NS_ASSUME_NONNULL_END
