//
//  HAInitConfig.h
//  Hybird_A03
//
//  Created by Key on 2018/10/8.
//  Copyright © 2018年 Key. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppInitializeConfig.h"

@interface HAInitConfig : NSObject
+ (NSString *)bundleId;
+ (NSArray *)gateways;
+ (NSString *)defaultH5Domain;
+ (NSString *)appKey;
+ (NSString *)appId;
+ (NSString *)socketIp;
+ (NSString *)socketPort;
+ (NSString *)productId;
+ (NSString *)defaultCDN;
@end
