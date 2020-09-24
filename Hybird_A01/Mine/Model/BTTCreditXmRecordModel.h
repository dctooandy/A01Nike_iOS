//
//  BTTCreditXmRecordModel.h
//  Hybird_A01
//
//  Created by Jairo on 24/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseModel.h"
@class BTTCreditXmRecordItemModel;
NS_ASSUME_NONNULL_BEGIN

@interface BTTCreditXmRecordModel : BTTBaseModel

@property (nonatomic, copy) NSString *pageNo;
@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, copy) NSString *totalPage;
@property (nonatomic, copy) NSString *totalRow;
@property (nonatomic, strong) NSArray<BTTCreditXmRecordItemModel *> *data;
@end

@interface BTTCreditXmRecordItemModel : BTTBaseModel

@property (nonatomic, copy) NSString *sourceCredit;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *createdDate;
@property (nonatomic, copy) NSString *targetCredit;
@property (nonatomic, copy) NSString *sourceLoginName;
@property (nonatomic, copy) NSString *requestId;
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, copy) NSString *targetLoginName;
@property (nonatomic, copy) NSString *srcCurrency;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *auditDate;
@property (nonatomic, copy) NSString *tgtCurrency;
@end

NS_ASSUME_NONNULL_END

