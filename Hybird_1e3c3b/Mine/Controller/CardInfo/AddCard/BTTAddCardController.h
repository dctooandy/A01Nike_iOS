//
//  BTTAddCardController.h
//  Hybird_1e3c3b
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTAddCardController : BTTCollectionViewController
@property (nonatomic, assign) BTTSafeVerifyType addCardType;
@property (nonatomic, assign) NSInteger cardCount;
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *validateId;
@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, strong) NSMutableArray *bankNamesArr;
@property (nonatomic, strong) NSMutableArray *bankIconArr;
@end

NS_ASSUME_NONNULL_END
