//
//  BTTAddBTCController.h
//  Hybird_1e3c3b
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTAddBTCController : BTTCollectionViewController
@property (nonatomic, assign) BTTSafeVerifyType addCardType;
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *validateId;
@property (nonatomic, copy) NSString *accountId;
@end

NS_ASSUME_NONNULL_END
