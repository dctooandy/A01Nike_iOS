//
//  BTTAccountBalanceController.h
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTAccountBalanceController : BTTCollectionViewController


@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *localAmount;

@property (nonatomic, copy) NSString *hallAmount;

@property (nonatomic, assign) BOOL isLoadingData;

@end

NS_ASSUME_NONNULL_END
