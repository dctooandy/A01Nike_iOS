//
//  BridgeModel.m
//  MainHybird
//
//  Created by Key on 2018/6/7.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "BridgeModel.h"

@implementation BridgeModel
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    if ([propertyName isEqualToString:@"requestId"]) {
        return NO;
    }
    return YES;
}
@end
