//
//  CNPayQRVC.m
//  HybirdApp
//
//  Created by cean.q on 2018/10/24.
//  Copyright © 2018年 harden-imac. All rights reserved.
//

#import "CNPayQRVC.h"
#import "CNPayQRCell.h"
#import "BTTBankUnionAppIconCell.h"
#import "BTTQueryOnlineBankModel.h"

#define kQRCellIndentifier @"CNPayQRCell"

@interface CNPayQRVC () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *appsView;

@property (weak, nonatomic) IBOutlet UICollectionView *appCollectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appsViewHeightConstants;
@property (weak, nonatomic) IBOutlet UIView *noticesView;

@property (weak, nonatomic) IBOutlet UIView *preSettingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *preSettingViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *preSettingMessageLb;

@property (weak, nonatomic) IBOutlet CNPayAmountTF *amountTF;
@property (weak, nonatomic) IBOutlet UIButton *amountBtn;
@property (weak, nonatomic) IBOutlet UIImageView *arrawDownIV;

@property (assign, nonatomic) BOOL setSelect;
@property (assign, nonatomic) NSInteger currentSelectedIndex;
@property (nonatomic) CGSize cellSize;
@property (nonatomic, assign) CGSize appSize;
@property (nonatomic, strong) NSArray *apps;
@property (weak, nonatomic) IBOutlet UIView *collectionBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstants;
@property (nonatomic, strong) NSArray *amountList;
@property (nonatomic, strong) BTTQueryOnlineBankModel *typeModel;
@end

@implementation CNPayQRVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appsView.hidden = YES;
    self.noticesView.hidden = YES;
    [self configCollectionView];
    [self configPreSettingMessage];
    // 刷新数据
    [self queryOnlineBanks];
    if (self.payments.count > 0) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    [self setViewHeight:450 fullScreen:NO];
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
    [self.appCollectionView registerNib:[UINib nibWithNibName:@"BTTBankUnionAppIconCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBankUnionAppIconCell"];
    NSInteger count = self.payments.count;
    // 根据数组个数与屏幕宽度来调节高度
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width - 18 - 35 - 10) / 2.0;
    CGFloat itemHeight = itemWidth * 56 / 160.0;
    CGFloat totalHeight = ((count - 1) / 2 + 1) * (itemHeight + 15);
    if (self.paymentModel.payType == CNPaymentWechatQR ||
        self.paymentModel.payType == CNPaymentAliQR ||
        self.paymentModel.payType == CNPaymentQQQR ||
        self.paymentModel.payType == CNPaymentYSFQR  ||
        self.paymentModel.payType == CNPaymentJDQR ||
        self.paymentModel.payType == 19 ||
        self.paymentModel.payType == CNPaymentUnionQR) {
        self.collectionBgView.hidden = YES;
        self.collectionViewHeight.constant = 0;
        self.topConstants.constant = -62;
    } else {
        self.collectionViewHeight.constant = totalHeight;
    }
    self.cellSize = CGSizeMake(itemWidth, itemHeight + 10);
    self.apps = @[@"ysfapp", @"mtapp", @"dzapp", @"wphapp", @"ttzgapp", @"mfbapp", @"wzfapp", @"jdapp"];
    self.appCollectionView.delegate = self;
    self.appCollectionView.dataSource = self;
    CGFloat iconWidth = 60;
    self.appSize = CGSizeMake(iconWidth, iconWidth);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = self.appSize;
    self.appCollectionView.collectionViewLayout = layout;
    self.appsViewHeightConstants.constant = iconWidth * 2 + 36;
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
    if (model.payType == 15) {
        self.appsView.hidden = NO;
        self.noticesView.hidden = NO;
    } else {
        self.appsView.hidden = YES;
        self.noticesView.hidden = YES;
    }
    self.amountTF.text = @"";
    // 金额提示语
    if ([self.typeModel.maxAmount doubleValue] > [self.typeModel.minAmount doubleValue]) {
        self.amountTF.placeholder = [NSString stringWithFormat:@"最少%.0f，最多%.0f", [self.typeModel.minAmount doubleValue], [self.typeModel.maxAmount doubleValue]];
    } else {
        self.amountTF.placeholder = [NSString stringWithFormat:@"最少%.0f", [self.typeModel.minAmount doubleValue]];
    }
}

- (void)configAmountList {
    self.amountBtn.hidden = self.typeModel.amountType.fix == 0;
    if (self.typeModel.amountType.fix == 1) {
        self.amountTF.placeholder = @"仅可选择以下金额";
    }
}

#pragma mark- UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 11100) {
        return 8;
    } else {
        return self.payments.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 11100) {
        BTTBankUnionAppIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBankUnionAppIconCell" forIndexPath:indexPath];
        cell.iconImageView.image = ImageNamed(self.apps[indexPath.row]);
        return cell;
    } else {
        CNPayQRCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kQRCellIndentifier forIndexPath:indexPath];

        CNPaymentModel *payment = [self.payments objectAtIndex:indexPath.row];
//        cell.tuijianIcon.hidden = (payment.payType == CNPaymentUnionQR ? NO : YES);
        cell.titleLb.text = payment.payTypeName;
        switch (payment.payType) {
            case 8:
                cell.tuijianIcon.image = [UIImage imageNamed:@"me_wechatsecond"];
                break;
            case 9:
                cell.tuijianIcon.image = [UIImage imageNamed:@"me_aliwap"];
                break;
            case 11:
                cell.tuijianIcon.image = [UIImage imageNamed:@"me_qqScan"];
                break;
            case 17:
                cell.tuijianIcon.image = [UIImage imageNamed:@"me_jdscan"];
                break;
            case 27:
                cell.tuijianIcon.image = [UIImage imageNamed:@"me_YSF"];
                break;

            default:
                break;
        }
        cell.channelIconIV.image = [UIImage imageNamed:payment.payTypeIcon];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == _currentSelectedIndex || collectionView.tag == 11100) {
        return;
    }
    [self.view endEditing:YES];

    self.currentSelectedIndex = indexPath.row;
    self.paymentModel = [self.payments objectAtIndex:indexPath.row];
    [self queryOnlineBanks];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 11100) {
        return self.appSize;
    } else {
        return self.cellSize;
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

- (IBAction)nextStep:(UIButton *)sender {
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
    double maxAmount = [self.typeModel.maxAmount doubleValue] > [self.typeModel.minAmount doubleValue] ? [self.typeModel.maxAmount doubleValue] : CGFLOAT_MAX;
    if ([amount doubleValue] > maxAmount || [amount doubleValue] < [self.typeModel.minAmount doubleValue]) {
        _amountTF.text = nil;
        [self showError:[NSString stringWithFormat:@"存款金额必须是%.f~%.f之间，最大允许2位小数", [self.typeModel.minAmount doubleValue], maxAmount]];
        return;
    }

    if (sender.selected) {
        return;
    }
    sender.selected = YES;

    /// 提交
    __weak typeof(self) weakSelf =  self;
    NSDictionary *params = @{
            @"amount": text,
            @"payType": @(self.paymentModel.payType),
            @"payid": self.typeModel.payid,
            @"loginName": [IVNetwork savedUserInfo].loginName,
            @"bankNo": @""
    };
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTCreateOnlineOrder paramters:params completionBlock:^(id _Nullable response, NSError *_Nullable error) {
        [weakSelf hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            sender.selected = NO;
            [strongSelf handlerResult:result];
        }
    }];
//    NSString *tempAmount = [NSString stringWithFormat:@"%.2f",[text floatValue]];
//    NSDictionary *params = @{
//        @"amount":tempAmount,
//        @"payType":@(self.paymentModel.payType),
//        @"currency":@"CNY",
//        @"loginName":[IVNetwork savedUserInfo].loginName
//        //        ,@"protocol" : self.selectedProtocol
//    };
//    [IVNetwork requestPostWithUrl:BTTCreateOnlineOrderV2 paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
//        [self hideLoading];
//        IVJResponseObject *result = response;
//        if ([result.head.errCode isEqualToString:@"0000"]) {
//            strongSelf(strongSelf)
//            sender.selected = NO;
//            [strongSelf handlerResult:result];
//        }else{
//            [self showError:result.head.errMsg];
//        }
//    }];
}

- (void)handlerResult:(IVJResponseObject *)model {
    // 数据容灾
    if (![model.body isKindOfClass:[NSDictionary class]]) {
        // 后台返回类型不一，全部转成字符串
        [self showError:[NSString stringWithFormat:@"%@", model.head.errMsg]];
        return;
    }

    NSError *error;
//    CNPayOrderModelV2 *orderModel = [[CNPayOrderModelV2 alloc] initWithDictionary:model.body error:&error];
    CNPayOrderModel *orderModel = [[CNPayOrderModel alloc] initWithDictionary:model.body error:&error];
    if (error && !orderModel) {
        [self showError:@"操作失败！请联系客户，或者稍后重试!"];
        return;
    }
    self.writeModel.orderModel = orderModel;
//    self.writeModel.orderModelV2 = orderModel;
    self.writeModel.depositType = self.paymentModel.payTypeName;
    [self goToStep:1];
}

@end
