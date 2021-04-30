//
//  BTTLiCaiTransferRecordModel.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/28/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTLiCaiTransferRecordModel.h"

@implementation BTTLiCaiTransferRecordModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[BTTLiCaiTransferRecordItemModel class]};
}
@end

@implementation BTTLiCaiTransferRecordItemModel

@end
