//
//  FJProgressHUD.m
//  Hybird_A01
//
//  Created by Domino on 2018/7/27.
//  Copyright © 2018年 Domino. All rights reserved.
//

#import "BTTProgressHUD.h"
#import "BTTProgressHUDConfig.h"
#import "BTTProgressHUDInfo.h"

@interface BTTProgressHUD()

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UILabel *textLabel;

@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic,strong) BTTProgressHUDInfo *HUDInfo;

@property (nonatomic,strong) CAShapeLayer *HUDlayer;

@end

@implementation BTTProgressHUD


#pragma mark - show(类方法)
//加载(指示器)
+ (BTTProgressHUD *)showLoadingIndicatorText:(NSString *)text toView:(UIView *)view {
    BTTProgressHUD *hud = [[BTTProgressHUD alloc] initWithFrame:view.frame];
    hud.text = text;
    hud.showType = BTTProgressHUDLoadingIndicator;
    hud.maskType = BTTProgressHUDMaskTypeClear;
    [hud showToView:view];
    return hud;
}
//加载（圆环）
+ (BTTProgressHUD *)showLoadingCircleText:(NSString *)text toView:(UIView *)view {
    BTTProgressHUD *hud = [[BTTProgressHUD alloc] initWithFrame:view.frame];
    hud.text = text;
    hud.showType = BTTProgressHUDLoadingCircle;
    hud.maskType = BTTProgressHUDMaskTypeClear;
    [hud showToView:view];
    return hud;
}

// 只显示转圈
+ (BTTProgressHUD *)showLoadingCircletoView:(UIView *)view {
    BTTProgressHUD *hud = [[BTTProgressHUD alloc] initWithFrame:view.frame];
    hud.showType = BTTProgressHUDLoadingCircle;
//    hud.maskType = BTTProgressHUDMaskTypeClear;
    [hud showToView:view];
    return hud;
}

//进度(圆饼)
+ (BTTProgressHUD *)showProgressCircleText:(NSString *)text toView:(UIView *)view {
    BTTProgressHUD *hud = [[BTTProgressHUD alloc] initWithFrame:view.frame];
    hud.text = text;
    hud.showType = BTTProgressHUDProgressCircle;
//    hud.maskType = BTTProgressHUDMaskTypeClear;
    [hud showToView:view];
    return hud;
}
//状态(成功)
+ (void)showSuccessText:(NSString *)text toView:(UIView *)view {
    BTTProgressHUD *hud = [[BTTProgressHUD alloc] initWithFrame:view.frame];
    hud.text = text;
    hud.showType = BTTProgressHUDStatusSuccess;
    hud.maskType = BTTProgressHUDMaskTypeClear;
    hud.dissmissTime = 1.5;
    [hud showToView:view];
    
}
//状态(失败)
+ (void)showFailText:(NSString *)text toView:(UIView *)view {
    BTTProgressHUD *hud = [[BTTProgressHUD alloc] initWithFrame:view.frame];
    hud.text = text;
    hud.showType = BTTProgressHUDStatusFail;
    hud.maskType = BTTProgressHUDMaskTypeClear;
    hud.dissmissTime = 1.5;
    [hud showToView:view];
    
}
//自定义图片
+ (BTTProgressHUD *)showCustomText:(NSString *)text images:(NSArray *)images toView:(UIView *)view {
    BTTProgressHUD *hud = [[BTTProgressHUD alloc] initWithFrame:view.frame];
    hud.frame = view.frame;
    hud.text = text;
    hud.images = images;
    hud.showType = BTTProgressHUDCustom;
    hud.maskType = BTTProgressHUDMaskTypeClear;
    [hud showToView:view];
    return hud;
}

+ (BTTProgressHUD *)showCustomText:(NSString *)text images:(NSArray *)images width:(CGFloat)width height:(CGFloat)height toView:(UIView *)view {
    BTTProgressHUD *hud = [[BTTProgressHUD alloc] initWithFrame:view.frame];
    hud.text = text;
    hud.width = width;
    hud.height = height;
    hud.images = images;
    hud.showType = BTTProgressHUDCustom;
    hud.maskType = BTTProgressHUDMaskTypeClear;
    [hud showToView:view];
    return hud;
}

//只有文本
+ (void)showOnlyText:(NSString *)text toView:(UIView *)view {
    BTTProgressHUD *hud = [[BTTProgressHUD alloc] initWithFrame:view.frame];
    hud.text = text;
    hud.modeType = BTTProgressHUDModeOnlyText;
    hud.dissmissTime = 1.5;
    [hud showToView:view];
}

//不显示文本
+ (BTTProgressHUD *)showOnlyHUDOrCustom:(BTTProgressHUDShowType)showType images:(NSArray *)images toView:(UIView *)view {
    BTTProgressHUD *hud = [[BTTProgressHUD alloc] initWithFrame:view.frame];
    hud.images = images;
    hud.showType = showType;
    hud.iconImageView.hidden = YES;
    hud.maskType = BTTProgressHUDMaskTypeNone;
    hud.styleType = BTTProgressHUDStyleDark;
    [hud showToView:view];
    return hud;
}

#pragma mark - init

+ (instancetype)progressHUD {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
        [self layoutFrame];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self layoutFrame];
    }
    return self;
}

- (void)setupUI {
    self.alpha = 0;
    self.contentView.alpha = 1;
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.textLabel];
    [self.contentView.layer addSublayer:self.HUDlayer];
    [self.contentView addSubview:self.indicatorView];
    [self.contentView addSubview:self.iconImageView];
    self.iconImageView.backgroundColor = [UIColor redColor];
    
}


- (void)layoutFrame {
    
    self.textLabel.text = _text;
    self.HUDlayer.frame = self.HUDInfo.HUDFrame;
    self.contentView.frame = self.HUDInfo.contentViewFrame;
    self.iconImageView.frame = self.HUDInfo.iconFrame;
    self.textLabel.frame = self.HUDInfo.textLabelFrame;
    self.imageView.frame = self.HUDInfo.imageViewFrame;
    self.indicatorView.frame = self.HUDlayer.frame;
}

- (void)setText:(NSString *)text {
    _text = text;
    //指定默认模式 (hudinfo会判断文字是否为空)
    self.modeType = BTTProgressHUDModeHudOrCustom;
}

- (void)setImages:(NSArray *)images {
    _images = images;
    //指定默认模式
    self.modeType = BTTProgressHUDModeHudOrCustom;
}

- (void)setWidth:(CGFloat)width {
    _width = width;
    //指定默认模式
    self.modeType = BTTProgressHUDModeHudOrCustom;
}

- (void)setHeight:(CGFloat)height {
    _height = height;
    //指定默认模式
    self.modeType = BTTProgressHUDModeHudOrCustom;
}

- (void)setMaskType:(BTTProgressHUDMaskType )maskType {
    _maskType = maskType;
    switch (maskType) {
        case BTTProgressHUDMaskTypeNone:
            self.backgroundColor = [UIColor clearColor];
            break;
        case BTTProgressHUDMaskTypeClear:
            self.backgroundColor = [UIColor clearColor];
            break;
        case BTTProgressHUDMaskTypeGray:
            self.backgroundColor = [UIColor lightGrayColor];
            break;
    }
}

- (void)setModeType:(BTTProgressHUDModeType )modeType {
    _modeType = modeType;
    switch (modeType) {
        case BTTProgressHUDModeHudOrCustom:
            if (self.images.count > 0) {
                if (!_width&&!_height) {
                    [self.HUDInfo layoutCustomWithText:_text withFrame:self.frame];
                } else {
                    [self.HUDInfo layoutCustomWithText:_text Width:_width height:_height withFrame:self.frame];
                }
            } else {
                [self.HUDInfo layoutHUDWithText:_text withFrame:self.frame];
            }
            [self layoutFrame];
            break;
        case BTTProgressHUDModeOnlyHudOrCustom:
            if (self.images.count > 0) {
                [self.HUDInfo layoutOnlyCustomWithFrame:self.frame];
            } else {
                [self.HUDInfo layoutOnlyHUDWithFrame:self.frame];
            }
            [self layoutFrame];
            break;
        case BTTProgressHUDModeOnlyText:
            [self.HUDInfo layoutOnlyTextWithText:_text withFrame:self.frame];
            [self layoutFrame];
            self.iconImageView.hidden = YES;
            break;
    }
    
}


- (void)setShowType:(BTTProgressHUDShowType )showType {
    _showType = showType;
    [self.HUDlayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (showType == BTTProgressHUDLoadingIndicator) {
        self.indicatorView.hidden = NO;
        self.HUDlayer.hidden = YES;
    } else {
        self.indicatorView.hidden = YES;
        self.HUDlayer.hidden = NO;
    }
    
    switch (showType) {
        case BTTProgressHUDLoadingIndicator:
            [self.indicatorView startAnimating];
            break;//加载(指示器)
        case BTTProgressHUDLoadingCircle:
            [self.HUDInfo drawLoadingCircle:self.HUDlayer];
            break;//加载（圆环）
        case BTTProgressHUDProgressCircle:
            [self.HUDInfo drawProgressCircle:self.HUDlayer progress:_progress];
            break;//进度(圆饼)
        case BTTProgressHUDStatusSuccess:
            [self.HUDInfo drawStatusSuccess:self.HUDlayer];
            break;//状态(成功)
        case BTTProgressHUDStatusFail:
            [self.HUDInfo drawStatusFail:self.HUDlayer];
            break;//状态(失败)
        case BTTProgressHUDCustom:
            [self imageViewSetImages:_images];
            break;//自定义
    }
}

- (void)setStyleType:(BTTProgressHUDStyleType )styleType {
    _styleType = styleType;
    switch (styleType) {
        case BTTProgressHUDStyleDark:
            self.contentView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.85];
            break;
        case BTTProgressHUDStyleLight:
            self.contentView.backgroundColor = COLOR_RGBA(234, 237, 239, 0.95);
            break;
        case BTTProgressHUDStyleClear:
            self.contentView.backgroundColor = [UIColor clearColor];
            break;
    }
    
    UIColor *color = _styleType == BTTProgressHUDStyleDark?[UIColor whiteColor]:[UIColor blackColor];
    self.textLabel.textColor = color;
    self.HUDlayer.strokeColor = color.CGColor;
    self.indicatorView.color = color;
}



- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    if (self.showType == BTTProgressHUDProgressCircle) {
        [self.HUDInfo drawProgressCircle:self.HUDlayer progress:_progress];
    }
}

- (void)setCustomText:(NSString *)text images:(NSArray *)images width:(CGFloat)width height:(CGFloat)height {
    self.text = text;
    self.width = width;
    self.height = height;
    self.images = images;
    self.showType = BTTProgressHUDCustom;
}

- (void)imageViewSetImages:(NSArray *)images{
    if (images.count == 0) return;
    if (_images.count == 1) {
        self.imageView.image = [UIImage imageNamed:[_images firstObject]];
    } else {
        NSMutableArray *imagesMutableArray = [NSMutableArray array];
        [_images enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL * _Nonnull stop) {
            [imagesMutableArray addObject:[UIImage imageNamed:imageName]];
        }];
        self.imageView.animationImages = imagesMutableArray;
        self.imageView.animationDuration = BTTimageAnimationTime;
        self.imageView.animationRepeatCount = NSUIntegerMax;
        [self.imageView startAnimating];
    }
}

#pragma mark - show（实例方法）

- (void)showToView:(UIView *)view {
    if (!view||self.maskType == BTTProgressHUDMaskTypeClear||self.maskType == BTTProgressHUDMaskTypeGray){
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [window addSubview:self];
    } else {
        [view addSubview:self];
    }
    if (self.animationType == BTTProgressHUDAnimationNormal) {
        [self showNormalAnimation];
    } else {
        [self showSpringAnimation];
    }
    if (self.dissmissTime == 0) return;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.dissmissTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
    
}
#pragma mark - showAnimation

- (void)showNormalAnimation {
    self.contentView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration:BTTAnimationTime animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        self.alpha = 1;
    }];
}

- (void)showSpringAnimation {
    self.contentView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration:BTTAnimationTime delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.9 options: UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        self.alpha = 1;
    } completion:nil];
}

#pragma mark - dismiss

- (void)dismiss{
    [UIView animateWithDuration:BTTAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        self.contentView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
#pragma mark - 懒加载

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.85];
        _contentView.layer.cornerRadius = 5;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

- (UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc]init];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    }
    return _indicatorView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (CAShapeLayer *)HUDlayer{
    if (!_HUDlayer) {
        _HUDlayer = [CAShapeLayer layer];
        _HUDlayer.strokeColor = [UIColor whiteColor].CGColor;
    }
    return _HUDlayer;
}

- (BTTProgressHUDInfo *)HUDInfo{
    if (!_HUDInfo) {
        _HUDInfo = [[BTTProgressHUDInfo alloc] initWithFrame:self.frame];
    }
    return _HUDInfo;
}









@end

