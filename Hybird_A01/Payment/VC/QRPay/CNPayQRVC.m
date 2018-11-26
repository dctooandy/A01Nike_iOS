//
//  CNPayQRVC.m
//  HybirdApp
//
//  Created by cean.q on 2018/10/24.
//  Copyright © 2018年 harden-imac. All rights reserved.
//

#import "CNPayQRVC.h"

@interface CNPayQRVC ()
@property (weak, nonatomic) IBOutlet CNPayAmountRecommendView *recommendView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reconmendViewHeight;

@property (weak, nonatomic) IBOutlet UIView *preSettingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *preSettingViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *preSettingMessageLb;

@property (weak, nonatomic) IBOutlet CNPayAmountTF *amountTF;
@property (weak, nonatomic) IBOutlet UIButton *amountBtn;
@property (weak, nonatomic) IBOutlet UIImageView *arrawDownIV;

@property (weak, nonatomic) IBOutlet UILabel *bottomTipLb;
@property (weak, nonatomic) IBOutlet UILabel *unionTipLb;

@property (copy, nonatomic) NSString *tipText;
@property (assign, nonatomic) BOOL setSelect;
@end

@implementation CNPayQRVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tipText = self.bottomTipLb.text;
    [self configDifferentUI];
    [self configPreSettingMessage];
    [self configRecommendView];
    // 刷新数据
    [self updateAllContentWithModel:self.paymentModel];
    [self configAmountList];
    [self setViewHeight:750 fullScreen:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_setSelect) {
        [self.recommendView selectIndex:0];
        _setSelect = YES;
    }
}

- (void)configDifferentUI {
    NSString *tipText;
    self.unionTipLb.hidden = YES;
    switch (self.paymentModel.paymentType) {
        case CNPaymentAliQR:
            tipText = @"支付宝";
            break;
        case CNPaymentWechatQR:
            tipText = @"微信";
            break;
        case CNPaymentQQQR:
            tipText = @"QQ";
            break;
        case CNPaymentUnionQR:
            tipText = @"手机银行";
            self.unionTipLb.hidden = NO;
            break;
        case CNPaymentJDQR:
            tipText = @"京东";
            break;
        default:
            tipText = @"";
            break;
    }
    self.bottomTipLb.text = [NSString stringWithFormat:self.tipText, tipText];
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

- (void)configRecommendView {
    NSMutableArray *array = [NSMutableArray array];
    for (CNPaymentModel *model in self.payments) {
        [array addObject:model.paymentTitle];
    }
    _recommendView.dataSource = array;
    // 根据数组个数与屏幕宽度来调节高度
    CGFloat height = ((array.count - 1)/3 + 1) * 200 * 100 / ([UIScreen mainScreen].bounds.size.width * 1.0);
    self.reconmendViewHeight.constant = height + 30;
    
    __weak typeof(self) weakSelf = self;
    _recommendView.clickHandler = ^(NSString *value, NSInteger index) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.view endEditing:YES];
        strongSelf.paymentModel = strongSelf.payments[index];
        [strongSelf configDifferentUI];
        [strongSelf updateAllContentWithModel:strongSelf.paymentModel];
        [strongSelf configAmountList];
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

- (void)configAmountList {
    // 微信app,扫码和支付app,宝扫码，只展示amountList
    if (self.paymentModel.amountList.count > 0 &&
        (self.paymentModel.paymentType == CNPaymentWechatQR ||
         self.paymentModel.paymentType == CNPaymentAliQR)) {
            self.amountBtn.hidden = NO;
            self.amountTF.placeholder = @"请选择支付金额";
        } else {
            self.amountBtn.hidden = YES;
            self.arrawDownIV.hidden = YES;
        }
}


- (IBAction)selectAmountList:(id)sender {
    weakSelf(weakSelf);
    [BRStringPickerView showStringPickerWithTitle:@"选择充值金额" dataSource:self.paymentModel.amountList defaultSelValue:self.amountTF.text resultBlock:^(id selectValue) {
        if ([weakSelf.amountTF.text isEqualToString:selectValue]) {
            return;
        }
        weakSelf.amountTF.text = selectValue;
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
    
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    
    /// 提交
    __weak typeof(self) weakSelf =  self;
    [CNPayRequestManager paymentWithPayType:[self getPaytypeString]
                                      payId:self.paymentModel.payid
                                     amount:text
                                   bankCode:nil
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
