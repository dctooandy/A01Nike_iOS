//
//  BTTForgetPasswordStepTwoController.h
//  Hybird_1e3c3b
//
//  Created by Domino on 15/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTForgetPwdPhoneCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTForgetPasswordStepTwoController : BTTCollectionViewController

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *validateId;
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *BindStr;
@property (nonatomic, assign) BTTChooseFindWay findType;
-(BTTForgetPwdPhoneCell *)getForgetPhoneCell;
@end

NS_ASSUME_NONNULL_END
