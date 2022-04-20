//
//  BTTWithdrawalController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTWithdrawalController.h"
#import "BTTWithdrawalHeaderCell.h"
#import "BTTWithdrawalController+LoadData.h"
#import "BTTMeMainModel.h"
#import "BTTHomePageSeparateCell.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTBindingMobileBtnCell.h"
#import "BTTWithdrawalCardSelectCell.h"
#import "BRPickerView.h"
#import "BTTWithdrawalSuccessController.h"
#import "BTTAccountBalanceController.h"
#import "BTTBankModel.h"
#import "BTTWithdrawalNotifyCell.h"
#import "BTTWithDrawUSDTConfirmCell.h"
#import "BTTBTCRateModel.h"
#import "CNPayUSDTRateModel.h"
#import "BTTWithDrawProtocolView.h"
#import "BTTBitollWithDrawCell.h"
#import "BTTCardInfosController.h"
#import "HAInitConfig.h"
#import "IVRsaEncryptWrapper.h"
#import "BTTPasswordChangeController.h"
#import "BTTActionSheet.h"
#import "KYMWithdrewAmountCell.h"
#import "KYMWithdrewHomeNotifyCell.h"
#import "KYMWithdrewRequest.h"
#import "CNMAlertView.h"
#import "KYMWithdrawHistoryCell.h"
#import "KYMWithdrewSuccessVC.h"
#import "KYMWithdrawAlertVC.h"
@interface BTTWithdrawalController ()<BTTElementsFlowLayoutDelegate,KYMWithdrewAmountCellDelegate>
@property(nonatomic, copy)NSString *amount;
@property(nonatomic, copy)NSString *password;
@property(nonatomic, copy)NSString *usdtAmount;
@property(nonatomic, strong) UITextField *usdtField;
@property (nonatomic, copy) NSString *selectedProtocol;
@property(nonatomic, strong) NSIndexPath *selectedMatchIndexPath;
@property (nonatomic, assign) BOOL submitBtnEnable;
@end

@implementation BTTWithdrawalController

- (void)setCheckModel:(KYMWithdrewCheckModel *)checkModel
{
    _checkModel = checkModel;
    [self checkIfHasExistingMacthOrder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"取款申请";
    self.selectIndex = 0;
    self.isSellUsdt = NO;
    self.amount = @"";
    self.usdtAmount = @"";
    self.password = @"";
    self.totalAvailable = @"-";
    self.dcboxLimit = @"15";
    self.usdtLimit = @"15";
    [self setupCollectionView];
    [self setUpNav];
    [self refreshBankList];
    [self requestSellUsdtSwitch];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.bankList.count != 0) {
//        if ([[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"]) {
//            [self getLimitUSDT];
//        } else {
//            [self getLimitUSDT];//根据用户币种返回限额
////            [self loadMainData];
//        }
        [self loadCreditsTotalAvailable];
    }
}

-(void)setUpNav {
    UIButton * leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 54, 44);
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

-(void)backAction {
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTWithdrawalHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTWithdrawalHeaderCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageSeparateCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageSeparateCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTWithdrawalCardSelectCell" bundle:nil] forCellWithReuseIdentifier:@"BTTWithdrawalCardSelectCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTWithdrawalNotifyCell" bundle:nil] forCellWithReuseIdentifier:@"BTTWithdrawalNotifyCell"];
    [self.collectionView registerClass:[BTTWithDrawUSDTConfirmCell class] forCellWithReuseIdentifier:@"BTTWithDrawUSDTConfirmCell"];
    [self.collectionView registerClass:[BTTWithDrawProtocolView class] forCellWithReuseIdentifier:@"BTTWithDrawProtocolView"];
    [self.collectionView registerClass:[BTTBitollWithDrawCell class] forCellWithReuseIdentifier:@"BTTBitollWithDrawCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"KYMWithdrewAmountCell" bundle:nil] forCellWithReuseIdentifier:@"KYMWithdrewAmountCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"KYMWithdrewHomeNotifyCell" bundle:nil] forCellWithReuseIdentifier:@"KYMWithdrewHomeNotifyCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"KYMWithdrawHistoryCell" bundle:nil] forCellWithReuseIdentifier:@"KYMWithdrawHistoryCell"];
    
}
- (void)setSubmitBtnEnable:(BOOL)submitBtnEnable
{
    _submitBtnEnable = submitBtnEnable;
    [self getSubmitBtn].enabled = submitBtnEnable;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sheetDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    weakSelf(weakSelf);
    BTTMeMainModel *cellModel = self.sheetDatas.count ? self.sheetDatas[indexPath.row] : nil;
    if ([cellModel.name isEqualToString:@"头"]) {
        BTTWithdrawalHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTWithdrawalHeaderCell" forIndexPath:indexPath];
        cell.totalAvailable = [PublicMethod getMoneyString:[self.totalAvailable doubleValue]];
        if ([[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"]) {
            if ([self.bankList[self.selectIndex].accountType isEqualToString:@"DCBOX"]) {
                cell.limitLabel.text = [NSString stringWithFormat:@"取款限额:%@USDT-143万USDT,全额投注即可申请取款", self.dcboxLimit];
            } else {
                cell.limitLabel.text = [NSString stringWithFormat:@"取款限额:%@USDT-143万USDT,全额投注即可申请取款", self.usdtLimit];;
            }
            
        } else {
            if ([self.bankList[self.selectIndex].accountType isEqualToString:@"借记卡"]||[self.bankList[self.selectIndex].accountType isEqualToString:@"信用卡"]||[self.bankList[self.selectIndex].accountType isEqualToString:@"存折"]) {
                cell.limitLabel.text = [NSString stringWithFormat:@"取款限额:%@-1000万RMB,全额投注即可申请取款", self.cnyLimit];
            } else {
                cell.limitLabel.text = [NSString stringWithFormat:@"取款限额:%@-1000万RMB,全额投注即可申请取款", self.cnyLimit];
            }
        }
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf);
            BTTAccountBalanceController *accountBalance = [[BTTAccountBalanceController alloc] init];
            [strongSelf.navigationController pushViewController:accountBalance animated:YES];
        };
        return cell;
    }
    
    //推荐金额
    if ([cellModel.name isEqualToString:@"固定金额"]) {
        KYMWithdrewAmountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KYMWithdrewAmountCell" forIndexPath:indexPath];
        cell.amountArray = self.checkModel.data.currentAmountList;
        cell.delegate = self;
        return cell;
    }
    
    if ([cellModel.name isEqualToString:@"分割"]) {
        BTTHomePageSeparateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageSeparateCell" forIndexPath:indexPath];
        return cell;
    }
    
    if (([self.bankList[self.selectIndex].bankName isEqualToString:@"USDT"]||[self.bankList[self.selectIndex].bankName isEqualToString:@"BITOLL"]||[self.bankList[self.selectIndex].bankName isEqualToString:@"DCBOX"])&&[cellModel.name isEqualToString:@"usdt确认"]) {
        BTTWithDrawUSDTConfirmCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTWithDrawUSDTConfirmCell" forIndexPath:indexPath];
        [cell setCellRateWithRate:self.usdtRate];
        return cell;
    }
    if ([self.bankList[self.selectIndex].bankName isEqualToString:@"USDT"]&& [cellModel.name isEqualToString:@"协议"]) {
        BTTWithDrawProtocolView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTWithDrawProtocolView" forIndexPath:indexPath];
        if ([self.bankList[self.selectIndex].protocol isEqualToString:@""]) {
            [cell setTypeData:@[@"ERC20", @"TRC20",@"OMNI"]];
        }else{
            [cell setTypeData:@[self.bankList[self.selectIndex].protocol]];
        }
        cell.tapProtocol = ^(NSString * _Nonnull protocol) {
            self.selectedProtocol = protocol;
        };
        return cell;
    }
    if ([self.bankList[self.selectIndex].bankName isEqualToString:@"DCBOX"]&& [cellModel.name isEqualToString:@"协议"]) {
        BTTWithDrawProtocolView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTWithDrawProtocolView" forIndexPath:indexPath];
        [cell setTypeData:@[@"ERC20", @"TRC20"]];
//        if ([self.bankList[self.selectIndex].protocol isEqualToString:@""]) {
//        }else{
//            [cell setTypeData:@[self.bankList[self.selectIndex].protocol]];
//        }
        cell.tapProtocol = ^(NSString * _Nonnull protocol) {
            self.selectedProtocol = protocol;
        };
        return cell;
    }

    if ([cellModel.name isEqualToString:@"提交"]) {
        
        BTTBitollWithDrawCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBitollWithDrawCell" forIndexPath:indexPath];
        BOOL imgHidden = ![self.bankList[self.selectIndex].bankName isEqualToString:@"DCBOX"];
        BOOL isSellUSDT = [self.bankList[self.selectIndex].bankName isEqualToString:@"DCBOX"]||[self.bankList[self.selectIndex].bankName isEqualToString:@"BITOLL"]||[self.bankList[self.selectIndex].bankName isEqualToString:@"USDT"];
        [cell setImageViewHidden:imgHidden onekeyHidden:!imgHidden sellHidden:isSellUSDT];
        cell.confirmTap = ^{
            if (self.bankList[self.selectIndex].accountId==nil) {
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"bitollAddCard"];
                BTTCardInfosController *vc = [[BTTCardInfosController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            [self submitWithDraw];
        };
        cell.oneKeySell = ^{
            if (self.sellUsdtLink!=nil&&![self.sellUsdtLink isEqualToString:@""]) {
                BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
                vc.title = @"一键卖币";
                vc.webConfigModel.theme = @"outside";
                vc.webConfigModel.newView = YES;
                vc.webConfigModel.url = self.sellUsdtLink;
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        cell.bindTap = ^{
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"bitollAddCard"];
            BTTCardInfosController *vc = [[BTTCardInfosController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        };
        cell.confirmBtn.enabled = self.submitBtnEnable;
        [cell.confirmBtn setTitle:@"立即取款" forState:UIControlStateNormal];
        return cell;
    }

    NSString *cellName = cellModel.name;
    if ([cellName isEqualToString:@"取款至"]) {
        BTTWithdrawalCardSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTWithdrawalCardSelectCell" forIndexPath:indexPath];
        cell.model = self.bankList[self.selectIndex];
        
        return cell;
    }
    if ([cellName isEqualToString:@"联系客服"]) {
        KYMWithdrewHomeNotifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KYMWithdrewHomeNotifyCell" forIndexPath:indexPath];
        cell.canUseCount = self.checkModel.data.remainWithdrawTimes;
        __weak typeof(self)weakSelf = self;
        cell.forgotPwdBlock = ^{
            [weakSelf customerBtnClicked];
        };
        return cell;
    }
    if ([cellName isEqualToString:@"历史"]) {
        KYMWithdrawHistoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KYMWithdrawHistoryCell" forIndexPath:indexPath];
        cell.historyView.amount = self.checkModel.data.mmProcessingOrderAmount;
        cell.historyView.orderNo = self.checkModel.data.mmProcessingOrderTransactionId;
        if (self.checkModel.data.mmProcessingOrderManualStatus == 4) {
            cell.isManualStatus = YES;
            cell.historyView.confirmBtnHandler = ^{
                [weakSelf customerBtnClicked];
            };
        } else {
            cell.historyView.confirmBtnHandler = ^{
                [weakSelf showConfirmMathWithdrawAlert];
            };
        }
        
        cell.historyView.noConfirmBtnHandler = ^ {
            [weakSelf showConfirmMathWithdrawAlert];
        };
        return cell;
    }
    BTTBindingMobileOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileOneCell" forIndexPath:indexPath];
    cell.model = cellModel;
    cell.textField.userInteractionEnabled = cellModel.available;
    cell.textField.text = cellModel.desc;
    cell.textField.secureTextEntry = NO;
    if ([cellName isEqualToString:@"本次存款金额"]) {
        cell.textField.textColor = [UIColor colorWithHexString:@"2497FF"];
    } else if ([cellName isEqualToString:@"需要达到的投注额"]) {
        cell.textField.textColor = [UIColor colorWithHexString:@"2497FF"];
    } else if ([cellName isEqualToString:@"已经达成的投注额"]) {
        cell.textField.textColor = [UIColor colorWithHexString:@"2497FF"];
    } else if ([cellName isEqualToString:@"资金密码"]) {
        cell.textField.secureTextEntry = YES;
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.textField.text = self.password;
        cell.textField.tag = 8001;
    } else if ([cellName isEqualToString:@"金额"]) {
        cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
        cell.textField.text = self.amount;
        cell.textField.tag = 8002;
    }else if ([cellName isEqualToString:@"预估到账"]) {
        _usdtField = cell.textField;
        _usdtField.text = self.usdtAmount;;
        
    }
    [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}

- (void)confirmBtn_click:(id)sender{
    
    [self submitWithDraw];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    BTTMeMainModel * model = self.sheetDatas[indexPath.row];
    if ([model.iconName isEqualToString:@"没有资金密码？点击设置资金密码"]) {
        BTTPasswordChangeController *vc = [[BTTPasswordChangeController alloc] init];
        vc.selectedType = BTTChangeWithdrawPwd;
        vc.isGoToMinePage = false;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row != self.sheetDatas.count) {
        if (indexPath.row==self.sheetDatas.count-1&&![self.bankList[self.selectIndex].bankName isEqualToString:@"USDT"]) {
//            [self submitWithDraw];
        }else{
            BTTMeMainModel *model = self.sheetDatas[indexPath.row];
            if ([model.name isEqualToString:@"取款至"]) {
                [self.view endEditing:YES];
                [self bankCardPick:indexPath];
            }
        }
        
    }
}

#pragma mark - LMJCollectionViewControllerDataSource

- (UICollectionViewLayout *)collectionViewController:(BTTCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView {
    BTTCollectionViewFlowlayout *elementsFlowLayout = [[BTTCollectionViewFlowlayout alloc] initWithDelegate:self];
    
    return elementsFlowLayout;
}

#pragma mark - LMJElementsFlowLayoutDelegate

- (CGSize)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.elementsHight[indexPath.item].CGSizeValue;
}

- (UIEdgeInsets)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView {
    return UIEdgeInsetsMake(0, 0, 40, 0);
}

/**
 *  列间距, 默认10
 */
- (CGFloat)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView columnsMarginForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

/**
 *  行间距, 默认10
 */
- (CGFloat)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}
#pragma mark - KYMWithdrewAmountCellDelegate

- (void)matchWithdrewAmountCellDidSelected:(KYMWithdrewAmountCell *)cell indexPath:(NSIndexPath *)indexPath
{
    self.amount = cell.amountArray[indexPath.row].amount;
    self.selectedMatchIndexPath = indexPath;
    if ([PublicMethod isValidateWithdrawPwdNumber:self.password]) {
        self.submitBtnEnable = true;
    } else {
        self.submitBtnEnable = false;
    }
    [self getAmountTextField].text = self.amount;
}
- (void)setupElements {
    if (self.elementsHight.count) {
        [self.elementsHight removeAllObjects];
    }
    NSInteger total = self.sheetDatas.count;
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        BTTMeMainModel *cellModel = self.sheetDatas[i];
        [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, cellModel.cellHeight)]];
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}
- (void)textChanged:(UITextField *)textField
{
    if (textField.tag == 8001) {
        self.password = textField.text;
        if ([PublicMethod isValidateWithdrawPwdNumber:self.password]) {
            self.submitBtnEnable = true;
        } else {
            self.submitBtnEnable = false;
        }
    } else if (textField.tag == 8002) {
        self.amount = textField.text;
        if ([self.bankList[self.selectIndex].bankName isEqualToString:@"USDT"]||[self.bankList[self.selectIndex].bankName isEqualToString:@"BITOLL"]||[self.bankList[self.selectIndex].bankName isEqualToString:@"DCBOX"]) {
            if (self.amount.length != 0) {
                NSString *fUsdtAmount = [NSString stringWithFormat:@"%.5f",([self.amount doubleValue] * self.usdtRate)];
                self.usdtAmount = [NSString stringWithFormat:@"%@ USDT",[fUsdtAmount substringWithRange:NSMakeRange(0, fUsdtAmount.length-1)]];
            } else {
                self.usdtAmount = @"";
            }
            _usdtField.text = self.usdtAmount;
        }
        if ([[IVNetwork savedUserInfo].uiMode isEqualToString:@"CNY"]) {
            self.checkModel.data.inputAmount = self.amount;
            [self getAmountListCell].amountArray = self.checkModel.data.currentAmountList;
            [[self getAmountListCell] setCurrentAmount:self.amount];
            for (BTTMeMainModel *cellModel in self.sheetDatas) {
                if ([cellModel.name isEqualToString:@"固定金额"]) {
                    NSInteger index = [self.sheetDatas indexOfObject:cellModel];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                    CGSize size = self.elementsHight[indexPath.item].CGSizeValue;
                    CGFloat height = [self getMatchAmountListHeight];
                    if (size.height != height) {
                        size.height = [self getMatchAmountListHeight];
                        self.elementsHight[indexPath.item] = @(size);
                        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                    }
                }
            }
        }
    }
    
    CGFloat amount = [self.amount doubleValue];
    NSInteger cnyLimitNum = 100;
    if (![[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] && ([self.bankList[self.selectIndex].accountType isEqualToString:@"借记卡"]||[self.bankList[self.selectIndex].accountType isEqualToString:@"信用卡"]||[self.bankList[self.selectIndex].accountType isEqualToString:@"存折"])) {
        cnyLimitNum = [self.cnyLimit integerValue];
    }
    NSInteger usdtLimitNum = [self.usdtLimit integerValue];
    if ([[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] && [self.bankList[self.selectIndex].accountType isEqualToString:@"DCBOX"]) {
        usdtLimitNum = [self.dcboxLimit integerValue];
    }
    if ([[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"]) {
        BOOL enable = amount >= usdtLimitNum && amount <= 1430000 && [PublicMethod isValidateWithdrawPwdNumber:self.password];
        self.submitBtnEnable = enable;
    }else{
        BOOL enable = amount >= cnyLimitNum && amount <= 10000000 && [PublicMethod isValidateWithdrawPwdNumber:self.password];
        self.submitBtnEnable = enable;
    }
    
    if ([[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"]) {
        if (amount > 1430000) {
            [MBProgressHUD showMessagNoActivity:@"超过最大取款额度!" toView:self.view];
        }
    }else{
        if (amount > 10000000) {
            [MBProgressHUD showMessagNoActivity:@"超过最大取款额度!" toView:self.view];
        }
    }
}
- (UIButton *)getSubmitBtn
{
    for (BTTMeMainModel *cellModel in self.sheetDatas) {
        if ([cellModel.name isEqualToString:@"提交"]) {
            NSInteger index = [self.sheetDatas indexOfObject:cellModel];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            BTTBitollWithDrawCell *cell = (BTTBitollWithDrawCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            return cell.confirmBtn;
        }
    }
    return nil;
    
}
- (KYMWithdrewAmountCell *)getAmountListCell
{
    for (BTTMeMainModel *cellModel in self.sheetDatas) {
        if ([cellModel.name isEqualToString:@"固定金额"]) {
            NSInteger index = [self.sheetDatas indexOfObject:cellModel];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            KYMWithdrewAmountCell *cell = (KYMWithdrewAmountCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            return cell;
        }
    }
    return nil;
}
- (UITextField *)getAmountTextField
{
    for (BTTMeMainModel *cellModel in self.sheetDatas) {
        if ([cellModel.name isEqualToString:@"金额"]) {
            NSInteger index = [self.sheetDatas indexOfObject:cellModel];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            BTTBindingMobileOneCell *cell = (BTTBindingMobileOneCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            return cell.textField;
        }
    }
    return nil;
}
//选中银行卡
- (void)bankCardPick:(NSIndexPath *)indexPath
{
    BOOL isUSDTAcc = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"];
    BTTWithdrawalCardSelectCell *cell = (BTTWithdrawalCardSelectCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    NSMutableArray *textArray = @[].mutableCopy;
    if (isUSDTAcc) {
        [textArray addObject:[NSString stringWithFormat:@"➕ 小金库钱包"]];
    }
    BOOL haveBfb = NO;
    
    for (BTTBankModel *model in self.bankList) {
        if ([model.accountType isEqualToString:@"借记卡"]||[model.accountType isEqualToString:@"信用卡"]||[model.accountType isEqualToString:@"存折"]||[model.accountType isEqualToString:@"BTC"]) {
            [textArray addObject:[NSString stringWithFormat:@"%@-%@",model.bankName,model.accountNo]];
        }else if ([model.accountType isEqualToString:@"BITOLL"]){
            if (model.accountId!=nil) {
                [textArray addObject:[NSString stringWithFormat:@"币付宝-%@",model.accountNo]];
            }
            
        }else if ([model.accountType isEqualToString:@"DCBOX"]){
            if (model.accountId!=nil) {
                [textArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"小金库-%@",model.accountNo]];
                haveBfb = YES;
            }
            
        }else{
            NSString*resultStr=[model.accountType stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[model.accountType substringToIndex:1] capitalizedString]];
            [textArray addObject:[NSString stringWithFormat:@"%@-%@",resultStr,model.accountNo]];
        }
    }
    [BRStringPickerView showStringPickerWithTitle:@"请选择银行卡" dataSource:textArray.copy defaultSelValue:[NSString stringWithFormat:@"➕ 小金库钱包"] resultBlock:^(id selectValue, NSInteger index) {
        
        if (index==0&&!haveBfb) {
            self.selectIndex = 0;
            [self.view endEditing:YES];
            [self loadMainData];
            return;
        }
        cell.detailLabel.text = selectValue;
       
        for (int i = 0; i < self.bankList.count; i++) {
            NSString *withDrawText = @"";
            if ([self.bankList[i].accountType isEqualToString:@"借记卡"]||[self.bankList[i].accountType isEqualToString:@"信用卡"]||[self.bankList[i].accountType isEqualToString:@"存折"]||[self.bankList[i].accountType isEqualToString:@"BTC"]) {
                withDrawText = [NSString stringWithFormat:@"%@-%@",self.bankList[i].bankName,self.bankList[i].accountNo];
                if ([withDrawText isEqualToString:selectValue]) {
                    self.selectIndex = i;
                }
            }else if ([self.bankList[i].accountType isEqualToString:@"BITOLL"]&&self.bankList[i].accountId!=nil){
                withDrawText = [NSString stringWithFormat:@"币付宝-%@",self.bankList[i].accountNo];
                if ([withDrawText isEqualToString:selectValue]) {
                    self.selectIndex = i;
                }
            }else if ([self.bankList[i].accountType isEqualToString:@"DCBOX"]&&self.bankList[i].accountId!=nil){
                withDrawText = [NSString stringWithFormat:@"小金库-%@",self.bankList[i].accountNo];
                if ([withDrawText isEqualToString:selectValue]) {
                    self.selectIndex = i;
                }
            } else{
                NSString*resultStr=[self.bankList[i].accountType stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self.bankList[i].accountType substringToIndex:1] capitalizedString]];
                withDrawText = [NSString stringWithFormat:@"%@-%@",resultStr,self.bankList[i].accountNo];
                if ([withDrawText isEqualToString:selectValue]) {
                    self.selectIndex = i;
                }
            }
        }
        [self.view endEditing:YES];
        self.usdtAmount = @"";
        self.password = @"";
        self.usdtField.text = self.usdtAmount;
        self.submitBtnEnable = false;
        [self loadMainData];
    }];
}

- (void)refreshBankList
{
    NSDictionary *json = [IVCacheWrapper objectForKey:BTTCacheBankListKey];
    if (json!=nil) {
        NSArray *array = json[@"accounts"];
//        BOOL isBlackNineteen = [[IVNetwork savedUserInfo].depositLevel isEqualToString:@"-19"];
        BOOL isHaveBitoll = NO;
        BOOL isUSDTAcc = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"];
        if (isArrayWithCountMoreThan0(array)) {
            NSMutableArray *bankList = [[NSMutableArray alloc]init];
            for (int i =0 ; i<array.count; i++) {
                NSDictionary *json = array[i];
                BTTBankModel *model = [BTTBankModel yy_modelWithDictionary:json];
                if (![model.accountType isEqualToString:@"Bitbase"]) {
                    if (isUSDTAcc) {
//                        if (isBlackNineteen) {
//                            if (![model.accountType isEqualToString:@"存折"]&&![model.accountType isEqualToString:@"借记卡"]&&![model.accountType isEqualToString:@"信用卡"]) {
//                                if ([model.accountType isEqualToString:@"DCBOX"]) {
//                                    [bankList insertObject:model atIndex:0];
//                                    isHaveBitoll = YES;
//                                }else{
//                                    [bankList addObject:model];
//                                }
//                            }
//                        }else{
                            if ([model.bankName isEqualToString:@"DCBOX"]) {
                                [bankList insertObject:model atIndex:0];
                                isHaveBitoll = YES;
                            }else if(![model.bankName isEqualToString:@"BITOLL"]){
                                [bankList addObject:model];
                            }
//                        }
                        if (i==array.count-1) {
                            if (!isHaveBitoll) {
                                BTTBankModel *bModel = [[BTTBankModel alloc]init];
                                bModel.accountType = @"DCBOX";
                                bModel.bankName = @"DCBOX";
                                [bankList insertObject:bModel atIndex:0];
                            }
                        }
                    } else { //CNY
                        if ([model.accountType isEqualToString:@"存折"] || [model.accountType isEqualToString:@"借记卡"] || [model.accountType isEqualToString:@"信用卡"]) {
                                [bankList addObject:model];
                        }
                    }
                }
            }
            self.bankList = bankList;
            if (self.bankList.count == 0) {
                [self hideLoading];
                [MBProgressHUD showErrorWithTime:@"还没获取到可用的银行卡 请稍候" toView:[UIApplication sharedApplication].keyWindow duration:4];
                [self.navigationController popToRootViewControllerAnimated:true];
                return;
            }
            [self loadMainData];
            [self setupElements];
            self.selectedProtocol = self.bankList.firstObject.protocol;
        }
    }
}

- (void)submitWithDraw
{
    
    if ([self.bankList[_selectIndex].bankName isEqualToString:@"DCBOX"]&&self.bankList[_selectIndex].accountId==nil) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"bitollAddCard"];
        BTTCardInfosController *vc = [[BTTCardInfosController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    NSInteger cnyLimitNum = 100;
    if (![[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] && ([self.bankList[self.selectIndex].accountType isEqualToString:@"借记卡"]||[self.bankList[self.selectIndex].accountType isEqualToString:@"信用卡"]||[self.bankList[self.selectIndex].accountType isEqualToString:@"存折"])) {
        cnyLimitNum =  [self.cnyLimit integerValue];
    }
    if (self.amount.floatValue < cnyLimitNum && ![[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"]) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"最少%ld元", cnyLimitNum] toView:nil];
        return;
    }
    NSInteger usdtLimitNum = [self.usdtLimit integerValue];
    if ([[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] && [self.bankList[self.selectIndex].accountType isEqualToString:@"DCBOX"]) {
        usdtLimitNum = [self.dcboxLimit integerValue];
    }
    if (self.amount.floatValue < usdtLimitNum && [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"]) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"最少%ld元", usdtLimitNum] toView:nil];
        return;
    }
    if (self.canWithdraw>0) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"您有%ld个未处理的取款提案",(long)self.canWithdraw] toView:nil];
        return;
    }
    if (![PublicMethod isValidateWithdrawPwdNumber:self.password]) {
        [MBProgressHUD showError:@"输入的资金密码格式有误！" toView:nil];
        return;
    }
    
    if ([self.bankList[self.selectIndex].accountType isEqualToString:@"借记卡"]||[self.bankList[self.selectIndex].accountType isEqualToString:@"信用卡"]||[self.bankList[self.selectIndex].accountType isEqualToString:@"存折"]) {
        [self showLoading];
    
        if ([self getAmountListCell].selectedIndexPath && !self.isForceNormalWithdraw) {
            //撮合取款
            [self createRequestMatchWithdraw];
        } else {
            //普通取款
            [self createRequestWithBtcModel:nil usdtModel:nil];
        }
        
    }else if ([self.bankList[self.selectIndex].accountType isEqualToString:@"BTC"]){
        NSDictionary *params = @{
            @"amount":self.amount,
            @"loginName":[IVNetwork savedUserInfo].loginName
        };
        [self showLoading];
        [IVNetwork requestPostWithUrl:BTTWithDrawBTCRate paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
            IVJResponseObject *result = response;
            if ([result.head.errCode isEqualToString:@"0000"]) {
                BTTBTCRateModel *model = [BTTBTCRateModel yy_modelWithJSON:result.body];
                [self createRequestWithBtcModel:model usdtModel:nil];
            }else{
                [self hideLoading];
                [MBProgressHUD showError:@"获取比特币汇率失败，请稍后重试" toView:nil];
            }
        }];
    }else{
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        params[@"amount"] = self.amount;
        params[@"srcCurrency"] = @"CNY";
        params[@"tgtCurrency"] = @"USDT";
        params[@"used"] = @"2";
        params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
        [self showLoading];
        [IVNetwork requestPostWithUrl:BTTCurrencyExchanged paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
            IVJResponseObject *result = response;
            if ([result.head.errCode isEqualToString:@"0000"]) {
                CNPayUSDTRateModel *rateModel = [CNPayUSDTRateModel yy_modelWithJSON:result.body];
                [self createRequestWithBtcModel:nil usdtModel:rateModel];
            }else{
                [self hideLoading];
                [MBProgressHUD showError:@"获取USDT汇率失败，请稍后重试" toView:nil];
            }
        }];
    }
}
- (void)createRequestMatchWithdraw
{    
    //撮合取款
    BTTBankModel *model = self.bankList[self.selectIndex];
    NSMutableDictionary *mparams = @{}.mutableCopy;
//            mparams[@"loginName"] = @""; //用户名，底层已拼接
//            mparams[@"productId"] = @""; //脱敏产品编号，底层已拼接
    mparams[@"accountId"] = model.accountId;; //银行账户编号
    mparams[@"amount"] = self.amount; //取款金额
    mparams[@"currency"] = @"CNY"; //币种
    mparams[@"withdrawType"] = @"4"; //取款提案类型
    mparams[@"password"] = [IVRsaEncryptWrapper encryptorString:self.password]; //取款密码
    [self showLoading];
    
    [KYMWithdrewRequest createWithdrawWithParams:mparams.copy callback:^(BOOL status, NSString * _Nonnull msg, KYMCreateWithdrewModel  *_Nonnull model) {
        [self hideLoading];
        if (!status) {
            [MBProgressHUD showError:msg toView:nil];
            return;
        }
        KYMWithdrewSuccessVC *vc = [[KYMWithdrewSuccessVC alloc] init];
        vc.amountStr = model.amount;
        vc.transactionId = model.referenceId;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
- (void)createRequestWithBtcModel:(BTTBTCRateModel *)btcModel usdtModel:(CNPayUSDTRateModel *)usdtModel{
    NSString *amount = self.amount;
    BTTBankModel *model = self.bankList[self.selectIndex];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"accountId"] = model.accountId;
    params[@"amount"] = self.amount;
    if (btcModel!=nil) {
        params[@"btcAmount"] = btcModel.btcAmount;
        params[@"btcRate"] = btcModel.btcRate;
        params[@"btcUuid"] = btcModel.btcUuid;
    }
    if (usdtModel!=nil) {
        params[@"btcAmount"] = usdtModel.tgtAmount;
        params[@"btcRate"] = usdtModel.rate;
        params[@"btcUuid"] = usdtModel.uuid;
    }
    if (!(isNull(self.selectedProtocol)||[self.selectedProtocol isEqualToString:@""])) {
        params[@"protocol"] = self.selectedProtocol;
    }
    if ([model.bankName isEqualToString:@"BITOLL"]) {
        params[@"protocol"] = @"ERC20";
    }
    if ([model.bankName isEqualToString:@"DCBOX"]) {
        params[@"protocol"] = self.selectedProtocol;
    }
    params[@"password"] = [IVRsaEncryptWrapper encryptorString:self.password];
    BOOL isUSDTSell = [model.bankName isEqualToString:@"BITOLL"]||[model.bankName isEqualToString:@"DCBOX"]||[model.bankName isEqualToString:@"USDT"];
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:BTTWithDrawCreate paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSDictionary *json = @{@"request_id":result.body[@"referenceId"]};
            [IVLAManager singleEventId:@"A01_withdraw_create" errorCode:@"" errorMsg:@"" customsData:json];
            BTTWithdrawalSuccessController *vc = [[BTTWithdrawalSuccessController alloc] init];
            vc.amount = amount;
            vc.isSell = self.isSellUsdt&&isUSDTSell;
            vc.sellLink = self.sellUsdtLink;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            if ([result.head.errCode isEqualToString:@"GW_601596"]) {
                IVActionHandler confirm = ^(UIAlertAction *action){
                    
                };
                __weak typeof(self)weakSelf = self;
                IVActionHandler kf = ^(UIAlertAction *action){
                    [weakSelf customerBtnClicked];
                };
                NSString *title = @"温馨提示";
                NSString *message = @"资金密码错输入误，请重新输入或联系客服!";
                [IVUtility showAlertWithActionTitles:@[@"确认", @"联系客服"] handlers:@[confirm, kf] title:title message:message];
                return;
            }
            [MBProgressHUD showError:result.head.errMsg toView:weakSelf.view];
        }
    }];
}
//是否已存在撮合订单
- (void)checkIfHasExistingMacthOrder
{
    KYMWithdrewCheckModel *model = self.checkModel;
    if (model.data.mmProcessingOrderTransactionId && model.data.mmProcessingOrderTransactionId.length != 0) {
        self.isForceNormalWithdraw = YES;
    }
}
- (void)customerBtnClicked
{
    [CSVisitChatmanager startWithSuperVC:self finish:^(CSServiceCode errCode) {
        if (errCode != CSServiceCode_Request_Suc) {
            [MBProgressHUD showErrorWithTime:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持" toView:nil duration:3];
        } else {

        }
    }];
}
- (void)showConfirmMathWithdrawAlert
{
    __weak typeof(self)weakSelf = self;
    KYMWithdrawAlertVC *vc = [KYMWithdrawAlertVC new];
    vc.confirmBtnHandler = ^{
        [weakSelf showLoading];
        [KYMWithdrewRequest checkReceiveStats:NO transactionId:weakSelf.checkModel.data.mmProcessingOrderTransactionId callBack:^(BOOL status, NSString *msg) {
            [weakSelf hideLoading];
            if (status) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [MBProgressHUD showError:msg toView:nil];
            }
        }];
        
    };
    vc.noConfirmBtnHandler = ^{
        [weakSelf noConfirmGetMathWithdraw];
    };
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)noConfirmGetMathWithdraw
{
    [self showLoading];
    [KYMWithdrewRequest checkReceiveStats:YES transactionId:self.checkModel.data.mmProcessingOrderTransactionId callBack:^(BOOL status, NSString *msg) {
        [self hideLoading];
        if (status) {
            [self customerBtnClicked];
        } else {
            [MBProgressHUD showError:msg toView:nil];
        }
    }];
}

@end
