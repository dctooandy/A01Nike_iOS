//
//  CNPayBQStep1VC.m
//  HybirdApp
//
//  Created by cean.q on 2018/10/23.
//  Copyright © 2018年 harden-imac. All rights reserved.
//

#import "CNPayBQStep1VC.h"
#import "CNCompleteInfoView.h"
#import "CNPayNormalTF.h"

@interface CNPayBQStep1VC ()

@property (weak, nonatomic) IBOutlet UIView *preSettingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *preSettingViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *preSettingMessageLb;

@property (weak, nonatomic) IBOutlet CNPayAmountTF *amountTF;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet CNPayNameTF *nameTF;
@property (weak, nonatomic) IBOutlet CNPayNormalTF *bankTF;

@property (weak, nonatomic) IBOutlet UIView *bottomTipView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomTipViewHeight;

@property (nonatomic, strong) CNPayBankCardModel *chooseBank;
@property (nonatomic, copy) NSArray *bankNames;
@end

@implementation CNPayBQStep1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configPreSettingMessage];
    [self configDifferentUI];
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
//    if (self.preSaveMsg.length == 0) {
//        __weak typeof(self) weakSelf = self;
//        [CNCompleteInfoView completeInfoHandler:^{
//            [weakSelf configPreSettingMessage];
//        }];
//    }
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

- (void)configDifferentUI {
    switch (self.paymentModel.paymentType) {
        case CNPaymentBQWechat:
        case CNPaymentBQAli:
            _nameLb.text = @"真实姓名";
            self.bottomTipView.hidden = YES;
            self.bottomTipViewHeight.constant = 0;
            break;
        default:
            break;
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

- (IBAction)selectedBank:(UIButton *)sender {
    [self.view endEditing:YES];
    if (!self.bankNames) {
        return;
    }
    weakSelf(weakSelf);
    [BRStringPickerView showStringPickerWithTitle:_bankTF.placeholder dataSource:self.bankNames defaultSelValue:self.bankTF.text resultBlock:^(NSString * selectValue) {
        if ([weakSelf.bankTF.text isEqualToString:selectValue]) {
            return;
        }
        weakSelf.bankTF.text = selectValue;
        NSInteger index = [weakSelf.bankNames indexOfObject:selectValue];
        weakSelf.chooseBank = weakSelf.paymentModel.bankList[index];
    }];
}

- (IBAction)submitAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self goToStep:1];return;
    
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
                weakSender.enabled = NO;
                return;
            }
            weakSelf.writeModel.chooseBank = array.firstObject;
            [self goToStep:1];
        } else {
            if (result.code_system == 99000013) {
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
                weakSender.enabled = NO;
                return;
            }
            weakSelf.writeModel.chooseBank = model;
            [weakSelf goToStep:1];
        } else {
            if (result.code_system == 99000013) {
                weakSender.enabled = NO;
            } else {
                [weakSelf showError:result.message]; 
            }
        }
    }];
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
