//
//  BTTLoginOrRegisterViewController.m
//  Hybird_A01
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
@end

@implementation BTTLoginOrRegisterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
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
        [self loadVerifyCode];
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
            } else if(playerItem.status==AVPlayerStatusUnknown){
            NSLog(@"playerItem Unknown错误");
            }
        else if (playerItem.status==AVPlayerStatusFailed){
            NSLog(@"playerItem 失败");
        }
    }
}

- (void)setUpView{
    UIImageView *appIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_header_logo"]];
    appIcon.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:appIcon];
    [appIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(122);
        make.width.height.mas_equalTo(72);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    weakSelf(weakSelf);
    BTTLoginInfoView *loginInfoView = [[BTTLoginInfoView alloc]initWithFrame:CGRectMake(0, 294, SCREEN_WIDTH, 285)];
    loginInfoView.hidden = YES;
    loginInfoView.sendSmdCode = ^(NSString * _Nonnull phone) {
        [weakSelf loadMobileVerifyCodeWithPhone:phone use:2];
    };
    loginInfoView.tapLogin = ^(NSString * _Nonnull account, NSString * _Nonnull password, BOOL isSmsCode, NSString *codeStr) {
        [weakSelf loginWithAccount:account pwd:password isSmsCode:isSmsCode codeStr:codeStr];
    };
    loginInfoView.tapForgetAccountAndPwd = ^{
        strongSelf(strongSelf);
        BTTForgetPasswordController *vc = [[BTTForgetPasswordController alloc] init];
        [strongSelf.navigationController pushViewController:vc animated:YES];
    };
    __weak typeof(loginInfoView) weaklginView = loginInfoView;
    loginInfoView.tapRegister = ^{
        strongSelf(strongSelf);
        weaklginView.hidden = YES;
        [strongSelf loadVerifyCode];
        strongSelf.fastRegisterView.hidden = NO;
        
    };
    loginInfoView.refreshCodeImage = ^{
        [weakSelf loadVerifyCode];
    };
    [self.view addSubview:loginInfoView];
    self.loginView = loginInfoView;
    
    BTTVideoFastRegisterView *fastRegisterView = [[BTTVideoFastRegisterView alloc]initWithFrame:CGRectMake(0, 234, SCREEN_WIDTH, 285)];
    fastRegisterView.hidden = YES;
    fastRegisterView.tapRegister = ^(NSString * _Nonnull account, NSString * _Nonnull code) {
        [weakSelf fastRegisterWithAccount:account code:code];
    };
    fastRegisterView.tapNormalRegister = ^{
        weakSelf.noramlRegisterView.hidden = NO;
        weakSelf.fastRegisterView.hidden = YES;
    };
    fastRegisterView.refreshCodeImage = ^{
        [weakSelf loadVerifyCode];
    };
    [self.view addSubview:fastRegisterView];
    _fastRegisterView = fastRegisterView;
    BTTVideoNormalRegisterView *normalRegisterView = [[BTTVideoNormalRegisterView alloc]initWithFrame:CGRectMake(0, 234, SCREEN_WIDTH, 285)];
    normalRegisterView.hidden = YES;
    normalRegisterView.tapFast = ^{
        weakSelf.noramlRegisterView.hidden = YES;
        weakSelf.fastRegisterView.hidden = NO; 
    };
    normalRegisterView.tapRegister = ^(NSString * _Nonnull account, NSString * _Nonnull password) {
        [weakSelf checkLoginNameWithAccount:account password:password];
    };
    [self.view addSubview:normalRegisterView];
    _noramlRegisterView = normalRegisterView;
    
    [self loadVerifyCode];
}


#pragma mark - textfielddelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activedTextFieldRect = [textField convertRect:textField.frame toView:self.view];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

@end
