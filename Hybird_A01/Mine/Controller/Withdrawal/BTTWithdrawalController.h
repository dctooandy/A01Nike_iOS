//
//  BTTWithdrawalController.h
//  Hybird_A01
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTBankModel.h"
#import "BTTBetInfoModel.h"
#import "BTTCustomerBalanceModel.h"
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

@end

NS_ASSUME_NONNULL_END
