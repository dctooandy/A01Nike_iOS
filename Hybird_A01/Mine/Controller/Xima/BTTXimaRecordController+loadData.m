//
//  BTTXimaRecordController+loadData.m
//  Hybird_A01
//
//  Created by Domino on 10/10/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTXimaRecordController+loadData.h"
#import "BTTXimaRecordModel.h"


@implementation BTTXimaRecordController (loadData)

- (void)loadXimaDataIsLastWeek:(BOOL)isLastWeek {
    
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:nowDate];
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    // 获取几天是几号
    NSInteger day = [comp day];
    // 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    //    weekDay = 1; weekDay == 1 == 周日
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 0;
    }
    else
    {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        lastDiff = 8 - weekDay;
    }
    // 在当前日期(去掉时分秒)基础上加上差的天数
    NSDateComponents *baseDayComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  fromDate:nowDate];
    
    int weekday = isLastWeek ? 7 : 0;
    NSInteger countNumber = isLastWeek ? lastDiff : 0;
    
    NSString *dateStr = @"";
    for (NSInteger i=firstDiff; i<=countNumber; i++) {
        [baseDayComp setDay:day + i - weekday];
        NSDate *dayOfWeek = [calendar dateFromComponents:baseDayComp];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        if (i==countNumber) {
            dateStr = [dateStr stringByAppendingString:[formatter stringFromDate:dayOfWeek]];
            [self requestDataWithStr:dateStr isLastWeek:isLastWeek];
        }else{
            dateStr = [dateStr stringByAppendingString:[formatter stringFromDate:dayOfWeek]];
            dateStr = [dateStr stringByAppendingString:@"#"];
        }
    }
    
    
    
    
    
}

- (void)requestDataWithStr:(NSString *)dateStr isLastWeek:(BOOL)isLastWeek{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"dayGroup"] = dateStr;
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
//    NSDictionary *params = @{
//        @"dayGroup":dateStr,
//        @"loginName":[IVNetwork savedUserInfo].loginName
//    };
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTXiMaHistoryListUrl paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTXimaRecordModel *model = [BTTXimaRecordModel yy_modelWithDictionary:result.body];
            self.model = model;
            [self setupElements];
        }
    }];
}

@end
