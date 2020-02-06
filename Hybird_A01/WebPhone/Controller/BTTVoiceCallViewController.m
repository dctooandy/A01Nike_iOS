//
//  BTTVoiceCallViewController.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/1.
//  Copyright © 2018年 BTT. All rights reserved.
//

typedef NS_ENUM(NSInteger, BTTNumberBtnType) {
    BTTNumberBtnTypeOne = 1,
    BTTNumberBtnTypeTwo,
    BTTNumberBtnTypeThree,
    BTTNumberBtnTypeFour,
    BTTNumberBtnTypeFive,
    BTTNumberBtnTypeSix,
    BTTNumberBtnTypeSeven,
    BTTNumberBtnTypeEight,
    BTTNumberBtnTypeNine,
    BTTNumberBtnTypeXing,
    BTTNumberBtnTypeZero,
    BTTNumberBtnTypeJing,
    BTTNumberBtnTypeSilence,
    BTTNumberBtnTypeHangup,
    BTTNumberBtnTypeSpeaker
};

#import "BTTVoiceCallViewController.h"
#import "CallApi.h"

#define CURRENT_ACCOUNT @"1015"
#define PREFER_AUDIO_CODEC @"opus"
#define ONE_CODEC_MODE YES


@interface BTTVoiceCallViewController ()<CallApiDelegate> {
    dispatch_source_t _timer;
    dispatch_queue_t queue;
}

@property (weak, nonatomic) IBOutlet UIView *numberPadView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberPadHeightConstants;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *portraitConstants;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *landscapeConstants;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberLabelTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusLabelTop;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (nonatomic, copy) NSString *numString;

@property (weak, nonatomic) IBOutlet UIButton *xingBtn;

@property (nonatomic, strong) CallInfo *callinfo;

@property (nonatomic, strong) ApiConfig *sipConfig;

@property (nonatomic, strong) RegInfo *regInfo;

@property (nonatomic, strong) NSString *preferAudioCodec;

@property (weak, nonatomic) IBOutlet UIButton *hungupBtn;

@end

@implementation BTTVoiceCallViewController

- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    [self.navigationController setNavigationBarHidden:YES];
    [self updateUI];
    _numString = @"";
    [self initAccount];
    if(!self.regInfo || SipRegStatus_Offline == _regInfo.regStatus || SipRegStatus_Failed == _regInfo.regStatus){
        [CallApi startRegister];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    [self.navigationController setNavigationBarHidden:NO];
}


- (void)initAccount {
    [CallApi init];
    [CallApi setDelegate:self];
    _callinfo = nil;
    _regInfo = nil;
    
    _sipConfig = [[ApiConfig alloc] init];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:BTTUIDKey];
    _sipConfig.userName = uid;
    _sipConfig.password = @"jx@123";
    _sipConfig.displayName = uid;
    _sipConfig.authorizationUserName = uid;
    
    
    //测试环境
    //            _sipConfig.domain = @"223.119.51.211";
    //            _sipConfig.proxyServer = @"223.119.51.211";
    
    //生产环境
    _sipConfig.domain = @"218.213.95.77";
    _sipConfig.proxyServer = @"218.213.95.77";
    _sipConfig.port = 9060;
    [CallApi setConfig:_sipConfig];
    NSMutableArray *codec = [[NSMutableArray alloc] init];
    _preferAudioCodec = PREFER_AUDIO_CODEC;
    [self setPreferAudioCodecArray:codec];
    [CallApi setPreferredAudioCodecs: codec];
}

- (void) setPreferAudioCodecArray:(NSMutableArray*) codecs {
    [codecs removeAllObjects];
    [codecs addObject:_preferAudioCodec];
    if(ONE_CODEC_MODE){
        return;
    }
    if([_preferAudioCodec isEqualToString:@"opus"]) {
        [codecs addObject:@"ilbc"];
        [codecs addObject:@"PCMA"];
    }
    else if([_preferAudioCodec isEqualToString:@"ilbc"]){
        if([PREFER_AUDIO_CODEC isEqualToString:@"opus"])
            [codecs addObject:@"opus"];
        [codecs addObject:@"PCMA"];
    }
    else{
        if([PREFER_AUDIO_CODEC isEqualToString:@"opus"]){
            [codecs addObject:@"opus"];
            [codecs addObject:@"ilbc"];
        }
        else if([PREFER_AUDIO_CODEC isEqualToString:@"ilbc"])
            [codecs addObject:@"ilbc"];
    }
}

- (void)updateUI {
    self.numberPadHeightConstants.constant = SCREEN_HEIGHT / 4 * 3;
    if (SCREEN_WIDTH == 414) {
        self.btnWidth.constant = 75;
        self.btnHeight.constant = 75;
        self.numberLabelTop.constant = 50;
        self.statusLabelTop.constant = 20;
    } else if (SCREEN_WIDTH == 375) {
        self.btnWidth.constant = 70;
        self.btnHeight.constant = 70;
        self.numberLabelTop.constant = 50;
        self.statusLabelTop.constant = 15;
    }
}

- (IBAction)numBtnClick:(UIButton *)sender {
    NSInteger btnNum = sender.tag - 10000;
    switch (btnNum) {
        case BTTNumberBtnTypeOne:
        case BTTNumberBtnTypeTwo:
        case BTTNumberBtnTypeThree:
        case BTTNumberBtnTypeFour:
        case BTTNumberBtnTypeFive:
        case BTTNumberBtnTypeSix:
        case BTTNumberBtnTypeSeven:
        case BTTNumberBtnTypeEight:
        case BTTNumberBtnTypeNine:
        case BTTNumberBtnTypeZero:
        case BTTNumberBtnTypeXing:
        case BTTNumberBtnTypeJing:
        {
            if (!_numString.length) {
                _numLabel.text = @"";
            }
            
            _numString = [NSString stringWithFormat:@"%@%@",_numString,sender.titleLabel.text];
            _numLabel.text = _numString;
        }
            break;
        case BTTNumberBtnTypeSilence:
        {
            sender.selected = !sender.selected;
            [CallApi setMuted:sender.selected];
        }
            break;
        case BTTNumberBtnTypeSpeaker:
        {
            BOOL selectStatus = !sender.selected;
            BOOL success = [CallApi enableSpeaker:selectStatus];
            if (success) {
                sender.selected = selectStatus;
            }
            
        }
            break;
            
        case BTTNumberBtnTypeHangup:
        {
            [CallApi terminateCall];
            [CallApi unRegister];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - private methods

- (BOOL)canMakeCall{
    
    if(_callinfo && (CallStatus_Calling == _callinfo.callStatus ||
                     CallStatus_Connected == _callinfo.callStatus ||
                     CallStatus_Ringing == _callinfo.callStatus)) {
        return NO;
    }
    
    if(_regInfo && SipRegStatus_Connected== _regInfo.regStatus){
        return YES;
    }
    return NO;
}

- (void)setupTimer {
    // 创建GCD定时器
    __block NSInteger seconds = 0;
    weakSelf(weakSelf);
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    // 事件回调
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf(strongSelf);
            // 在主线程中实现需要的功能
            ++seconds;
            NSInteger min = seconds / 60;
            NSInteger sec = seconds % 60;
            NSString *timeStr = @"";
            if (sec < 10) {
                timeStr = [NSString stringWithFormat:@"通话中 %@:0%@",@(min),@(sec)];
            } else {
                timeStr = [NSString stringWithFormat:@"通话中 %@:%@",@(min),@(sec)];
            }
            
            strongSelf.statusLabel.text = timeStr;
        });
    });
    
    // 开启定时器
    dispatch_resume(_timer);
    
}

#pragma mark - CallApiDelegate

/* 通知呼叫状态事件信息 */
- (void)onCallState:(CallInfo *)callInfo {
    _callinfo = callInfo;
    NSString *statusString = @"";
    if (callInfo.callStatus == CallStatus_Ringing || callInfo.callStatus == CallStatus_Calling) {
        statusString = @"正在呼叫.....";
        _hungupBtn.userInteractionEnabled = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.statusLabel.text = statusString;
        });
    } else if (callInfo.callStatus == CallStatus_Connected) {
        _hungupBtn.userInteractionEnabled = YES;
        [self setupTimer];
    } else if (callInfo.callStatus == CallStatus_Disconnected) {
        // 关闭定时
        if (_timer!=nil) {
            dispatch_source_cancel(_timer);
        }
        
        statusString = @"通话结束";
        dispatch_async(dispatch_get_main_queue(), ^{
            self.statusLabel.textColor = [UIColor redColor];
            self.statusLabel.text = statusString;
        });
        [CallApi unRegister];
        [self postNotification];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:NO];
        });
    } else if (callInfo.callStatus == CallStatus_Failed) {
        self.statusLabel.textColor = [UIColor redColor];
        statusString = @"呼叫失败";
        dispatch_async(dispatch_get_main_queue(), ^{
            self.statusLabel.text = statusString;
        });
        [CallApi unRegister];
        [self postNotification];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:NO];
        });
    }
    
}

- (void)postNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:BTTVoiceCallResetTabbar object:nil];
}

/* 通知注册状态事件信息 */
- (void)onRegisterState:(RegInfo *)regInfo {
    _regInfo = regInfo;
    if (regInfo.regStatus == SipRegStatus_Connected) {
        if ([self canMakeCall]) {
            NSString *callNum = [[NSUserDefaults standardUserDefaults] objectForKey:BTTVoiceCallNumKey];
            [CallApi makeCall:callNum];
        }
    }
}

/* 呼叫接通后，通知当前通话的网络状态 */
- (void)onCallStatString:(NSString*)callStat {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
