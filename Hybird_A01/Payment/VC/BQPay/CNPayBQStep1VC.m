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
#import "BTTBishangStep1VC.h"

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

@property (nonatomic, strong) BTTBishangStep1VC *BSStep1VC;

@property (nonatomic, strong) CNPayBankCardModel *chooseBank;
@property (nonatomic, copy) NSArray *bankNames;
@property (nonatomic, strong) NSArray *amountList;
@end

@implementation CNPayBQStep1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configPreSettingMessage];
    [self configDifferentUI];
    [self queryAmountList];
    // 初始化数据
    [self updateAllContentWithModel:self.paymentModel];
    [self setViewHeight:450 fullScreen:NO];
    if (self.paymentModel.payType == 100) {
        [self configBishangUI];
        [self setViewHeight:400 fullScreen:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:450 fullScreen:NO];
    
}

- (void)configBishangUI {
    _BSStep1VC = [[BTTBishangStep1VC alloc] init];
//    _BSStep1VC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1000);
    _BSStep1VC.paymentModel = self.paymentModel;
    [self addChildViewController:_BSStep1VC];
    [self.view addSubview:_BSStep1VC.view];
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

- (void)queryAmountList{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:@(self.paymentModel.payType) forKey:@"payType"];
    [params setValue:[IVNetwork savedUserInfo].loginName forKey:@"loginName"];
    [IVNetwork requestPostWithUrl:BTTQueryAmountList paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (result.body[@"amounts"]!=nil) {
                self.amountList = result.body[@"amounts"];
                [self configAmountList];
            }
        }
    }];
}

- (void)configDifferentUI {
    switch (self.paymentModel.payType) {
        case 91:
        case 92:
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
    if (model.maxAmount > model.minAmount) {
        self.amountTF.placeholder = [NSString stringWithFormat:@"最少%ld，最多%ld", (long)model.minAmount, (long)model.maxAmount];
    } else {
        self.amountTF.placeholder = [NSString stringWithFormat:@"最少%ld", (long)model.minAmount];
    }
}


- (void)configAmountList {
//    self.amountBtn.hidden = self.paymentModel.amountCanEdit;
//    if (!self.paymentModel.amountCanEdit) {
//        self.amountTF.placeholder = @"仅可选择以下金额";
//    }
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
    [array addObject:@"其他金额请手动输入"];
        [BRStringPickerView showStringPickerWithTitle:@"选择充值金额" dataSource:array defaultSelValue:self.amountTF.text resultBlock:^(id selectValue, NSInteger index) {
            if (index==array.count-1) {
                if ([weakSelf.amountTF.text isEqualToString:selectValue]) {
                    return;
                }
                weakSelf.amountTF.text = selectValue;
            }else{
                self.amountTF.hidden = YES;
                self.amountTF.text = @"";
            }
            
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
    NSInteger bqPaymentType = 0;
//    if (self.paymentModel.paymentType == CNPaymentBQAli) {
//        bqPaymentType = 2;
//    } else if (self.paymentModel.paymentType == CNPaymentBQWechat) {
//        bqPaymentType = 1;
//    }
    [CNPayRequestManager paymentGetBankListWithType:NO depositor:self.nameTF.text referenceId:nil BQPayType:bqPaymentType completeHandler:^(id  _Nullable response, NSError * _Nullable error) {
        [weakSelf hideLoading];
#warning 调试接口
//        if (result.status) {
//            /// 数据解析
//            NSArray *array = result.data[@"bankList"];
//            NSArray *bankList = [CNPayBankCardModel arrayOfModelsFromDictionaries:array error:nil];
//            if (bankList.count == 0) {
//                [self showError:result.message];
//                return;
//            }
//            weakSelf.paymentModel.bankList = bankList.copy;
//            NSMutableArray *bankNames = [NSMutableArray array];
//            for (CNPayBankCardModel *model in bankList) {
//                [bankNames addObject:model.bankname];
//            }
//            weakSelf.bankNames = [bankNames copy];
//            [weakSelf selectBank];
//            return;
//        }
//        [weakSelf showError:result.message];
    }];
}

- (void)selectBank {
    weakSelf(weakSelf);
//    [BRStringPickerView showStringPickerWithTitle:_bankTF.placeholder dataSource:self.bankNames defaultSelValue:self.bankTF.text resultBlock:^(id selectValue, NSInteger index) {
//        if ([weakSelf.bankTF.text isEqualToString:selectValue]) {
//            return;
//        }
//        weakSelf.bankTF.text = selectValue;
//        weakSelf.chooseBank = weakSelf.paymentModel.bankList[index];
//    }];
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
//    NSNumber *amount = [NSString convertNumber:text];
//    double maxAmount = self.paymentModel.maxamount > self.paymentModel.minamount ? self.paymentModel.maxamount : CGFLOAT_MAX;
//    if ([amount doubleValue] > maxAmount || [amount doubleValue] < self.paymentModel.minamount) {
//        _amountTF.text = nil;
//        [self showError:[NSString stringWithFormat:@"存款金额必须是%.f~%.f之间，最大允许2位小数", self.paymentModel.minamount, maxAmount]];
//        return;
//    }
//
//    if (self.nameTF.text.length == 0) {
//        [self showError:@"请输入存款人姓名"];
//        return;
//    }
//
//    if (self.bankTF.text.length == 0) {
//        [self showError:self.bankTF.placeholder];
//        return;
//    }
//
//    self.writeModel.depositBy = self.nameTF.text;
//    self.writeModel.amount = self.amountTF.text;
//    self.writeModel.chooseBank = self.chooseBank;
//    self.writeModel.BQType = [self getBQType];
//    // 提交订单
//    [self sumbitBill:sender];
}

- (void)sumbitBill:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(sender) weakSender = sender;
    //TODO:这个地方的判断条件需要改一下
    [CNPayRequestManager paymentSubmitBill:self.writeModel completeHandler:^(IVJResponseObject *result, id response) {
        sender.selected = NO;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            CNPayBankCardModel *model = [[CNPayBankCardModel alloc] initWithDictionary:result.body error:nil];
            if (!model) {
                weakSender.enabled = NO;
                [weakSelf showError:@"系统错误，请联系客服"];
                return;
            }
            weakSelf.writeModel.chooseBank = model;
            [weakSelf goToStep:1];
        } else {
            [weakSelf showError:result.head.errMsg];
        }
    }];
}

- (CNPayBQType)getBQType {
//    switch (self.paymentModel.paymentType) {
//        case CNPaymentBQAli:
//            return CNPayBQTypeAli;
//        case CNPaymentBQFast:
//            return CNPayBQTypeBankUnion;
//        case CNPaymentBQWechat:
//            return CNPayBQTypeWechat;
//        default:
            return 0;
//    }
}

@end
