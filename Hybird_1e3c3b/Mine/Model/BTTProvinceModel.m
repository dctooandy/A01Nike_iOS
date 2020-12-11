//
//  BTTProvinceModel.m
//  Hybird_1e3c3b
//
//  Created by Domino on 24/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTProvinceModel.h"

@implementation BTTProvinceModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"citylist":[BTTCityModel class]};
}

@end

@implementation BTTCityModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"arealist":[BTTAreaModel class]};
}

@end

@implementation BTTAreaModel


@end
