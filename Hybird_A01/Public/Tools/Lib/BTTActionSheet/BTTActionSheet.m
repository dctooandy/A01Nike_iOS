//
//  BTTActionSheet.m
//  BTTActionSheetDemo
//
//  Created by Domino on 18/10/1.
//  Copyright © 2018年 Domino. All rights reserved.
//

#import "BTTActionSheet.h"

#define BTTTitleFont     [UIFont systemFontOfSize:18.0f]
#define BTTTitleHeight 60.0f
#define BTTButtonHeight  49.0f
#define BTTDarkShadowViewAlpha 0.35f

#define BTTShowAnimateDuration 0.3f
#define BTTHideAnimateDuration 0.2f

@interface BTTActionSheet () {
    
    NSString *_cancelButtonTitle;
    NSString *_destructiveButtonTitle;
    NSArray *_otherButtonTitles;
    
    
    UIView *_buttonBackgroundView;
    UIView *_darkShadowView;
}


@property (nonatomic, copy) BTTActionSheetBlock actionSheetBlock;

@end

@implementation BTTActionSheet

- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<BTTActionSheetDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {

    self = [super init];
    if(self) {
        _title = title;
        _delegate = delegate;
        _cancelButtonTitle = cancelButtonTitle.length > 0 ? cancelButtonTitle : @"取消";
        _destructiveButtonTitle = destructiveButtonTitle;
        NSMutableArray *args = [NSMutableArray array];
        if(_destructiveButtonTitle.length) {
            [args addObject:_destructiveButtonTitle];
        }
        [args addObject:otherButtonTitles];
        
        if (otherButtonTitles) {
            va_list params;
            va_start(params, otherButtonTitles);
            id buttonTitle;
            while ((buttonTitle = va_arg(params, id))) {
                if (buttonTitle) {
                    [args addObject:buttonTitle];
                }
            }
            va_end(params);
        }
        _otherButtonTitles = [NSArray arrayWithArray:args];
        [self _initSubViews];
    }
    
    return self;
}


- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
             actionSheetBlock:(BTTActionSheetBlock) actionSheetBlock {
    
    self = [super init];
    if(self) {
        _title = title;
        _cancelButtonTitle = cancelButtonTitle.length > 0 ? cancelButtonTitle : @"取消";
        _destructiveButtonTitle = destructiveButtonTitle;
        
        NSMutableArray *titleArray = [NSMutableArray array];
        if (_destructiveButtonTitle.length) {
            [titleArray addObject:_destructiveButtonTitle];
        }
        [titleArray addObjectsFromArray:otherButtonTitles];
        _otherButtonTitles = [NSArray arrayWithArray:titleArray];
        self.actionSheetBlock = actionSheetBlock;
        
        [self _initSubViews];
    }
    
    return self;
    
}


- (void)_initSubViews {

    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    
    _darkShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _darkShadowView.backgroundColor = COLOR_RGBA(20, 20, 20, 1);
    _darkShadowView.alpha = 0.0f;
    [self addSubview:_darkShadowView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView:)];
    [_darkShadowView addGestureRecognizer:tap];
    
    
    _buttonBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _buttonBackgroundView.backgroundColor = COLOR_RGBA(220, 220, 220, 1);
    [self addSubview:_buttonBackgroundView];
    
    if (self.title.length) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, BTTButtonHeight - BTTTitleHeight, SCREEN_WIDTH, BTTTitleHeight)];
        titleLabel.text = _title;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = COLOR_RGBA(125, 125, 125, 1);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        titleLabel.backgroundColor = [UIColor whiteColor];
        [_buttonBackgroundView addSubview:titleLabel];
    }
    
    
    for (int i = 0; i < _otherButtonTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:_otherButtonTitles[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = BTTTitleFont;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i==0 && _destructiveButtonTitle.length) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        UIImage *image = [UIImage imageNamed:@"BTTActionSheet.bundle/actionSheetHighLighted.png"];
        [button setBackgroundImage:image forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonY = BTTButtonHeight * (i + (_title.length > 0 ? 1 : 0));
        button.frame = CGRectMake(0, buttonY, SCREEN_WIDTH, BTTButtonHeight);
        [_buttonBackgroundView addSubview:button];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = COLOR_RGBA(210, 210, 210, 1);
        line.frame = CGRectMake(0, buttonY, SCREEN_WIDTH, 0.5);
        [_buttonBackgroundView addSubview:line];
    }
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.tag = _otherButtonTitles.count;
    [cancelButton setTitle:_cancelButtonTitle forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.titleLabel.font = BTTTitleFont;
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"BTTActionSheet.bundle/actionSheetHighLighted.png"];
    [cancelButton setBackgroundImage:image forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat buttonY = BTTButtonHeight * (_otherButtonTitles.count + (_title.length > 0 ? 1 : 0)) + 5;
    cancelButton.frame = CGRectMake(0, buttonY, SCREEN_WIDTH, KIsiPhoneX ? 83.0f : BTTButtonHeight);
    [_buttonBackgroundView addSubview:cancelButton];
    if (KIsiPhoneX) {
        [cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(-30, 0, 0, 0)];
    }
    
    
    CGFloat height = BTTButtonHeight  * (_otherButtonTitles.count + 1 + (_title.length > 0 ? 1 : 0)) + 5 + (KIsiPhoneX ? BTTDangerousAreaH : 0);
    _buttonBackgroundView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, height);
    
}

- (void)didClickButton:(UIButton *)button {

    if (_delegate && [_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
        [_delegate actionSheet:self didClickedButtonAtIndex:button.tag];
    }
    
    if (self.actionSheetBlock) {
        self.actionSheetBlock(button.tag);
    }
    
    [self hide];
}

- (void)dismissView:(UITapGestureRecognizer *)tap {

    if (_delegate && [_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
        [_delegate actionSheet:self didClickedButtonAtIndex:_otherButtonTitles.count];
    }
    
    if (self.actionSheetBlock) {
        self.actionSheetBlock(_otherButtonTitles.count);
    }
    
    [self hide];
}

- (void)show {

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    self.hidden = NO;
    
    [UIView animateWithDuration:BTTShowAnimateDuration animations:^{
        self->_darkShadowView.alpha = BTTDarkShadowViewAlpha;
        self->_buttonBackgroundView.transform = CGAffineTransformMakeTranslation(0, -(self->_buttonBackgroundView.frame.size.height));
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hide {
    
    [UIView animateWithDuration:BTTHideAnimateDuration animations:^{
        self->_darkShadowView.alpha = 0;
        self->_buttonBackgroundView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

@end
