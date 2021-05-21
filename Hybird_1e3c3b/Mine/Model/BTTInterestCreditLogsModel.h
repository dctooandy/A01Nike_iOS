//
//  BTTInterestCreditLogsModel.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/29/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseModel.h"
@class BTTInterestCreditLogsItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTInterestCreditLogsModel : BTTBaseModel
//body:{
//    "data" : [
//              {
//        "amount" : "10",
//        "afterAmount" : "10",
//        "changeType" : "1",
//        "createdTime" : "2021-04-29 16:20:33",
//        "beforeAmount" : "0",
//        "refrenceId" : "5011210429162165001"
//    }
//              ],
//    "totalRow" : 1,
//    "pageSize" : 15,
//    "totalPage" : 1,
//    "pageNo" : 1
//}
@property (nonatomic, copy) NSString *pageNo;
@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, copy) NSString *totalPage;
@property (nonatomic, copy) NSString *totalRow;
@property (nonatomic, strong) NSArray<BTTInterestCreditLogsItemModel *> *data;

@end

@interface BTTInterestCreditLogsItemModel : BTTBaseModel

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *afterAmount;
@property (nonatomic, copy) NSString *changeType;
@property (nonatomic, copy) NSString *createdTime;
@property (nonatomic, copy) NSString *beforeAmount;
@property (nonatomic, copy) NSString *refrenceId;

@end

NS_ASSUME_NONNULL_END
