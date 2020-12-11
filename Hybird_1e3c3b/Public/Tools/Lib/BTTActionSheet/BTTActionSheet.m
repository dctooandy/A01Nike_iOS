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

#define ACTIONSHEET_BACKGROUNDCOLOR             [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1]
#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define ANIMATE_DURATION                        0.25f

#define ActionSheetW [[UIScreen mainScreen] bounds].size.width
#define ActionSheetH [[UIScreen mainScreen] bounds].size.height

@interface BTTActionSheet () {
    
    NSString *_cancelButtonTitle;
    NSString *_destructiveButtonTitle;
    NSArray *_otherButtonTitles;
    
    
    UIView *_buttonBackgroundView;
    UIView *_darkShadowView;
}

@property (nonatomic,assign) CGFloat LXActionSheetHeight;
@property (nonatomic,strong) NSArray *shareBtnTitleArray;
@property (nonatomic,strong) NSArray *shareBtnImgArray;

@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,strong) UIView *topsheetView;
@property (nonatomic,strong) UIButton *cancelBtn;

//头部提示文字Label
@property (nonatomic,strong) UILabel *proL;

@property (nonatomic,copy) NSString *protext;

@property (nonatomic,assign) ShowType showtype;


@property (nonatomic, copy) BTTActionSheetBlock actionSheetBlock;

@end

@implementation BTTActionSheet

- (id)initWithShareHeadOprationWith:(NSArray *)titleArray andImageArry:(NSArray *)imageArr andProTitle:(NSString *)protitle and:(ShowType)type
{
    self = [super init];
    if (self) {
        self.shareBtnImgArray = imageArr;
        self.shareBtnTitleArray = titleArray;
        _protext = protitle;
        _showtype = type;
        
        self.frame = CGRectMake(0, 0, ActionSheetW, ActionSheetH);
        self.backgroundColor = WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        if (type == ShowTypeIsShareStyle) {
            [self loadUiConfig];
        }
        else
        {
            [self loadActionSheetUi];
        }
        
    }
    return self;
}

- (void)setCancelBtnColor:(UIColor *)cancelBtnColor
{
    [_cancelBtn setTitleColor:cancelBtnColor forState:UIControlStateNormal];
}
- (void)setProStr:(NSString *)proStr
{
    _proL.text = proStr;
}

- (void)setOtherBtnColor:(UIColor *)otherBtnColor
{
    for (id res in _backGroundView.subviews) {
        if ([res isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)res;
            if (button.tag>=100) {
                [button setTitleColor:otherBtnColor forState:UIControlStateNormal];
            }
        }
    }
}

- (void)setOtherBtnFont:(NSInteger)otherBtnFont
{
    for (id res in _backGroundView.subviews) {
        if ([res isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)res;
            if (button.tag>=100) {
                button.titleLabel.font = [UIFont systemFontOfSize:otherBtnFont];
            }
        }
    }
}

-(void)setProFont:(NSInteger)proFont
{
    _proL.font = [UIFont systemFontOfSize:proFont];
}

- (void)setCancelBtnFont:(NSInteger)cancelBtnFont
{
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:cancelBtnFont];
}

- (void)setDuration:(CGFloat)duration
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:duration];
}

- (void)loadActionSheetUi
{
    [self addSubview:self.backGroundView];
    [_backGroundView addSubview:self.cancelBtn];
    if (_protext.length) {
        [_backGroundView addSubview:self.proL];
    }
    
    for (NSInteger i = 0; i<_shareBtnTitleArray.count; i++) {
        BTTVerButton *button = [BTTVerButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, CGRectGetHeight(_proL.frame)+50*i, CGRectGetWidth(_backGroundView.frame), 50);
        [button setTitle:_shareBtnTitleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.tag = 100+i;
        [button addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backGroundView addSubview:button];
    }
    
    weakSelf(weakSelf)
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        weakSelf.backGroundView.frame = CGRectMake(0, ActionSheetH-(weakSelf.shareBtnTitleArray.count*50+50)-7-(weakSelf.protext.length==0?0:45), ActionSheetW, weakSelf.shareBtnTitleArray.count*50+50+7+(weakSelf.protext.length==0?0:45));
    }];
    
}


- (void)loadUiConfig
{
    [self addSubview:self.backGroundView];
    [_backGroundView addSubview:self.topsheetView];
    [_backGroundView addSubview:self.cancelBtn];
    
    _LXActionSheetHeight = CGRectGetHeight(_proL.frame)+7;
    
    for (NSInteger i = 0; i<_shareBtnImgArray.count; i++)
    {
        BTTActionButton *button = [BTTActionButton buttonWithType:UIButtonTypeCustom];
        if (_shareBtnImgArray.count % 3 == 0) {
            button.frame = CGRectMake(_backGroundView.bounds.size.width/ 3 * (i % 3), _LXActionSheetHeight+(i/3)*76, _backGroundView.bounds.size.width / 3, 70);
        }
        else
        {
            button.frame = CGRectMake(_backGroundView.bounds.size.width / 4 * ( i % 4), _LXActionSheetHeight + (i / 4) * 76, _backGroundView.bounds.size.width / 4, 70);
        }
        
        [button setTitle:_shareBtnTitleArray[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:_shareBtnImgArray[i]] forState:UIControlStateNormal];
        button.tag = 200+i;
        [button addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topsheetView addSubview:button];
    }
    
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        self->_backGroundView.frame = CGRectMake(7, ActionSheetH - CGRectGetHeight(self->_backGroundView.frame) - 34, ActionSheetW - 14, CGRectGetHeight(self->_backGroundView.frame));
    }];
    
}

- (void)BtnClick:(UIButton *)btn
{
    [self tappedCancel];
    if (btn.tag < 200) {
        _btnClick(btn.tag - 100);
    }
    else
    {
        _btnClick(btn.tag - 200);
    }
}

- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, ActionSheetH, ActionSheetW, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)noTap
{}

#pragma mark -------- getter
- (UIView *)backGroundView
{
    if (_backGroundView == nil) {
        _backGroundView = [[UIView alloc] init];
        
        if (_showtype == ShowTypeIsShareStyle) {
            if (_shareBtnImgArray.count<5) {
                _backGroundView.frame = CGRectMake(7, ActionSheetH, ActionSheetW-14, 64+(_protext.length==0?0:45)+76+14);
            }else
            {
                NSInteger index;
                if (_shareBtnTitleArray.count%4 ==0) {
                    index =_shareBtnTitleArray.count/4;
                }
                else
                {
                    index = _shareBtnTitleArray.count/4 + 1;
                }
                _backGroundView.frame = CGRectMake(7, ActionSheetH, ActionSheetW-14, 64+(_protext.length==0?0:45)+76*index+14);
            }
        }
        else
        {
            _backGroundView.frame = CGRectMake(0, ActionSheetH, ActionSheetW, _shareBtnTitleArray.count*50+50+7+(_protext.length==0?0:45));
            _backGroundView.backgroundColor = [UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f];
        }
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noTap)];
        [_backGroundView addGestureRecognizer:tapGesture];
    }
    return _backGroundView;
}


- (UIView *)topsheetView
{
    if (_topsheetView == nil) {
        _topsheetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_backGroundView.frame), CGRectGetHeight(_backGroundView.frame)-64)];
        _topsheetView.backgroundColor = [UIColor whiteColor];
        _topsheetView.layer.cornerRadius = 4;
        _topsheetView.clipsToBounds = YES;
        if (_protext.length) {
            [_topsheetView addSubview:self.proL];
        }
    }
    return _topsheetView;
}

- (UILabel *)proL
{
    if (_proL == nil) {
        _proL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_backGroundView.frame), 45)];
        _proL.text = @"分享至";
        _proL.textColor = [UIColor grayColor];
        _proL.backgroundColor = [UIColor whiteColor];
        _proL.textAlignment = NSTextAlignmentCenter;
    }
    return _proL;
}

- (UIButton *)cancelBtn
{
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (_showtype == ShowTypeIsShareStyle) {
            _cancelBtn.frame = CGRectMake(0, CGRectGetHeight(_backGroundView.frame)-57, CGRectGetWidth(_backGroundView.frame), 50);
            _cancelBtn.layer.cornerRadius = 4;
            _cancelBtn.clipsToBounds = YES;
        }
        else
        {
            _cancelBtn.frame = CGRectMake(0, CGRectGetHeight(_backGroundView.frame)-50, CGRectGetWidth(_backGroundView.frame), 50);
        }
        
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}



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
