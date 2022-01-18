//
//  RedPacketsInfoModel.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2022/1/17.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RedPacketsInfoModel : BTTBaseModel
@property (nonatomic, copy) NSString *preStatus;//预热状态(0 未开始;1 进行中,2 已结束)
@property (nonatomic, copy) NSString *preStartAt;//预热开始时间,格式:Y-m-d H:i:s
@property (nonatomic, copy) NSString *preEndAt;//预热结束时间,格式:Y-m-d H:i:s

@property (nonatomic, copy) NSString *status;//活动状态(0 未开始;1 进行中,2 已结束)
@property (nonatomic, copy) NSString *startAt;//开始时间,格式:Y-m-d H:i:s
@property (nonatomic, copy) NSString *endAt;//结束时间,格式:Y-m-d H:i:s

@property (nonatomic, copy) NSString *firstStartAt;//第一次红包雨开始的时间点,格式:H:i:s
@property (nonatomic, copy) NSString *firstEndAt;//第一次红包雨结束的时间点,格式:H:i:s
@property (nonatomic, copy) NSString *firstLatestOpeningAt;//第一次红包雨打开红包的最晚时间点,格式:H:i:s

@property (nonatomic, copy) NSString *secondStartAt;//第二次红包雨开始的时间点,格式:H:i:s
@property (nonatomic, copy) NSString *secondEndAt;//第二次红包雨结束的时间点,格式:H:i:s
@property (nonatomic, copy) NSString *secondLatestOpeningAt;//第二次红包雨打开红包的最晚时间点,格式:H:i:s

//活动未开始表示距离活动开始的剩余秒数；活动已开始表示距离最近的一次红包雨开始的剩余秒数，活动结束则为
@property (nonatomic, copy) NSString *leftTime;
//leftTime值的格式化
@property (nonatomic, copy) NSString *leftTimeStr;
@end

NS_ASSUME_NONNULL_END
