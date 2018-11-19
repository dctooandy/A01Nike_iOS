//
//  BTTBankModel.m
//  Hybird_A01
//
//  Created by Key on 2018/11/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBankModel.h"

@implementation BTTBankModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:
            @{@"bankName"           : @"bank_name",
              @"bankType"           : @"bank_account_type",
              @"bankAccount"        : @"bank_account_no_new",
              @"bankSecurityAccount": @"bank_account_no",
              @"bankAccountName"    : @"bank_account_name",
              @"branchName"         : @"branch_name",
              @"isDefault"          : @"is_default",
              @"isBTC"              : @"catalog",
              @"province"           : @"bank_country",
              @"city"               : @"bank_city"}];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"bankImage"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end
