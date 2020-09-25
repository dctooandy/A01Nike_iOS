//
//  BTTXmTransferRecordModel.m
//  Hybird_A01
//
//  Created by Jairo on 24/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTXmTransferRecordModel.h"

@implementation BTTXmTransferRecordModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[BTTXmTransferRecordItemModel class]};
}
@end

@implementation BTTXmTransferRecordItemModel

@end
