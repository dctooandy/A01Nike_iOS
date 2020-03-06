//
//  main.m
//  Hybird_A01
//
//  Created by Domino on 2018/9/29.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AppInitializeConfig.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        if (EnvirmentType == 2) {
            [NBSAppAgent startWithAppID:TingYunAppId];
            [NBSAppAgent setRedirectURL:@"https://app.tingyunfenxi.com"];
            if ([IVNetwork savedUserInfo]) {
                NSString *userId = [IVNetwork savedUserInfo].customerId;
                [NBSAppAgent setUserIdentifier:userId];
            }
        }
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
    
