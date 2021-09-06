//
//  BTTForgetAccountStepTwoController.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/16/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTCheckCustomerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTForgetAccountStepTwoController : BTTCollectionViewController

@property (nonatomic, assign) BTTChooseForgetType forgetType;

@property (nonatomic, copy) NSArray<BTTCheckCustomerItemModel*> * itemArr;

@property (nonatomic, copy) NSString *validateId;

@property (nonatomic, copy) NSString *messageId;

@end

NS_ASSUME_NONNULL_END
