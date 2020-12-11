//
//  BTTVerifyTypeSelectController.h
//  Hybird_1e3c3b
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

@class BTTBankModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTVerifyTypeSelectController : BTTCollectionViewController

@property (nonatomic, assign) BTTSafeVerifyType verifyType;

@property (nonatomic, strong) BTTBankModel *bankModel;

@end

NS_ASSUME_NONNULL_END
