//
//  BTTTabbarController+VoiceCall.h
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/1.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTTabbarController.h"


NS_ASSUME_NONNULL_BEGIN

typedef void (^MakeCallBlock)(NSString *uid);

@interface BTTTabbarController (VoiceCall)

- (void)loadVoiceCallNumWithIsLogin:(BOOL)isLogin makeCall:(MakeCallBlock)makeCall;

@end

NS_ASSUME_NONNULL_END
