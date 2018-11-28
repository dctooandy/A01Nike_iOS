//
//  BTTBindEmailController.m
//  Hybird_A01
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBindEmailController.h"
#import "BTTBindEmailController+LoadData.h"
#import "BTTMeMainModel.h"
#import "BTTBindingMobileBtnCell.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTBindingMobileTwoCell.h"
#import "BTTChangeMobileSuccessController.h"
@interface BTTBindEmailController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTBindEmailController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.codeType) {
        case BTTSafeVerifyTypeBindEmail:
            self.title = @"绑定邮箱";
            break;
        case BTTSafeVerifyTypeVerifyEmail:
        case BTTSafeVerifyTypeChangeEmail:
            self.title = @"修改邮箱地址";
            break;
        default:
            self.title = @"绑定邮箱";
            break;
    }
    [self setupCollectionView];
    [self loadMainData];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileTwoCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileTwoCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    weakSelf(weakSelf)
    if (indexPath.row == self.sheetDatas.count) {
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf submitBind];
        };
        return cell;
    } else {
        if (indexPath.row == 0) {
            BTTBindingMobileOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileOneCell" forIndexPath:indexPath];
            [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
            [cell.textField addTarget:self action:@selector(textBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
            BTTMeMainModel *model = self.sheetDatas[indexPath.row];
            cell.model = model;
            return cell;
        } else {
            BTTBindingMobileTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileTwoCell" forIndexPath:indexPath];
            [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
            BTTMeMainModel *model = self.sheetDatas[indexPath.row];
            cell.model = model;
            BOOL isUseRegEmail = (![IVNetwork userInfo].isEmailBinded && [IVNetwork userInfo].email.length != 0);
            if (self.codeType == BTTSafeVerifyTypeChangeEmail) {
                cell.sendBtn.enabled = NO;
            } else {
                cell.sendBtn.enabled = isUseRegEmail || [IVNetwork userInfo].isEmailBinded;
            }
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                [weakSelf sendCode];
            };
            return cell;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%zd", indexPath.item);
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
    NSInteger total = self.sheetDatas.count + 1;
    for (int i = 0; i < total; i++) {
        if (i == self.sheetDatas.count) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
        } else {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}
- (void)textBeginEditing:(UITextField *)textField
{
    if (textField == [self getMailTF]) {
        if (![IVNetwork userInfo].isEmailBinded && [IVNetwork userInfo].email.length != 0) {
            textField.text = @"";
            [self getSendBtn].enabled = NO;
            [self getSubmitBtn].enabled = NO;
        }
    }
}
- (void)textChanged:(UITextField *)textField
{
    if (textField == [self getMailTF]) {
        [self getSendBtn].enabled = [PublicMethod isValidateEmail:[self getMailTF].text];
    }
    if ([self getCodeTF].text.length == 0) {
        [self getSubmitBtn].enabled = NO;
    } else {
        if ([IVNetwork userInfo].isEmailBinded) {
            [self getSubmitBtn].enabled = YES;
        } else {
            if ([[self getMailTF].text isEqualToString:[IVNetwork userInfo].email]) {
                [self getSubmitBtn].enabled = YES;
            } else {
                [self getSubmitBtn].enabled = [PublicMethod isValidateEmail:[self getMailTF].text];
            }
        }
    }
}
- (UITextField *)getMailTF
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
    return [self getVerifyCell].sendBtn;
}
- (BTTBindingMobileTwoCell *)getVerifyCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    BTTBindingMobileTwoCell *cell = (BTTBindingMobileTwoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell;
}
- (void)sendCode
{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"2";
    params[@"send_to"] = [self getMailTF].text;
    switch (self.codeType) {
        case BTTSafeVerifyTypeBindEmail:
            params[@"v_type"] = @"2";
            break;
        case BTTSafeVerifyTypeVerifyEmail:
        case BTTSafeVerifyTypeChangeEmail:
            params[@"v_type"] = @"4";
            break;
        default:
            params[@"v_type"] = @"2";
            break;
    }
    weakSelf(weakSelf)
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    [IVNetwork sendRequestWithSubURL:@"verify/send" paramters:params.copy completionBlock:^(IVRequestResultModel *result, id response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (result.status) {
            [[weakSelf getVerifyCell] countDown];
        } else {
            [MBProgressHUD showError:result.message toView:weakSelf.view];
        }
    }];
}
- (void)submitBind
{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"2";
    params[@"send_to"] = [self getMailTF].text;
    params[@"code"] = [self getCodeTF].text;
    NSString *successStr = nil;
    switch (self.codeType) {
        case BTTSafeVerifyTypeBindEmail:
            params[@"v_type"] = @"2";
            break;
        case BTTSafeVerifyTypeVerifyEmail:
            params[@"v_type"] = @"4";
            successStr = @"验证成功!";
            break;
        case BTTSafeVerifyTypeChangeEmail:
            params[@"v_type"] = @"4";
            break;
        default:
            params[@"v_type"] = @"4";
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
            NSString *email = result.data[@"val"];
            [IVNetwork updateUserInfo:@{@"email" : email}];
            [BTTHttpManager fetchBindStatusWithUseCache:YES completionBlock:nil];
            switch (self.codeType) {
                case BTTSafeVerifyTypeBindEmail:
                case BTTSafeVerifyTypeChangeEmail:
                {
                    BTTChangeMobileSuccessController *vc = [BTTChangeMobileSuccessController new];
                    vc.mobileCodeType = self.codeType;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case BTTSafeVerifyTypeVerifyEmail:{
                    BTTBindEmailController *vc = [BTTBindEmailController new];
                    vc.codeType = BTTSafeVerifyTypeChangeEmail;
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
