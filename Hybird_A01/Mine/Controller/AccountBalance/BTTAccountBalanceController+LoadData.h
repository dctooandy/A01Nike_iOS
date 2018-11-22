//
//  BTTAccountBalanceController+LoadData.h
//  Hybird_A01
//
//  Created by Domino on 19/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTAccountBalanceController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTAccountBalanceController (LoadData)

@property (nonatomic, strong) NSMutableArray *games;

@property (nonatomic, strong) NSMutableArray *sheetDatas;


- (void)loadGamesListAndGameAmount;

- (void)loadMainData;

- (void)loadTransferAllMoneyToLocal;

@end

NS_ASSUME_NONNULL_END
