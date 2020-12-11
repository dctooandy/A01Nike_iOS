//
//  BTTQueryOnlineBankModel.h
//  Hybird_1e3c3b
//
//  Created by Levy on 1/13/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTBankAmountTypeModel : BTTBaseModel
@property (nonatomic, assign) NSInteger fix;
@property (nonatomic, strong) NSArray *amounts;
@end

@interface BTTQueryOnlineBankModel : BTTBaseModel

@property (nonatomic, strong) BTTBankAmountTypeModel *amountType;
@property (nonatomic, strong) NSArray *bankList;
@property (nonatomic, copy) NSString *maxAmount;
@property (nonatomic, copy) NSString *minAmount;
@property (nonatomic, assign) NSInteger netEarn;
@property (nonatomic, copy) NSString *payid;

@end



NS_ASSUME_NONNULL_END
