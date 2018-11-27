//
//  CNCacheDataKey.m
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNCacheDataKey.h"

@implementation CNCacheDataKey

+ (NSString *)createMD5key:(NSString *)key {
    NSString *userName = [IVNetwork userInfo].loginName;
    return [IVUtility md5StringFromString:[NSString stringWithFormat:@"%@%@", userName, key]] ;
}

/// 缓存所有支付渠道的key
+ (NSString *)cacheAllPayChannelKey {
    return [self createMD5key:[NSString stringWithFormat:@"84sdd76dfxgaj%s", __func__]];
}
@end
