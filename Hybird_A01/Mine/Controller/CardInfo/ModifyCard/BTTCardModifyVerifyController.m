//
//  BTTCardModifyVerifyController.m
//  Hybird_A01
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCardModifyVerifyController.h"
#import "BTTCardModifyVerifyController+LoadData.h"
#import "BTTMeMainModel.h"
#import "BTTCardModifyTitleCell.h"
#import "BTTCardModifyCell.h"
#import "BTTBindingMobileBtnCell.h"
#import "BTTAddCardController.h"
#import "BTTBankModel.h"

@interface BTTCardModifyVerifyController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTCardModifyVerifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行卡验证";
    if (self.safeVerifyType == 0) {
        self.safeVerifyType = BTTSafeVerifyTypeHumanChangeBankCard;
    }
    [self setupCollectionView];
    [self loadMainData];
    [self fetchHumanBankAndPhone];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTCardModifyTitleCell" bundle:nil] forCellWithReuseIdentifier:@"BTTCardModifyTitleCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTCardModifyCell" bundle:nil] forCellWithReuseIdentifier:@"BTTCardModifyCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    weakSelf(weakSelf)
    if (self.safeVerifyType == BTTSafeVerifyTypeMobileChangeBankCard) {
        if (indexPath.row == 0 || indexPath.row == 2) {
            BTTMeMainModel *model = self.sheetDatas[indexPath.row];
            BTTCardModifyTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTCardModifyTitleCell" forIndexPath:indexPath];
            cell.titleLabel.text = model.name;
            return cell;
        } else if (indexPath.row == 1 || indexPath.row == 3) {
            BTTMeMainModel *model = self.sheetDatas[indexPath.row];
            BTTCardModifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTCardModifyCell" forIndexPath:indexPath];
            if (indexPath.row == 1) {
                cell.textField.text = self.bankNumber ? self.bankNumber : model.name;
                cell.textField.userInteractionEnabled = NO;
            } else {
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                cell.textField.text = @"";
                cell.textField.placeholder = model.name;
                cell.textField.userInteractionEnabled = YES;
                [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
            }
            return cell;
        } else {
            BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
            cell.buttonType = BTTButtonTypeNext;
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                [weakSelf submitVerify];
            };
            return cell;
        }
    } else {
        if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6) {
            BTTMeMainModel *model = self.sheetDatas[indexPath.row];
            BTTCardModifyTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTCardModifyTitleCell" forIndexPath:indexPath];
            cell.titleLabel.text = model.name;
            return cell;
        } else if (indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 7) {
            BTTMeMainModel *model = self.sheetDatas[indexPath.row];
            BTTCardModifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTCardModifyCell" forIndexPath:indexPath];
            if (indexPath.row == 1 || indexPath.row == 5) {
                if (indexPath.row == 1) {
                    cell.textField.text = self.phone ? self.phone : model.name;
                    cell.textField.userInteractionEnabled = NO;
                } else {
                    cell.textField.text = self.bankNumber ? self.bankNumber : model.name;
                    cell.textField.userInteractionEnabled = NO;
                }
            } else {
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                cell.textField.text = @"";
                cell.textField.placeholder = model.name;
                cell.textField.userInteractionEnabled = YES;
                [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
            }
            return cell;
        } else {
            BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
            cell.buttonType = BTTButtonTypeNext;
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                [weakSelf submitVerify];
            };
            return cell;
        }
    }
   
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
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
    NSMutableArray *elementsHight = [NSMutableArray array];
    NSInteger total = self.sheetDatas.count + 1;
    for (int i = 0; i < total; i++) {
        if (i == self.sheetDatas.count) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
        } else {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}
- (void)textChanged:(UITextField *)textField
{
    if (self.safeVerifyType == BTTSafeVerifyTypeHumanChangeBankCard) {
        BOOL isPhone = [PublicMethod isValidatePhone:[self getVerifyPhoneTF].text];
        BOOL isBank = [PublicMethod isValidateBankNumber:[self getVerifyBankNumTF].text];
        if (isBank && isPhone) {
            [self getSubmitBtn].enabled = YES;
        } else {
            [self getSubmitBtn].enabled = NO;
        }
    } else {
        [self getSubmitBtn].enabled = [PublicMethod isValidateBankNumber:[self getVerifyBankNumTF].text];
    }
    
}
- (UITextField *)getVerifyBankNumTF
{
    NSIndexPath *indexPath = nil;
    if (self.safeVerifyType == BTTSafeVerifyTypeHumanChangeBankCard) {
        indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
    } else {
        indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    }
    BTTCardModifyCell *cell = (BTTCardModifyCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.textField;
}

- (UITextField *)getVerifyPhoneTF {
    NSIndexPath *indexPath = nil;
    if (self.safeVerifyType == BTTSafeVerifyTypeHumanChangeBankCard) {
        indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    } else {
        return nil;
    }
    BTTCardModifyCell *cell = (BTTCardModifyCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.textField;
}


- (UIButton *)getSubmitBtn
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    if (self.safeVerifyType == BTTSafeVerifyTypeHumanChangeBankCard) {
        indexPath = [NSIndexPath indexPathForRow:8 inSection:0];
    }
    BTTBindingMobileBtnCell *cell = (BTTBindingMobileBtnCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.btn;
}
- (void)fetchHumanBankAndPhone
{
    weakSelf(weakSelf)
//    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
//    [BTTHttpManager fetchHumanBankAndPhoneWithBankId:self.bankModel.accountId Completion:^(id response,NSError *error) {
//        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
//        IVJResponseObject *result = response;
//        if ([result.head.errCode isEqualToString:@"0000"]) {
//            if ([result.body isKindOfClass:[NSDictionary class]]) {
//                weakSelf.bankNumber = [result.body valueForKey:@"bank_account_no"];
//                weakSelf.phone = [result.body valueForKey:@"phone"];
//            }
//        }else{
//            weakSelf.bankNumber = @"获取失败，请重新打开该页面!";
//            weakSelf.phone = @"获取失败，请重新打开该页面!";
//            [MBProgressHUD showError:result.head.errMsg toView:weakSelf.view];
//        }
//
    weakSelf.bankNumber = self.bankModel.accountNo;
    [weakSelf.collectionView reloadData];
//    }];
}
- (void)submitVerify
{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    params[@"bankCard"] = [self getVerifyBankNumTF].text;
    if (self.messageId.length) {
        params[@"messageId"] = self.messageId;
        params[@"validateId"] = self.validateId;
    }
    params[@"used"] = @2;
    if ([self getVerifyPhoneTF]) {
        params[@"phone"] = [self getVerifyPhoneTF].text;
    }
    weakSelf(weakSelf)
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    [BTTHttpManager verifyHumanBankAndPhoneWithParams:params.copy completion:^(id response,NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"验证成功!" toView:nil];
            BTTAddCardController *vc = [[BTTAddCardController alloc] init];
            vc.addCardType = self.safeVerifyType;
            vc.messageId = self.messageId;
            vc.validateId = self.validateId;
            vc.accountId = self.bankModel.accountId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}
@end
