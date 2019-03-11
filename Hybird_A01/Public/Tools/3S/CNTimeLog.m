//
//  CNTimeLog.m
//  Hybird_A01
//
//  Created by cean.q on 2019/2/20.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "CNTimeLog.h"
#import <IN3SAnalytics/IN3SAnalytics.h>

@interface CNTimeLog ()
@property (nonatomic, strong) NSDate *appLaunch;
@property (nonatomic, strong) NSDate *payLaunch;
@property (nonatomic, strong) NSDate *AGINLaunch;
@property (nonatomic, strong) NSDate *AGQJLaunch;
@end

@implementation CNTimeLog

+ (instancetype)shareInstance {
    static CNTimeLog *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CNTimeLog alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(toGame:) name:@"FinishLoginGame" object:nil];
    });
    return instance;
}

- (void)start {
    [IN3SAnalytics configureSDKWithProduct:@"A01"];
}

- (void)startRecordTime:(CNEvent)event {
    switch (event) {
        case CNEventAppLaunch:
            self.appLaunch = [NSDate date];
            break;
            
        case CNEventPayLaunch:
            self.payLaunch = [NSDate date];
            break;
            
//        case CNEventAGINLaunch:
//            self.AGINLaunch = [NSDate date];
//            break;
            
        case CNEventAGQJLaunch:
            self.AGQJLaunch = [NSDate date];
            break;
    }
}

- (void)AGQJFirstLoad {
    [self recordAGQJTime:YES];
}

- (void)AGQJReLoad {
    [self recordAGQJTime:NO];
}

- (void)recordAGQJTime:(BOOL)isPreload {
    self.AGQJLaunch = [NSDate date];
    NSTimeInterval duration = [self.AGQJLaunch timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", duration];
    // 加载即上报数据
    [IN3SAnalytics loadAGQJWithResponseTime:0 isPreload:NO isFinishedPreload:NO msg:@"" timestamp:timeString];
}

- (void)endRecordTime:(CNEvent)event {
    NSDate *endDate = [NSDate date];
    NSDate *beginDate = nil;
    NSString *eventName = nil;
    switch (event) {
        case CNEventAppLaunch:
            beginDate = self.appLaunch;
            eventName = @"App启动";
            break;
            
        case CNEventPayLaunch:
            beginDate = self.payLaunch;
            eventName = @"进支付";
            break;

//        case CNEventAGINLaunch:
//            beginDate = self.AGINLaunch;
//            eventName = @"进AGIN";
//            break;
    
        case CNEventAGQJLaunch:
            beginDate = self.AGQJLaunch;
            eventName = @"进AGQJ";
            break;
    }
    
    if (!beginDate) {
        return;
    }
    // 耗时间隔毫秒
    NSTimeInterval duration = [endDate timeIntervalSinceDate:beginDate] * 1000;
    NSLog(@"%@耗时：%f毫秒", eventName, duration);
    NSString *timeString = [NSString stringWithFormat:@"%f", [beginDate timeIntervalSince1970]];
    
    switch (event) {
            case CNEventAppLaunch:
            [IN3SAnalytics launchFinished:timeString];
            self.appLaunch = nil;
            break;
            
            case CNEventPayLaunch:
            [IN3SAnalytics enterPageWithName:@"PaymentPageLoad" responseTime:duration timestamp:timeString];
            self.payLaunch = nil;
            break;
            
//            case CNEventAGINLaunch:
//            self.AGINLaunch = nil;
//            break;
            
            case CNEventAGQJLaunch:
            // 仅预加载完成后，再次进入才会到这里 isPreload: 已经加载完成（参数意思有差异）
            [IN3SAnalytics loadAGQJWithResponseTime:duration isPreload:YES isFinishedPreload:NO msg:@""  timestamp:timeString];
            self.AGQJLaunch = nil;
            break;
    }
}

- (void)toGame:(NSNotification *)notification {
    // 在AGQJController.m Line62 发的通知
    
    // 这时候需要判断AGQJ游戏状态：加载中和失败不需要发送，仅成功发送
    if ([IVGameManager sharedManager].agqjVC.loadStatus == IVGameLoadStatusSuccess) {
        [self endRecordTime:CNEventAGQJLaunch];
    }
}

- (void)debugEnable:(BOOL)isDebug {
    [IN3SAnalytics debugEnable:isDebug];
}

- (void)setUserName:(NSString *)name {
    [IN3SAnalytics setUserName:name];
}
@end
