//
//  NSDate+Extension.h
//  Hybird_A01
//
//  Created by Domino on 2018/7/26.
//  Copyright © 2018年 Key. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/**
 判断是否是当天
 
 @param timestamp 秒为单位的时间戳
 @return YES/NO
 */
+ (BOOL)isToday:(NSString *)timestamp;

- (NSDate *)dateByAddingMonths:(NSInteger)months;

@end
