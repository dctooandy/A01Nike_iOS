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
#import "Masonry.h"
@interface KYMFastWithdrewVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (nonatomic, assign) KYMWithdrewStatus status;
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

@end

@implementation KYMFastWithdrewVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    self.status = self.detailModel.data.status;
    [self.bankView.iconImgView sd_setImageWithURL:[NSURL URLWithString:self.detailModel.data.bankIcon] placeholderImage:nil];
    self.bankView.bankName.text = self.detailModel.data.bankName;
    self.bankView.accoutName.text = self.detailModel.data.bankAccountName;
    self.bankView.account.text = self.detailModel.data.bankAccountNo;
    self.bankView.withdrawType.text = @"急速取款";
    self.bankView.amount.text = [self.detailModel.data.amount stringByAppendingString:@"元"];
    self.bankView.submitTime.text = self.detailModel.data.createdDate;
    self.amountView.amountLB.text = [NSString stringWithFormat:@"¥ %@元",self.detailModel.data.amount];
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
    
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)setStatus:(KYMWithdrewStatus)status
{
    _status = status;
    if (status == KYMWithdrewStatusNotMatch || status == KYMWithdrewStatusFaild) {
        KYMWithdrewFaildVC *vc = [[KYMWithdrewFaildVC alloc] init];
        vc.userName = self.detailModel.data.loginName;
        vc.amountStr = self.detailModel.data.amount;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    self.statusView.status = status;
    self.amountView.status = status;
    self.submitView.status = status;
    CGFloat statusViewHeight = 0;
    CGFloat amountViewHeight = 0;
    CGFloat submitHeight = 0;
    CGFloat submitTop = 0;
    CGFloat customerTop = 0;
    switch (self.status) {
        case KYMWithdrewStatusSubmit:
            statusViewHeight = 160;
            amountViewHeight = 61;
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
        case KYMWithdrewStatusWaiting:
            statusViewHeight = 160;
            amountViewHeight = 61;
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
        case KYMWithdrewStatusConfirm:
            statusViewHeight = 160;
            amountViewHeight = 90;
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
        case KYMWithdrewStatusNotReceived:
            statusViewHeight = 160;
            amountViewHeight = 90;
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
        case KYMWithdrewStatusTimeout:
            statusViewHeight = 138;
            amountViewHeight = 123;
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
        case KYMWithdrewStatusSuccessed:
            statusViewHeight = 138;
            amountViewHeight = 102;
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
- (void)submitBtnClicked {
    
}
- (void)customerBtnClicked {
    printf("11111111");
}
- (void)goToBack {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
