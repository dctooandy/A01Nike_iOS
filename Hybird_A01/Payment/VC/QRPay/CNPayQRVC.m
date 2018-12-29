//
//  CNPayQRVC.m
//  HybirdApp
//
//  Created by cean.q on 2018/10/24.
//  Copyright © 2018年 harden-imac. All rights reserved.
//

#import "CNPayQRVC.h"
#import "CNPayQRCell.h"
#import "CNPayOnePixView.h"
#import "CNPayNormalTF.h"
#import "CNPayContainerVC.h"
#import "CNPayDepositStep2VC.h"
#import "CNPayDepositStep3VC.h"
#import "CNPayBQStep2VC.h"
#import "CNPayQRStep2VC.h"
#import "BTTStepTwoContainerController.h"

#define kQRCellIndentifier   @"CNPayQRCell"

@interface CNPayQRVC () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *preSettingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *preSettingViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *preSettingMessageLb;

@property (weak, nonatomic) IBOutlet CNPayAmountTF *amountTF;
@property (weak, nonatomic) IBOutlet UIButton *amountBtn;
@property (weak, nonatomic) IBOutlet UIImageView *arrawDownIV;

@property (assign, nonatomic) BOOL setSelect;
@property (assign, nonatomic) NSInteger currentSelectedIndex;
@property (nonatomic) CGSize cellSize;

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameViewHeight;

@property (weak, nonatomic) IBOutlet UIView *bankView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankViewHeight;

@property (weak, nonatomic) IBOutlet UIView *amountView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountViewHeight;
@property (weak, nonatomic) IBOutlet CNPayOnePixView *amountLine;


@property (weak, nonatomic) IBOutlet CNPayNameTF *nameTextField;

@property (weak, nonatomic) IBOutlet CNPayNormalTF *bankTextField;

@property (nonatomic, copy) NSArray *bankNames;

@property (nonatomic, strong) CNPayBankCardModel *chooseBank;

@end

@implementation CNPayQRVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCollectionView];
    [self configPreSettingMessage];
    // 刷新数据
    [self updateUIWithPaymentModel:self.payments[self.currentSelectedIndex]];
    [self updateAllContentWithModel:self.paymentModel];
    [self configAmountList];
    [self configSelectBankView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewHeight:500 fullScreen:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_setSelect) {
        // 默认选中第一个可以支付的渠道
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentSelectedIndex inSection:0];
        [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        _setSelect = YES;
    }
}

- (void)configCollectionView {
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 18, 15, 18);
    [self.collectionView registerNib:[UINib nibWithNibName:kQRCellIndentifier bundle:nil] forCellWithReuseIdentifier:kQRCellIndentifier];
    
    NSInteger count = self.payments.count;
    // 根据数组个数与屏幕宽度来调节高度
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width - 18 - 30 - 10) / 3.0;
    CGFloat itemHeight = itemWidth * 56 / 160.0;
    CGFloat totalHeight = ((count - 1) / 3 + 1) * (itemHeight + 15);
    self.collectionViewHeight.constant = totalHeight;
    self.cellSize = CGSizeMake(itemWidth, itemHeight + 10);
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

- (void)configSelectBankView {
    // 银行列表
    NSMutableArray *bankNames = [NSMutableArray array];
    for (CNPayBankCardModel *bankModel in self.paymentModel.bankList) {
        [bankNames addObject:bankModel.bankname];
    }
    self.bankNames = bankNames;
    if (self.bankNames.count == 1) {
        self.bankTextField.text = self.bankNames[0];
        self.chooseBank = self.paymentModel.bankList[0];
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

- (void)configAmountList {
    self.amountBtn.hidden = self.paymentModel.amountCanEdit;
    if (!self.paymentModel.amountCanEdit) {
        self.amountTF.placeholder = @"仅可选择以下金额";
    }
}

#pragma mark- UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.payments.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CNPayQRCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kQRCellIndentifier forIndexPath:indexPath];
    
    CNPaymentModel *payment = [self.payments objectAtIndex:indexPath.row];
    cell.titleLb.text = payment.paymentTitle;
    cell.channelIconIV.image = [UIImage imageNamed:payment.paymentLogo];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == _currentSelectedIndex) {
        return;
    }
    [self.view endEditing:YES];
    
    self.currentSelectedIndex = indexPath.row;
    self.paymentModel = [self.payments objectAtIndex:indexPath.row];
    [self updateUIWithPaymentModel:self.paymentModel];
    [self updateAllContentWithModel:self.paymentModel];
    [self configAmountList];
}

- (void)updateUIWithPaymentModel:(CNPaymentModel *)model {
    if (model.paymentType == CNPaymentUnionQR ||
        model.paymentType == CNPaymentJDQR ||
        model.paymentType == CNPaymentBTC ||
        model.paymentType == CNPaymentCoin ||
        model.paymentType == CNPaymentUnionApp ||
        model.paymentType == CNPaymentJDApp ||
        model.paymentType == CNPaymentWechatBarCode ||
        model.paymentType == CNPaymentWechatQR ||
        model.paymentType == CNPaymentWechatApp ||
        model.paymentType == CNPaymentAliQR ||
        model.paymentType == CNPaymentAliApp) {
        self.nameView.hidden = YES;
        self.nameViewHeight.constant = 0;
        self.bankView.hidden = YES;
        self.bankViewHeight.constant = 0;
        self.amountView.hidden = NO;
        self.amountViewHeight.constant = 50;
        self.amountLine.hidden = YES;
    } else if (model.paymentType == CNPaymentDeposit) {
        self.amountView.hidden = YES;
        self.amountViewHeight.constant = 0;
        self.nameView.hidden = NO;
        self.nameViewHeight.constant = 50;
        self.bankView.hidden = NO;
        self.bankViewHeight.constant = 50;
        self.amountLine.hidden = YES;
    } else {
        self.nameView.hidden = NO;
        self.nameViewHeight.constant = 50;
        self.bankView.hidden = NO;
        self.bankViewHeight.constant = 50;
        self.amountView.hidden = NO;
        self.amountViewHeight.constant = 50;
        self.amountLine.hidden = NO;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellSize;
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

- (IBAction)selectBankClick:(UIButton *)sender {
    if (!self.bankNames.count) {
        return;
    }
    [BRStringPickerView showStringPickerWithTitle:@"选择支付银行" dataSource:self.bankNames defaultSelValue:self.bankTextField.text resultBlock:^(id selectValue, NSInteger index) {
        if ([self.bankTextField.text isEqualToString:selectValue]) {
            return;
        }
        self.bankTextField.text = selectValue;
        self.chooseBank = self.paymentModel.bankList[index];
    }];
}


- (IBAction)nextStep:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString *text = _amountTF.text;
    /// 输入为不合法数字
    if (![NSString isPureInt:text] && ![NSString isPureFloat:text] && !self.amountView.hidden) {
        _amountTF.text = nil;
        [self showError:@"请输入充值金额"];
        return;
    }
    
    if (!self.bankView.hidden) {
        if (!self.bankTextField.text.length) {
            [self showError:@"请选择支付银行"];
        }
    }
    
    if (!self.nameView.hidden) {
        if (!self.nameTextField.text.length) {
            [self showError:@"请输入真实姓名"];
        }
    }
    
    /// 超出额度范围
    NSNumber *amount = [NSString convertNumber:text];
    double maxAmount = self.paymentModel.maxamount > self.paymentModel.minamount ? self.paymentModel.maxamount : CGFLOAT_MAX;
    if (([amount doubleValue] > maxAmount || [amount doubleValue] < self.paymentModel.minamount) && !self.amountView.hidden) {
        _amountTF.text = nil;
        [self showError:[NSString stringWithFormat:@"存款金额必须是%.2f~%.2f之间，最大允许2位小数", self.paymentModel.minamount, maxAmount]];
        return;
    }
    
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    if (self.paymentModel.paymentType == CNPaymentBQAli ||
        self.paymentModel.paymentType == CNPaymentBQWechat ||
        self.paymentModel.paymentType == CNPaymentBQFast) {
        self.writeModel.depositBy = self.nameTextField.text;
        self.writeModel.amount = self.amountTF.text;
        self.writeModel.chooseBank = self.chooseBank;
        self.writeModel.BQType = [self getBQType];
        [CNPayRequestManager paymentSubmitBill:self.writeModel completeHandler:^(IVRequestResultModel *result, id response) {
            sender.selected = NO;
            if (result.status) {
                CNPayBankCardModel *model = [[CNPayBankCardModel alloc] initWithDictionary:result.data error:nil];
                if (!model) {
                    [self showError:@"系统错误，请联系客服"];
                    return;
                }
                self.writeModel.chooseBank = model;
                BTTStepTwoContainerController *containerVC = [[BTTStepTwoContainerController alloc] initWithPaymentType:self.paymentModel.paymentType];
                containerVC.payments = self.payments;
                containerVC.writeModel = self.writeModel;
                AMSegmentViewController *segmentVC = [[AMSegmentViewController alloc] initWithViewController:containerVC];
                [self addChildViewController:segmentVC];
                [self.view addSubview:segmentVC.view];
                
            } else {
                [self showError:result.message];
            }
        }];
        
    } else if (self.paymentModel.paymentType == CNPaymentDeposit) {
        [CNPayRequestManager paymentGetBankListWithType:YES depositor:self.nameTextField.text referenceId:nil completeHandler:^(IVRequestResultModel *result, id response) {
            sender.selected = NO;
            if (!result.status) {
                [self showError:result.message];
                return;
            }
            /// 数据解析
            NSArray *array = result.data;
            NSArray *bankList = [CNPayBankCardModel arrayOfModelsFromDictionaries:array error:nil];
            if (bankList.count == 0) {
                [self showError:result.message];
                return;
            }
            self.writeModel.depositBy = self.nameTextField.text;
            self.writeModel.bankList = bankList;
            self.writeModel.chooseBank = bankList.firstObject;
            BTTStepTwoContainerController *containerVC = [[BTTStepTwoContainerController alloc] initWithPaymentType:self.paymentModel.paymentType];
            containerVC.payments = self.payments;
            containerVC.writeModel = self.writeModel;
            AMSegmentViewController *segmentVC = [[AMSegmentViewController alloc] initWithViewController:containerVC];
            [self addChildViewController:segmentVC];
            [self.view addSubview:segmentVC.view];
       
        }];
       
        
    } else {
        /// 提交
        __weak typeof(self) weakSelf =  self;
        [CNPayRequestManager paymentWithPayType:[self getPaytypeString] payId:self.paymentModel.payid amount:text bankCode:nil completeHandler:^(IVRequestResultModel *result, id response) {
            sender.selected = NO;
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf handlerResult:result];
        }];
    }
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
    BTTStepTwoContainerController *containerVC = [[BTTStepTwoContainerController alloc] initWithPaymentType:self.paymentModel.paymentType];
    containerVC.payments = self.payments;
    containerVC.writeModel = self.writeModel;
    AMSegmentViewController *segmentVC = [[AMSegmentViewController alloc] initWithViewController:containerVC];
    [self addChildViewController:segmentVC];
    [self.view addSubview:segmentVC.view];
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
