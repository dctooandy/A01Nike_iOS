//
//  BTTWithdrawalController.h
//  Hybird_1e3c3b
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTBankModel.h"
#import "BTTBetInfoModel.h"
#import "BTTCustomerBalanceModel.h"
#import "KYMWithdrewCheckModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BTTWithdrawalController : BTTCollectionViewController


@property (nonatomic, copy) NSString *totalAvailable;
@property (nonatomic, copy) NSArray<BTTBankModel *> *bankList;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) BTTCustomerBalanceModel *balanceModel;
@property (nonatomic, assign) NSInteger canWithdraw;
@property (nonatomic, assign) CGFloat usdtRate;
@property (nonatomic, assign) BOOL isUSDT;
@property (nonatomic, copy) NSString *btcRate;
@property (nonatomic, copy) NSString *sellUsdtLink;
@property (nonatomic, assign) BOOL isSellUsdt;
@property (nonatomic, copy) NSString * dcboxLimit;
@property (nonatomic, copy) NSString * usdtLimit;
@property (nonatomic, copy) NSString * iChiPayLimit;
@property (nonatomic, copy) NSString * cnyLimit;
@property (nonatomic, strong) KYMWithdrewCheckModel *checkModel;
@property (nonatomic, assign) BOOL isForceNormalWithdraw; //是否为强制普通取款
@end

NS_ASSUME_NONNULL_END
