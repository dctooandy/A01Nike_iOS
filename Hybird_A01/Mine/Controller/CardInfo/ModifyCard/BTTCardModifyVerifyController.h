//
//  BTTCardModifyVerifyController.h
//  Hybird_A01
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTCardModifyVerifyController : BTTCollectionViewController

@property (nonatomic, assign) BTTSafeVerifyType safeVerifyType;
@property(nonatomic, copy) NSString *bankNumber;

@property (nonatomic, copy) NSString *phone;
@end

NS_ASSUME_NONNULL_END
