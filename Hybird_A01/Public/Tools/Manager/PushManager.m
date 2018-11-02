//
//  PushManager.m
//  HybirdApp
//
//  Created by harden-imac on 2017/6/2.
//  Copyright © 2017年 harden-imac. All rights reserved.
//

#import "PushManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BTTTabbarController.h"
#import "BTTBaseWebViewController.h"

@implementation PushManager

SingletonImplementation(PushManager);

//跳转到站内信列表
- (void)pushToMsgVCWithMsgId:(NSDictionary *)userInfo {
    if (userInfo == nil) return;
    [self setNotificationInfo: userInfo];
    BTTTabbarController *tabbarVC = (BTTTabbarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    if (tabbarVC == nil) return;
    
    BTTBaseWebViewController *topWebVC = (BTTBaseWebViewController *)tabbarVC.selectedViewController;
    if (topWebVC == nil) return;
    // 新页面reload
    NSString *url = nil;
    if (topWebVC.webConfigModel.newView) {
        NSDictionary *dict = [userInfo objectForKey:@"data"];
        url = (dict == nil ? nil : [dict objectForKey:@"url"]);
        if (url != nil && url.length > 0) {
            url = [NSString stringWithFormat:@"%@%@", [IVNetwork gameDomain], url];
        } else {
            NSString *messageId = [userInfo objectForKey:@"id"];
            url = [NSString stringWithFormat:@"customer/letter_detail.htm?id=%@",messageId];
        }
        topWebVC.webConfigModel.url = url;
        [topWebVC loadWebView];
    } else {
        NSDictionary *dict = [userInfo objectForKey:@"data"];
        NSString *url = (dict == nil ? nil : [dict objectForKey:@"url"]);
        if (url != nil && url.length > 0) {
            url = [NSString stringWithFormat:@"%@%@", [IVNetwork gameDomain], url];;
        } else {
            NSString *messageId = [userInfo objectForKey:@"id"];
            url = [NSString stringWithFormat:@"customer/letter_detail.htm?id=%@",messageId];
        }
        BTTBaseWebViewController  *webController = [[BTTBaseWebViewController alloc] init];
        webController.webConfigModel.url = url;
        webController.webConfigModel.newView = YES;
        [webController loadWebView];
        [topWebVC.navigationController pushViewController:webController animated:YES];
    }
}

- (void)performActionDidReceiveRemoteNotification:(NSDictionary *)userInfo {
    UIApplicationState applicationState = [UIApplication sharedApplication].applicationState;
    // 前台
    if (applicationState == UIApplicationStateActive) {
         //震动
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(1007);
        weakSelf(weakSelf);
        IVActionHandler handler = ^(UIAlertAction *action){};
        IVActionHandler handler1 = ^(UIAlertAction *action){
            strongSelf(strongSelf)
            if ([userInfo objectForKey:@"id"] != nil) {
                [strongSelf pushToMsgVCWithMsgId:userInfo];
            }
        };
        NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        [IVUtility showAlertWithActionTitles:@[@"取消",@"查看"] handlers:@[handler,handler1] title:@"提示" message:message];
    } else {
        if ([userInfo objectForKey:@"id"] != nil) {
            [self pushToMsgVCWithMsgId:userInfo];
        }
    }
}
- (void)didReceiveNotificationPushData {
    if (self.notificationInfo == nil) return;
    [self pushToMsgVCWithMsgId:self.notificationInfo];
}

@end
