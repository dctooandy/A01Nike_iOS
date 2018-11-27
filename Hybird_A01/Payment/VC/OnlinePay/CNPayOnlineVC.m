//
//  CNPayOnlineVC.m
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayOnlineVC.h"
#import "CNPayOrderModel.h"


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


@property (nonatomic, strong) CNPayBankCardModel *chooseBank;
@property (nonatomic, copy) NSArray *bankNames;
@end

@implementation CNPayOnlineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDifferentUI];
    [self configPreSettingMessage];
    // 刷新数据
    [self updateAllContentWithModel:self.paymentModel];
    [self configSelectBankView];
    [self configAmountList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:500 fullScreen:NO];
}

- (void)configDifferentUI {
    switch (self.paymentModel.paymentType) {
        case CNPaymentOnline:
            self.selectBankView.hidden = NO;
            self.selectBankViewHeight.constant = 50;
            self.payBankTF.placeholder = @"请选择支付银行";
            break;
        case CNPaymentCoin:
            
            break;
        default:
            self.selectBankView.hidden = YES;
            self.selectBankViewHeight.constant = 0;
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

- (void)configSelectBankView {
    if (self.paymentModel.paymentType != CNPaymentOnline ||
        self.paymentModel.bankList.count == 0) {
        self.selectBankView.hidden = YES;
        self.selectBankViewHeight.constant = 0;
        return;
    }
    
    // 银行列表
    NSMutableArray *bankNames = [NSMutableArray array];
    for (CNPayBankCardModel *bankModel in self.paymentModel.bankList) {
        [bankNames addObject:bankModel.bankname];
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
    // 微信app,扫码和支付app,宝扫码，只展示amountList
    if (self.paymentModel.amountList.count > 0 &&
        (self.paymentModel.paymentType == CNPaymentWechatApp ||
         self.paymentModel.paymentType == CNPaymentAliApp)) {
        self.amountBtn.hidden = NO;
        self.arrawDownIV.hidden = NO;
        self.amountTF.placeholder = @"仅可选择以下金额";
    } else {
        self.amountBtn.hidden = YES;
        self.arrawDownIV.hidden = YES;
    }
}


- (IBAction)selectAmountList:(id)sender {
    weakSelf(weakSelf);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.paymentModel.amountList.count];
    for (id obj in self.paymentModel.amountList) {
        [array addObject:[NSString stringWithFormat:@"%@", obj]];
    }
    [BRStringPickerView showStringPickerWithTitle:@"选择充值金额" dataSource:array defaultSelValue:self.amountTF.text resultBlock:^(id selectValue) {
        if ([weakSelf.amountTF.text isEqualToString:selectValue]) {
            return;
        }
        weakSelf.amountTF.text = selectValue;
    }];
}

- (IBAction)selectedBank:(UIButton *)sender {
    [self.view endEditing:YES];
    weakSelf(weakSelf);
    [BRStringPickerView showStringPickerWithTitle:@"选择支付银行" dataSource:self.bankNames defaultSelValue:self.payBankTF.text resultBlock:^(NSString * selectValue) {
        if ([weakSelf.payBankTF.text isEqualToString:selectValue]) {
            return;
        }
        weakSelf.payBankTF.text = selectValue;
        NSInteger index = [weakSelf.bankNames indexOfObject:selectValue];
        weakSelf.chooseBank = weakSelf.paymentModel.bankList[index]; 
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
    double maxAmount = self.paymentModel.maxamount > self.paymentModel.minamount ? self.paymentModel.maxamount : CGFLOAT_MAX;
    if ([amount doubleValue] > maxAmount || [amount doubleValue] < self.paymentModel.minamount) {
        _amountTF.text = nil;
        [self showError:_amountTF.placeholder];
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
    [CNPayRequestManager paymentWithPayType:[self getPaytypeString]
                                      payId:self.paymentModel.payid
                                     amount:text
                                   bankCode:self.chooseBank.bankcode
                            completeHandler:^(IVRequestResultModel *result, id response) {
                                sender.selected = NO;
                                __strong typeof(weakSelf) strongSelf = weakSelf;
                                [strongSelf handlerResult:result];
                            }];
    
}

- (void)handlerResult:(IVRequestResultModel *)model {
    // 数据容灾
    if (![model.data isKindOfClass:[NSDictionary class]]) {
        // 后台返回类型不一，全部转成字符串
        [self showError:[NSString stringWithFormat:@"%@", model.message]];
        return;
    }
    
    NSError *error;
    CNPayOrderModel *orderModel = [[CNPayOrderModel alloc] initWithDictionary:model.data error:&error];
    if (error && !orderModel) {
        [self showError:@"操作失败！请联系客户，或者稍后重试!"];
        return;
    }
    self.writeModel.orderModel = orderModel;
    self.writeModel.depositType = self.paymentModel.paymentTitle;
    [self goToStep:1];
}

@end
