//
//  BTTInterestRecordsModel.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 5/4/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTInterestRecordsModel.h"

@implementation BTTInterestRecordsModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[BTTInterestRecordsItemModel class]};
}
@end

@implementation BTTInterestRecordsItemModel

@end
