//
//  AppDelegate+AD.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/3.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "AppDelegate+AD.h"
#import "BTTIntroductoryPagesHelper.h"
#import "BTTAdvertiseHelper.h"

@implementation AppDelegate (AD)

- (void)setupADandWelcome {
    // 欢迎视图
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:BTTWelcomePage] boolValue]) {
        [BTTIntroductoryPagesHelper showIntroductoryPageView:@[@"intro_0.jpg", @"intro_1.jpg", @"intro_2.jpg", @"intro_3.jpg"]];
    }

    NSArray <NSString *> *imagesURLS = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495189872684&di=03f9df0b71bb536223236235515cf227&imgtype=0&src=http%3A%2F%2Fatt1.dzwww.com%2Fforum%2F201405%2F29%2F1033545qqmieznviecgdmm.gif", @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1495189851096&di=224fad7f17468c2cc080221dd78a4abf&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201505%2F12%2F20150512124019_GPjEJ.gif"];
    // 启动广告
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(BTTLaunchScreenTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [BTTAdvertiseHelper showAdvertiserView:imagesURLS];
    });
}

@end
