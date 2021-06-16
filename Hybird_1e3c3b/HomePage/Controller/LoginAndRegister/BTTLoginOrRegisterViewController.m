//
//  BTTLoginOrRegisterViewController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 12/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTLoginOrRegisterViewController.h"
#import "BTTLoginOrRegisterHeaderCell.h"
#import "BTTLoginOrRegisterTypeSelectCell.h"
#import "BTTLoginCell.h"
#import "BTTForgetPasswordCell.h"
#import "BTTLoginOrRegisterBtnCell.h"
#import "BTTRegisterNormalCell.h"
#import "BTTRegisterQuickAutoCell.h"
#import "BTTRegisterQuickManualCell.h"
#import "BTTLoginOrRegisterViewController+UI.h"
#import "BTTLoginCodeCell.h"
#import "BTTLoginOrRegisterViewController+API.h"
#import "BTTForgetPasswordController.h"
#import "BTTLoginNoRegisterCell.h"
#import "BTTRegisterNinameNormalCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "BTTLoginInfoView.h"
#import "BTTVideoNormalRegisterView.h"

@interface BTTLoginOrRegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, assign) CGRect activedTextFieldRect;

@property (nonatomic, copy) NSString *mobile; ///< 输入过的手机号码

@property (nonatomic, strong) NSURL *videoUrl;
/** 视频播放器 */
@property (nonatomic, strong) AVPlayerViewController *playerVC;

@property (strong,nonatomic) AVPlayerItem *item;

@property (strong,nonatomic) AVPlayer *player;

@property (nonatomic, strong) BTTVideoNormalRegisterView *noramlRegisterView;
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel * pressNumLab;
@property (nonatomic, assign) NSInteger pressNum;
@property (nonatomic, strong) UIButton *imgCodeBtn;
@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong)UIView * imgCodePopViewBg;
@end

@implementation BTTLoginOrRegisterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player pause];
    self.player = nil;
    [self.item removeObserver:self forKeyPath:@"status"];
    [self.item removeObserver:self forKeyPath:@"loadedTimeRanges"];
    self.item = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.pressLocationArr = [[NSMutableArray alloc] init];
    //设置本地视频路径
    NSString *mpath=[[NSBundle mainBundle] pathForResource:@"login_bg_video" ofType:@"mp4"];
    NSURL *url=[NSURL fileURLWithPath:mpath];
    AVAsset *asset = [AVAsset assetWithURL:url];
    self.item=[AVPlayerItem playerItemWithAsset:asset];
    //设置AVPlayer中的AVPlayerItem
    self.player=[AVPlayer playerWithPlayerItem:self.item];
    //初始化layer 传入player
    AVPlayerLayer *layer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    //设置layer的属性
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.frame = self.view.bounds;
    layer.backgroundColor=[UIColor blackColor].CGColor;
    //将视频的layer添加到视图的layer中
    [self.view.layer addSublayer:layer];
    //监听status属性，注意监听的是AVPlayerItem
    [self.item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //监听loadedTimeRanges属性
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(runLoopTheMovie:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

    self.qucikRegisterType = BTTQuickRegisterTypeAuto;
    self.loginCellType = BTTLoginCellTypeNormal;
    if (self.registerOrLoginType == BTTRegisterOrLoginTypeLogin) {
        self.title = @"登录";
    } else {
        self.registerOrLoginType = BTTRegisterOrLoginTypeRegisterQuick;
        self.title = @"立即开户";
    }
    
    [self setUpView];
    [self handleShowOrHide];
}

- (void)handleShowOrHide{
    if (self.registerOrLoginType==BTTRegisterOrLoginTypeRegisterNormal) {
        self.loginView.hidden = YES;
        self.fastRegisterView.hidden = YES;
        self.noramlRegisterView.hidden = NO;
    }else if (self.registerOrLoginType==BTTRegisterOrLoginTypeLogin){
        self.loginView.hidden = NO;
        self.fastRegisterView.hidden = YES;
        self.noramlRegisterView.hidden = YES;
    }else if (self.registerOrLoginType==BTTRegisterOrLoginTypeRegisterQuick){
        self.loginView.hidden = YES;
        self.fastRegisterView.hidden = NO;
        self.noramlRegisterView.hidden = YES;
    }
}

- (void)runLoopTheMovie:(NSNotification *)n{
    //注册的通知  可以自动把 AVPlayerItem 对象传过来，只要接收一下就OK
    AVPlayerItem * p = [n object];
    //关键代码
    [p seekToTime:kCMTimeZero];
    [_player play];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;

    if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        
    }else if ([keyPath isEqualToString:@"status"]){
        if (playerItem.status == AVPlayerItemStatusReadyToPlay){
            NSLog(@"playerItem is ready");
            //如果视频准备好 就开始播放
            [self.player play];
        } else if(playerItem.status == AVPlayerStatusUnknown){
            NSLog(@"playerItem Unknown错误");
        } else if (playerItem.status == AVPlayerStatusFailed){
            NSLog(@"playerItem 失败");
        }
    }
}

- (void)backBtn_click:(id)sender{
    if (self.registerOrLoginType==BTTRegisterOrLoginTypeRegisterNormal) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.registerOrLoginType==BTTRegisterOrLoginTypeLogin){
        if (self.loginView.isHidden) {
            self.noramlRegisterView.hidden = YES;
            self.fastRegisterView.hidden = YES;
            self.loginView.hidden = NO;
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (self.registerOrLoginType==BTTRegisterOrLoginTypeRegisterQuick){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)setUpView{
    
    UIButton *backBtn = [[UIButton alloc]init];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    _backBtn = backBtn;
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(36);
        make.width.mas_equalTo(23);
        make.height.mas_equalTo(41);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
    }];
    
    UIImageView *appIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_header_logo"]];
    appIcon.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:appIcon];
    [appIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(122);
        make.width.height.mas_equalTo(72);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    weakSelf(weakSelf);
    BTTLoginInfoView *loginInfoView = [[BTTLoginInfoView alloc]initWithFrame:CGRectMake(0, 234, SCREEN_WIDTH, 345)];
    __weak typeof(loginInfoView) weaklginView = loginInfoView;
    loginInfoView.hidden = YES;
    loginInfoView.sendSmdCode = ^(NSString * _Nonnull phone) {
        [weakSelf loadMobileVerifyCodeWithPhone:phone use:2 completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
            IVJResponseObject *result = response;
            if ([result.head.errCode isEqualToString:@"0000"]) {
                [MBProgressHUD showSuccess:@"验证码已发送, 请注意查收" toView:nil];
                [weaklginView.pwdTextField setEnabled:true];
                self.messageId = result.body[@"messageId"];
            }else{
                [weaklginView.pwdTextField setEnabled:false];
                [MBProgressHUD showError:result.head.errMsg toView:nil];
            }
        }];
    };
    loginInfoView.tapLogin = ^(NSString * _Nonnull account, NSString * _Nonnull password, BOOL isSmsCode, NSString *codeStr) {
        [weakSelf loginWithAccount:account pwd:password isSmsCode:isSmsCode codeStr:codeStr];
    };
    loginInfoView.tapForgetAccountAndPwd = ^{
        strongSelf(strongSelf);
        BTTForgetPasswordController *vc = [[BTTForgetPasswordController alloc] init];
        [strongSelf.navigationController pushViewController:vc animated:YES];
    };
    
    loginInfoView.tapRegister = ^{
        strongSelf(strongSelf);
        weaklginView.hidden = YES;
        strongSelf.fastRegisterView.hidden = NO;
    };
    
    loginInfoView.refreshCodeImage = ^{
        strongSelf(strongSelf);
        [strongSelf.pressLocationArr removeAllObjects];
        [self imgCodeBtnPopView];
        [strongSelf loadVerifyCode];
    };
    
    [self.view addSubview:loginInfoView];
    self.loginView = loginInfoView;
    
    BTTVideoFastRegisterView *fastRegisterView = [[BTTVideoFastRegisterView alloc]initWithFrame:CGRectMake(0, 234, SCREEN_WIDTH, 285)];
    __weak typeof(fastRegisterView) weakFastRegisterView = fastRegisterView;
    fastRegisterView.hidden = YES;
    fastRegisterView.tapRegister = ^(NSString * _Nonnull account, NSString * _Nonnull code) {
        [weakSelf verifySmsCodeCorrectWithAccount:account code:code];
    };
    fastRegisterView.tapOneKeyRegister = ^{
        [weakSelf onekeyRegisteAccount];
    };
    fastRegisterView.sendSmdCode = ^(NSString * _Nonnull phone) {
        [weakSelf loadMobileVerifyCodeWithPhone:phone use:1 completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
            IVJResponseObject *result = response;
            if ([result.head.errCode isEqualToString:@"0000"]) {
                [MBProgressHUD showSuccess:@"验证码已发送, 请注意查收" toView:nil];
                [weakFastRegisterView.imgCodeField setEnabled:true];
                self.messageId = result.body[@"messageId"];
            }else{
                [weakFastRegisterView.imgCodeField setEnabled:false];
                [MBProgressHUD showError:result.head.errMsg toView:nil];
            }
        }];
    };

    [self.view addSubview:fastRegisterView];
    _fastRegisterView = fastRegisterView;
}

-(void)imgCodeBtnPopView {
    self.pressNum = 0;
    [self.view endEditing:true];
    
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap)];
    tap.numberOfTapsRequired = 1;
    view.userInteractionEnabled = true;
    [view addGestureRecognizer:tap];
    _imgCodePopViewBg = view;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    UIButton * imgCodeBtn = [[UIButton alloc] init];
    imgCodeBtn.adjustsImageWhenHighlighted = NO;
    [imgCodeBtn addTarget:self action:@selector(savePressLocation:event:) forControlEvents:UIControlEventTouchUpInside];
    [_imgCodePopViewBg addSubview:imgCodeBtn];
    _imgCodeBtn = imgCodeBtn;
    [imgCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view).offset(-20);
        make.center.equalTo(view);
    }];
    
    UIButton * refreshBtn = [[UIButton alloc] init];
    [refreshBtn setImage:[UIImage imageNamed:@"bjl_refresh"] forState:UIControlStateNormal];
    refreshBtn.adjustsImageWhenHighlighted = NO;
    [refreshBtn addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    [_imgCodePopViewBg addSubview:refreshBtn];
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(imgCodeBtn);
        make.width.height.offset(30);
    }];
}

-(void)addLocationImg:(CGFloat)x y:(CGFloat)y num:(NSInteger)num {
    UIImage * img = [UIImage imageNamed:@"ic_login_captcha_location"];
    CGSize size = CGSizeMake(img.size.width, img.size.height);
    UIImageView * locImageView = [[UIImageView alloc] init];
    locImageView.tag = num;
    locImageView.frame = CGRectMake(x-size.width/2, y-size.height, size.width, size.height);
    locImageView.image = img;
    [self.imgCodeBtn addSubview:locImageView];
    
    UILabel * pressNumLab = [[UILabel alloc] init];
    pressNumLab.font = [UIFont systemFontOfSize:14];
    pressNumLab.text = [NSString stringWithFormat:@"%ld", (long)num];
    pressNumLab.backgroundColor = [UIColor clearColor];
    pressNumLab.textColor = [UIColor whiteColor];
    pressNumLab.textAlignment = NSTextAlignmentCenter;
    [locImageView addSubview:pressNumLab];
    _pressNumLab = pressNumLab;
    [pressNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(locImageView);
    }];
}

-(void)refreshAction {
    [self removeLocationView];
    [self.pressLocationArr removeAllObjects];
    [self loadVerifyCode];
}

-(void)setImgCodeImg:(UIImage *)imgCodeImg {
    _imgCodeImg = imgCodeImg;
    [self.imgCodeBtn setImage:imgCodeImg forState:UIControlStateNormal];
    if (self.cancelBtn == nil) {
        UIButton * cancelBtn = [[UIButton alloc] init];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [cancelBtn setBackgroundColor:[UIColor whiteColor]];
        cancelBtn.layer.borderColor = [UIColor brownColor].CGColor;
        cancelBtn.layer.borderWidth = 2.0;
        cancelBtn.layer.cornerRadius = 5.0;
        cancelBtn.clipsToBounds = true;
        cancelBtn.adjustsImageWhenHighlighted = NO;
        [cancelBtn addTarget:self action:@selector(bgTap) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn = cancelBtn;
        [_imgCodePopViewBg addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgCodeBtn.mas_bottom).offset(10);
            make.left.right.equalTo(self.imgCodeBtn);
            make.height.offset(50);
        }];
    }
}

-(void)removeLocationView {
    self.pressNum = 0;
    for (UIView * subView in self.imgCodeBtn.subviews) {
        if ([subView isKindOfClass:[UIImageView class]] && subView.tag > 0) {
            [subView removeFromSuperview];
        }
    }
}

-(void)savePressLocation:(UIButton *)sender event:(UIEvent *)event {
    self.pressNum += 1;
    UITouch *touch = [[event touchesForView:sender] anyObject];
    CGPoint point = [touch locationInView:sender];
    NSDictionary * dict = @{@"x":@(point.x), @"y":@(point.y)};
    [self addLocationImg:point.x y:point.y num:self.pressNum];
    [self.pressLocationArr addObject:dict];
    if (self.pressLocationArr.count == self.specifyWordNum) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:self.pressLocationArr options:NSJSONWritingPrettyPrinted error:nil];
        NSString * result = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [self checkChineseCaptcha:result];
    }
}

-(void)checkChineseCaptchaSuccess {
    [self.imgCodePopViewBg removeFromSuperview];
    [self.loginView.showBtn setTitle:@"验证成功" forState:UIControlStateNormal];
    [self.loginView.showBtn setTitleColor:[UIColor colorWithRed: 0.45 green: 0.96 blue: 0.62 alpha: 1.00] forState:UIControlStateNormal];
    self.loginView.showBtn.layer.borderColor = [UIColor colorWithRed: 0.45 green: 0.96 blue: 0.62 alpha: 1.00].CGColor;
    [self.loginView.showBtn setImage:[UIImage imageNamed:@"ic_login_captcha_success"] forState:UIControlStateNormal];
    self.loginView.showBtn.userInteractionEnabled = false;
}

-(void)checkChineseCaptchaAgain {
    [self.loginView.showBtn setTitle:@"点此进行验证" forState:UIControlStateNormal];
    [self.loginView.showBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    self.loginView.showBtn.layer.borderColor = [UIColor brownColor].CGColor;
    [self.loginView.showBtn setImage:[UIImage imageNamed:@"ic_login_show_captcha_icon"] forState:UIControlStateNormal];
    self.loginView.showBtn.userInteractionEnabled = true;
    self.loginView.ticketStr = @"";
    self.cancelBtn = nil;
}

-(void)bgTap {
    [self.imgCodePopViewBg removeFromSuperview];
    self.cancelBtn = nil;
}

#pragma mark - textfielddelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activedTextFieldRect = [textField convertRect:textField.frame toView:self.view];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
