//
//  BTTLiCaiTransferRecordModel.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/28/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseModel.h"
@class BTTLiCaiTransferRecordItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTLiCaiTransferRecordModel : BTTBaseModel
//{
//    "interestAmount" : "0",
//    "createdTime" : "2021-04-28 09:16:47",
//    "totalInterest" : "0",
//    "amount" : "10",
//    "transferInTime" : "2021-04-28 09:16:47",
//    "requestId" : "5011210428091765001",
//    "billno" : "A01292104280917AA01",
//    "transferType" : "1",
//    "countInterest" : "0",
//    "acturalBeginTime" : "2021-04-28 09:17:53",
//    "expectEndTime" : "2021-04-29 09:17:53",
//    "finalInterestAmt" : "0",
//    "status" : "1"
//}
@property (nonatomic, copy) NSString *pageNo;
@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, copy) NSString *totalPage;
@property (nonatomic, copy) NSString *totalRow;
@property (nonatomic, strong) NSArray<BTTLiCaiTransferRecordItemModel *> *data;

@end

@interface BTTLiCaiTransferRecordItemModel : BTTBaseModel

@property (nonatomic, copy) NSString *interestAmount;
@property (nonatomic, copy) NSString *createdTime;
@property (nonatomic, copy) NSString *totalInterest;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *transferInTime;
@property (nonatomic, copy) NSString *transferOutTime;
@property (nonatomic, copy) NSString *requestId;
@property (nonatomic, copy) NSString *billno;
@property (nonatomic, copy) NSString *transferType;
@property (nonatomic, copy) NSString *countInterest;
@property (nonatomic, copy) NSString *acturalBeginTime;
@property (nonatomic, copy) NSString *expectEndTime;
@property (nonatomic, copy) NSString *finalInterestAmt;
@property (nonatomic, copy) NSString *status;


@end

NS_ASSUME_NONNULL_END
