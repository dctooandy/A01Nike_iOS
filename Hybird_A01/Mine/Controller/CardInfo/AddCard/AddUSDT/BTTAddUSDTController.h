//
//  BTTAddUSDTController.h
//  Hybird_A01
//
//  Created by Domino on 24/12/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTAddUSDTController : BTTCollectionViewController
@property (nonatomic, assign) BTTSafeVerifyType addCardType;
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *validateId;
@end

NS_ASSUME_NONNULL_END
