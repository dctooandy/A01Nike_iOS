//
//  KYMWithdrewCheckModel.h
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrewAmountModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KYMWithdrewCheckModel : NSObject
@property (nonatomic, strong) NSArray<KYMWithdrewAmountModel *> *amountList;
@property (nonatomic, assign) BOOL isAvaliable;
@property (nonatomic, copy) NSString *remainWithdrawTimes;
@end

NS_ASSUME_NONNULL_END
