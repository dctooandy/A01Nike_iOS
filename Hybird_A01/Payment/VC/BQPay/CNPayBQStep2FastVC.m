//
//  CNPayBQStep2FastVC.m
//  HybirdApp
//
//  Created by cean.q on 2018/10/23.
//  Copyright © 2018年 harden-imac. All rights reserved.
//

#import "CNPayBQStep2FastVC.h"
#import "CNWKWebVC.h"

@interface CNPayBQStep2FastVC ()
@property (weak, nonatomic) IBOutlet UILabel *timeLb;

@property (weak, nonatomic) IBOutlet UIView *AliView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *AliViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;

@property (weak, nonatomic) IBOutlet UIView *fastView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fastViewHeight;
@property (weak, nonatomic) IBOutlet CNPayLabel *fastNameLb;
@property (weak, nonatomic) IBOutlet UILabel *fastAmountLb;


@property (weak, nonatomic) IBOutlet UIView *bankView;
@property (weak, nonatomic) IBOutlet UIImageView *bankBGIV;
@property (weak, nonatomic) IBOutlet UIImageView *bankLogoIV;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLb;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLb;
@property (weak, nonatomic) IBOutlet UILabel *bankAccountLb;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLb;
@property (weak, nonatomic) IBOutlet UILabel *bankAddressLb;

@property (weak, nonatomic) IBOutlet UILabel *bottomTipLb;

@property (weak, nonatomic) IBOutlet CNPaySubmitButton *submitBtn;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger second;
@end

@implementation CNPayBQStep2FastVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDifferentUI];
    [self setViewHeight:700 fullScreen:YES];
    // 倒计时15分钟
    _second = 900;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)configDifferentUI {
    switch (self.paymentModel.paymentType) {
        case CNPaymentBQFast: {
            self.AliView.hidden = YES;
            self.AliViewHeight.constant = 0;
        }
            break;
            
        case CNPaymentBQWechat: {
            self.fastView.hidden = YES;
            self.fastViewHeight.constant = 0;
            self.bottomTipLb.text = @"请登录微信，打开微信钱包，点击收付款，点击下方的转账到银行卡功能进行转账操作。";
            [self.submitBtn setTitle:@"启动微信" forState:UIControlStateNormal];
        }
            break;
            
        case CNPaymentBQAli: {
            self.fastView.hidden = YES;
            self.fastViewHeight.constant = 0;
            self.bottomTipLb.text = @"请登录支付宝，点击转账，选择转账到银行卡，填写上述收款卡信息与系统提示的转账金额，完成转账。";
            [self.submitBtn setTitle:@"启动支付宝" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

// 倒计时
- (void)countDownAction {
    _second--;
    NSString *minute = [NSString stringWithFormat:@"%02ld", _second / 60];
    NSString *second = [NSString stringWithFormat:@"%02ld", _second % 60];
    self.timeLb.text = [NSString stringWithFormat:@"%@:%@", minute, second];
    if(_second == 0) {
        [self.timer invalidate];
    }
}

- (void)updateUI {
    CNPayBankCardModel *model = self.writeModel.chooseBank;
    self.amountLb.text = model.amount;
    self.fastAmountLb.text = model.amount;
    self.fastNameLb.text = self.writeModel.depositBy;
    
    [self.bankBGIV sd_setImageWithURL:[NSURL URLWithString:model.bankimage.cn_appendH5Domain] placeholderImage:[UIImage imageNamed:@"pay_bankBGPlaceholder"]];
    [self.bankLogoIV sd_setImageWithURL:[NSURL URLWithString:model.banklogo.cn_appendH5Domain]];
    self.bankNameLb.text = model.bankname;
    self.bankAccountLb.text = model.accountnumber;
    self.accountNameLb.text  = model.accountname;
    self.bankAddressLb.text  = [NSString stringWithFormat:@"%@ %@ %@",
                            model.bankprovince,
                            model.bankcity,
                            model.bankaddress];
    NSString *dateString = [NSDate br_getDateString:[NSDate dateWithTimeIntervalSinceNow:900] format:@"yyyy年MM月dd日 hh:mm"];
    self.deadlineLb.text = [NSString stringWithFormat:@"有效期限至：\n%@", dateString];
}



- (IBAction)copyBankInfo:(UIButton *)sender {
    [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%@%@%@%@", _bankNameLb.text, _bankAccountLb.text, _accountNameLb.text, _bankAddressLb.text];
    [self showSuccess:@"已复制到剪切板"];
}

- (IBAction)saveBankImage:(UIButton *)sender {
    [self saveToLibraryWithImage:[self creatViewImage:self.bankView]];
}


- (IBAction)submitAction:(UIButton *)sender {
    CNPayBankCardModel *model = self.writeModel.chooseBank;
    NSString *jumbURL;
    switch (self.paymentModel.paymentType) {
        case CNPaymentBQFast:
            jumbURL = model.bankurl;
            break;
            
        case CNPaymentBQAli:
            jumbURL = model.alipay;
            break;
            
        case CNPaymentBQWechat:
            jumbURL = model.bankurl;
            break;
            
        default:
            break;
    }
//    CNWKWebVC *payWebVC = [[CNWKWebVC alloc] initWithURLString:jumbURL];
//    [self pushViewController:payWebVC];
    [self pushUIWebViewWithURLString:jumbURL title:nil];
}


- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

@end
