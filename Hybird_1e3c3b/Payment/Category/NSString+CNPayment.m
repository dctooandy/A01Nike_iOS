//
//  NSString+CNPayment.m
//  HybirdApp
//
//  Created by cean.q on 2018/10/11.
//  Copyright © 2018年 harden-imac. All rights reserved.
//

#import "NSString+CNPayment.h"

@implementation NSString (CNPayment)

- (NSString *)cn_thousandsFormat {
    double money = [self doubleValue];
    if (!self || money == 0) {
        return @"¥0.00";
    } else if (money < 1 && money > 0) {
        return [NSString stringWithFormat:@"¥%.2f", money];
    } else {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"¥,###.00;"];
        return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:money]];
    }
}

- (NSString *)cn_appendH5Domain {
    if (!self || self.length == 0) {
        return self;
    }
    NSMutableString *string = [self mutableCopy];
    if ([self hasPrefix:@"/"]) {
        [string deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    return [NSString stringWithFormat:@"%@%@", [IVHttpManager shareManager].domain, string];
}

- (NSString *)cn_appendCDN {
    if (!self || self.length == 0) {
        return self;
    }
    NSMutableString *string = [self mutableCopy];
    if ([self hasPrefix:@"/"]) {
        [string deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    NSString *cnd = [IVHttpManager shareManager].cdn;
    if ([cnd hasSuffix:@"/"]) {
        return [NSString stringWithFormat:@"%@%@", cnd, string];
    }
    return [NSString stringWithFormat:@"%@/%@", cnd, string];
}

+ (BOOL)isPureInt:(NSString *)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)isPureFloat:(NSString *)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

+ (nullable NSNumber *)convertNumber:(NSString *)string {
    
    if ([NSString isPureInt:string]) {
        return @([string intValue]);
    }
    
    if ([NSString isPureFloat:string]) {
        return @([string doubleValue]);
    }
    
    return nil;
}

// 根据正则，过滤特殊字符
+ (BOOL)isChineseCharacter:(NSString *)string{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:string];
}


+ (NSString *)insertSpaceToString:(NSString *)string {
    NSString *result = @"";
    
    int a = (int)string.length / 4;
    int b = (int)string.length % 4;
    int c = a;
    
    if (b > 0) {
        c = a + 1;
    } else {
        c = a;
    }
    
    for (int i = 0 ; i < c; i++) {
        NSString *temStr = @"";
        
        if (i == (c - 1) && b > 0) {
            temStr = [string substringWithRange:NSMakeRange(4 * (c - 1), b)];
        } else {
            temStr = [string substringWithRange:NSMakeRange(4 * i, 4)];
        }
        result = [NSString stringWithFormat:@"%@ %@", result, temStr];
    }
    return result;
}
@end
