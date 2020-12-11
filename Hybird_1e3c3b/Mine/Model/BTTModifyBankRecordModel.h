//
//  BTTModifyBankRecordModel.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 22/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseModel.h"
@class BTTModifyBankRecordItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTModifyBankRecordModel : BTTBaseModel
@property (nonatomic, strong) NSArray<BTTModifyBankRecordItemModel *> *accounts;
@end

@interface BTTModifyBankRecordItemModel : BTTBaseModel
@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, copy) NSString *accountNo;
@property (nonatomic, copy) NSString *accountType;
@property (nonatomic, copy) NSString *backgroundColor;
@property (nonatomic, copy) NSString *bankBranchName;
@property (nonatomic, copy) NSString *bankIcon;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *createdDate;
@property (nonatomic, assign) BOOL defaultBool;
@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, copy) NSString *lastUpdate;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *remarks;
@end

NS_ASSUME_NONNULL_END
