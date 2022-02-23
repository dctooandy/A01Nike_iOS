//
//  KYMWithdrewCheckModel.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrewCheckModel.h"

@implementation KYMWithdrewCheckModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"amountList" : [KYMWithdrewAmountModel class]};
}
@end
