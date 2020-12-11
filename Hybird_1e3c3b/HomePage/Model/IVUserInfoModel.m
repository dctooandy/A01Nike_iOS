//
//  IVUserInfoModel.m
//  Hybird_1e3c3b
//
//  Created by Levy on 12/20/19.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "IVUserInfoModel.h"

@implementation IVUserInfoModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:
            @{@"userToken"           : @"token",
              @"phone"           : @"mobileNo",}];
}
@end
