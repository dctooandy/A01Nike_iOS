//
//  BTTInterestRecordsModel.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 5/4/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBaseModel.h"
@class BTTInterestRecordsItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTInterestRecordsModel : BTTBaseModel
@property (nonatomic, copy) NSString *pageNo;
@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, copy) NSString *totalPage;
@property (nonatomic, copy) NSString *totalRow;
@property (nonatomic, strong) NSArray<BTTInterestRecordsItemModel *> *data;
@end

@interface BTTInterestRecordsItemModel : BTTBaseModel
@property (nonatomic, copy) NSString *bonusFlag;
@property (nonatomic, copy) NSString *configId;
@property (nonatomic, copy) NSString *createdTime;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *customerLevel;
@property (nonatomic, copy) NSString *fromTime;
@property (nonatomic, copy) NSString *interestAmount;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *toTime;
@property (nonatomic, copy) NSString *yearRate;
@property (nonatomic, copy) NSString *yebAmount;
@property (nonatomic, copy) NSString *yebBillno;
@end

NS_ASSUME_NONNULL_END
