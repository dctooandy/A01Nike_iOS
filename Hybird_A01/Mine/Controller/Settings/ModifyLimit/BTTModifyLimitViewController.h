//
//  BTTModifyLimitViewController.h
//  Hybird_A01
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTModifyLimitViewController : BTTCollectionViewController
@property (nonatomic, copy) NSString *aginStr;

@property (nonatomic, copy) NSString *bbinStr;

@property (nonatomic, strong) NSArray *agin;

@property (nonatomic, strong) NSArray *bbin;
@end

NS_ASSUME_NONNULL_END
