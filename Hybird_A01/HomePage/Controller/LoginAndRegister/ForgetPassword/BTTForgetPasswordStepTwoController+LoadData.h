//
//  BTTForgetPasswordStepTwoController+LoadData.h
//  Hybird_A01
//
//  Created by Domino on 15/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTForgetPasswordStepTwoController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTForgetPasswordStepTwoController (LoadData)

@property (nonatomic, strong) NSMutableArray *mainData;

- (void)loadMainData;

- (void)sendVerifyCodeWithAccount:(NSString *)account;

- (void)verifyCode:(NSString *)code account:(NSString *)account completeBlock:(KYHTTPCallBack)completeBlock;

@end

NS_ASSUME_NONNULL_END
