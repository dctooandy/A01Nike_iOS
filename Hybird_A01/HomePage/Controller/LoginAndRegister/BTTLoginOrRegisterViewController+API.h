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

- (void)loginWithAccount:(NSString *)account pwd:(NSString *)pwd isSmsCode:(BOOL)isSmsCode codeStr:(NSString *)codeStr;

- (void)verifySmsCodeCorrectWithAccount:(NSString *)account code:(NSString *)code;

- (void)loadVerifyCode;

- (void)loadMobileVerifyCodeWithPhone:(NSString *)phone use:(NSInteger)use;

- (void)createAccountNormalWithAPIModel:(BTTCreateAPIModel *)model;

- (void)checkLoginNameWithAccount:(NSString *)account password:(NSString *)password;

- (void)MobileNoAndCodeRegisterAPIModel:(BTTCreateAPIModel *)model;

- (void)onekeyRegisteAccount;
@end

NS_ASSUME_NONNULL_END
