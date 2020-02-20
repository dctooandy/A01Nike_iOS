//
//  CNPayOnlineVC.m
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayOnlineVC.h"
#import "CNPayOrderModel.h"
#import "BTTQueryOnlineBankModel.h"

@interface CNPayOnlineVC ()
@property (weak, nonatomic) IBOutlet UIView *preSettingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *preSettingViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *preSettingMessageLb;


@property (weak, nonatomic) IBOutlet CNPayAmountTF *amountTF;
@property (weak, nonatomic) IBOutlet UIButton *amountBtn;
@property (weak, nonatomic) IBOutlet UIImageView *arrawDownIV;

@property (weak, nonatomic) IBOutlet UIView *selectBankView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectBankViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *payBankTF;

@property (weak, nonatomic) IBOutlet UIView *bibaoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bibaoViewHeight;


@property (nonatomic, strong) CNPayBankCardModel *chooseBank;
@property (nonatomic, copy) NSArray *bankNames;
@property (nonatomic, strong) NSArray *amountList;
@property (nonatomic, strong) BTTQueryOnlineBankModel *typeModel;
@end

@implementation CNPayOnlineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDifferentUI];
    [self configPreSettingMessage];
    [self queryOnlineBanks];
    // 刷新数据
    [self updateAllContentWithModel:self.paymentModel];
    [self configSelectBankView];
    [self configAmountList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:350 fullScreen:NO];
}

- (void)queryOnlineBanks {
    [self showLoading];
    NSDictionary *params = @{
            @"payType": @(self.paymentModel.payType),
            @"loginName": [IVNetwork savedUserInfo].loginName
    };
    [IVNetwork requestPostWithUrl:BTTQueryOnlineBanks paramters:params completionBlock:^(id _Nullable response, NSError *_Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTQueryOnlineBankModel *model = [BTTQueryOnlineBankModel yy_modelWithJSON:result.body];
            self.typeModel = model;
            if (model.amountType.amounts != nil && model.amountType.amounts.count > 0) {
                self.amountList = model.amountType.amounts;
            }
            [self updateAllContentWithModel:self.paymentModel];
            [self configAmountList];
        }
    }];
}

- (void)configDifferentUI {
    BOOL online = self.paymentModel.payType == CNPaymentOnline;
    self.selectBankView.hidden = !online;
    self.selectBankViewHeight.constant = online ? 50: 0;

    BOOL bibao = self.paymentModel.payType == CNPaymentCoin;
    self.bibaoView.hidden = !bibao;
    self.bibaoViewHeight.constant = bibao ? 45: 0;
}

/// 刷新数据
- (void)updateAllContentWithModel:(CNPaymentModel *)model {
    self.amountTF.text = @"";
    // 金额提示语
    if (model.maxAmount > model.minAmount) {
        self.amountTF.placeholder = [NSString stringWithFormat:@"最少%ld，最多%ld", model.minAmount, model.maxAmount];
    } else {
        self.amountTF.placeholder = [NSString stringWithFormat:@"最少%ld", model.minAmount];
    }
}

- (void)configSelectBankView {
    if (self.paymentModel.payType != CNPaymentOnline ||
        self.typeModel.bankList.count == 0) {
        self.selectBankView.hidden = YES;
        self.selectBankViewHeight.constant = 0;
        return;
    }

    // 银行列表
    NSMutableArray *bankNames = [NSMutableArray array];
    for (CNPayBankCardModel *bankModel in self.typeModel.bankList) {
        [bankNames addObject:bankModel.bankName];
    }
    self.bankNames = bankNames;
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

- (void)configAmountList {
    self.amountBtn.hidden = self.typeModel.amountType.fix == 0;
    if (self.typeModel.amountType.fix == 1) {
        self.amountTF.placeholder = @"仅可选择以下金额";
    }
}


- (IBAction)selectAmountList:(id)sender {
    weakSelf(weakSelf);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.amountList.count];
    for (id obj in self.amountList) {
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
    weakSelf(weakSelf);
    [BRStringPickerView showStringPickerWithTitle:@"选择支付银行" dataSource:self.bankNames defaultSelValue:self.payBankTF.text resultBlock:^(id selectValue, NSInteger index) {
        if ([weakSelf.payBankTF.text isEqualToString:selectValue]) {
            return;
        }
        weakSelf.payBankTF.text = selectValue;
        weakSelf.chooseBank = weakSelf.typeModel.bankList[index];
    }];
}

- (IBAction)sumitAction:(UIButton *)sender {
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
    double maxAmount = self.paymentModel.maxAmount > self.paymentModel.minAmount ? self.paymentModel.maxAmount : CGFLOAT_MAX;
    if ([amount doubleValue] > maxAmount || [amount doubleValue] < self.paymentModel.minAmount) {
        _amountTF.text = nil;
        [self showError:[NSString stringWithFormat:@"存款金额必须是%ld~%.f之间，最大允许2位小数", self.paymentModel.minAmount, maxAmount]];
        return;
    }

    // 在线支付才有支付银行
    if (self.selectBankViewHeight.constant > 0 && !self.chooseBank) {
        [self showError:@"请选择支付银行"];
        return;
    }

    if (sender.selected) {
        return;
    }
    sender.selected = YES;

    /// 提交
    __weak typeof(self) weakSelf =  self;
    NSDictionary *params = @{
        @"amount":text,
        @"payType":@(self.paymentModel.payType),
        @"payId":self.typeModel.payid,
        @"bankNo":self.chooseBank==nil||self.chooseBank.accountNo==nil?@"":self.chooseBank.accountNo,
    };
    [IVNetwork requestPostWithUrl:BTTCreateOnlineOrder paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            sender.selected = NO;
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf paySucessHandler:result.body repay:nil];
        }
    }];
}

- (IBAction)bibaoAction:(UIButton *)sender {
    
}


@end
