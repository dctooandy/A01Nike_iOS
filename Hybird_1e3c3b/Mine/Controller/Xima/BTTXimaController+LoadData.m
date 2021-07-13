//
//  BTTXimaController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by Domino on 21/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTXimaController+LoadData.h"
#import "BTTXimaModel.h"
#import "BTTXimaItemModel.h"
#import "BTTXimaSuccessItemModel.h"
#import "BTTXimaHeaderCell.h"

@implementation BTTXimaController (LoadData)

- (void)loadMainData {
    self.selectedArray = [NSMutableArray new];
    NSDictionary *params = @{
        @"loginName":[IVNetwork savedUserInfo].loginName
    };
    [IVNetwork requestPostWithUrl:BTTXimaAmount paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        self.otherListType = BTTXimaOtherListTypeNoData;
        self.currentListType = BTTXimaCurrentListTypeNoData;
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTXimaTotalModel *model = [BTTXimaTotalModel yy_modelWithJSON:result.body];
            BTTXimaTotalModel *otherModel = [BTTXimaTotalModel yy_modelWithJSON:result.body];
            NSMutableArray *list = [[NSMutableArray alloc]init];
            NSMutableArray *otherList = [[NSMutableArray alloc]init];
            if (model.xmList.count>0) {
                for (int i=0; i<model.xmList.count; i++) {
                    if (model.xmList[i].betAmount!=0) {
                        [self.selectedArray addObject:model.xmList[i]];
                        [list addObject:model.xmList[i]];
                    }else{
                        [otherList addObject:model.xmList[i]];
                    }
                    if (i==model.xmList.count-1) {
                        model.xmList = list;
                        otherModel.xmList = otherList;
                        self.otherModel = otherModel;
                        self.validModel = model;
                        if (list.count>0) {
                            self.currentListType = BTTXimaCurrentListTypeData;
                        }
                        if (otherList.count>0) {
                            self.otherListType = BTTXimaOtherListTypeData;
                        }
                        [self setupElements];
                    }
                }
            }else{
                self.currentListType = BTTXimaCurrentListTypeNoData;
                self.otherListType = BTTXimaOtherListTypeNoData;
                [self setupElements];
            }
            
        }
    }];
    [self loadHistoryData];
}



- (void)loadHistoryData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[IVNetwork savedUserInfo].loginName forKey:@"loginName"];
    NSString *dateStr = [PublicMethod getLastWeekTime];
    NSString *startStr = [dateStr componentsSeparatedByString:@"||"][0];
    NSString *endStr = [dateStr componentsSeparatedByString:@"||"][1];
    [params setValue:startStr forKey:@"beginDate"];
    [params setValue:endStr forKey:@"endDate"];
    [params setValue:@[@0,@2] forKey:@"flags"];
    [params setValue:@1 forKey:@"inclSumAmount"];
    [params setValue:@1 forKey:@"pageNo"];
    [params setValue:@100 forKey:@"pageSize"];
    [params setValue:@1 forKey:@"inclDeleted"];
    
    [IVNetwork requestPostWithUrl:BTTXimaQueryRequest paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        self.historyListType = BTTXimaHistoryListTypeNoData;
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if ([result.body isKindOfClass:[NSDictionary class]]) {
                self.historyArray = result.body[@"data"];
                if (self.historyArray.count>0) {
                    self.historyListType = BTTXimaHistoryListTypeData;
                }else{
                    self.historyListType = BTTXimaHistoryListTypeNoData;
                }
            }
        }
    }];
}


- (void)loadXimaBillOut {
    [self showLoading];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *nowDate = [NSDate date];
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
    int weekday = 0;
    
    [baseDayComp setDay:day + firstDiff - weekday];
    NSDate *beginDate = [calendar dateFromComponents:baseDayComp];
    NSString *beginStr = [formatter stringFromDate:beginDate];
    
    [baseDayComp setDay:day - weekday + lastDiff];
    NSDate *endDate = [calendar dateFromComponents:baseDayComp];
    NSString *endStr = [formatter stringFromDate:endDate];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"isXm"] = @0;
    params[@"xmBeginDate"] = [NSString stringWithFormat:@"%@ 00:00:00",beginStr];
    params[@"xmEndDate"] = [NSString stringWithFormat:@"%@ 23:59:59",endStr];
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    NSMutableArray *array = [NSMutableArray new];
    for (BTTXimaItemModel *itemModel in self.selectedArray) {
        NSDictionary *json = @{
            @"betAmount":[NSString stringWithFormat:@"%ld",(long)itemModel.betAmount],
            @"periodXmAmount":[NSString stringWithFormat:@"%lf",itemModel.xmAmount],
            @"reduceBetAmount":@"0",
            @"totalBetAmount":[NSString stringWithFormat:@"%ld",(long)itemModel.totalBetAmont],
            @"xmAmount":[NSString stringWithFormat:@"%lf",itemModel.xmAmount],
            @"xmRate":itemModel.xmRate,
            @"xmType":itemModel.xmTypes.firstObject.xmType
        };
        [array addObject:json];
    }
    params[@"xmRequests"] = array;
    [IVNetwork requestPostWithUrl:BTTXiMaRequest paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSArray *xmResult = result.body[@"xmResult"];
            self.xmResults = [[NSMutableArray alloc] initWithArray:xmResult];
            self.ximaStatusType = BTTXimaStatusTypeSuccess;
            BTTXimaHeaderCell *cell = (BTTXimaHeaderCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell setBtnOneType:BTTXimaHeaderBtnOneTypeOtherNormal];
            [self setupElements];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}


- (NSMutableArray *)xms {
    NSMutableArray *xms = objc_getAssociatedObject(self, _cmd);
    if (!xms) {
        xms = [NSMutableArray array];
        [self setXms:xms];
    }
    return xms;
}

- (void)setXms:(NSMutableArray *)xms {
    objc_setAssociatedObject(self, @selector(xms), xms, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)xmResults {
    NSMutableArray *xmResults = objc_getAssociatedObject(self, _cmd);
    if (!xmResults) {
        xmResults = [NSMutableArray array];
        [self setXmResults:xmResults];
    }
    return xmResults;
}

- (void)setXmResults:(NSMutableArray *)xmResults {
    objc_setAssociatedObject(self, @selector(xmResults), xmResults, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



@end
