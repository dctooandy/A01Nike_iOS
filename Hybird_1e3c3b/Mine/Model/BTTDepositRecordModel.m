//
//  BTTDepositRecordModel.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 25/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTDepositRecordModel.h"

@implementation BTTDepositRecordModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[BTTDepositRecordItemModel class]};
}
@end

@implementation BTTDepositRecordItemModel

@end

@implementation BTTDepositRecordExtraModel

@end
