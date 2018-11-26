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

@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (weak, nonatomic) IBOutlet UIImageView *bankLogoIV;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLb;
@property (weak, nonatomic) IBOutlet UILabel *accountLb;
@property (weak, nonatomic) IBOutlet UILabel *branchNameLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;


@property (weak, nonatomic) IBOutlet CNPaySubmitButton *submitBtn;


@property (nonatomic, assign) BOOL addLayer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger second;
@end

@implementation CNPayBQStep2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 倒计时15分钟
    _second = 900;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
    [self setViewHeight:800 fullScreen:YES];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configUI];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_addLayer) {
        [self addBorderToView:self.borderView];
        _addLayer = YES;
    }
}

- (void)configUI {
    CNPayBankCardModel *bankModel = self.writeModel.chooseBank;
    
    self.payBankNameLb.text = bankModel.bankname;
    self.depositLb.text = self.writeModel.depositBy;
    self.amountLb.text = bankModel.amount;
    
    [self.bankLogoIV sd_setImageWithURL:[NSURL URLWithString:bankModel.banklogo.cn_appendH5Domain]];
    self.bankNameLb.text = bankModel.bankname;
    self.branchNameLb.text = bankModel.accountname;
    self.accountLb.text  = bankModel.accountnumber;
    self.addressLb.text  = [NSString stringWithFormat:@"%@ %@ %@",
                            bankModel.bankprovince,
                            bankModel.bankcity,
                            bankModel.bankaddress];
    NSArray *payType = [self.paymentModel payTypeArray];
    NSString *title = [payType objectAtIndex:(NSInteger)self.writeModel.BQType];
    [self.submitBtn setTitle:title forState:UIControlStateNormal];
}

- (void)addBorderToView:(UIView *)view {
    view.layer.cornerRadius = 8;
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = COLOR_HEX(0x979797).CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:8].CGPath;
    border.frame = view.bounds; 
    border.lineWidth = 1;
    border.lineCap = @"square";
    border.lineDashPattern = @[@2, @4];
    [view.layer addSublayer:border];
}

- (IBAction)copyAction:(UIButton *)sender {
    [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%@%@%@", _branchNameLb.text, _accountLb.text, _addressLb.text];
    [self showSuccess:@"已复制到剪切板"];
}

- (IBAction)goToPay:(UIButton *)sender {
    switch (self.writeModel.BQType) {
        case CNPayBQTypeWechat:
        case CNPayBQTypeWap:
        case CNPayBQTypeBankUnion: {
//            CNWKWebVC *payWebVC = [[CNWKWebVC alloc] initWithURLString:self.model.chooseBank.bankurl];
//            [self pushViewController:payWebVC];
            [self pushUIWebViewWithURLString:self.writeModel.chooseBank.bankurl title:sender.currentTitle];
        }
            break;
            
        case CNPayBQTypeAli: {
//            CNWKWebVC *payWebVC = [[CNWKWebVC alloc] initWithURLString:self.model.chooseBank.alipay];
//            [self pushViewController:payWebVC];
            [self pushUIWebViewWithURLString:self.writeModel.chooseBank.alipay title:sender.currentTitle];
        }
            break;
            
        case CNPayBQTypeOther: {
            CNPayBQSuccessVC *payWebVC = [[CNPayBQSuccessVC alloc] initWithName:self.writeModel.depositBy];
            [self pushViewController:payWebVC];
        }
            break;
    }
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

@end
