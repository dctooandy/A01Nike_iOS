//
//  BTTWithdrawalController+LoadData.h
//  Hybird_A01
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTWithdrawalController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTWithdrawalController (LoadData)

- (void)loadMainData;

@property (nonatomic, strong) NSMutableArray *sheetDatas;

- (void)loadCreditsTotalAvailable;

- (void)requestSellUsdtSwitch;

-(void)getLimitUSDT;

@end

NS_ASSUME_NONNULL_END
