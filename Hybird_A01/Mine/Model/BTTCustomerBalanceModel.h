//
//  BTTCustomerBalanceModel.h
//  Hybird_A01
//
//  Created by Levy on 1/7/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTCustomerBalanceModel : BTTBaseModel

@property (nonatomic, copy  ) NSString  *accountStatus;
@property (nonatomic, assign) NSInteger balance;
@property (nonatomic, assign) NSInteger bonusAmount;
@property (nonatomic, copy  ) NSString  *currency;
@property (nonatomic, copy  ) NSString  *isPwd;
@property (nonatomic, assign) NSInteger localBalance;
@property (nonatomic, copy  ) NSString  *loginName;
@property (nonatomic, assign) NSInteger maxWithdrawAmount;
@property (nonatomic, assign) NSInteger minWithdrawAmount;
@property (nonatomic, strong) NSArray   *platformBalances;
@property (nonatomic, assign) NSInteger platformTotalBalance;
@property (nonatomic, copy  ) NSString  *rate;
@property (nonatomic, assign) NSInteger remainBet;
@property (nonatomic, copy  ) NSString  *serviceCharge;
@property (nonatomic, assign) NSInteger tlbinCredit;
@property (nonatomic, strong) NSDictionary   *walletBalance;
@property (nonatomic, assign) NSInteger withdrawBal;
@property (nonatomic, assign) NSInteger yebAmount;
@property (nonatomic, assign) NSInteger yebInterest;

@end

@interface platformBanlaceModel : BTTBaseModel

@property (nonatomic, assign) CGFloat balance;
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