//
//  BTTXmRecordModel.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 22/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseModel.h"
@class BTTXmRecordItemModel;
NS_ASSUME_NONNULL_BEGIN

@interface BTTXmRecordModel : BTTBaseModel
@property (nonatomic, copy) NSString *pageNo;
@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, copy) NSString *totalPage;
@property (nonatomic, copy) NSString *totalRow;
@property (nonatomic, strong) NSArray<BTTXmRecordItemModel *> *data;
@end

@interface BTTXmRecordItemModel : BTTBaseModel

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *auditDate;
@property (nonatomic, copy) NSString *bettingAmount;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, assign) BOOL deleteFlag;
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, copy) NSString *flagDesc;
@property (nonatomic, copy) NSString *gameKind;
@property (nonatomic, copy) NSString *gameKindName;
@property (nonatomic, copy) NSString *itemIcon;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *platformName;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *rebateMode;
@property (nonatomic, copy) NSString *requestId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *updateDate;
@end

NS_ASSUME_NONNULL_END
