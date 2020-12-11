
//
//  BTTXimaItemModel.m
//  Hybird_1e3c3b
//
//  Created by Domino on 21/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTXimaItemModel.h"

@implementation BTTXimaTotalModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"xmList":[BTTXimaItemModel class]};
}



@end

@implementation BTTXimaItemModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"xmTypes":[BTTXimaItemModel class]};
}
@end

@implementation BTTXimaItemTypesModel

@end

@implementation BTTXimaLastWeekItemModel

@end
