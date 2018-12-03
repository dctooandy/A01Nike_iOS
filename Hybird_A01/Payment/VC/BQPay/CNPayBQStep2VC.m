//
//  CNPayBQStep2VC.m
//  A05_iPhone
//
//  Created by cean.q on 2018/10/1.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayBQStep2VC.h"
#import "CNPayBQSuccessVC.h"

@interface CNPayBQStep2VC ()

@property (weak, nonatomic) IBOutlet UILabel *payBankNameLb;
@property (weak, nonatomic) IBOutlet UILabel *depositLb;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;

@property (weak, nonatomic) IBOutlet UIImageView *alertIV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertIVHeight;
@property (weak, nonatomic) IBOutlet UILabel *alertLb;

@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (weak, nonatomic) IBOutlet UILabel *fastTipLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fastTipLbHeight;

@property (weak, nonatomic) IBOutlet UIImageView *bankBGIV;
@property (weak, nonatomic) IBOutlet UIImageView *bankLogoIV;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLb;
@property (weak, nonatomic) IBOutlet UILabel *accountLb;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;

@property (weak, nonatomic) IBOutlet UIView *oneBtnView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneBtnViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UIView *twoBtnView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoBtnViewHeight;



@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger second;
@end

@implementation CNPayBQStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 倒计时15分钟
    _second = 900;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
    [self configDifferentUI];
}

// 倒计时
- (void)countDownAction {
    _second--;
    NSString *minute = [NSString stringWithFormat:@"%02ld", _second / 60];
    NSString *second = [NSString stringWithFormat:@"%02ld", _second % 60];
    self.timeLB.text = [NSString stringWithFormat:@"%@:%@", minute, second];
    if(_second == 0) {
        [self.timer invalidate];
    }
}

- (void)configDifferentUI {
    switch (self.paymentModel.paymentType) {
        case CNPaymentBQFast:
            self.alertIV.hidden = YES;
            self.alertIVHeight.constant = 0;
            self.alertLb.textColor = COLOR_HEX(0x82868F);
            self.alertLb.text = @"为保障快速到账，实际存款金额和持卡人须与订单一致。";
            self.twoBtnView.hidden = YES;
            self.twoBtnViewHeight.constant = 0;
            break;
        case CNPaymentBQWechat:
            self.fastTipLb.hidden = YES;
            self.fastTipLbHeight.constant = 0;
            self.oneBtnView.hidden = YES;
            self.oneBtnViewHeight.constant = 0;
            break;
        case CNPaymentBQAli:
            self.fastTipLb.hidden = YES;
            self.fastTipLbHeight.constant = 0;
            self.twoBtnView.hidden = YES;
            self.twoBtnViewHeight.constant = 0;
            [self.submitBtn setTitle:@"我已成功付款" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:750 fullScreen:YES];
    [self configUI];
}



- (void)configUI {
    CNPayBankCardModel *bankModel = self.writeModel.chooseBank;
    
    self.payBankNameLb.text = bankModel.bankname;
    self.depositLb.text = self.writeModel.depositBy;
    self.amountLb.text = bankModel.amount;
    
    [self.bankLogoIV sd_setImageWithURL:[NSURL URLWithString:bankModel.banklogo.cn_appendH5Domain]];
    self.bankNameLb.text = bankModel.bankname;
    self.accountNameLb.text = bankModel.accountname;
    self.accountLb.text  = bankModel.accountnumber;
    self.addressLb.text  = [NSString stringWithFormat:@"%@ %@ %@", bankModel.bankprovince, bankModel.bankcity, bankModel.bankaddress];
}

- (IBAction)copyAction:(UIButton *)sender {
    [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%@%@%@", _accountNameLb.text, _accountLb.text, _addressLb.text];
    [self showSuccess:@"已复制到剪切板"];
}

- (IBAction)goToPay:(UIButton *)sender {
    if (self.paymentModel.paymentType == CNPaymentBQAli) {
        [self popToRootViewController];
        return;
    }
    [self pushUIWebViewWithURLString:self.writeModel.chooseBank.bankurl title:self.paymentModel.paymentTitle];
}

- (IBAction)finishPay:(id)sender {
    [self popToRootViewController];
}

- (IBAction)seeWeChatPay:(id)sender {
    
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

@end
