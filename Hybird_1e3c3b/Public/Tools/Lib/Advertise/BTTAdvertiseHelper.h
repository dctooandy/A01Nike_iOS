//
//  BTTAdvertiseHelper.h
//  Hybird_1e3c3b
//
//  Created by domino on 2018/10/01.
//  Copyright © 2018年 domino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTTAdvertiseView.h"

@interface BTTAdvertiseHelper : NSObject

+ (instancetype)sharedInstance;

+ (void)showAdvertiserView:(NSArray<NSString *> *)imageArray;

@end
