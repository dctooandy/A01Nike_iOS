//
//  BTTAddUSDTController+LoadData.h
//  Hybird_1e3c3b
//
//  Created by Domino on 24/12/2019.
//  Copyright © 2019 BTT. All rights reserved.
//


#import "BTTAddUSDTController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTAddUSDTController (LoadData)

@property (nonatomic, strong) NSMutableArray *usdtDatas;


- (void)loadUSDTData;

@end

NS_ASSUME_NONNULL_END
