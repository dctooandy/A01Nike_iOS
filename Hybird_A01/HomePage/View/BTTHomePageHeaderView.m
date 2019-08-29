//
//  BTTHomePageHeaderView.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/11.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTHomePageHeaderView.h"
#import "UIImage+GIF.h"

#define BTTIconTop (KIsiPhoneX ? 50 : 30) // 按钮距离顶端的高度
#define BTTLeftConstants 15 // 边距
#define BTTBtnAndBtnConstants 30   // 
#define BTTBtnWidthAndHeight 24
#define BTTCornerRadius      4     //圆角度数
#define BTTBorderWidth       1     //边框宽度

@interface BTTHomePageHeaderView ()

@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) UIButton *registerBtn;

@end

@implementation BTTHomePageHeaderView

- (instancetype)initWithFrame:(CGRect)frame withNavType:(BTTNavType)navType {
    self = [super initWithFrame:frame];
    if (self) {
        self.image = ImageNamed(@"navbg");
        self.userInteractionEnabled = YES;
        [self setupSubviewsWithNavType:navType];
    }
    return self;
}

- (void)setupSubviewsWithNavType:(BTTNavType)navType {
    switch (navType) {
        case BTTNavTypeHomePage:
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"zqzs" ofType:@"gif"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            UIImage *image = [UIImage sd_animatedGIFWithData:data];
            [self sd_setImageWithURL:nil placeholderImage:image];
            UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(BTTLeftConstants, KIsiPhoneX ? 49 : 27, 80, 30)];
            [self addSubview:logoImageView];
            logoImageView.image = ImageNamed(@"Navlogo");
            
            UIImageView *moonImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moon"]];
            if (KIsiPhoneX) {
                moonImage.frame = CGRectMake(20, 10, 50, 50);
            } else {
                moonImage.frame = CGRectMake(80, 0, 50, 50);
            }
            [self addSubview:moonImage];
            
            self.titleLabel = [UILabel new];
            [self addSubview:self.titleLabel];
            self.titleLabel.frame = CGRectMake((SCREEN_WIDTH - 150) / 2, BTTIconTop, 150, BTTBtnWidthAndHeight);
//            self.titleLabel.text = @"首页";
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font = kFontSystem(17);
            self.titleLabel.textColor = [UIColor whiteColor];
            
            UIButton *serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:serviceBtn];
            serviceBtn.frame = CGRectMake(SCREEN_WIDTH - BTTLeftConstants - BTTBtnWidthAndHeight, BTTIconTop, BTTBtnWidthAndHeight, BTTBtnWidthAndHeight);
            [serviceBtn setImage:ImageNamed(@"homepage_service") forState:UIControlStateNormal];
            [serviceBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            serviceBtn.tag = 2001;
            __block UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:messageBtn];
            messageBtn.frame = CGRectMake(SCREEN_WIDTH - BTTLeftConstants - BTTBtnWidthAndHeight - BTTBtnAndBtnConstants - BTTBtnWidthAndHeight, BTTIconTop, BTTBtnWidthAndHeight, BTTBtnWidthAndHeight);
            [messageBtn setImage:ImageNamed(@"homepage_messege") forState:UIControlStateNormal];
            messageBtn.redDotOffset = CGPointMake(1, 3);
            messageBtn.tag = 2002;
            [messageBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [GJRedDot registNodeWithKey:BTTHomePageMessage
                              parentKey:BTTHomePageItemsKey
                            defaultShow:NO];
            [self setRedDotKey:BTTHomePageMessage refreshBlock:^(BOOL show) {
                NSInteger num = [[[NSUserDefaults standardUserDefaults] objectForKey:BTTUnreadMessageNumKey] integerValue];
                messageBtn.showRedDot = num;
            } handler:self];
            
            [self setupLoginAndRegisterBtn];
        }
            break;
        case BTTNavTypeOnlyTitle:
        {
            self.titleLabel = [UILabel new];
            [self addSubview:self.titleLabel];
            self.titleLabel.frame = CGRectMake((SCREEN_WIDTH - 150) / 2, BTTIconTop, 150, BTTBtnWidthAndHeight);
            self.titleLabel.text = @"首页";
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font = kFontSystem(17);
            self.titleLabel.textColor = [UIColor whiteColor];
        }
            break;
        case BTTNavTypeDiscount:
        {
            UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(BTTLeftConstants, KIsiPhoneX ? 49 : 27, 80, 30)];
            [self addSubview:logoImageView];
            logoImageView.image = ImageNamed(@"Navlogo");
            self.titleLabel = [UILabel new];
            [self addSubview:self.titleLabel];
            self.titleLabel.frame = CGRectMake((SCREEN_WIDTH - 150) / 2, BTTIconTop, 150, BTTBtnWidthAndHeight);
            self.titleLabel.text = @"首页";
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font = kFontSystem(17);
            self.titleLabel.textColor = [UIColor whiteColor];
            
            UIButton *serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:serviceBtn];
            serviceBtn.frame = CGRectMake(SCREEN_WIDTH - BTTLeftConstants - BTTBtnWidthAndHeight, BTTIconTop, BTTBtnWidthAndHeight, BTTBtnWidthAndHeight);
            [serviceBtn setImage:ImageNamed(@"homepage_service") forState:UIControlStateNormal];
            serviceBtn.tag = 2001;
            [serviceBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            __block UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:messageBtn];
            messageBtn.frame = CGRectMake(SCREEN_WIDTH - BTTLeftConstants - BTTBtnWidthAndHeight - BTTBtnAndBtnConstants - BTTBtnWidthAndHeight, BTTIconTop, BTTBtnWidthAndHeight, BTTBtnWidthAndHeight);
            [messageBtn setImage:ImageNamed(@"homepage_messege") forState:UIControlStateNormal];
            messageBtn.redDotOffset = CGPointMake(1, 3);
            messageBtn.tag = 2002;
            [messageBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [GJRedDot registNodeWithKey:BTTDiscount
                              parentKey:BTTDiscountItemsKey
                            defaultShow:NO];
            [self setRedDotKey:BTTDiscountMessage refreshBlock:^(BOOL show) {
                messageBtn.showRedDot = [[[NSUserDefaults standardUserDefaults] objectForKey:BTTUnreadMessageNumKey] integerValue];
            } handler:self];
        }
            break;
            
            case BTTNavTypeMine:
        {
            UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(BTTLeftConstants, KIsiPhoneX ? 49 : 27, 80, 30)];
            [self addSubview:logoImageView];
            logoImageView.image = ImageNamed(@"Navlogo");
            self.titleLabel = [UILabel new];
            [self addSubview:self.titleLabel];
            self.titleLabel.frame = CGRectMake((SCREEN_WIDTH - 150) / 2, BTTIconTop, 150, BTTBtnWidthAndHeight);
            self.titleLabel.text = @"首页";
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font = kFontSystem(17);
            self.titleLabel.textColor = [UIColor whiteColor];
            
            UIButton *serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:serviceBtn];
            serviceBtn.frame = CGRectMake(SCREEN_WIDTH - BTTLeftConstants - BTTBtnWidthAndHeight, BTTIconTop, BTTBtnWidthAndHeight, BTTBtnWidthAndHeight);
            [serviceBtn setImage:ImageNamed(@"homepage_service") forState:UIControlStateNormal];
            serviceBtn.tag = 2001;
            [serviceBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            __block UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:messageBtn];
            messageBtn.frame = CGRectMake(SCREEN_WIDTH - BTTLeftConstants - BTTBtnWidthAndHeight - BTTBtnAndBtnConstants - BTTBtnWidthAndHeight, BTTIconTop, BTTBtnWidthAndHeight, BTTBtnWidthAndHeight);
            [messageBtn setImage:ImageNamed(@"homepage_messege") forState:UIControlStateNormal];
            messageBtn.redDotOffset = CGPointMake(1, 3);
            messageBtn.tag = 2002;
            [messageBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [GJRedDot registNodeWithKey:BTTMineCenter
                              parentKey:BTTMineCenterItemsKey
                            defaultShow:NO];
            [self setRedDotKey:BTTMineCenterNavMessage refreshBlock:^(BOOL show) {
                messageBtn.showRedDot = [[[NSUserDefaults standardUserDefaults] objectForKey:BTTUnreadMessageNumKey] integerValue];
            } handler:self];
        }
        default:
            break;
    }
    
    
    
}

- (void)setIsLogin:(BOOL)isLogin {
    _isLogin = isLogin;
    if (_isLogin) {
        self.loginBtn.hidden = YES;
        self.registerBtn.hidden = YES;
    } else {
        self.loginBtn.hidden = NO;
        self.registerBtn.hidden = NO;
    }
}

- (void)setupLoginAndRegisterBtn {
    CGFloat btnWidth = (SCREEN_WIDTH - 40) / 2.0f;
    CGFloat btnHeight = 35.0f;
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:loginBtn];
    loginBtn.frame = CGRectMake(BTTLeftConstants, KIsiPhoneX ? 89 : 69, btnWidth, btnHeight);
    [loginBtn setTitle:@"用户登录" forState:UIControlStateNormal];
    loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    loginBtn.layer.borderWidth = BTTBorderWidth;
    loginBtn.layer.cornerRadius = BTTCornerRadius;
    loginBtn.clipsToBounds = YES;
    loginBtn.tag = 2003;
    loginBtn.layer.borderWidth = 0.5;
    loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    loginBtn.layer.cornerRadius = 4;
    loginBtn.clipsToBounds = YES;
    [loginBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn = loginBtn;
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:registerBtn];
    registerBtn.frame = CGRectMake(BTTLeftConstants + btnWidth + 10, KIsiPhoneX ? 89 : 69, btnWidth, btnHeight);
    [registerBtn setTitle:@"立即开户" forState:UIControlStateNormal];
    registerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    registerBtn.layer.borderWidth = BTTBorderWidth;
    registerBtn.layer.cornerRadius = BTTCornerRadius;
    registerBtn.clipsToBounds = YES;
    registerBtn.tag = 2004;
    registerBtn.layer.borderWidth = 0.5;
    registerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    registerBtn.layer.cornerRadius = 4;
    registerBtn.clipsToBounds = YES;
    [registerBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.registerBtn = registerBtn;
}

- (void)buttonClick:(UIButton *)button {
    if (_btnClickBlock) {
        _btnClickBlock(button);
    }
}

@end
