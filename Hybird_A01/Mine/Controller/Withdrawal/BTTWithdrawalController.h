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
NS_ASSUME_NONNULL_BEGIN

@interface BTTWithdrawalController : BTTCollectionViewController


@property (nonatomic, copy) NSString *totalAvailable;
@property (nonatomic, copy) NSArray<BTTBankModel *> *bankList;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) BTTBetInfoModel *betInfoModel;

@end

NS_ASSUME_NONNULL_END
