//
//  BTTAddBTCController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTAddBTCController.h"
#import "BTTAddBTCController+LoadData.h"
#import "BTTMeMainModel.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTBindingMobileBtnCell.h"
#import "BTTCardInfosController.h"
#import "BTTChangeMobileSuccessController.h"
#import "HAInitConfig.h"
#import "BTTPasswordCell.h"

@interface BTTAddBTCController ()<BTTElementsFlowLayoutDelegate>
@property (nonatomic, copy) NSString *withdrawPwdString;
@end

@implementation BTTAddBTCController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加比特币钱包";
    self.withdrawPwdString = @"";
    [self setupCollectionView];
    [self loadMainData];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTPasswordCell" bundle:nil] forCellWithReuseIdentifier:@"BTTPasswordCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    weakSelf(weakSelf)
    if (indexPath.row == self.sheetDatas.count) {
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf saveBtnClickded:button];
        };
        return cell;
    } else if (indexPath.row == 2) {
        BTTPasswordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTPasswordCell" forIndexPath:indexPath];
        BTTMeMainModel *model = [BTTMeMainModel new];
        model.name = @"资金密码";
        model.iconName = @"6位数数字组合";
        cell.textField.tag = 1001;
        [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.model = model;
        cell.textField.textAlignment = NSTextAlignmentLeft;
        return cell;
    } else {
        BTTBindingMobileOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileOneCell" forIndexPath:indexPath];
        cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        cell.model = model;
        if (indexPath.row == self.sheetDatas.count - 1) {
            cell.mineSparaterType = BTTMineSparaterTypeNone;
        } else {
            cell.mineSparaterType = BTTMineSparaterTypeSingleLine;
        }
        [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

}

- (void)textChanged:(UITextField *)textField
{
    if (textField.tag == 1001) {
        self.withdrawPwdString = textField.text;
    }
    BOOL enable = [PublicMethod checkBitcoinAddress:[self getAddressTF].text] && [PublicMethod checkBitcoinAddress:[self getSureAddressTF].text]
    && [[self getAddressTF].text isEqualToString:[self getSureAddressTF].text] && [PublicMethod isValidateWithdrawPwdNumber:self.withdrawPwdString];
    [self getSubmitBtn].enabled = enable;
}

- (UITextField *)getAddressTF
{
    return [self getCellTextFieldWithIndex:0];
}

- (UITextField *)getSureAddressTF
{
    return [self getCellTextFieldWithIndex:1];
}

- (UITextField *)getCellTextFieldWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    BTTBindingMobileOneCell *cell = (BTTBindingMobileOneCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.textField;
}

- (UIButton *)getSubmitBtn
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    BTTBindingMobileBtnCell *cell = (BTTBindingMobileBtnCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.btn;
}

- (void)saveBtnClickded:(UIButton *)sender
{
    NSString *url = BTTAddBankCard;
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"accountNo"] = [self getSureAddressTF].text;
    params[@"password"] = [IVRsaEncryptWrapper encryptorString:self.withdrawPwdString];
    params[@"accountType"] = @"BTC";
    params[@"expire"] = @0;
    params[@"messageId"] = self.messageId;
    params[@"validateId"] = self.validateId;
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:url paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [IVLAManager singleEventId:@"A01_bankcard_update" errorCode:@"" errorMsg:@"" customsData:@{}];

            [BTTHttpManager fetchBankListWithUseCache:NO completion:^(id  _Nullable response, NSError * _Nullable error) {
                if ([IVNetwork savedUserInfo].bankCardNum > 0 || [IVNetwork savedUserInfo].usdtNum > 0||[IVNetwork savedUserInfo].bfbNum>0||[IVNetwork savedUserInfo].dcboxNum>0) {
                    BTTChangeMobileSuccessController *vc = [BTTChangeMobileSuccessController new];
                    vc.mobileCodeType = self.addCardType;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                } else {
                    [self.navigationController popToRootViewControllerAnimated:true];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoCardInfoNotification" object:@{@"showAlert":[NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults]boolForKey:@"pressWithdrawAddUSDTCard"]]}];
                }
            }];
        }else{
            if ([result.head.errCode isEqualToString:@"GW_601596"]) {
                IVActionHandler confirm = ^(UIAlertAction *action){
                    [self goToBack];
                };
                NSString *title = @"温馨提示";
                NSString *message = @"密码错误，请重新添加比特币钱包资料";
                [IVUtility showAlertWithActionTitles:@[@"确认"] handlers:@[confirm] title:title message:message];
                return;
            }
            [MBProgressHUD showError:result.head.errMsg toView:weakSelf.view];
        }
    }];
}

- (void)goToBack
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[BTTCardInfosController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
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
    return UIEdgeInsetsMake(15, 0, 40, 0);
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

@end
