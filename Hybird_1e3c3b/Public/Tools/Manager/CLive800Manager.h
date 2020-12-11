//
//  Live800Manager.h
//  HybirdApp
//
//  Created by harden-imac on 2017/6/3.
//  Copyright © 2017年 harden-imac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LIVUserInfo.h"

@interface CLive800Manager : NSObject

SingletonInterface(CLive800Manager);

- (void)setUpLive800WithUserInfo:(LIVUserInfo *)userModel;

+ (void)switchLive800UserWithCustomerId:(LIVUserInfo *)userModel;

- (void)startLive800Chat:(UIViewController *)superController;

- (void)startLive800ChatSaveMoney:(UIViewController *)superController;

@end
