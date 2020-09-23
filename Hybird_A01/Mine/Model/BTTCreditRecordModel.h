//
//  BTTCreditRecordModel.h
//  Hybird_A01
//
//  Created by Jairo on 22/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseModel.h"
@class BTTCreditRecordItemModel;
NS_ASSUME_NONNULL_BEGIN

@interface BTTCreditRecordModel : BTTBaseModel
@property (nonatomic, copy) NSString *pageNo;
@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, copy) NSString *totalPage;
@property (nonatomic, copy) NSString *totalRow;
@property (nonatomic, strong) NSArray<BTTCreditRecordItemModel *> *data;
@end

@interface BTTCreditRecordItemModel : BTTBaseModel

@property (nonatomic, copy) NSString *referenceId;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *destAmount;
@property (nonatomic, copy) NSString *itemIcon;
@property (nonatomic, copy) NSString *transCode;
@property (nonatomic, copy) NSString *srcAmount;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *gameAmount;
@property (nonatomic, copy) NSString *transNo;
@property (nonatomic, copy) NSString *gameDestAmount;
@property (nonatomic, copy) NSString *beginDate;
@property (nonatomic, copy) NSString *gameSrcAmount;

@end

NS_ASSUME_NONNULL_END
