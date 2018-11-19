//
//  BTTAddCardController.h
//  Hybird_A01
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

typedef enum {
    BTTAddCardTypeNew,
    BTTAddCardTypeUpdate
}BTTAddCardType;

NS_ASSUME_NONNULL_BEGIN

@interface BTTAddCardController : BTTCollectionViewController

@property (nonatomic, assign) BTTAddCardType addCardType;
@property (nonatomic, assign) NSInteger cardCount;
@end

NS_ASSUME_NONNULL_END
