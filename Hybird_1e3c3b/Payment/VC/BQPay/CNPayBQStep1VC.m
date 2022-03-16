//
//  CNPayBQStep1VC.m
//  HybirdApp
//
//  Created by cean.q on 2018/10/23.
//  Copyright © 2018年 harden-imac. All rights reserved.
//

#import "CNPayBQStep1VC.h"
#import "CNPayNormalTF.h"
#import "BTTBishangStep1VC.h"
#import "BTTPaymentWarningPopView.h"

#import "CNMAmountSelectCCell.h"
#import "CNMAlertView.h"
#define kCNMAmountSelectCCell  @"CNMAmountSelectCCell"
#import "CNMatchPayRequest.h"
#import "CNMBankModel.h"
#import "CNMFastPayStatusVC.h"

@interface CNPayBQStep1VC () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet CNPayAmountTF *amountTF;
@property (weak, nonatomic) IBOutlet UIButton *amountBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet CNPayNameTF *nameTF;

@property (weak, nonatomic) IBOutlet CNPaySubmitButton *commitBtn;

@property (weak, nonatomic) IBOutlet UIView *bottomTipView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomTipViewHeight;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic, strong) BTTBishangStep1VC *BSStep1VC;

@property (nonatomic, copy) NSArray *bankNames;
@property (nonatomic, strong) NSArray *amountList;
@property (nonatomic, strong) NSArray *bankList;
@property (nonatomic, assign) BOOL haveBankData;

#pragma mark - 撮合相关属性
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewH;
@property (weak, nonatomic) IBOutlet UILabel *matchTipLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *matchTipLbH;
@property (nonatomic, strong) NSArray *matchAmountList;
@property (nonatomic, strong) NSArray *dataAList;
@end

@implementation CNPayBQStep1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    _haveBankData = NO;
    self.amountBtn.hidden = YES;
    [self configDifferentUI];
    [self queryAmountList];
    // 初始化数据
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(100);
    }];
    if (self.paymentModel.payType == 100) {
        [self setViewHeight:300 fullScreen:NO];
        [self configBishangUI];
    } else {
        [self setupMatchUI];
    }
}

#pragma mark - 撮合相关

- (void)setupMatchUI {
//    if (self.matchModel.amountList.count > 0) {
        NSMutableArray *array = [NSMutableArray array];
        for (CNWAmountListModel *model in self.matchModel.amountList) {
            [array addObject:model.amount];
        }
        array = [@[@"100000", @"90000", @"8000", @"5000", @"7000", @"6000", @"5500", @"100", @"1000", @"1500", @"3500", @"2500"] mutableCopy];
    
        self.matchAmountList = [array sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
            if (obj1.intValue < obj2.intValue) {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }];
        self.dataAList = [self getRecommendAmountFromAmount:nil];
        
        [self.collectionView registerNib:[UINib nibWithNibName:kCNMAmountSelectCCell bundle:nil] forCellWithReuseIdentifier:kCNMAmountSelectCCell];
        self.collectionViewH.constant = 42 * MIN(ceilf(self.matchAmountList.count/3.0), 3) +30;
        self.matchTipLb.hidden = NO;
        self.matchTipLbH.constant = 20;
        [self.amountTF addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
//    }
    [self setViewHeight:(self.collectionViewH.constant + 300) fullScreen:NO];
}

- (void)textFieldValueChange:(UITextField *)tf {
    self.dataAList = [self getRecommendAmountFromAmount:tf.text];
    [self.collectionView reloadData];
    if ([self.dataAList containsObject:tf.text]) {
        NSInteger index = [self.dataAList indexOfObject:tf.text];
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    } else {
        [self.collectionView deselectItemAtIndexPath:[self.collectionView indexPathsForSelectedItems].lastObject animated:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataAList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CNMAmountSelectCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCNMAmountSelectCCell forIndexPath:indexPath];
    cell.amountLb.text = self.dataAList[indexPath.row];
    cell.recommendTag.hidden = YES;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((collectionView.bounds.size.width-50)/3.0, 32);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.amountTF.text = self.dataAList[indexPath.row];
}

- (void)submitMatchBill {
    //提交订单
    [self showLoading];
    __weak typeof(self) weakSelf = self;
    [CNMatchPayRequest createDepisit:self.amountTF.text finish:^(id  _Nullable response, NSError * _Nullable error) {
        [weakSelf hideLoading];
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)response;
            if ([[dic objectForKey:@"mmFlag"] boolValue]) {
                NSError *err;
                CNMBankModel *bank = [[CNMBankModel alloc] initWithDictionary:[dic objectForKey:@"mmPaymentRsp"] error:&err];
                if (!err) {
                    // 成功跳转
                    CNMFastPayStatusVC *statusVC = [[CNMFastPayStatusVC alloc] init];
                    statusVC.cancelTime = [weakSelf.paymentModel.remainCancelDepositTimes integerValue];
                    statusVC.transactionId = bank.transactionId;
                    [weakSelf pushViewController:statusVC];
                    return;
                }
            }
        }
        // 失败走普通存款
        [weakSelf submitBQBill];
    }];
}


/// 计算合理推荐金额
- (NSArray *)getRecommendAmountFromAmount:(NSString *)amount {
    
    NSArray *sourceArray = self.matchAmountList;
    
    if (sourceArray.count < 9) {
        return sourceArray;
    }
    
    if (amount == nil || amount.length == 0) {
        return [sourceArray subarrayWithRange:NSMakeRange(sourceArray.count - 9, 9)];
    }
    
    NSMutableArray *sortArr = [sourceArray mutableCopy];
    [sortArr addObject:amount];
    
    sortArr = [[sortArr sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
        if (obj1.intValue < obj2.intValue) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }] mutableCopy];
    
    NSInteger index = [sortArr indexOfObject:amount];

    if (index < 5) {
        return [sourceArray subarrayWithRange:NSMakeRange(0, 9)];
    } else if  (index > (sourceArray.count - 5)) {
        return [sourceArray subarrayWithRange:NSMakeRange(sourceArray.count - 9, 9)];
    } else {
        return [sourceArray subarrayWithRange:NSMakeRange(index - 4, 9)];
    }
}

#pragma mark - BQ相关

- (void)configBishangUI {
    _BSStep1VC = [[BTTBishangStep1VC alloc] init];
    //    _BSStep1VC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1000);
    _BSStep1VC.paymentModel = self.paymentModel;
    [self addChildViewController:_BSStep1VC];
    [self.view addSubview:_BSStep1VC.view];
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
                NSNumber * min = result.body[@"minAmount"];
                NSNumber * max = result.body[@"maxAmount"];
                self.amountTF.placeholder = [NSString stringWithFormat:@"最少%@，最多%@", min, max];
            }
        }else{
            self.amountTF.text = @"";
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
}

- (IBAction)selectAmountList:(id)sender {
    weakSelf(weakSelf);
    [self.view endEditing:YES];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.amountList.count];
    for (id obj in self.amountList) {
        [array addObject:[[NSString stringWithFormat:@"%@", obj] mutableCopy]];
    }
    if (array.count == 0) {
        [self showError:@"无可选金额，请直接输入"];
        return;
    }
    NSString *addTip = @"其他金额请手动输入";
    [array addObject:[addTip mutableCopy]];
    [BRStringPickerView showStringPickerWithTitle:@"选择充值金额" dataSource:array defaultSelValue:self.amountTF.text resultBlock:^(id selectValue, NSInteger index) {
        if (index!=array.count-1) {
            if ([weakSelf.amountTF.text isEqualToString:selectValue]) {
                return;
            }
            weakSelf.amountTF.text = selectValue;
            [weakSelf textFieldValueChange:weakSelf.amountTF];
        }else{
            self.amountBtn.hidden = YES;
            self.amountTF.text = @"";
        }
        
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
    
    BOOL isMatch = [self.dataAList containsObject:text];
    if (!isMatch) {
        /// 超出额度范围
        NSNumber *amount = [NSString convertNumber:text];
        double maxAmount = self.paymentModel.maxAmount > self.paymentModel.minAmount ? self.paymentModel.maxAmount : CGFLOAT_MAX;
        if ([amount doubleValue] > maxAmount || [amount doubleValue] < self.paymentModel.minAmount) {
            _amountTF.text = nil;
            [self showError:[NSString stringWithFormat:@"存款金额必须是%ld~%.f之间，最大允许2位小数", (long)self.paymentModel.minAmount, maxAmount]];
            return;
        }
    }
    
    if (self.nameTF.text.length == 0) {
        [self showError:@"请输入存款人姓名"];
        return;
    }
    
    
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    if (isMatch) {
        [self submitMatchBill];
    } else {
        [self submitBQBill];
    }
}

- (void)submitBQBill {
    self.writeModel.depositBy = self.nameTF.text;
    self.writeModel.amount = self.amountTF.text;
    [self sumbitBill:self.submitBtn amount:self.amountTF.text depositor:self.nameTF.text depositorType:@"" payType:[NSString stringWithFormat:@"%ld",(long)self.paymentModel.payType]];
}

- (void)sumbitBill:(UIButton *)sender amount:(NSString *)amount depositor:(NSString *)depositor depositorType:(NSString *)depositorType payType:(NSString *)payType{
    __weak typeof(self) weakSelf = self;
    __weak typeof(sender) weakSender = sender;
    NSDictionary *params = @{
        @"amount":amount,
        @"depositor":depositor,
        @"depositorType":depositorType,
        @"payType":payType,
        @"loginName":[IVNetwork savedUserInfo].loginName
    };
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTBQPayment paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self hideLoading];
        weakSender.selected = NO;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            CNPayBankCardModel *model = [[CNPayBankCardModel alloc] initWithDictionary:result.body error:nil];
            if (!model) {
                weakSender.enabled = NO;
                [weakSelf showError:@"系统错误，请联系客服"];
                return;
            }
            weakSelf.writeModel.chooseBank = model;
            [weakSelf goToStep:1];
        }else{
            if ([result.head.errCode isEqualToString:@"GW_800705"]) {
                BTTPaymentWarningPopView *pop = [BTTPaymentWarningPopView viewFromXib];
                pop.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                pop.contentStr = @"存款人姓名与绑定姓名不符，无法充值，请填写绑定姓名，或切换必多多账户买币存款";
                BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:pop popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
                popView.isClickBGDismiss = YES;
                [popView pop];
                pop.dismissBlock = ^{
                    [popView dismiss];
                };
                pop.btnBlock = ^(UIButton * _Nullable btn) {
                    //0=>kefu 1=>changeMode
                    [popView dismiss];
                    if (btn.tag == 0) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoKefu" object:nil];
                    } else {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoBack" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeModeNotification" object:nil];
                    }
                };
            } else {
                [weakSelf showError:result.head.errMsg];
            }
        }
    }];
}

@end
