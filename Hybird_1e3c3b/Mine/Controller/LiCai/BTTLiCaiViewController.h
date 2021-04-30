//
//  BTTLiCaiViewController.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/26/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTInterestCreditLogsModel.h"
#import "BTTCustomerBalanceModel.h"
#import "BTTLiCaiInDetailPopView.h"
#import "BTTLiCaiOutDetailPopView.h"
#import "BTTLiCaiConfigModel.h"
#import "BTTLiCaiTransferRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTLiCaiViewController : BTTCollectionViewController
@property (nonatomic, copy) NSString *walletAmount;
@property (nonatomic, copy) NSString *earn;
@property (nonatomic, copy) NSString *interestRate;
@property (nonatomic, copy) NSString *accountBalance;
@property (nonatomic, strong) BTTLiCaiInDetailPopView * inDetailPopView;
@property (nonatomic, strong) BTTLiCaiOutDetailPopView * OutDetailPopView;
@end

NS_ASSUME_NONNULL_END
