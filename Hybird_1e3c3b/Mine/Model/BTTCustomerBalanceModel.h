//
//  BTTCustomerBalanceModel.h
//  Hybird_1e3c3b
//
//  Created by Levy on 1/7/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTCustomerBalanceModel : BTTBaseModel

@property (nonatomic, copy) NSString *accountStatus;
@property (nonatomic, assign) double balance;
@property (nonatomic, assign) NSInteger bonusAmount;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *isPwd;
@property (nonatomic, assign) double localBalance;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *maxWithdrawAmount;
@property (nonatomic, copy) NSString *minWithdrawAmount;
@property (nonatomic, strong) NSArray *platformBalances;
@property (nonatomic, copy) NSString *platformTotalBalance;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, assign) NSInteger remainBet;
@property (nonatomic, copy) NSString *serviceCharge;
@property (nonatomic, assign) NSInteger tlbinCredit;
@property (nonatomic, strong) NSDictionary *walletBalance;
@property (nonatomic, assign) double withdrawBal;
@property (nonatomic, assign) NSInteger yebAmount;
@property (nonatomic, assign) NSInteger yebInterest;

@end

@interface platformBanlaceModel : BTTBaseModel

@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *gameKind;
@property (nonatomic, copy) NSString *platformCode;
@property (nonatomic, copy) NSString *platformName;

@end

@interface walletBanlaceModel : BTTBaseModel
@property (nonatomic, assign) NSInteger nonWithDrawable;
@property (nonatomic, assign) NSInteger promotion;
@property (nonatomic, assign) NSInteger withdrawable;
@end

NS_ASSUME_NONNULL_END
