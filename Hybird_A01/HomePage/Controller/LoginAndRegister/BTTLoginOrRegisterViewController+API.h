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

- (void)loginWithAccount:(NSString *)account pwd:(NSString *)pwd isSmsCode:(BOOL)isSmsCode;

- (void)registerAction;

- (void)loadVerifyCode;

- (void)loadMobileVerifyCodeWithPhone:(NSString *)phone use:(NSInteger)use;

- (void)createAccountNormalWithAPIModel:(BTTCreateAPIModel *)model;

- (void)fastRegisterAPIModel:(BTTCreateAPIModel *)model;


@end

NS_ASSUME_NONNULL_END
