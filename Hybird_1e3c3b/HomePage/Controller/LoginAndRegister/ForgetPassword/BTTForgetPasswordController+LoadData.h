//
//  BTTForgetPasswordController+LoadData.h
//  Hybird_1e3c3b
//
//  Created by Domino on 15/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTForgetPasswordController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTForgetPasswordController (LoadData)

@property (nonatomic, strong) NSMutableArray *mainData;

- (void)loadMainData;

- (void)loadVerifyCode;

- (void)verifyPhotoCode:(NSString *)code loginName:(NSString *)loginName WithCaptchaId:(NSString *)captchaId completeBlock:(KYHTTPCallBack)completeBlock;

- (void)makeCallWithPhoneNum:(NSString *)phone captcha:(NSString *)captcha captchaId:(NSString *)captchaId;

@end

NS_ASSUME_NONNULL_END
