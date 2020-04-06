//
//  BTTWithdrawalController.m
//  Hybird_A01
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
#import "CLive800Manager.h"
#import "BTTWithDrawProtocolView.h"

@interface BTTWithdrawalController ()<BTTElementsFlowLayoutDelegate>
@property(nonatomic, copy)NSString *amount;
@property(nonatomic, copy)NSString *password;
@property(nonatomic, copy)NSString *usdtAmount;
@property(nonatomic, strong) UITextField *usdtField;
@property (nonatomic, copy) NSString *selectedProtocol;
@end

@implementation BTTWithdrawalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"取款";
    self.selectIndex = 0;
    self.amount = @"";
    self.usdtAmount = @"";
    self.password = @"";
    self.totalAvailable = @"-";
    [self setupCollectionView];
    [self loadMainData];
    [self refreshBankList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadCreditsTotalAvailable];
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
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sheetDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    weakSelf(weakSelf);
    BTTMeMainModel *cellModel = self.sheetDatas.count ? self.sheetDatas[indexPath.row] : nil;
    if (indexPath.row == 0) {
        BTTWithdrawalHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTWithdrawalHeaderCell" forIndexPath:indexPath];
        cell.totalAvailable = self.totalAvailable;
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf);
            BTTAccountBalanceController *accountBalance = [[BTTAccountBalanceController alloc] init];
            [strongSelf.navigationController pushViewController:accountBalance animated:YES];
        };
        return cell;
    }
    if (indexPath.row == 1) {
        BTTHomePageSeparateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageSeparateCell" forIndexPath:indexPath];
        return cell;
    }
    if (([self.bankList[self.selectIndex].bankName isEqualToString:@"USDT"]||[self.bankList[self.selectIndex].bankName isEqualToString:@"BITOLL"])&&indexPath.row==self.sheetDatas.count-2) {
        BTTWithDrawUSDTConfirmCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTWithDrawUSDTConfirmCell" forIndexPath:indexPath];
        [cell setCellRateWithRate:self.usdtRate];
        return cell;
    }
    if (([self.bankList[self.selectIndex].bankName isEqualToString:@"USDT"]||[self.bankList[self.selectIndex].bankName isEqualToString:@"BITOLL"])&&indexPath.row==self.sheetDatas.count-3) {
        BTTWithDrawProtocolView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTWithDrawProtocolView" forIndexPath:indexPath];
        if ([self.bankList[self.selectIndex].protocol isEqualToString:@""]) {
            [cell setTypeData:@[@"OMNI",@"ERC20"]];
        }else{
            [cell setTypeData:@[self.bankList[self.selectIndex].protocol]];
        }
        cell.tapProtocol = ^(NSString * _Nonnull protocol) {
            self.selectedProtocol = protocol;
        };
        return cell;
    }
    if (indexPath.row == self.sheetDatas.count - 1) {
        
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf submitWithDraw];
        };
        return cell;
        
        
    }
    NSString *cellName = cellModel.name;
    if ([cellName isEqualToString:@"取款至"]) {
        BTTWithdrawalCardSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTWithdrawalCardSelectCell" forIndexPath:indexPath];
        cell.model = self.bankList[self.selectIndex];

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
    } else if ([cellName isEqualToString:@"登录密码"]) {
        cell.textField.secureTextEntry = YES;
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.textField.text = self.password;
        cell.textField.tag = 8001;
    } else if ([cellName isEqualToString:@"金额(元)"]) {
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
    if (indexPath.row != self.sheetDatas.count) {
        if (indexPath.row==self.sheetDatas.count-1) {
            [self submitWithDraw];
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
    } else if (textField.tag == 8002) {
        self.amount = textField.text;
        if ([self.bankList[self.selectIndex].bankName isEqualToString:@"USDT"]) {
            NSString *fUsdtAmount = [NSString stringWithFormat:@"%.5f",([self.amount doubleValue] * self.usdtRate)];
            self.usdtAmount = [NSString stringWithFormat:@"%@ USDT",[fUsdtAmount substringWithRange:NSMakeRange(0, fUsdtAmount.length-1)]];
            _usdtField.text = self.usdtAmount;
        }
    }
    CGFloat amount = [self.amount doubleValue];
    BOOL enable = amount >= 10 && amount <= 1000000;
    [self getSubmitBtn].enabled = enable;
    if (amount > 1000000) {
        [MBProgressHUD showMessagNoActivity:@"超过最大取款额度!" toView:self.view];
    }
}
- (UIButton *)getSubmitBtn
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.sheetDatas.count - 1 inSection:0];
    BTTBindingMobileBtnCell *cell = (BTTBindingMobileBtnCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.btn;
}
//选中银行卡
- (void)bankCardPick:(NSIndexPath *)indexPath
{
    BTTWithdrawalCardSelectCell *cell = (BTTWithdrawalCardSelectCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    NSMutableArray *textArray = @[].mutableCopy;
    for (BTTBankModel *model in self.bankList) {
        if ([model.accountType isEqualToString:@"借记卡"]||[model.accountType isEqualToString:@"信用卡"]||[model.accountType isEqualToString:@"存折"]||[model.accountType isEqualToString:@"BTC"]) {
            [textArray addObject:[NSString stringWithFormat:@"%@-%@",model.bankName,model.accountNo]];
        }else if ([model.accountType isEqualToString:@"BITOLL"]){
            [textArray addObject:[NSString stringWithFormat:@"币付宝-%@",model.accountNo]];
        }else{
            NSString*resultStr=[model.accountType stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[model.accountType substringToIndex:1] capitalizedString]];
            [textArray addObject:[NSString stringWithFormat:@"%@-%@",resultStr,model.accountNo]];
        }
    }
    [BRStringPickerView showStringPickerWithTitle:@"请选择银行卡" dataSource:textArray.copy defaultSelValue:cell.detailLabel.text resultBlock:^(id selectValue, NSInteger index) {
        cell.detailLabel.text = selectValue;
        self.amount = @"";
        for (int i = 0; i < self.bankList.count; i++) {
            NSString *withDrawText = @"";
            if ([self.bankList[i].accountType isEqualToString:@"借记卡"]||[self.bankList[i].accountType isEqualToString:@"信用卡"]||[self.bankList[i].accountType isEqualToString:@"存折"]||[self.bankList[i].accountType isEqualToString:@"BTC"]) {
                withDrawText = [NSString stringWithFormat:@"%@-%@",self.bankList[i].bankName,self.bankList[i].accountNo];
                if ([withDrawText isEqualToString:selectValue]) {
                    self.selectIndex = i;
                }
            }else if ([self.bankList[i].accountType isEqualToString:@"BITOLL"]){
                withDrawText = [NSString stringWithFormat:@"币付宝-%@",self.bankList[i].accountNo];
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
        [self loadMainData];
    }];
}

- (void)refreshBankList
{
    BOOL haveUSDT = NO;
    NSDictionary *json = [IVCacheWrapper objectForKey:BTTCacheBankListKey];
    if (json!=nil) {
        NSArray *array = json[@"accounts"];
        BOOL isBlackNineteen = [[IVNetwork savedUserInfo].depositLevel isEqualToString:@"-19"];
        if (isArrayWithCountMoreThan0(array)) {
            NSMutableArray *bankList = [[NSMutableArray alloc]init];
            for (int i =0 ; i<array.count; i++) {
                NSDictionary *json = array[i];
                BTTBankModel *model = [BTTBankModel yy_modelWithDictionary:json];
                if (self.isUSDT&&!haveUSDT&&[model.bankName isEqualToString:@"USDT"]) {
                    [bankList insertObject:model atIndex:0];
                    haveUSDT = YES;
                    
                }else{
                    if (isBlackNineteen) {
                        if (![model.accountType isEqualToString:@"存折"]&&![model.accountType isEqualToString:@"借记卡"]&&![model.accountType isEqualToString:@"信用卡"]) {
                            [bankList addObject:model];
                        }
                    }else{
                        [bankList addObject:model];
                    }
            
                }
                if (i==array.count-1) {
                    self.bankList = bankList;
                    [self loadMainData];
                    [self setupElements];
                }
            }
            
        }
    }
}
- (void)submitWithDraw
{
    if (self.amount.floatValue < 10) {
        [MBProgressHUD showError:@"最少10元" toView:nil];
        return;
    }
    if (self.canWithdraw>0) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"您有%ld个未处理的取款提案",(long)self.canWithdraw] toView:nil];
        return;
    }
    if ([self.bankList[self.selectIndex].accountType isEqualToString:@"借记卡"]||[self.bankList[self.selectIndex].accountType isEqualToString:@"信用卡"]||[self.bankList[self.selectIndex].accountType isEqualToString:@"存折"]) {
        [self showLoading];
        [self createRequestWithBtcModel:nil usdtModel:nil];
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
            [self hideLoading];
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
    
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:BTTWithDrawCreate paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTWithdrawalSuccessController *vc = [[BTTWithdrawalSuccessController alloc] init];
            vc.amount = amount;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:weakSelf.view];
        }
    }];
}

@end
