//
//  KYMWithdrewCheckModel.h
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrewAmountModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KYMWithdrewCheckDataModel : NSObject
@property (nonatomic, strong) NSArray<KYMWithdrewAmountModel *> *amountList;
@property (nonatomic, assign) BOOL isAvaliable;
@property (nonatomic, copy) NSString *remainWithdrawTimes;
@end

@interface KYMWithdrewCheckModel : NSObject
@property (nonatomic, strong) KYMWithdrewCheckDataModel *data;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *requestId;
@end

NS_ASSUME_NONNULL_END
