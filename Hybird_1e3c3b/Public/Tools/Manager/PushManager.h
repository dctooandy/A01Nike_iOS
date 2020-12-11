//
//  PushManager.h
//  HybirdApp
//
//  Created by harden-imac on 2017/6/2.
//  Copyright © 2017年 harden-imac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushManager : NSObject
SingletonInterface(PushManager);

@property (nonatomic, strong) NSDictionary *notificationInfo;

- (void)performActionDidReceiveRemoteNotification:(NSDictionary *)userInfo;
- (void)didReceiveNotificationPushData;
@end
