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
@interface BTTWithdrawalController ()<BTTElementsFlowLayoutDelegate>
@property(nonatomic, copy)NSString *amount;
@property(nonatomic, copy)NSString *password;
@end

@implementation BTTWithdrawalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"取款";
    self.selectIndex = 0;
    self.amount = @"";
    self.password = @"";
    self.totalAvailable = @"-";
    [self setupCollectionView];
    [self loadMainData];
    [self loadCreditsTotalAvailable];
    [self refreshBankList];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTWithdrawalHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTWithdrawalHeaderCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageSeparateCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageSeparateCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTWithdrawalCardSelectCell" bundle:nil] forCellWithReuseIdentifier:@"BTTWithdrawalCardSelectCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    weakSelf(weakSelf);
    if (indexPath.row == 0) {
        BTTWithdrawalHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTWithdrawalHeaderCell" forIndexPath:indexPath];
        cell.totalAvailable = self.totalAvailable;
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf);
            BTTAccountBalanceController *accountBalance = [[BTTAccountBalanceController alloc] init];
            [strongSelf.navigationController pushViewController:accountBalance animated:YES];
        };
        return cell;
    } else if (indexPath.row == 1) {
        BTTHomePageSeparateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageSeparateCell" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == self.sheetDatas.count) {
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf submitWithDraw];
        };
        return cell;
    }  else {
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        if ([model.name isEqualToString:@"取款至"]) {
            BTTWithdrawalCardSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTWithdrawalCardSelectCell" forIndexPath:indexPath];
            cell.model = self.bankList[self.selectIndex];
            return cell;
        } else {
            BTTBindingMobileOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileOneCell" forIndexPath:indexPath];
            cell.model = model;
            if ([model.name isEqualToString:@"登录密码"]) {
                cell.textField.secureTextEntry = YES;
                cell.textField.keyboardType = UIKeyboardTypeDefault;
                cell.textField.text = self.password;
                cell.textField.tag = 8001;
            } else if ([model.name isEqualToString:@"金额(元)"]) {
                cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                cell.textField.secureTextEntry = NO;
                cell.textField.text = self.amount;
                cell.textField.tag = 8002;
            } else if ([model.name isEqualToString:@"比特币"]) {
                cell.textField.userInteractionEnabled = NO;
            }
            [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
            return cell;
        }
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.row != self.sheetDatas.count) {
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        if ([model.name isEqualToString:@"取款至"]) {
            [self bankCardPick:indexPath];
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
    NSInteger total = self.sheetDatas.count + 1;
    for (int i = 0; i < total; i++) {
        if (i == self.sheetDatas.count) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
        } else {
            if (i == 0) {
                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 205)]];
            } else if (i == 1) {
                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 15)]];
            } else {
                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
            }
        }
    }
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
    }
    CGFloat amount = [self.amount doubleValue];
    BOOL enable = [PublicMethod isValidatePwd:self.password] && amount >= 10 && amount <= 1000000;
    [self getSubmitBtn].enabled = enable;
    if (amount > 1000000) {
        [MBProgressHUD showMessagNoActivity:@"超过最大取款额度!" toView:self.view];
    }
}
- (UIButton *)getSubmitBtn
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.sheetDatas.count inSection:0];
    BTTBindingMobileBtnCell *cell = (BTTBindingMobileBtnCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.btn;
}
//选中银行卡
- (void)bankCardPick:(NSIndexPath *)indexPath
{
    BTTWithdrawalCardSelectCell *cell = (BTTWithdrawalCardSelectCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    NSMutableArray *textArray = @[].mutableCopy;
    for (BTTBankModel *model in self.bankList) {
        [textArray addObject:model.withdrawText];
    }
    [BRStringPickerView showStringPickerWithTitle:@"请选择银行卡" dataSource:textArray.copy defaultSelValue:cell.detailLabel.text resultBlock:^(id selectValue, NSInteger index) {
        cell.detailLabel.text = selectValue;
        for (int i = 0; i < self.bankList.count; i++) {
            if ([self.bankList[i].withdrawText isEqualToString:selectValue]) {
                self.selectIndex = i;
            }
        }
        [self loadMainData];
    }];
}
- (void)refreshBankList
{
    NSArray *array = [[IVCacheManager sharedInstance] nativeReadDictionaryForKey:BTTCacheBankListKey];
    if (isArrayWithCountMoreThan0(array)) {
        NSArray<BTTBankModel *> *bankList  = [BTTBankModel arrayOfModelsFromDictionaries:array error:nil];
        NSMutableArray *mBankList = @[].mutableCopy;
        for (BTTBankModel *model in bankList) {
            //取后3位
            NSRange rang = NSMakeRange(model.bankSecurityAccount.length - 3, 3);
            NSString *subBankNum = [model.bankSecurityAccount substringWithRange:rang];
            NSString *pickStr = [NSString stringWithFormat:@"%@-尾号***%@",model.bankName,subBankNum];
            model.withdrawText = pickStr;
            if (model.flag == 1) {
                [mBankList addObject:model];
            }
        }
        self.bankList = mBankList.copy;
        [self setupElements];
    }
}
- (void)submitWithDraw
{
    BTTBankModel *model = self.bankList[self.selectIndex];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"customer_bank_id"] = model.customer_bank_id;
    params[@"amount"] = self.amount;
    NSString *url = nil;
    if (model.isBTC) {
        url = @"public/withdraws/btc";
    } else {
        url = @"public/withdraws/newCreate";
        params[@"password"] = self.password;
    }
    weakSelf(weakSelf)
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    [BTTHttpManager submitWithdrawWithUrl:url params:params.copy completion:^(IVRequestResultModel *result, id response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        if (result.status) {
            BTTWithdrawalSuccessController *vc = [[BTTWithdrawalSuccessController alloc] init];
            vc.amount = weakSelf.amount;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showError:result.message toView:weakSelf.view];
        }
    }];
    
}
@end
