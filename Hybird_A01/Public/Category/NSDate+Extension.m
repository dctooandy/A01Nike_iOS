//
//  NSDate+Extension.m
//  Hybird_A01
//
//  Created by Domino on 2018/7/26.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)


/**
 判断是否是当天

 @param timestamp 秒为单位的时间戳
 @return YES/NO
 */
+ (BOOL)isToday:(NSString *)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp.longLongValue / 1000];
    return [date isToday];
}

//是否为今天
- (BOOL)isToday
{
    //self 调用这个方法的对象本身
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear ;
    
    //1.获得当前时间的 年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    //2.获得self
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
}

- (NSDate *)dateByAddingMonths:(NSInteger)months {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

@end
