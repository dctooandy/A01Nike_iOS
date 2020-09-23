//
//  BTTXmRecordModel.m
//  Hybird_A01
//
//  Created by Jairo on 22/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTXmRecordModel.h"

@implementation BTTXmRecordModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[BTTXmRecordItemModel class]};
}
@end

@implementation BTTXmRecordItemModel

@end
