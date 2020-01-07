//
//  BTTTabbarController+VoiceCall.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/1.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTTabbarController+VoiceCall.h"
#import "BTTVoiceCallModel.h"

@implementation BTTTabbarController (VoiceCall)

- (void)loadVoiceCallNumWithIsLogin:(BOOL)isLogin makeCall:(MakeCallBlock)makeCall {
    NSString *url = isLogin ? BTTVoiceCallLogin : BTTVoiceCall;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if (isLogin) {
        [params setValue:[IVNetwork savedUserInfo].loginName forKey:@"loginName"];
    }
    [IVNetwork requestPostWithUrl:url paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSDictionary *data = result.body;
            BTTVoiceCallModel *model = [BTTVoiceCallModel yy_modelWithDictionary:data];
            [[NSUserDefaults standardUserDefaults] setObject:model.uid forKey:BTTUIDKey];
            [[NSUserDefaults standardUserDefaults] setObject:model.phone_number forKey:BTTVoiceCallNumKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (makeCall) {
                makeCall(model.uid);
            }
        }
    }];
}

@end
