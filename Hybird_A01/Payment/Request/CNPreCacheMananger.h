//
//  CNPreCacheMananger.h
//  A05_iPhone
//
//  Created by cean.q on 2018/10/5.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 预先缓存网络数据
 */
@interface CNPreCacheMananger : NSObject

/// 需要登录预缓存总入口
+ (void)prepareCacheDataNeedLogin;
/// 不需要登录预缓存总入口
+ (void)prepareCacheDataNormal;
@end
