//
//  BTTFirstWinningListModel.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 3/17/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTFirstWinningListModel : BTTBaseModel

@property (nonatomic, copy) NSString *bureauNo;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, copy) NSString *points;

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *betWay;

@property (nonatomic, copy) NSString *gameingRoom;

@property (nonatomic, copy) NSString *betAmount;

@property (nonatomic, copy) NSString *cardType;

@property (nonatomic, copy) NSString *ticketNo;

@property (nonatomic, copy) NSString *gameType;

@property (nonatomic, copy) NSString *winningTime;

@property (nonatomic, copy) NSString *status;
//    "bureauNo" : "1615965820740",
//                "loginName" : "g*****40",
//                "points" : "庄8闲7",
//                "amount" : "138",
//                "betWay" : "庄",
//                "gameingRoom" : "AG旗舰厅",
//                "betAmount" : "9,060.28",
//                "cardType" : "918",
//                "ticketNo" : "16159658207401",
//                "gameType" : "普通百家乐",
//                "winningTime" : "2021-03-17 15:25:26",
//                "status" : "已派发"
@end

NS_ASSUME_NONNULL_END
