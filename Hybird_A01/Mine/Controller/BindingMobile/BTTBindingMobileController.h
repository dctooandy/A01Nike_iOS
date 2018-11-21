//
//  BTTBindingMobileController.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface BTTBindingMobileController : BTTCollectionViewController

@property (nonatomic, assign) BTTSafeVerifyType mobileCodeType;
- (void)setupElements;

@end

NS_ASSUME_NONNULL_END
