//
//  KYMFastWithdrewVC.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/19.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMFastWithdrewVC.h"
#import "KYMWithdrewStatusView.h"
#import "KYMWithdrewAmountView.h"
#import "KYMWithdrewSubmitView.h"
#import "KYMWithdrewBankView.h"
#import "KYMWithdrewCusmoterView.h"
#import "KYMWithdrewNoticeView.h"
#import "KYMWithdrewNoticeView1.h"
#import "KYMWithdrewNoticeView2.h"
#import "KYMWithdrewRequest.h"
#import "Masonry.h"
@interface KYMFastWithdrewVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (nonatomic, assign) KYMWithdrewStep step;
@property (strong, nonatomic) KYMWithdrewStatusView *statusView;
@property (weak, nonatomic) NSLayoutConstraint *statusViewHeight;
@property (weak, nonatomic) NSLayoutConstraint *amountViewHeight;
@property (strong, nonatomic) KYMWithdrewAmountView *amountView;
@property (strong, nonatomic) KYMWithdrewBankView *bankView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) KYMWithdrewSubmitView *submitView;
@property (strong, nonatomic) KYMWithdrewCusmoterView *cusmoterView;
@property (strong, nonatomic) KYMWithdrewNoticeView *noticeView;
@property (strong, nonatomic) KYMWithdrewNoticeView1 *noticeView1;
@property (strong, nonatomic) KYMWithdrewNoticeView2 *noticeView2;
@property (weak, nonatomic) NSLayoutConstraint *contentViewHeight;
@property (strong, nonatomic) NSTimer *statusTimer;
@property (strong, nonatomic) NSTimer *timeoutTimer;
@property (assign, nonatomic) NSUInteger timeout;
@property (assign, nonatomic) BOOL isStartedTimeout;
@property (assign, nonatomic) BOOL isLoadedView;
@end

@implementation KYMFastWithdrewVC

- (void)dealloc
{
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
    [self stopGetWithdrawDetail];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"急速取款";
    [self setupSubViews];
    self.step = self.step;
    self.isLoadedView = YES;
    [self statusTimer];
}
- (NSTimer *)statusTimer
{
    if (!_statusTimer) {
        _statusTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(getWithdrawDetail) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_statusTimer forMode:NSRunLoopCommonModes];
    }
    return _statusTimer;
}
- (NSTimer *)timeoutTimer
{
    if (!_timeoutTimer) {
        _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeoutCountDown) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timeoutTimer forMode:NSRunLoopCommonModes];
    }
    return _timeoutTimer;
}
- (void)setupSubViews
{
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.offset(CGRectGetWidth([UIScreen mainScreen].bounds));
        make.height.offset(CGRectGetHeight([UIScreen mainScreen].bounds));
    }];
    self.statusView = [[KYMWithdrewStatusView alloc] init];
    self.amountView = [[KYMWithdrewAmountView alloc] init];
    self.bankView = [[KYMWithdrewBankView alloc] init];
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithRed:0x2c / 255.0 green:0x2d / 255.0 blue:0x33 / 255.0 alpha:1];
    self.submitView = [[KYMWithdrewSubmitView alloc] init];
    self.cusmoterView = [[KYMWithdrewCusmoterView alloc] init];
    self.noticeView = [[KYMWithdrewNoticeView alloc] init];
    self.noticeView1 = [[KYMWithdrewNoticeView1 alloc] init];
    self.noticeView2 = [[KYMWithdrewNoticeView2 alloc] init];
    __weak typeof(self)weakSelf = self;
    self.submitView.submitBtnHandle = ^{
        [weakSelf submitBtnClicked];
    };
    self.submitView.notReceivedBtnHandle = ^{
        [weakSelf notRecivedBtnClicked];
    };
    self.cusmoterView.customerBtnHandle = ^{
        [weakSelf customerBtnClicked];
    };
    [self.contentView addSubview:self.statusView];
    [self.contentView addSubview:self.amountView];
    [self.contentView addSubview:self.bankView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.submitView];
    [self.contentView addSubview:self.cusmoterView];
    [self.contentView addSubview:self.noticeView];
    [self.contentView addSubview:self.noticeView1];
    [self.contentView addSubview:self.noticeView2];
    
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.offset(160);
    }];
    [self.amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.statusView.mas_bottom).offset(19);
        make.height.offset(61);
    }];
    [self.bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.amountView.mas_bottom).offset(21);
        make.height.offset(230);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.bankView.mas_bottom).offset(24);
        make.height.offset(1);
    }];
    [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.bankView.mas_bottom).offset(51);
        make.height.offset(110);
    }];
    [self.noticeView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.bankView.mas_bottom).offset(53);
        make.height.offset(217);
    }];
    [self.noticeView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.bankView.mas_bottom).offset(39);
        make.height.offset(217);
    }];
    [self.submitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.bankView.mas_bottom).offset(35);
        make.height.offset(48);
    }];
    [self.cusmoterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.bankView.mas_bottom).offset(107);
        make.width.offset(191);
        make.height.offset(30);
    }];
    
    [self.bankView.iconImgView sd_setImageWithURL:[NSURL URLWithString:self.detailModel.data.bankIcon] placeholderImage:[UIImage imageNamed:@"mwd_default"]];
    self.bankView.bankName.text = self.detailModel.data.bankName;
    self.bankView.accoutName.text = self.detailModel.data.bankAccountName;
    self.bankView.account.text = self.detailModel.data.bankAccountNo;
    self.bankView.withdrawType.text = @"急速取款";
    self.bankView.amount.text = [self.detailModel.data.amount stringByAppendingString:@"元"];
    self.bankView.submitTime.text = self.detailModel.data.createdDate;
    self.bankView.confirmTime.text = self.detailModel.data.confirmTime;
    self.amountView.amount = self.detailModel.data.amount;
    
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)setStep:(KYMWithdrewStep)step
{
    if (_step == step && self.isLoadedView) {
        return;
    }
    _step = step;
    self.statusView.step = step;
    self.amountView.step = step;
    self.submitView.step = step;
    self.bankView.step = step;
    CGFloat statusViewHeight = 0;
    CGFloat amountViewHeight = 0;
    CGFloat bankViewHeight = 0;
    CGFloat submitHeight = 0;
    CGFloat submitTop = 0;
    CGFloat customerTop = 0;
    switch (step) {
        case KYMWithdrewStepOne:
            statusViewHeight = 160;
            amountViewHeight = 61;
            bankViewHeight = 230;
            submitHeight = 48;
            submitTop = 35;
            customerTop = 107;
            self.submitView.hidden = NO;
            self.noticeView.hidden = YES;
            self.noticeView1.hidden = YES;
            self.noticeView2.hidden = YES;
            self.cusmoterView.hidden = YES;
            self.lineView.hidden = YES;
            break;
        case KYMWithdrewStepTwo:
            statusViewHeight = 160;
            amountViewHeight = 61;
            bankViewHeight = 230;
            submitHeight = 48;
            submitTop = 35;
            customerTop = 221;
            self.submitView.hidden = YES;
            self.noticeView.hidden = YES;
            self.noticeView1.hidden = YES;
            self.noticeView2.hidden = NO;
            self.cusmoterView.hidden = NO;
            self.lineView.hidden = NO;
            break;
        case KYMWithdrewStepThree:
            statusViewHeight = 160;
            amountViewHeight = 90;
            bankViewHeight = 230;
            submitHeight = 125;
            submitTop = 187;
            customerTop = 337;
            self.submitView.hidden = NO;
            self.noticeView.hidden = NO;
            self.noticeView1.hidden = YES;
            self.noticeView2.hidden = YES;
            self.cusmoterView.hidden = NO;
            self.lineView.hidden = NO;
            break;
        case KYMWithdrewStepFour:
            statusViewHeight = 160;
            amountViewHeight = 90;
            bankViewHeight = 230;
            submitHeight = 125;
            submitTop = 167;
            customerTop = 304;
            self.submitView.hidden = YES;
            self.noticeView.hidden = YES;
            self.noticeView1.hidden = NO;
            self.noticeView2.hidden = YES;
            self.cusmoterView.hidden = NO;
            self.lineView.hidden = NO;
            break;
        case KYMWithdrewStepFive:
            statusViewHeight = 138;
            amountViewHeight = 123;
            bankViewHeight = 263;
            submitHeight = 48;
            submitTop = 35;
            customerTop = 107;
            self.submitView.hidden = NO;
            self.noticeView.hidden = YES;
            self.noticeView1.hidden = YES;
            self.noticeView2.hidden = YES;
            self.cusmoterView.hidden = NO;
            self.lineView.hidden = YES;
            break;
        case KYMWithdrewStepSix:
            statusViewHeight = 138;
            amountViewHeight = 102;
            bankViewHeight = 263;
            submitHeight = 48;
            submitTop = 35;
            customerTop = 107;
            self.submitView.hidden = NO;
            self.noticeView.hidden = YES;
            self.noticeView1.hidden = YES;
            self.noticeView2.hidden = YES;
            self.cusmoterView.hidden = NO;
            self.lineView.hidden = YES;
            break;
            
        default:
            break;
    }
    
    [self.statusView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(statusViewHeight);
    }];
    [self.amountView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(amountViewHeight);
    }];
    [self.bankView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(bankViewHeight);
    }];
    [self.submitView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankView.mas_bottom).offset(submitTop);
        make.height.offset(submitHeight);
    }];
    [self.cusmoterView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankView.mas_bottom).offset(customerTop);
    }];
    [self.view layoutIfNeeded];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(CGRectGetMaxY(self.cusmoterView.frame) + 30);
    }];
    [self.contentView bringSubviewToFront:self.submitView];
}
- (void)setDetailModel:(KYMGetWithdrewDetailModel *)detailModel
{
    _detailModel = detailModel;
    if (detailModel.matchStatus == KYMWithdrewDetailStatusFaild) { //撮合失败,走常规取款
        KYMWithdrewFaildVC *vc = [[KYMWithdrewFaildVC alloc] init];
        vc.userName = self.detailModel.data.loginName;
        vc.amountStr = self.detailModel.data.amount;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (detailModel.data.status == KYMWithdrewStatusSubmit || detailModel.data.status == KYMWithdrewStatusSubmit1 ) { // 第一步
        self.step = KYMWithdrewStepOne;
    } else if (detailModel.data.status == KYMWithdrewStatusWaiting && detailModel.data.depositStatus == KYMWithdrewStatusWaiting ) { // 第二步，等待付款
        self.step = KYMWithdrewStepTwo;
    } else if (detailModel.data.status == KYMWithdrewStatusWaiting && detailModel.data.depositStatus == KYMWithdrewStatusConfirm ) { // 第三步，待确认到账
        self.step = KYMWithdrewStepThree;
    } else if (detailModel.data.status == KYMWithdrewStatusSuccessed && detailModel.matchStatus == KYMWithdrewDetailStatusSuccess ) { // 第四步，超时
        self.step = KYMWithdrewStepFive;
    } else if (detailModel.data.status == KYMWithdrewStatusSuccessed && detailModel.matchStatus == KYMWithdrewDetailStatusDoing ) { // 第四步，点击取款确认
        self.step = KYMWithdrewStepSix;
    } else if (detailModel.data.status == KYMWithdrewStatusFaild ) { // 第三步，点击取款未到账
        self.step = KYMWithdrewStepFour;
    }
}

- (void)getWithdrawDetail
{
    [self stopGetWithdrawDetail];
    [KYMWithdrewRequest getWithdrawDetailWithParams:self.checkChannelParams callback:^(BOOL status, NSString * _Nonnull msg, KYMGetWithdrewDetailModel *  _Nonnull model) {
        if (!status) {
            [self statusTimer];
            return;
        }
        
        self.detailModel = model;
    
        if (!self.isStartedTimeout && model.data.confirmTimeFmt && model.data.confirmTimeFmt.length > 0) {
            NSUInteger m = 0;
            NSUInteger s = 0;
            NSArray *arry = [model.data.confirmTimeFmt componentsSeparatedByString:@":"];
            if (arry.count > 1) {
                m = [arry[0] integerValue];
                s = [arry[1] integerValue];
            } else if (arry.count == 1) {
                s = [arry[0] integerValue];
            }
            self.timeout = m * 60 + s;
            self.isStartedTimeout = YES;
            [self timeoutTimer];
        }
        if (model.matchStatus != KYMWithdrewDetailStatusFaild) {
            [self statusTimer];
        }
        
    }];
}
- (void)timeoutCountDown
{
    self.timeout--;
    NSUInteger m = self.timeout / 60;
    NSUInteger s = self.timeout - m * 60;
    self.statusView.statusLB3.text = [NSString stringWithFormat:@"%02ld分%02ld秒",m,s];
    if (self.timeout <= 0 ) {
        [self.timeoutTimer invalidate];
        self.timeoutTimer = nil;
        return;
    }
    
}
- (void)stopGetWithdrawDetail
{
    [self.statusTimer invalidate];
    self.statusTimer = nil;
}
- (void)submitBtnClicked {
    
    if (self.step == KYMWithdrewStepThree) {
        [self checkReceiveStats:NO];
    } else if (self.step == KYMWithdrewStepFive || self.step == KYMWithdrewStepSix) {
        [self stopGetWithdrawDetail];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
- (void)notRecivedBtnClicked {
    [self checkReceiveStats:YES];
}
- (void)checkReceiveStats:(BOOL)isNotRceived
{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"merchant"] = @"A01";
    //            mparams[@"loginName"] = @""; //用户名，底层已拼接
    //            mparams[@"productId"] = @""; //脱敏产品编号，底层已拼接
    params[@"opType"] = isNotRceived ? @"2" : @"1"; //是否为未到账
    params[@"transactionId"] = self.detailModel.data.transactionId;
    
    [self stopGetWithdrawDetail];
    
    [self showLoading];
    [KYMWithdrewRequest checkReceiveStatus:params callback:^(BOOL status, NSString * _Nonnull msg, id  _Nonnull body) {
        [self hideLoading];
        if (!status) {
            [MBProgressHUD showMessagNoActivity:msg toView:nil];
            return;
        }
        self.step =  isNotRceived ? KYMWithdrewStepFour : KYMWithdrewStepSix;
    }];
}
- (void)customerBtnClicked {
    
}
- (void)goToBack {
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
    [self stopGetWithdrawDetail];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
