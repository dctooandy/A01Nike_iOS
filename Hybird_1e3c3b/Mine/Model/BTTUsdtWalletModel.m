//
//  BTTUsdtWalletModel.m
//  Hybird_1e3c3b
//
//  Created by Levy on 1/9/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTUsdtWalletModel.h"

@implementation BTTUsdtWalletModel
+ (NSDictionary *)modelCustomPropertyMapper {
   // 将personId映射到key为id的数据字段
    return @{@"wid":@"id"};
   // 映射可以设定多个映射字段
   //  return @{@"personId":@[@"id",@"uid",@"ID"]};
}
@end
