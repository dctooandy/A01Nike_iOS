//
//  BTTPTTransferController.h
//  Hybird_A01
//
//  Created by Domino on 26/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTCustomerBalanceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTPTTransferController : BTTCollectionViewController

@property (nonatomic, copy) NSString *totalAmount;

@property (nonatomic, copy) NSString *ptAmount;

@property (nonatomic, copy) NSString *transferAmount;

@property (nonatomic, copy) NSString *gameKind;

@property (nonatomic, assign) BOOL submitBtnEnable;

@property (nonatomic, strong) BTTCustomerBalanceModel *balanceModel;
@end

NS_ASSUME_NONNULL_END
