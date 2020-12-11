//
//  CNPayCardModel.m
//  HybirdApp
//
//  Created by cean.q on 2018/10/31.
//  Copyright © 2018年 harden-imac. All rights reserved.
//

#import "CNPayCardModel.h"

@implementation CNPayCardModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (NSString<Ignore> *)minCredit {
    return self.cardValues.firstObject;
}
@end
