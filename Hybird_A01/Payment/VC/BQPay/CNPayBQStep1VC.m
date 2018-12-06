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
@property (weak, nonatomic) IBOutlet UIButton *amountBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet CNPayNameTF *nameTF;
@property (weak, nonatomic) IBOutlet CNPayNormalTF *bankTF;
@property (weak, nonatomic) IBOutlet CNPayAmountRecommendView *nameView;
@property (weak, nonatomic) IBOutlet UIView *nameAreaView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameAreaViewHeight;


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
    [self configRecommendView];
    [self configAmountList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:450 fullScreen:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    weakSelf(weakSelf);
    self.nameTF.endedHandler = ^{
        weakSelf.bankTF.text = nil;
        weakSelf.bankNames = nil;
    };
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

/// 推荐姓名
- (void)configRecommendView {
    if (self.paymentModel.depositor.length == 0) {
        _nameAreaView.hidden = YES;
        _nameAreaViewHeight.constant = 0;
        return;
    }
    NSArray *array = [self.paymentModel.depositor componentsSeparatedByString:@";"];
    if (array.count == 0) {
        _nameAreaView.hidden = YES;
        _nameAreaViewHeight.constant = 0;
        return;
    }
    _nameTF.text = array.firstObject;
    _nameView.dataSource = array;
    __weak typeof(self) weakSelf = self;
    _nameView.clickHandler = ^(NSString *value, NSInteger index) {
        [weakSelf.view endEditing:YES];
        if ([weakSelf.nameTF.text isEqualToString:value]) {
            return;
        }
        weakSelf.nameTF.text = value;
        weakSelf.bankTF.text = nil;
        weakSelf.bankNames = nil;
    };
}

- (void)configAmountList {
    self.amountBtn.hidden = self.paymentModel.amountCanEdit;
    if (!self.paymentModel.amountCanEdit) {
        self.amountTF.placeholder = @"仅可选择以下金额";
    }
}


- (IBAction)selectAmountList:(id)sender {
    weakSelf(weakSelf);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.paymentModel.amountList.count];
    for (id obj in self.paymentModel.amountList) {
        [array addObject:[NSString stringWithFormat:@"%@", obj]];
    }
    if (array.count == 0) {
        [self showError:@"无可选金额，请直接输入"];
        return;
    }
    [BRStringPickerView showStringPickerWithTitle:@"选择充值金额" dataSource:array defaultSelValue:self.amountTF.text resultBlock:^(id selectValue, NSInteger index) {
        if ([weakSelf.amountTF.text isEqualToString:selectValue]) {
            return;
        }
        weakSelf.amountTF.text = selectValue;
    }];
}

- (IBAction)selectedBank:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.nameTF.text.length == 0) {
        [self showError:@"请输入姓名"];
        return;
    }
    if (!self.bankNames) {
        [self BQGetBank];
        return;
    }
    [self selectBank];
}

- (void)BQGetBank {
    [self showLoading];
    __weak typeof(self) weakSelf = self;
    // 获取银行卡列表
    [CNPayRequestManager paymentGetBankListWithType:NO depositor:self.nameTF.text referenceId:nil completeHandler:^(IVRequestResultModel *result, id response) {
        [weakSelf hideLoading];
        if (result.status) {
            /// 数据解析
            NSArray *array = result.data[@"bankList"];
            NSArray *bankList = [CNPayBankCardModel arrayOfModelsFromDictionaries:array error:nil];
            if (bankList.count == 0) {
                [self showError:result.message];
                return;
            }
            NSMutableArray *bankNames = [NSMutableArray array];
            for (CNPayBankCardModel *model in bankList) {
                [bankNames addObject:model.bankname];
            }
            weakSelf.bankNames = [bankNames copy];
            [weakSelf selectBank];
            return;
        }
        [weakSelf showError:result.message];
    }];
}

- (void)selectBank {
    weakSelf(weakSelf);
    [BRStringPickerView showStringPickerWithTitle:_bankTF.placeholder dataSource:self.bankNames defaultSelValue:self.bankTF.text resultBlock:^(id selectValue, NSInteger index) {
        if ([weakSelf.bankTF.text isEqualToString:selectValue]) {
            return;
        }
        weakSelf.bankTF.text = selectValue;
        weakSelf.chooseBank = weakSelf.paymentModel.bankList[index];
    }];
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
        [self showError:[NSString stringWithFormat:@"存款金额必须是%.f~%.f之间，最大允许2位小数", self.paymentModel.minamount, maxAmount]];
        return;
    }
    
    if (self.nameTF.text.length == 0) {
        [self showError:@"请输入存款人姓名"];
        return;
    }
    
    if (self.bankTF.text.length == 0) {
        [self showError:self.bankTF.placeholder];
        return;
    }
    
    self.writeModel.depositBy = self.nameTF.text;
    self.writeModel.amount = self.amountTF.text;
    self.writeModel.chooseBank = self.chooseBank;
    self.writeModel.BQType = [self getBQType];
    // 提交订单
    [self sumbitBill:sender];
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
                [weakSelf showError:@"系统错误，请联系客服"];
                return;
            }
            weakSelf.writeModel.chooseBank = model;
            [weakSelf goToStep:1];
        } else {
            [weakSelf showError:result.message];
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
