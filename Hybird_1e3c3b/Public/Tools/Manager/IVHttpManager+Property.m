//
//  IVHttpManager+Property.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/7/20.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "IVHttpManager+Property.h"
static const char *beforeLoginDateKey = "beforeLoginDate";
static const char *registDateKey = "registDate";
@implementation IVHttpManager (Property)

- (NSString *)beforeLoginDate {
    return objc_getAssociatedObject(self, &beforeLoginDateKey);
}

- (void)setBeforeLoginDate:(NSString *)beforeLoginDate {
    objc_setAssociatedObject(self, &beforeLoginDateKey, beforeLoginDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)registDate {
    return objc_getAssociatedObject(self, &registDateKey);
}

- (void)setRegistDate:(NSString *)registDate {
    objc_setAssociatedObject(self, &registDateKey, registDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
