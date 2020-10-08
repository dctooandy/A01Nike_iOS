//
//  AppDelegate.h
//  Hybird_A01
//
//  Created by Domino on 2018/9/29.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)reSendIVPushRequestIpsSuperSign:(NSString *)customerId;

-(void)jumpToTabIndex:(NSInteger )type;

@end

