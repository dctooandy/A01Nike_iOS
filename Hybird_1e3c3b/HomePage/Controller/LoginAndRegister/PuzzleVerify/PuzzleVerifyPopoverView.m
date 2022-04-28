//
//  PuzzleVerifyPopoverView.m
//  Hybird_1e3c3b
//
//  Created by Kevin on 2022/4/18.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "PuzzleVerifyPopoverView.h"

#import "PuzzleVerifyPopoverView.h"
#import "PuzzleVerifyView.h"
#import <Masonry/Masonry.h>

NSInteger const kBTTLoginOrRegisterCaptchaPuzzle = 3;

@interface PuzzleVerifyPopoverView()<PuzzleVerifyViewDelegate>

@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIView *contentView;

@property(nonatomic,strong) PuzzleVerifyView *verifyView;
@property(nonatomic,strong) UIView *slidView;
@property(nonatomic,strong) UILabel *slidTitle;
@property(nonatomic,strong) UISlider *slider;
@property(nonatomic,strong) UIView *innerView;
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *translucentView;

@property(nonatomic,strong) UIButton *cancelButton;
@property(nonatomic,assign) BOOL sliding;
@property(nonatomic,strong) CAGradientLayer *gradientLayer;
@property(nonatomic,strong) CABasicAnimation *locationAnimation;
@property(nonatomic,strong) UIButton *refreshButton;

@end

@implementation PuzzleVerifyPopoverView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setLayout];
    }
    return self;
}

-(void)setupUI {
    self.alpha = 0;
    self.layer.cornerRadius = 0;
    self.layer.masksToBounds = YES;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.verifyView];
    [self addSubview:self.topView];
    [self addSubview:self.slidView];
    [self.slidView addSubview:self.innerView];
    [self.slidView addSubview:self.translucentView];
    [self.slidView addSubview:self.slidTitle];
    [self.slidView addSubview:self.slider];

    [self addSubview:self.cancelButton];
    [self addSubview:self.refreshButton];
}

-(void)setLayout {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(30);
    }];
    
    [self.verifyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.equalTo(self);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(95);
    }];
    
    [self.slidView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verifyView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self);
    }];
    
    [self.slidTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(70);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.translucentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.innerView);
        make.right.equalTo(self.slider.mas_left).offset(10);
    }];
    
    [self.innerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(31);
        make.right.mas_equalTo(-31);
        make.bottom.mas_equalTo(-8);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.left.mas_equalTo(42);
        make.right.mas_equalTo(-42);
        make.height.mas_equalTo(34);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView).offset(6);
        make.left.equalTo(self.topView).offset(10);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView).offset(6);
        make.right.equalTo(self.topView).offset(-11);
        make.width.height.offset(20);
    }];
}

#pragma mark - event methods

- (void)refresh {
    if ([self.delegate respondsToSelector:@selector(puzzleViewRefresh)]) {
        [self.delegate puzzleViewRefresh];
    }
}

- (void)cancel {
    if ([self.delegate respondsToSelector:@selector(puzzleViewCanceled)]) {
        [self.delegate puzzleViewCanceled];
    }
    [self hide];
}

-(void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

-(void)show {
    if ([self superview]) {
        [self reset];
        return;
    }
    UIView *superView = [UIApplication sharedApplication].keyWindow;
    
    [superView addSubview:self.bgView];
    [superView addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView);
        make.centerY.equalTo(superView).offset(-20);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }completion:^(BOOL finished) {}];
}

- (void)reset {
    _verifyView.puzzleXPercentage = 0;
    _slider.value = 0.0;
    [_translucentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.slider.mas_left).offset(10);
    }];
}

- (void)successAndDismiss {
    self.slider.selected = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hide];
    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_gradientLayer) {
        UILabel *animationLabel = [[UILabel alloc] initWithFrame:_slidTitle.bounds];
        animationLabel.text = _slidTitle.text;
        animationLabel.font = _slidTitle.font;
        animationLabel.textAlignment = NSTextAlignmentCenter;
        CGFloat duration = 1.0;
        NSArray *gradientColors = @[(id)[UIColor colorWithWhite:0.4 alpha:1.0].CGColor, (id)[UIColor whiteColor].CGColor, (id)[UIColor colorWithWhite:0.4 alpha:1.0].CGColor];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.bounds = _slidTitle.bounds;
        gradientLayer.position = CGPointMake(_slidTitle.width / 2.0, _slidTitle.height / 2.0);
        
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(1, 0);
            
        gradientLayer.colors = gradientColors;
        gradientLayer.locations = @[@(0.2), @(0.5), @(0.8)];
        self.gradientLayer = gradientLayer;
        CABasicAnimation *locationAnimation = [CABasicAnimation animationWithKeyPath:@"locations"];
        locationAnimation.fromValue = @[@(0),@(0.0),@(0.3)];
        locationAnimation.toValue = @[@(0.7),@(1),@(1)];
        locationAnimation.duration = duration;
        locationAnimation.repeatCount = HUGE;
        locationAnimation.autoreverses = NO;
        self.locationAnimation = locationAnimation;
        [_slidTitle.layer addSublayer:gradientLayer];
        _slidTitle.maskView = animationLabel;
        gradientLayer.mask = animationLabel.layer;
        [gradientLayer addAnimation:locationAnimation forKey:locationAnimation.keyPath];
    }
}

#pragma mark - slider actions

// UISlider actions
- (void)sliderUp:(UISlider *)sender {
    if (_sliding) {
        _sliding = NO;
        [_verifyView performCallback];
    }
}

- (void)sliderDown:(UISlider *)sender {
    _sliding = YES;
}

- (void)sliderChanged:(UISlider *)sender {
    _verifyView.puzzleXPercentage = sender.value;
    [_translucentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sender.mas_left).offset(10+(sender.value*184));
    }];
}

#pragma mark - PuzzleVerifyViewDelegate

- (void)puzzleVerifyView:(PuzzleVerifyView *)puzzleVerifyView didChangedPuzzlePosition:(CGPoint)newPosition xPercentage:(CGFloat)xPercentage yPercentage:(CGFloat)yPercentage {
    if ([self.delegate respondsToSelector:@selector(puzzleViewDidChangePosition:)]) {
        [self.delegate puzzleViewDidChangePosition:newPosition];
    }
}

#pragma mark - setter and getter

- (void)setOriginImage:(UIImage *)originImage {
    _verifyView.originImage = originImage;
}

- (void)setShadeImage:(UIImage *)shadeImage {
    _verifyView.shadeImage = shadeImage;
}

- (void)setCutoutImage:(UIImage *)cutoutImage {
    _verifyView.cutoutImage = cutoutImage;
}

- (void)setPosition:(CGPoint)position {
    _verifyView.puzzlePosition = CGPointMake(0, position.y);
}

-(UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:[UIImage imageNamed:@"X_A01"] forState:UIControlStateNormal];
        _cancelButton.adjustsImageWhenHighlighted = NO;
        [_cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)refreshButton {
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshButton setImage:[UIImage imageNamed:@"O_刷新"] forState:UIControlStateNormal];
        _refreshButton.adjustsImageWhenHighlighted = NO;
        [_refreshButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectZero];
        _topView.backgroundColor = kHexColor(0x004F8F);
    }
    return _topView;
}

-(PuzzleVerifyView *)verifyView{
    
    if (!_verifyView) {
        _verifyView = [[PuzzleVerifyView alloc] initWithFrame:CGRectMake(20, 20, 300, 95)];
        _verifyView.puzzlePosition = CGPointMake(100, 30);
        _verifyView.puzzleXPercentage = 0;
        _verifyView.layer.masksToBounds = YES;
        _verifyView.delegate = self;
    }
    return _verifyView;
}

-(UIView *)slidView{
    
    if (!_slidView) {
        _slidView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 46)];
        _slidView.backgroundColor = [UIColor whiteColor];
        _slidView.layer.masksToBounds = YES;
    }
    return _slidView;
}

- (UIView *)translucentView {
    if (!_translucentView) {
        _translucentView = [[UIView alloc] initWithFrame:CGRectZero];
        _translucentView.backgroundColor = kHexColorAlpha(0x0994E7, 0.1);
        _translucentView.layer.cornerRadius = 4.0;
        _translucentView.layer.borderWidth = 1.0;
        _translucentView.layer.borderColor = [kHexColor(0x0994E7) CGColor];
    }
    return _translucentView;
}

- (UIView *)innerView {
    if (!_innerView) {
        CGSize size = CGSizeMake(266, 22);
        _innerView = [[UIView alloc] initWithFrame:CGRectMake(17, 12, size.width, size.height)];
        _innerView.backgroundColor = [UIColor clearColor];
        _innerView.layer.cornerRadius = 4.0;
        _innerView.layer.borderColor = [kHexColor(0xE7E8E8) CGColor];
        _innerView.layer.borderWidth = 1.0;
    }
    return _innerView;
}

-(UILabel *)slidTitle {
    if (!_slidTitle) {
        _slidTitle = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200, 34)];
        _slidTitle.textColor = [UIColor clearColor];
        _slidTitle.font = [UIFont systemFontOfSize:14];
        _slidTitle.textAlignment = NSTextAlignmentCenter;
        _slidTitle.text = @"拖动滑块完成拼图验证>>>";
    }
    return _slidTitle;
}

-(UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.continuous = YES;
        _slider.minimumValue = 0.0;
        _slider.maximumValue = 1.0;
        _slider.value = 0.0;
        [_slider setThumbImage:[UIImage imageNamed:@"ic_puzzle_slider"] forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"ic_puzzle_succ"] forState:UIControlStateSelected];
        _slider.backgroundColor = [UIColor clearColor];
        _slider.minimumTrackTintColor = [UIColor clearColor];
        _slider.maximumTrackTintColor = [UIColor clearColor];
        // Set the slider action methods
        [_slider addTarget:self
                    action:@selector(sliderUp:)
          forControlEvents:UIControlEventTouchUpInside];
        [_slider addTarget:self
                    action:@selector(sliderUp:)
          forControlEvents:UIControlEventTouchUpOutside];
        [_slider addTarget:self
                    action:@selector(sliderDown:)
          forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self
                    action:@selector(sliderChanged:)
          forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

-(UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

@end
