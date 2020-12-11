//
//  BTTModifyBankRecordModel.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 22/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTModifyBankRecordModel.h"

@implementation BTTModifyBankRecordModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"accounts":[BTTModifyBankRecordItemModel class]};
}
@end

@implementation BTTModifyBankRecordItemModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"defaultBool":@"default"};
}

@end
