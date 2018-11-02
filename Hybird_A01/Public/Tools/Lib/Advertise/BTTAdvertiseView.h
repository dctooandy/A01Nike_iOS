//
//  BTTAdvertiseView.h
//  Hybird_A01
//
//  Created by domino on 2018/10/01.
//  Copyright © 2018年 domino. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BTTSkipButtonType) {
    BTTSkipButtonTypeNormalTimeAndText = 0,      //普通的倒计时+跳过
    BTTSkipButtonTypeCircleAnimationTest,        //圆形动画+跳过
    BTTSkipButtonTypeNormalText,                 //只有普通的跳过
    BTTSkipButtonTypeNormalTime,                 //只有普通的倒计时
    BTTSkipButtonTypeNone                        //无
};


UIKIT_EXTERN NSString *const NotificationContants_Advertise_Key;

@interface BTTAdvertiseView : UIView

/** 显示广告页面方法*/
- (void)show;

/** 图片路径*/
@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, assign) BTTSkipButtonType skipType;  // 跳过按钮类型

/** 广告图的显示时间（默认5秒）*/
@property (nonatomic, assign) NSUInteger duration;

/** 获取数据前，启动图的等待时间（若不设置则不启动等待机制）*/
@property (nonatomic, assign) NSUInteger waitTime;


@end
