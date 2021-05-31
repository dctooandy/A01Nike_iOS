//
//  CNPayOrderModelV2.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/5/26.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "JSONModel.h"

@interface CNPayOrderModelV2 : JSONModel
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *amount;

@property(nonatomic, copy) NSString *billNo;
@property(nonatomic, copy) NSString *crc;
@property(nonatomic, copy) NSString *refAmount;
@property(nonatomic, copy) NSString *refCurrency;
@property(nonatomic, copy) NSString *refRate;

@end
