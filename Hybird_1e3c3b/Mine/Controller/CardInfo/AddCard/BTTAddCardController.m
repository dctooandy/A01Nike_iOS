//
//  BTTAddCardController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTAddCardController.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTAddCardController+LoadData.h"
#import "BTTMeMainModel.h"
#import "BTTAddCardBtnsCell.h"
#import "BRPickerView.h"
#import "BTTCardInfosController.h"
#import "BTTChangeMobileSuccessController.h"
#import "BTTProvinceModel.h"
#import "HAInitConfig.h"
#import "BTTPasswordCell.h"

@interface BTTAddCardController ()<BTTElementsFlowLayoutDelegate, UITextFieldDelegate>

@property (nonatomic, assign) CGRect activedTextFieldRect;
@property (nonatomic, copy) NSString *withdrawPwdString;

@end

@implementation BTTAddCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.addCardType) {
        case BTTSafeVerifyTypeMobileChangeBankCard:
        case BTTSafeVerifyTypeHumanChangeBankCard:
            self.title = @"修改银行卡";
            break;
        default:
            self.title = @"添加银行卡";
            break;
    }
    self.withdrawPwdString = @"";
    [self setupCollectionView];
    [self loadMainData];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTAddCardBtnsCell" bundle:nil] forCellWithReuseIdentifier:@"BTTAddCardBtnsCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTPasswordCell" bundle:nil] forCellWithReuseIdentifier:@"BTTPasswordCell"];
}

//- (void)keyboardWillShow:(NSNotification *)notification {
//    //取出键盘最终的frame
//    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    //取出键盘弹出需要花费的时间
//    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    //获取最佳位置距离屏幕上方的距离
//    if ((self.activedTextFieldRect.origin.y + self.activedTextFieldRect.size.height) >  ([UIScreen mainScreen].bounds.size.height - rect.size.height)) {//键盘的高度 高于textView的高度 需要滚动
//        [UIView animateWithDuration:duration animations:^{
//            self.collectionView.contentOffset = CGPointMake(0, 64 + self.activedTextFieldRect.origin.y + self.activedTextFieldRect.size.height - ([UIScreen mainScreen].bounds.size.height - rect.size.height));
//        }];
//    }
//}
//
//- (void)keyboardWillHide:(NSNotification *)notify {
//    [UIView animateWithDuration:.25 animations:^{
//        self.collectionView.contentOffset = CGPointMake(0, 0);
//    }];
//}
//
//- (void)keyboardFrameChange:(NSNotification *)notify {
//    NSLog(@"%@",notify.userInfo);
//    //取出键盘最终的frame
//    CGRect rect = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    //取出键盘弹出需要花费的时间
//    double duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    //获取最佳位置距离屏幕上方的距离
//    [UIView animateWithDuration:duration animations:^{
//        self.collectionView.contentOffset = CGPointMake(0, 64 + self.activedTextFieldRect.origin.y + self.activedTextFieldRect.size.height - ([UIScreen mainScreen].bounds.size.height - rect.size.height));
//    }];
//
//}

#pragma mark - textfielddelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activedTextFieldRect = [textField convertRect:textField.frame toView:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    weakSelf(weakSelf)
    if (indexPath.row == self.sheetDatas.count) {
        BTTAddCardBtnsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTAddCardBtnsCell" forIndexPath:indexPath];
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf saveBtnClickded:button];
        };
        return cell;
    } else if (indexPath.row == 7) {
        BTTPasswordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTPasswordCell" forIndexPath:indexPath];
        BTTMeMainModel *model = [BTTMeMainModel new];
        model.name = @"资金密码";
        model.iconName = @"6位数数字组合";
        [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.model = model;
        cell.textField.tag = 1000;
        cell.textField.textAlignment = NSTextAlignmentLeft;
        return cell;
    } else {
        BTTBindingMobileOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileOneCell" forIndexPath:indexPath];
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        cell.textField.delegate = self;
        cell.model = model;
        if (indexPath.row == self.sheetDatas.count - 1) {
            cell.mineSparaterType = BTTMineSparaterTypeNone;
        } else {
            cell.mineSparaterType = BTTMineSparaterTypeSingleLine;
        }
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self.collectionView endEditing:YES];
    BTTBindingMobileOneCell *cell = (BTTBindingMobileOneCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"%zd", indexPath.item);
    if (indexPath.item == 1) {
        NSArray *banks = @[@"招商银行", @"交通银行", @"农业银行", @"工商银行", @"建设银行", @"中国银行", @"民生银行", @"光大银行", @"兴业银行", @"平安银行", @"中信银行", @"浦发银行", @"广发银行", @"华夏银行", @"中国邮政银行", @"深圳发展银行", @"农村信用合作社"];
        [BRStringPickerView showStringPickerWithTitle:@"选择收款银行" dataSource:banks defaultSelValue:cell.textField.text resultBlock:^(id selectValue, NSInteger index) {
            cell.textField.text = selectValue;
        }];
    } else if (indexPath.item == 2) {
        [BRStringPickerView showStringPickerWithTitle:@"卡片类别" dataSource:@[@"借记卡", @"信用卡", @"存折"] defaultSelValue:cell.textField.text resultBlock:^(id selectValue, NSInteger index) {
            cell.textField.text = selectValue;
        }];
    } else if (indexPath.item == 4 || indexPath.item == 5) {
        [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeCity dataSource:nil defaultSelected:nil isAutoSelect:NO themeColor:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
            BTTBindingMobileOneCell *fourCell = (BTTBindingMobileOneCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
            fourCell.textField.text = province.name;
            BTTBindingMobileOneCell *fiveCell = (BTTBindingMobileOneCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
            fiveCell.textField.text = city.name;
        } cancelBlock:^{
            
        }];
    }
}

-(void)textChanged:(UITextField *)textField {
    self.withdrawPwdString = textField.text;
}

- (UITextField *)getCellTextFieldWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    BTTBindingMobileOneCell *cell = (BTTBindingMobileOneCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.textField;
}

- (void)saveBtnClickded:(UIButton *)sender
{
    NSInteger setDefaultCard = [sender.titleLabel.text isEqualToString:@"保存"] ? 0 : 1;
    UITextField *realNameTF = [self getCellTextFieldWithIndex:0];
    UITextField *bankNameTF = [self getCellTextFieldWithIndex:1];
    UITextField *cardTypeTF = [self getCellTextFieldWithIndex:2];
    UITextField *cardNumberTF = [self getCellTextFieldWithIndex:3];
    UITextField *provinceTF = [self getCellTextFieldWithIndex:4];
    UITextField *cityTF = [self getCellTextFieldWithIndex:5];
    UITextField *locationTF = [self getCellTextFieldWithIndex:6];
    NSString *withdrawPwdStr = self.withdrawPwdString;
    if (bankNameTF.text.length == 0) {
        [MBProgressHUD showError:@"请选择开户行" toView:self.view];
        return;
    }
    if (cardTypeTF.text.length == 0) {
        [MBProgressHUD showError:@"请选择卡片类型" toView:self.view];
        return;
    }
    if (![PublicMethod isValidateBankNumber:cardNumberTF.text]) {
        [MBProgressHUD showError:@"银行卡号必须为16-21位数字" toView:self.view];
        return;
    }
    if (provinceTF.text.length == 0) {
        [MBProgressHUD showError:@"请选择开户省份" toView:self.view];
        return;
    }
    if (cityTF.text.length == 0) {
        [MBProgressHUD showError:@"请选择开户城市" toView:self.view];
        return;
    }
    if (locationTF.text.length == 0) {
        [MBProgressHUD showError:@"请填写正确的开户地点" toView:self.view];
        return;
    }
    if (![PublicMethod isValidateWithdrawPwdNumber:withdrawPwdStr]) {
        [MBProgressHUD showError:@"输入的资金密码格式有误" toView:self.view];
        return;
    }
    NSMutableDictionary *params = @{}.mutableCopy;
    
    params[@"accountName"] = realNameTF.text;
    params[@"bankName"] = bankNameTF.text;
    params[@"accountType"] = cardTypeTF.text;
    params[@"accountNo"] = cardNumberTF.text;
    params[@"province"] = provinceTF.text;
    params[@"city"] = cityTF.text;
    params[@"bankBranchName"] = locationTF.text;
    params[@"password"] = [IVRsaEncryptWrapper encryptorString:withdrawPwdStr];
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    params[@"saveDefault"] = @(setDefaultCard);
    
    params[@"smsCode"] = @"";
    if (self.validateId.length) {
        params[@"validateId"] = self.validateId;
        params[@"messageId"] = self.messageId;
    }
    NSString *url = nil;
    NSString *message = nil;
    BOOL isUpdate = NO;
    switch (self.addCardType) {
        case BTTSafeVerifyTypeNormalAddBankCard:
        case BTTSafeVerifyTypeMobileAddBankCard:
        case BTTSafeVerifyTypeMobileBindAddBankCard:
            url = BTTAddBankCard;
            message = @"添加成功!";
            [params setValue:@"0" forKey:@"manual"];
            break;
        case BTTSafeVerifyTypeHumanAddBankCard:
            url = BTTAddBankCard;
            [params setValue:@"1" forKey:@"manual"];
            message = @"添加成功!";
            break;
        case BTTSafeVerifyTypeMobileChangeBankCard:
        case BTTSafeVerifyTypeMobileBindChangeBankCard:
            isUpdate = YES;
            url = BTTModifyBankCard;
            params[@"accountId"] = self.accountId;
            message = @"修改成功!";
            break;
        case BTTSafeVerifyTypeHumanChangeBankCard:
            isUpdate = YES;
            url = BTTModifyBankCard;
            params[@"accountId"] = self.accountId;
            message = @"修改成功!";
            break;
        default:
            break;
    }

    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    [BTTHttpManager updateBankCardWithUrl:url params:params.copy completion:^(id response,NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        IVJResponseObject *result = response;
        weakSelf(weakSelf)
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [IVLAManager singleEventId:@"A01_bankcard_update" errorCode:@"" errorMsg:@"" customsData:@{}];
            [BTTHttpManager fetchBindStatusWithUseCache:NO completionBlock:nil];
            [BTTHttpManager fetchBankListWithUseCache:NO completion:nil];
            BTTChangeMobileSuccessController *vc = [BTTChangeMobileSuccessController new];
            vc.mobileCodeType = self.addCardType;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else {
            if ([result.head.errCode isEqualToString:@"GW_601596"]) {
                IVActionHandler confirm = ^(UIAlertAction *action){
                };
                NSString *title = @"温馨提示";
                NSString *message = @"资金密码错误，请重新输入！";
                [IVUtility showAlertWithActionTitles:@[@"确认"] handlers:@[confirm] title:title message:message];
                return;
            }
            [MBProgressHUD showError:result.head.errMsg toView:weakSelf.view];
        }
    }];
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
