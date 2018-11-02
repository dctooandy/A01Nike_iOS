//
//  BTTTabbarController+VoiceCall.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/1.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTTabbarController.h"

typedef void (^MakeCallBlock)(NSString *uid);

NS_ASSUME_NONNULL_BEGIN

@interface BTTTabbarController (VoiceCall)

- (void)loadVoiceCallNumWithIsLogin:(BOOL)isLogin makeCall:(MakeCallBlock)makeCall;

@end

NS_ASSUME_NONNULL_END
