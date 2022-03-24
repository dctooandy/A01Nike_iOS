//
//  BTTMineViewController.h
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/1.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTBindStatusModel.h"
#import "BTTShareRedirectModel.h"
#import "BTTCustomerBalanceModel.h"
#import "BTTInterestRecordsModel.h"
#import "CNPaymentModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface BTTMineViewController : BTTCollectionViewController

@property (nonatomic, assign) BOOL isShowHidden;

@property (nonatomic, strong) BTTShareRedirectModel *redirectModel;

@property (nonatomic, strong) BTTBindStatusModel *statusModel;

@property (nonatomic, copy) NSString *totalAmount;

@property (nonatomic, copy) NSString *yebAmount;

@property (nonatomic, copy) NSString *yebInterest;

@property (nonatomic, assign) BOOL isFanLi;  ///< 返利

@property (nonatomic, assign) BOOL isOpenAccount;  ///< 开户礼金

@property (nonatomic, copy) NSString *preAmount; ///< 计算余额

@property (nonatomic, copy) NSString *buyUsdtLink;
@property (nonatomic, copy) NSString *sellUsdtLink;

@property (nonatomic, assign) BOOL isLoading;  ///< 余额计算中

@property (nonatomic, assign) BOOL isShowHot;  ///< 我的優惠的 hot icon

@property (nonatomic, assign) BTTMeSaveMoneyShowType saveMoneyShowType;

@property (nonatomic, assign) NSInteger saveMoneyCount;

@property (nonatomic, assign) BTTSaveMoneyTimesType saveMoneyTimesType;

- (void)setupElements;

@property (nonatomic, strong) BTTCustomerBalanceModel *balanceModel;

@property (nonatomic, assign) BOOL isOpenSellUsdt;
@property (nonatomic, assign) BOOL isShowDepositCheck;

@property (nonatomic, copy) NSString *messageId;

@property (nonatomic, copy) NSString *validateId;

/// 撮合参数
@property (nonatomic, strong) CNPaymentModel *fastModel;
@end

NS_ASSUME_NONNULL_END
