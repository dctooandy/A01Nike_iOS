//
//  CNMFastPayStatusVC.m
//  Hybird_1e3c3b
//
//  Created by cean on 2/17/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNMFastPayStatusVC.h"
typedef NS_ENUM(NSUInteger, CNMPayStatus) {
    CNMPayStatusSubmit,  //已提交
    CNMPayStatusPaying,  //等待支付
    CNMPayStatusConfirm, //已确认
    CNMPayStatusSuccess  //已完成
};

@interface CNMFastPayStatusVC ()

#pragma mark - 顶部状态试图
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *statusIVs;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *statusLbs;
@property (nonatomic, assign) CNMPayStatus status;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerH;
/// 时间前面
@property (weak, nonatomic) IBOutlet UILabel *tip1Lb;
/// 时间标签
@property (weak, nonatomic) IBOutlet UILabel *tip2Lb;
/// 时间后面
@property (weak, nonatomic) IBOutlet UILabel *tip3Lb;
/// 时间下面
@property (weak, nonatomic) IBOutlet UILabel *tip4Lb;
/// 大字提示语
@property (weak, nonatomic) IBOutlet UILabel *tip5Lb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tip5LbH;

#pragma mark - 中间金额视图
@property (weak, nonatomic) IBOutlet UILabel *amountTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;
@property (weak, nonatomic) IBOutlet UILabel *amountTipLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountTipLbH;

#pragma mark - 中间银行卡视图
@property (weak, nonatomic) IBOutlet UIView *bankView;


#pragma mark - 底部提示内容
@property (weak, nonatomic) IBOutlet UIView *clockView;
@property (weak, nonatomic) IBOutlet UIView *submitTipView;
@property (weak, nonatomic) IBOutlet UIView *confirmTipView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmTipViewH;

#pragma mark - 底部按钮组
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *customerServerBtn;

@end

@implementation CNMFastPayStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.bankView.layer.borderWidth = 1;
    self.bankView.layer.borderColor = kHexColor(0x3A3D46).CGColor;
    self.bankView.layer.cornerRadius = 8;
    
    self.clockView.layer.borderWidth = 1;
    self.clockView.layer.borderColor = kHexColor(0x0994E7).CGColor;
    self.clockView.layer.cornerRadius = 8;
    
    self.cancelBtn.layer.borderWidth = 1;
    self.cancelBtn.layer.borderColor = kHexColor(0xF2DA0F).CGColor;
    self.cancelBtn.layer.cornerRadius = 8;
    
    self.amountTipLb.hidden = YES;
    self.amountTipLbH.constant = 0;
    self.submitTipView.hidden = NO;
    self.confirmTipView.hidden = YES;
    self.customerServerBtn.hidden = YES;
}

- (void)setStatusUI:(CNMPayStatus)status {
    for (int i = 0; i <= status; i++) {
        if (i >= self.statusIVs.count) {
            break;
        }
        UIImageView *iv = self.statusIVs[i];
        [iv setHighlighted:YES];
        UILabel *label = self.statusLbs[i];
        label.textColor = kHexColor(0xD2D2D2);
    }
    
    switch (status) {
        case CNMPayStatusConfirm:
            self.headerH.constant = 140;
            self.tip1Lb.text = @"已等待";
            self.tip3Lb.hidden = YES;
            self.tip4Lb.hidden = YES;
            self.tip5Lb.hidden = YES;
            
            self.submitTipView.hidden = YES;
            self.confirmTipView.hidden = NO;
            break;
        case CNMPayStatusSuccess:
            self.headerH.constant = 140;
            self.tip1Lb.hidden = YES;
            self.tip2Lb.hidden = YES;
            self.tip3Lb.hidden = YES;
            self.tip4Lb.hidden = YES;
            self.tip5Lb.hidden = NO;
            self.tip5Lb.textColor = kHexColor(0x818791);
            self.tip5Lb.text = @"您完成了一笔存款";
            self.tip5LbH.constant = 16;
            
            self.amountTitleLb.hidden = YES;
            self.amountTipLb.hidden = NO;
            self.amountTipLbH.constant = 50;
            
            self.submitTipView.hidden = YES;
            self.confirmTipView.hidden = YES;
            self.confirmTipViewH.constant = 0;
            self.btnView.hidden = YES;
            self.customerServerBtn.hidden = NO;
            break;
        default:
            break;
    }
}

#pragma mark - 底部按钮组事件
- (IBAction)cancel:(UIButton *)sender {
    [self setStatusUI:CNMPayStatusSuccess];
}

- (IBAction)confirm:(UIButton *)sender {
    [self setStatusUI:CNMPayStatusConfirm];
}

- (IBAction)customerServer:(UIButton *)sender {
}


@end
