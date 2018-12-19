//
//  main.m
//  Hybird_A01
//
//  Created by Domino on 2018/9/29.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <tingyunApp/NBSAppAgent.h>
#import "AppInitializeConfig.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
#if !DEBUG
    if (EnvirmentType == 2) {
        [NBSAppAgent startWithAppID:TingYunAppId];
        [NBSAppAgent setRedirectURL:@"https://app.tingyunfenxi.com"];
        if ([IVNetwork userInfo]) {
            NSString *userId = [@([IVNetwork userInfo].customerId) stringValue];
            [NBSAppAgent setUserIdentifier:userId];
        }
    }
#endif
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
    
