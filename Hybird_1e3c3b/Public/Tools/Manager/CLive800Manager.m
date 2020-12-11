//
//  Live800Manager.m
//  HybirdApp
//
//  Created by harden-imac on 2017/6/3.
//  Copyright © 2017年 harden-imac. All rights reserved.
//

#import "CLive800Manager.h"
#import "Live800ChatLib.h"


@implementation CLive800Manager
SingletonImplementation(CLive800Manager);

- (void)setUpLive800WithUserInfo:(LIVUserInfo *)userModel {
    [Live800ChatLib setupLive800ChatWithSuccessBlock:^{
        NSLog(@"初始化Live800成功");
        [CLive800Manager switchLive800UserWithCustomerId:userModel];
    } failedBlock:^(NSError * _Nonnull error) {
        NSLog(@"初始化Live800失败");
    }];
}

+ (void)switchLive800UserWithCustomerId:(LIVUserInfo *)userModel {
    NSError *error = nil;
    
    if (!userModel) {
        [Live800ChatLib switchUser:nil error:&error];
    }else{
        [Live800ChatLib switchUser:userModel error:&error];
    }
    if (error) {
        NSLog(@"切换用户出错:%@",error);
    }
}

- (void)startLive800Chat:(UIViewController *)superController {
    [Live800ChatLib startService:nil superVC:superController operatorId:nil skillId:Live800SkillId subchannel:nil];
}

- (void)startLive800ChatSaveMoney:(UIViewController *)superController {
    [Live800ChatLib startService:nil superVC:superController operatorId:nil skillId:@"58" subchannel:nil];
}
//- (void)startLive800Chat:(UIViewController *)superController {
//    NSString *url = @"https://www.why918.com/chat/chatClient/chatbox.jsp?companyID=8990&configID=41&skillId=27";
//    BTTLive800ViewController *live800 = [[BTTLive800ViewController alloc] init];
//    live800.webConfigModel.url = url;
//    live800.webConfigModel.newView = YES;
//    [superController.navigationController pushViewController:live800 animated:YES];
//}
//
//- (void)startLive800ChatSaveMoney:(UIViewController *)superController {
//    NSString *url = @"https://www.why918.com/chat/chatClient/chatbox.jsp?companyID=8990&configID=41&skillId=58";
//    BTTLive800ViewController *live800 = [[BTTLive800ViewController alloc] init];
//    live800.webConfigModel.url = url;
//    live800.webConfigModel.newView = YES;
//    [superController.navigationController pushViewController:live800 animated:YES];
//}
@end
