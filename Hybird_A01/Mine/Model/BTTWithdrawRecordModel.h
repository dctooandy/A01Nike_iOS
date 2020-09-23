//
//  BTTWithdrawRecordModel.h
//  Hybird_A01
//
//  Created by Jairo on 05/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseModel.h"
@class BTTWithdrawRecordItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTWithdrawRecordModel : BTTBaseModel
@property (nonatomic, copy) NSString *pageNo;
@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, copy) NSString *totalPage;
@property (nonatomic, copy) NSString *totalRow;
@property (nonatomic, strong) NSArray<BTTWithdrawRecordItemModel *> *data;
@end

@interface BTTWithdrawRecordItemModel : BTTBaseModel

@property (nonatomic, copy) NSString *accountNo;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *bankAccountType;
@property (nonatomic, copy) NSString *bankCode;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *catalog;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, assign) BOOL deleteFlag;
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, copy) NSString *flagDesc;
@property (nonatomic, copy) NSString *itemIcon;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *processedDate;
@property (nonatomic, strong) NSNumber *rate;
@property (nonatomic, copy) NSString *requestId;
@property (nonatomic, copy) NSString *targetCurrency;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *transAmount;
@property (nonatomic, copy) NSString *updateDate;

@end

NS_ASSUME_NONNULL_END
