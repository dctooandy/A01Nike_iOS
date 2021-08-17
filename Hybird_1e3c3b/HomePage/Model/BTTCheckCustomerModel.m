//
//  BTTCheckCustomerModel.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/16/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTCheckCustomerModel.h"

@implementation BTTCheckCustomerModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"loginNames":[BTTCheckCustomerItemModel class]};
}
@end

@implementation BTTCheckCustomerItemModel

@end
