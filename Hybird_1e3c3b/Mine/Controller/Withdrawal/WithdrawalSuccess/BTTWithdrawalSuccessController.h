//
//  BTTWithdrawalSuccessController.h
//  Hybird_1e3c3b
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTWithdrawalSuccessController : BTTCollectionViewController
@property(nonatomic, copy)NSString *amount;
@property (nonatomic, assign) BOOL isSell;
@property (nonatomic, copy) NSString *sellLink;
@end

NS_ASSUME_NONNULL_END
