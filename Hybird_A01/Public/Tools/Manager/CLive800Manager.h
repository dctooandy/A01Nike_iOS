//
//  Live800Manager.h
//  HybirdApp
//
//  Created by harden-imac on 2017/6/3.
//  Copyright © 2017年 harden-imac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CLive800Manager : NSObject

SingletonInterface(CLive800Manager);

- (void)setUpLive800;

+ (void)switchLive800UserWithCustomerId:(NSString *)customerid;

- (void)startLive800Chat:(UIViewController *)superController;

@end
