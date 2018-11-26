//
//  CNPayBQStep1VC.m
//  HybirdApp
//
//  Created by cean.q on 2018/10/23.
//  Copyright © 2018年 harden-imac. All rights reserved.
//

#import "CNPayBQStep1VC.h"
#import "CNCompleteInfoView.h"

@interface CNPayBQStep1VC ()
@property (weak, nonatomic) IBOutlet UIView *topTipView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTipViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *topTipLb;

@property (weak, nonatomic) IBOutlet UIView *preSettingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *preSettingViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *preSettingMessageLb;

@property (weak, nonatomic) IBOutlet CNPayAmountTF *amountTF;

@property (weak, nonatomic) IBOutlet CNPayNameTF *nameTF;

@property (weak, nonatomic) IBOutlet UIView *bottomTipView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomTipViewHeight;
@property (assign, nonatomic) CGFloat bottomViewHeight;
@end

@implementation CNPayBQStep1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDifferentUI];
    [self configPreSettingMessage];
    // 初始化数据
    [self updateAllContentWithModel:self.paymentModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:500 fullScreen:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 需要完善个人信息
    if (self.preSaveMsg.length == 0) {
        __weak typeof(self) weakSelf = self;
        [CNCompleteInfoView completeInfoHandler:^{
            [weakSelf configPreSettingMessage];
        }];
    }
    /// 只引导用户一次
    [self showAliTip];
}

- (void)configDifferentUI {
    self.bottomTipView.hidden = YES;
    self.bottomViewHeight = self.bottomTipViewHeight.constant;
    self.bottomTipViewHeight.constant = 0;
    NSString *tipText;
    switch (self.paymentModel.paymentType) {
        case CNPaymentBQWechat:
            tipText = @"使用微信转账至银行卡进行充值。";
            break;
        case CNPaymentBQAli:
            tipText = @"使用支付宝转账至银行卡进行充值。";
            break;
        case CNPaymentBQFast:
            tipText = @"";
            self.topTipView.hidden = YES;
            self.topTipViewHeight.constant = 10;
            break;
        case CNPaymentDeposit:
            tipText = @"使用手工存款至银行卡进行充值。";
            break;
        default:
            tipText = @"";
            break;
    }
    self.topTipLb.text = tipText;
}

- (void)configPreSettingMessage {
    if (self.preSaveMsg.length > 0) {
        self.preSettingMessageLb.text = self.preSaveMsg;
        self.preSettingViewHeight.constant = 50;
        self.preSettingView.hidden = NO;
    } else {
        self.preSettingViewHeight.constant = 0;
        self.preSettingView.hidden = YES;
    }
}

/// 刷新数据
- (void)updateAllContentWithModel:(CNPaymentModel *)model {
    self.amountTF.text = @"";
    // 金额提示语
    if (model.maxamount > model.minamount) {
        self.amountTF.placeholder = [NSString stringWithFormat:@"最少%.0f，最多%.0f", model.minamount, model.maxamount];
    } else {
        self.amountTF.placeholder = [NSString stringWithFormat:@"最少%.0f", model.minamount];
    }
}

- (void)showAliTip {
    if (self.paymentModel.paymentType != CNPaymentBQFast) { return; }
    NSString *key = @"aliTipHasAlreadyShow";
    BOOL show = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    if (show) { return; }
    NSString *message = @"使用支付宝付款的客户请使用上方的【支付宝转账】充值方式";
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
    }];
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (IBAction)submitAction:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString *text = _amountTF.text;
    
    /// 输入为不合法数字
    if (![NSString isPureInt:text] && ![NSString isPureFloat:text]) {
        _amountTF.text = nil;
        [self showError:@"请输入充值金额"];
        return;
    }
    
    /// 超出额度范围
    NSNumber *amount = [NSString convertNumber:text];
    double maxAmount = self.paymentModel.maxamount > self.paymentModel.minamount ? self.paymentModel.maxamount : CGFLOAT_MAX;
    if ([amount doubleValue] > maxAmount || [amount doubleValue] < self.paymentModel.minamount) {
        _amountTF.text = nil;
        [self showError:_amountTF.placeholder];
        return;
    }
    
    if (self.nameTF.text.length == 0) {
        [self showError:@"请输入存款人姓名"];
        return;
    }
    
    self.writeModel.depositBy = self.nameTF.text;
    self.writeModel.amount = self.amountTF.text;
    
    
    if (self.paymentModel.paymentType == CNPaymentDeposit) {
        [self depositGetBank:sender];
        return;
    }
    
    
    // 下面是BQ
    self.writeModel.chooseBank = self.paymentModel.bankList.firstObject;
    self.writeModel.BQType = [self getBQType];
    if (!self.writeModel.chooseBank) {
        self.bottomTipView.hidden = NO;
        self.bottomTipViewHeight.constant = 65;
        sender.enabled = NO;
        return;
    }
    // 提交订单
    [self sumbitBill:sender];
}

- (void)depositGetBank:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(sender) weakSender = sender;
    // 获取银行卡列表
    [CNPayRequestManager paymentGetBankListWithType:YES depositor:self.nameTF.text referenceId:nil completeHandler:^(IVRequestResultModel *result, id response) {
        sender.selected = NO;
        if (result.status) {
            /// 数据解析
            NSError *error;
            NSArray *array = [CNPayBankCardModel arrayOfModelsFromDictionaries:result.data error:&error];
            if (array.count == 0) {
                [weakSelf showNoBankError];
                weakSender.enabled = NO;
                return;
            }
            weakSelf.writeModel.chooseBank = array.firstObject;
            [self goToStep:1];
        } else {
            if (result.code_system == 99000013) {
                [weakSelf showNoBankError];
                weakSender.enabled = NO;
            } else {
                [weakSelf showError:result.message];
            }
        }
    }];
}

- (void)sumbitBill:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(sender) weakSender = sender;
    [CNPayRequestManager paymentSubmitBill:self.writeModel completeHandler:^(IVRequestResultModel *result, id response) {
        sender.selected = NO;
        if (result.status) {
            CNPayBankCardModel *model = [[CNPayBankCardModel alloc] initWithDictionary:result.data error:nil];
            if (!model) {
                [weakSelf showNoBankError];
                weakSender.enabled = NO;
                return;
            }
            weakSelf.writeModel.chooseBank = model;
            [weakSelf goToStep:1];
        } else {
            if (result.code_system == 99000013) {
                [weakSelf showNoBankError];
                weakSender.enabled = NO;
            } else {
                [weakSelf showError:result.message]; 
            }
        }
    }];
}

- (void)showNoBankError {
    self.bottomTipView.hidden = NO;
    self.bottomTipViewHeight.constant = self.bottomViewHeight;
}

- (CNPayBQType)getBQType {
    switch (self.paymentModel.paymentType) {
        case CNPaymentBQAli:
            return CNPayBQTypeAli;
        case CNPaymentBQFast:
            return CNPayBQTypeBankUnion;
        case CNPaymentBQWechat:
            return CNPayBQTypeWechat;
        default:
            return 0;
    }
}

@end
