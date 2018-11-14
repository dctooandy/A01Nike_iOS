//
//  BTTLoginOrRegisterViewController+API.h
//  Hybird_A01
//
//  Created by Domino on 14/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTLoginOrRegisterViewController.h"
#import "BTTLoginAPIModel.h"
#import "BTTCreateAPIModel.H"

NS_ASSUME_NONNULL_BEGIN

@interface BTTLoginOrRegisterViewController (API)

- (void)login;

- (void)registerAction;

- (void)loadVerifyCode;

@end

NS_ASSUME_NONNULL_END
