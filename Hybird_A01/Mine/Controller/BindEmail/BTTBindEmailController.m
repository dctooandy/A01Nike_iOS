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

@interface BTTBindEmailController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTBindEmailController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.codeType) {
        case BTTEmmailCodeTypeBind:
            self.title = @"绑定邮箱";
            break;
        case BTTEmmailCodeTypeVerify:
        case BTTEmmailCodeTypeChange:
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
            BTTMeMainModel *model = self.sheetDatas[indexPath.row];
            cell.model = model;
            return cell;
        } else {
            BTTBindingMobileTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileTwoCell" forIndexPath:indexPath];
            [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
            BTTMeMainModel *model = self.sheetDatas[indexPath.row];
            cell.model = model;
            cell.sendBtn.enabled = [IVNetwork userInfo].isEmailBinded;
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
- (void)textChanged:(UITextField *)textField
{
    if (textField == [self getMailTF]) {
        [self getSendBtn].enabled = [PublicMethod isValidateEmail:[self getMailTF].text];
    }
    if ([self getCodeTF].text.length == 0) {
        [self getSubmitBtn].enabled = NO;
    } else {
        if ([IVNetwork userInfo].isPhoneBinded) {
            [self getSubmitBtn].enabled = YES;
        } else {
            [self getSubmitBtn].enabled = [PublicMethod isValidateEmail:[self getMailTF].text];
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    BTTBindingMobileTwoCell *cell = (BTTBindingMobileTwoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.sendBtn;
}
- (void)sendCode
{
    if (![IVNetwork userInfo].isPhoneBinded && ![PublicMethod isValidateEmail:[self getMailTF].text]) {
        [MBProgressHUD showError:@"请输入正确的邮箱地址" toView:self.view];
        return;
    }
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"2";
    params[@"send_to"] = [self getMailTF].text;
    switch (self.codeType) {
        case BTTEmmailCodeTypeBind:
            params[@"v_type"] = @"2";
            break;
        case BTTEmmailCodeTypeVerify:
        case BTTEmmailCodeTypeChange:
            params[@"v_type"] = @"4";
            break;
        default:
            params[@"v_type"] = @"2";
            break;
    }
    [IVNetwork sendRequestWithSubURL:@"verify/send" paramters:params.copy completionBlock:nil];
}
- (void)submitBind
{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"2";
    params[@"send_to"] = [self getMailTF].text;
    params[@"code"] = [self getCodeTF].text;
    NSString *successStr = nil;
    switch (self.codeType) {
        case BTTEmmailCodeTypeBind:
            params[@"v_type"] = @"2";
            successStr = @"绑定成功!";
            break;
        case BTTEmmailCodeTypeVerify:
            params[@"v_type"] = @"4";
            break;
        case BTTEmmailCodeTypeChange:
            params[@"v_type"] = @"4";
            successStr = @"修改成功!";
            break;
        default:
            params[@"v_type"] = @"4";
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
            NSString *email = result.data[@"val"];
            [IVNetwork updateUserInfo:@{@"email" : email,@"isEmailBinded" : @(YES)}];
            switch (self.codeType) {
                case BTTEmmailCodeTypeBind:
                case BTTEmmailCodeTypeChange:
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    break;
                case BTTEmmailCodeTypeVerify:{
                    BTTBindEmailController *vc = [BTTBindEmailController new];
                    vc.codeType = BTTEmmailCodeTypeChange;
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
