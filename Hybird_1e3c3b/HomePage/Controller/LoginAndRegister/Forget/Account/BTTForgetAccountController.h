//
//  BTTForgetAccountController.h
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/12/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "BTTForgetPwdPhoneCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTForgetAccountController : BTTCollectionViewController
@property (nonatomic, assign) BTTChooseFindWay findType;
@property (nonatomic, assign) BTTChooseForgetType forgetType;
@property (nonatomic, copy) NSString *messageId;
-(BTTForgetPwdPhoneCell *)getForgetPhoneCell;
@end

NS_ASSUME_NONNULL_END
