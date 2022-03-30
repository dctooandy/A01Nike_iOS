//
//  BTTDepositRecordModel.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 25/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseModel.h"
#import "CNMBankModel.h"

@class BTTDepositRecordExtraModel;
@class BTTDepositRecordItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTDepositRecordModel : BTTBaseModel
@property (nonatomic, copy) NSString *pageNo;
@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, copy) NSString *totalPage;
@property (nonatomic, copy) NSString *totalRow;
@property (nonatomic, strong) BTTDepositRecordExtraModel * extra;
@property (nonatomic, strong) NSArray<BTTDepositRecordItemModel *> *data;
@end

@interface BTTDepositRecordItemModel : BTTBaseModel

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *arrivalAmount;
@property (nonatomic, copy) NSString *bankAccountNo;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, assign) BOOL deleteFlag;
@property (nonatomic, copy) NSString *fee;
@property (nonatomic, copy) NSString * feeRate;
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, copy) NSString *flagDesc;
@property (nonatomic, copy) NSString *itemIcon;
@property (nonatomic, copy) NSString *orderSource;
@property (nonatomic, copy) NSString *payTypeIcon;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *remindFlag;
@property (nonatomic, copy) NSString *requestId;
@property (nonatomic, copy) NSString *sourceCurrency;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *transAmount;
@property (nonatomic, copy) NSString *transCode;


@property (nonatomic, copy) NSString *referenceId;
@property (nonatomic, assign) CNMPayBillStatus mmStatus;
@end

@interface BTTDepositRecordExtraModel : BTTBaseModel

@property (nonatomic, copy) NSString *sumAmount1;
@property (nonatomic, copy) NSString *sumAmount2;
@property (nonatomic, copy) NSString *sumBtc;
@property (nonatomic, copy) NSString *sumAmount;

@end

NS_ASSUME_NONNULL_END
