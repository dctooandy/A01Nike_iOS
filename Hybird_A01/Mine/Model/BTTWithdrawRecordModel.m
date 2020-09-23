//
//  BTTWithdrawRecordModel.m
//  Hybird_A01
//
//  Created by Jairo on 05/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTWithdrawRecordModel.h"

@implementation BTTWithdrawRecordModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[BTTWithdrawRecordItemModel class]};
}

@end

@implementation BTTWithdrawRecordItemModel

@end
