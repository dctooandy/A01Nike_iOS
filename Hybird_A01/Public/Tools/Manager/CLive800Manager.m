//
//  Live800Manager.m
//  HybirdApp
//
//  Created by harden-imac on 2017/6/3.
//  Copyright © 2017年 harden-imac. All rights reserved.
//

#import "CLive800Manager.h"
#import "Live800ChatLib.h"
#import "LIVUserInfo.h"

@implementation CLive800Manager
SingletonImplementation(CLive800Manager);

- (void)setUpLive800 {
    [Live800ChatLib setupLive800ChatWithSuccessBlock:^{
        NSLog(@"初始化Live800成功");
    } failedBlock:^(NSError * _Nonnull error) {
        NSLog(@"初始化Live800失败");
    }];
}

+ (void)switchLive800UserWithCustomerId:(NSString *)customerid {
    NSError *error = nil;
    
    if ([NSString isBlankString:customerid]) {
        [Live800ChatLib switchUser:nil error:&error];
    }else{
        LIVUserInfo *userInfo = [[LIVUserInfo alloc] init];
        userInfo.userAccount = customerid;
        [Live800ChatLib switchUser:userInfo error:&error];
    }
    if (error) {
        NSLog(@"切换用户出错:%@",error);
    }
}

- (void)startLive800Chat:(UIViewController *)superController {
    [Live800ChatLib startService:nil superVC:superController operatorId:nil skillId:Live800SkillId subchannel:nil];
}
@end
