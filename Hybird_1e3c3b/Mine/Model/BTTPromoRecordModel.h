//
//  BTTPromoRecordModel.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 04/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

@class BTTPromoRecordItemModel;

NS_ASSUME_NONNULL_BEGIN
@interface BTTPromoRecordModel : BTTBaseModel
@property (nonatomic, copy) NSString *pageNo;
@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, copy) NSString *totalPage;
@property (nonatomic, copy) NSString *totalRow;
@property (nonatomic, strong) NSArray<BTTPromoRecordItemModel *> *data;

@end

@interface BTTPromoRecordItemModel : BTTBaseModel

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *betAmount;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *deleteFlag;
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, copy) NSString *flagDesc;
@property (nonatomic, copy) NSString *itemIcon;
@property (nonatomic, copy) NSString *promotionType;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *requestId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *updateDate;

@end

NS_ASSUME_NONNULL_END
