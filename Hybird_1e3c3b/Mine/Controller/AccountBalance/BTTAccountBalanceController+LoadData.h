//
//  BTTAccountBalanceController+LoadData.h
//  Hybird_1e3c3b
//
//  Created by Domino on 19/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTAccountBalanceController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTAccountBalanceController (LoadData)

@property (nonatomic, strong) NSMutableArray *games;

@property (nonatomic, strong) NSMutableArray *sheetDatas;


- (void)loadGamesListAndGameAmount:(UIButton *)button;

- (void)loadMainData;

- (void)loadTransferAllMoneyToLocal:(UIButton *)button;

@end

NS_ASSUME_NONNULL_END
