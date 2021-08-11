//
//  BTTAddBitollCardController.h
//  Hybird_1e3c3b
//
//  Created by Flynn on 2020/6/2.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTAddBitollCardController : BTTBaseViewController
@property (nonatomic, copy) NSString *validateId;
@property (nonatomic, copy) NSString *messageId;
- (void)makeCallWithPhoneNum:(NSString *)phone captcha:(NSString *)captcha captchaId:(NSString *)captchaId;
@end

NS_ASSUME_NONNULL_END
