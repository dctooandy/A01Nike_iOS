//
//  BTTLoginOrRegisterViewController+API.h
//  Hybird_1e3c3b
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


- (void)MobileNoAndCodeRegisterAPIModel:(BTTCreateAPIModel *)model;

- (void)onekeyRegisteAccount;

-(void)checkChineseCaptcha:(NSString *)captchaStr;

-(void)loginWith2FA:(NSDictionary *)resultDic smsCode:(NSString *)smsCode model:(BTTLoginAPIModel *)model isBack:(BOOL)isback;

@property (nonatomic, strong) UIAlertAction *confirm;
@property (nonatomic, strong) BTTLoginAPIModel *exModel;
@end

NS_ASSUME_NONNULL_END
