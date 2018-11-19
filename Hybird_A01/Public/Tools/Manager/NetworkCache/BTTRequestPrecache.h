//
//  BTTRequestPrecache.h
//  Hybird_A01
//
//  Created by Key on 2018/11/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTTRequestPrecache : NSObject
+ (void)startUpdateCache;
+ (void)updateCacheNormal;
+ (void)updateCacheNeedLoginRequest;
@end
