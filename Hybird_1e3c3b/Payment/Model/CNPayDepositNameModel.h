//
//  CNPayDepositNameModel.h
//  Hybird_1e3c3b
//
//  Created by cean.q on 2018/12/3.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNPayDepositNameModel : JSONModel
@property (nonatomic, copy) NSString *bank_name;
@property (nonatomic, copy) NSString *deposit_location;
@property (nonatomic, copy) NSString *deposit_type;
@property (nonatomic, copy) NSString *deposit_name;
@property (nonatomic, copy) NSString *request_id;
@end

NS_ASSUME_NONNULL_END
