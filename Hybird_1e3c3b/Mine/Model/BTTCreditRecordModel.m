//
//  BTTCreditRecordModel.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 22/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTCreditRecordModel.h"

@implementation BTTCreditRecordModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[BTTCreditRecordItemModel class]};
}
@end

@implementation BTTCreditRecordItemModel

@end
