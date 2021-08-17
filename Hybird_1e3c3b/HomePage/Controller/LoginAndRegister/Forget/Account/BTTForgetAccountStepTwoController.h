//
//  BTTForgetAccountStepTwoController.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/16/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
@class BTTCheckCustomerItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTForgetAccountStepTwoController : BTTCollectionViewController

@property (nonatomic, assign) BTTChooseFindWay findType;

@property (nonatomic, copy) NSArray<BTTCheckCustomerItemModel*> * itemArr;

@end

NS_ASSUME_NONNULL_END
