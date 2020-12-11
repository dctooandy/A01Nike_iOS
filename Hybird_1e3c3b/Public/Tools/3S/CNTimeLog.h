//
//  CNTimeLog.h
//  Hybird_1e3c3b
//
//  Created by cean.q on 2019/2/20.
//  Copyright © 2019 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CNEvent) {
    CNEventAppLaunch = 0,
    CNEventPayLaunch,
    CNEventAGQJLaunch,
};

NS_ASSUME_NONNULL_BEGIN

@interface CNTimeLog : NSObject

+ (instancetype)shareInstance;

/// 启动配置, 配置项目id
- (void)configProduct:(NSString *)productID;

/// 事件开始打点
- (void)startRecordTime:(CNEvent)event;
/// 事件结束打点
- (void)endRecordTime:(CNEvent)event;

/// 仅针对于AGQJ首次预加载打点，
- (void)AGQJFirstLoad;
/// AGQJ reload 打点，
- (void)AGQJReLoad;

/// 开启Debug模式，有日志
- (void)debugEnable:(BOOL)isDebug;
/// 登录名设置
- (void)setUserName:(nullable NSString *)name;
@end

NS_ASSUME_NONNULL_END
