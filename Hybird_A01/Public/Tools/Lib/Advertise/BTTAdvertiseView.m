//
//  BTTAdvertiseView.m
//  Hybird_A01
//
//  Created by domino on 2018/10/01.
//  Copyright © 2018年 domino. All rights reserved.
//

#import "BTTAdvertiseView.h"
#import <YYAnimatedImageView.h>
#import <YYImage.h>

NSString *const NotificationContants_Advertise_Key = @"NotificationContants_Advertise_Key";

@interface BTTAdvertiseView()

@property (nonatomic, strong) YYAnimatedImageView *adView;
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) dispatch_source_t timer;      //显示计时器
@property (nonatomic, strong) dispatch_source_t timerWait;  //等待计时器
@property (nonatomic, assign) BOOL flag;                    //是否将要消失
@property (nonatomic, strong) UIView *timerView;
@property (nonatomic, weak) CAShapeLayer *viewLayer;
@property (nonatomic, assign) NSInteger remain;             //剩余时间
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) dispatch_source_t gcdTimer;
@end

@implementation BTTAdvertiseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 1.广告图片
        _adView = [[YYAnimatedImageView alloc] initWithFrame:frame];
        _adView.userInteractionEnabled = YES;
        _adView.contentMode = UIViewContentModeScaleAspectFill;
        _adView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_adView addGestureRecognizer:tap];
        
        [self addSubview:_adView];
        [self configDefaultParameter];
    }
    return self;
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}


- (UIButton *)skipButton {
    if (!_skipButton) {
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.frame = CGRectMake(SCREEN_WIDTH - 70, 30, 60, 30);
        _skipButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _skipButton.layer.cornerRadius = 15;
        _skipButton.layer.masksToBounds = YES;
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:13.5];
        weakSelf(weakSelf);
        [_skipButton addTarget:weakSelf action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipButton;
}

- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    [self adImageShowWithImage:[YYImage imageWithContentsOfFile:filePath]];
}

- (void)setDuration:(NSUInteger)duration {
    _duration = duration;
    if (duration < 3) {
        _duration = 3;
    }
}

- (void)setWaitTime:(NSUInteger)waitTime {
    _waitTime = waitTime;
    if (waitTime < 1) {
        _waitTime = 1;
    }
    [self scheduledWaitTimer];              // 启动等待计时器
}

- (UIView *)timerView {
    if (!_timerView) {
        self.timerView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 62, 32, 40, 40)];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4].CGColor;    // 填充颜色
        layer.strokeColor = [UIColor redColor].CGColor;                                 // 绘制颜色
        layer.lineCap = kCALineCapRound;
        layer.lineJoin = kCALineJoinRound;
        layer.lineWidth = 2;
        layer.frame = self.bounds;
        layer.path = [self getCirclePath].CGPath;
        layer.strokeStart = 0;
        [_timerView.layer addSublayer:layer];
        self.viewLayer = layer;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, 34, 34)];
        titleLabel.text = @"跳过";
        titleLabel.textColor = [UIColor whiteColor];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [_timerView addSubview:titleLabel];
        _remain = _duration * 20;
        _count = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipAction)];
        [_timerView addGestureRecognizer:tap];
    }
    return _timerView;
}

#pragma mark - Private Method -

/** 配置默认参数 */
- (void)configDefaultParameter {
    self.flag = NO;
    self.duration = 5;
    self.skipType = BTTSkipButtonTypeCircleAnimationTest;
    self.frame = [[UIScreen mainScreen] bounds];
}


/* 绘制路径
 * path这个属性必须需要设置，不然是没有效果的/
 */
- (UIBezierPath *)getCirclePath {
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(20, 20) radius:19 startAngle:-0.5*M_PI endAngle:1.5*M_PI clockwise:YES];
}


- (void)setSkipType:(BTTSkipButtonType)skipType {
    _skipType = skipType;
    
}


/** 显示广告图 */
- (void)adImageShowWithImage:(YYImage *)image {
    if (_flag) return;
    if (_timerWait) dispatch_source_cancel(_timerWait);
    self.adView.image = image;
    self.userInteractionEnabled = YES;
    if (_skipType == BTTSkipButtonTypeCircleAnimationTest) {
        [self addSubview:self.timerView];
        [self setCircleTimer];
    } else {
        [self addSubview:self.skipButton];
        [self scheduledTimer];
    }
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2;                           //动画执行时间
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    animation.type = kCATransitionFade;
    [self.layer addAnimation:animation forKey:@"animation"];
    
}

/** 广告图显示倒计时 */
- (void)setCircleTimer {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 0.05 * NSEC_PER_SEC, 0); // 每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->_count >= self->_remain) {
                dispatch_source_cancel(self->_timer);
                self.viewLayer.strokeStart = 1;
                [self dismiss];                         // 关闭界面
            } else {
                self.viewLayer.strokeStart += 0.01;
                self->_count++;                               //剩余时间进行自加
            }
        });
    });
    dispatch_resume(_timer);
}


/** 广告图显示倒计时 */
- (void)scheduledTimer {
    if (_timerWait) dispatch_source_cancel(_timerWait);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); // 每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->_duration <= 0) {
                dispatch_source_cancel(self->_timer);
                [self dismiss];                         // 关闭界面
            } else {
                [self showSkipBtnTitleTime:self->_duration];
                self->_duration--;
            }
        });
    });
    dispatch_resume(_timer);
}


/** 广告图加载前等待计时器 */
- (void)scheduledWaitTimer {
    if (_timerWait) dispatch_source_cancel(_timerWait);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timerWait = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timerWait, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_timerWait, ^{
        if (self->_waitTime <= 0) {
            self->_flag = YES;
            dispatch_source_cancel(self->_timerWait);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismiss];                         // 关闭界面
            });
        } else {
            self->_waitTime--;
        }
    });
    dispatch_resume(_timerWait);
}

/** 消失广告图 */
- (void)dismiss {
    NSLog(@"dismiss");
    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

/** 设置跳过按钮 */
- (void)showSkipBtnTitleTime:(NSInteger)timeLeave {
    switch (_skipType) {
        case BTTSkipButtonTypeNormalTimeAndText:
            [self.skipButton setTitle:[NSString stringWithFormat:@"%ld 跳过", (long)timeLeave] forState:UIControlStateNormal];
            break;
        case BTTSkipButtonTypeNormalText:
            [self.skipButton setTitle:@"跳过" forState:UIControlStateNormal];
            break;
        case BTTSkipButtonTypeNormalTime:
            [self.skipButton setTitle:[NSString stringWithFormat:@"%ld S", (long)timeLeave] forState:UIControlStateNormal];
            break;
        case BTTSkipButtonTypeNone:
            self.skipButton.hidden = YES;
            break;
        default:
            break;
    }
}

#pragma mark - Action Method -

/** 广告图点击相应方法 */
- (void)tapAction {
    if (_timer) dispatch_source_cancel(_timer);
    [self dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationContants_Advertise_Key object:nil userInfo:nil];
}

/** 跳过按钮响应方法 */
- (void)skipAction {
    if (_timer) dispatch_source_cancel(_timer);
    [self dismiss];
}

- (void)dealloc {
    NSLog(@"销毁");
}

@end
