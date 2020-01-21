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
#import <IQKeyboardManager/IQUIWindow+Hierarchy.h>
#import "IVUtility.h"
@implementation PushManager

SingletonImplementation(PushManager);

//跳转到站内信列表
- (void)pushToMsgVCWithData:(NSDictionary *)dataDict {
    if (dataDict == nil) return;
    [self setNotificationInfo: dataDict];
    UIViewController *topVC = [self currentViewController];
    if (topVC == nil) return;
    NSString *url = [dataDict objectForKey:@"url"];
    NSString *messageId = [dataDict objectForKey:@"id"];
    if (url != nil && url.length > 0) {
        if (![url hasPrefix:@"http"]) {
            url = [NSString stringWithFormat:@"%@%@",[IVHttpManager shareManager].domain,url];
        }
    } else {
        if (messageId != nil && messageId.length > 0) {
            url = [NSString stringWithFormat:@"customer/letter_detail.htm?id=%@",messageId];
        } else {
            return;
        }
    }

    if ([topVC isKindOfClass:[BTTBaseWebViewController class]]) {
        BTTBaseWebViewController *topWebVC = (BTTBaseWebViewController *)topVC;
        if (topWebVC.webConfigModel.newView) {
            topWebVC.webConfigModel.url = url;
            [topWebVC loadWebView];
            return;
        }
    }
    BTTBaseWebViewController  *webController = [[BTTBaseWebViewController alloc] init];
    webController.webConfigModel.url = url;
    webController.webConfigModel.newView = YES;
    [webController loadWebView];
    [topVC.navigationController pushViewController:webController animated:YES];
}

- (void)performActionDidReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    UIApplicationState applicationState = [UIApplication sharedApplication].applicationState;
    
    if (applicationState == UIApplicationStateActive) {
        //震动
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(1007);
    }
    NSDictionary *apsDict = [userInfo valueForKey:@"aps"];
    if (!apsDict) {
        return;
    }
    NSDictionary *dict = [apsDict valueForKey:@"data"];
    NSString *url = (dict == nil ? nil : [dict valueForKey:@"url"]);
    NSString *messageId = (dict == nil ? nil :  [userInfo valueForKey:@"id"]);
    
    if ((url && url.length > 0) || (messageId && messageId.length > 0)) {
        // 前台
        if (applicationState == UIApplicationStateActive) {
            weakSelf(weakSelf);
            IVActionHandler handler = ^(UIAlertAction *action){};
            IVActionHandler handler1 = ^(UIAlertAction *action){
                strongSelf(strongSelf)
                [strongSelf pushToMsgVCWithData:dict];
            };
            NSString *message = [apsDict valueForKey:@"alert"];
            [IVUtility showAlertWithActionTitles:@[@"取消",@"查看"] handlers:@[handler,handler1] title:@"提示" message:message];
        } else {
            [self pushToMsgVCWithData:dict];
        }
    }
    
}

- (UIViewController*)topMostWindowController
{
    UIWindow *win = [UIApplication sharedApplication].delegate.window;
    UIViewController *topController = [win rootViewController];
    if ([topController isKindOfClass:[UITabBarController class]]) {
        topController = [(UITabBarController *)topController selectedViewController];
    }
    while ([topController presentedViewController])  topController = [topController presentedViewController];
    return topController;
}

- (UIViewController*)currentViewController;
{
    UIViewController *currentViewController = [self topMostWindowController];
    
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    
    return currentViewController;
}

- (void)didReceiveNotificationPushData {
    if (self.notificationInfo == nil) return;
    [self pushToMsgVCWithData:self.notificationInfo];
}

@end
