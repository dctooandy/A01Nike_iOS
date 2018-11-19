//
//  BTTBindingMobileController.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBindingMobileController.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTBindingMobileTwoCell.h"
#import "BTTBindingMobileBtnCell.h"
#import "BTTBindingMobileController+LoadData.h"
#import "BTTMeMainModel.h"
#import "BTTCardModifyVerifyController.h"
#import "BTTAddCardController.h"
#import "BTTAddBTCController.h"

@interface BTTBindingMobileController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTBindingMobileController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.mobileCodeType) {
        case BTTMobileCodeTypeBindMobile:
            self.title = @"绑定手机";
            break;
        case BTTMobileCodeTypeVerifyMobile:
        case BTTMobileCodeTypeChangeMobile:
            self.title = @"更换手机";
            break;
        default:
            self.title = @"安全验证";
            break;
    }
    [self setupCollectionView];
    [self loadMianData];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileTwoCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileTwoCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    weakSelf(weakSelf)
    if (indexPath.row == 0) {
        BTTBindingMobileOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileOneCell" forIndexPath:indexPath];
        [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        cell.model = model;
        return cell;
    } else if (indexPath.row == 1) {
        BTTBindingMobileTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileTwoCell" forIndexPath:indexPath];
        [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        cell.model = model;
        cell.sendBtn.enabled = [IVNetwork userInfo].isPhoneBinded;
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf sendCode];
        };
        return cell;
    } else {
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf submitBind];
        };
        return cell;
    }
   
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self.collectionView endEditing:YES];
    NSLog(@"%zd", indexPath.item);
    if (indexPath.item == 2) {
        if (self.mobileCodeType == BTTMobileCodeTypeUpdateBankCard) {
            BTTCardModifyVerifyController *vc = [[BTTCardModifyVerifyController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            if (self.mobileCodeType == BTTMobileCodeTypeAddBankCard) {
                BTTAddCardController *vc = [[BTTAddCardController alloc] init];
                vc.addCardType = BTTAddCardTypeNew;
                [self.navigationController pushViewController:vc animated:YES];
            } else if (self.mobileCodeType == BTTMobileCodeTypeAddBTC) {
                BTTAddBTCController *vc = [[BTTAddBTCController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
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
    for (int i = 0; i < 3; i++) {
        if (i == 0 || i == 1) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
        } else {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
        }
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}
- (void)textChanged:(UITextField *)textField
{
    if (textField == [self getPhoneTF]) {
        [self getSendBtn].enabled = [PublicMethod isValidatePhone:[self getPhoneTF].text];
    }
    if ([self getCodeTF].text.length == 0) {
        [self getSubmitBtn].enabled = NO;
    } else {
        if ([IVNetwork userInfo].isPhoneBinded) {
            [self getSubmitBtn].enabled = YES;
        } else {
            [self getSubmitBtn].enabled = [PublicMethod isValidatePhone:[self getPhoneTF].text];
        }
    }
}
- (UITextField *)getPhoneTF
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    BTTBindingMobileOneCell *cell = (BTTBindingMobileOneCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.textField;
}
- (UITextField *)getCodeTF
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    BTTBindingMobileTwoCell *cell = (BTTBindingMobileTwoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.textField;
}
- (UIButton *)getSubmitBtn
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    BTTBindingMobileBtnCell *cell = (BTTBindingMobileBtnCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.btn;
}
- (UIButton *)getSendBtn
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    BTTBindingMobileTwoCell *cell = (BTTBindingMobileTwoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.sendBtn;
}
- (void)sendCode
{
    if (![IVNetwork userInfo].isPhoneBinded && ![PublicMethod isValidatePhone:[self getPhoneTF].text]) {
        [MBProgressHUD showError:@"请输入正确的手机号" toView:self.view];
        return;
    }
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"1";
    params[@"send_to"] = [self getPhoneTF].text;
    switch (self.mobileCodeType) {
        case BTTMobileCodeTypeBindMobile:
            params[@"v_type"] = @"1";
            break;
        case BTTMobileCodeTypeVerifyMobile:
        case BTTMobileCodeTypeChangeMobile:
            params[@"v_type"] = @"3";
            break;
        default:
            params[@"v_type"] = @"1";
            break;
    }
    [IVNetwork sendRequestWithSubURL:@"verify/send" paramters:params.copy completionBlock:nil];
}
- (void)submitBind
{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"1";
    params[@"send_to"] = [self getPhoneTF].text;
    params[@"code"] = [self getCodeTF].text;
    NSString *successStr = nil;
    switch (self.mobileCodeType) {
        case BTTMobileCodeTypeBindMobile:
            params[@"v_type"] = @"1";
            successStr = @"绑定成功!";
            break;
        case BTTMobileCodeTypeVerifyMobile:
            params[@"v_type"] = @"3";
            break;
        case BTTMobileCodeTypeChangeMobile:
            params[@"v_type"] = @"3";
            successStr = @"修改成功!";
            break;
        default:
            params[@"v_type"] = @"1";
            successStr = @"绑定成功!";
            break;
    }
    weakSelf(weakSelf)
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    [IVNetwork sendRequestWithSubURL:@"A01/verify/newBind" paramters:params.copy completionBlock:^(IVRequestResultModel *result, id response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        if (result.status && result.data && [result.data isKindOfClass:[NSDictionary class]] && [result.data valueForKey:@"val"]) {
            if (successStr) {
                [MBProgressHUD showSuccess:successStr toView:nil];
            }
            NSString *phone = result.data[@"val"];
            [IVNetwork updateUserInfo:@{@"phone" : phone,@"isPhoneBinded" : @(YES)}];
            switch (self.mobileCodeType) {
                case BTTMobileCodeTypeBindMobile:
                case BTTMobileCodeTypeChangeMobile:
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    break;
                case BTTMobileCodeTypeVerifyMobile:{
                    BTTBindingMobileController *vc = [BTTBindingMobileController new];
                    vc.mobileCodeType = BTTMobileCodeTypeChangeMobile;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
        } else {
            [MBProgressHUD showError:result.message toView:weakSelf.view];
        }
    }];
}
- (void)goToBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
