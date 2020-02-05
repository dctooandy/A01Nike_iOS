//
//  BTTChangeMobileSuccessController.h
//  Hybird_A01
//
//  Created by Domino on 19/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTChangeMobileSuccessController : BTTCollectionViewController
@property (nonatomic, assign) BTTSafeVerifyType mobileCodeType;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *email;
@end

NS_ASSUME_NONNULL_END
