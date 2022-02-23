//
//  KYMGetWithdrewDetailModel.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMGetWithdrewDetailModel.h"

@implementation KYMGetWithdrewDetailDataModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation KYMGetWithdrewDetailModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [KYMGetWithdrewDetailDataModel class]};
}
- (void)setData:(KYMGetWithdrewDetailDataModel *)data
{
    _data = data;
}
@end
