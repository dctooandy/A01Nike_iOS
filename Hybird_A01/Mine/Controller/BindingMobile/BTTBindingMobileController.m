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
    if (self.mobileCodeType == BTTMobileCodeTypeBindMobile) {
        self.title = @"绑定手机";
    } else {
        self.title = @"安全验证";
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
        if (self.mobileCodeType == BTTMobileCodeTypeVerifyMobileUpdate) {
            BTTCardModifyVerifyController *vc = [[BTTCardModifyVerifyController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            if (self.mobileCodeType == BTTMobileCodeTypeVerifyMobileAddBankCard) {
                BTTAddCardController *vc = [[BTTAddCardController alloc] init];
                vc.addCardType = BTTAddCardTypeNew;
                [self.navigationController pushViewController:vc animated:YES];
            } else if (self.mobileCodeType == BTTMobileCodeTypeVerifyMobileAddBTC) {
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
    [self getSubmitBtn].enabled = ([PublicMethod isValidatePhone:[self getPhoneTF].text] && ([self getCodeTF].text.length != 0));
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
    if (![PublicMethod isValidatePhone:[self getPhoneTF].text]) {
        [MBProgressHUD showError:@"请输入正确的手机号" toView:self.view];
        return;
    }
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"1";
    params[@"v_type"] = @"1";
    params[@"send_to"] = [self getPhoneTF].text;
    [IVNetwork sendRequestWithSubURL:@"verify/send" paramters:params.copy completionBlock:nil];
}
- (void)submitBind
{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = @"1";
    params[@"v_type"] = @"1";
    params[@"send_to"] = [self getPhoneTF].text;
    params[@"code"] = [self getCodeTF].text;
    weakSelf(weakSelf)
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    [IVNetwork sendRequestWithSubURL:@"A01/verify/newBind" paramters:params.copy completionBlock:^(IVRequestResultModel *result, id response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (result.status && result.data && [result.data isKindOfClass:[NSDictionary class]] && [result.data valueForKey:@"val"]) {
            [MBProgressHUD showSuccess:@"绑定成功!" toView:nil];
            NSString *phone = result.data[@"val"];
            IVUserInfoModel *userInfo = [[IVUserInfoModel alloc] initWithDictionary:@{@"phone" : phone} error:nil];
            [IVNetwork updateUserInfo:userInfo];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:result.message toView:weakSelf.view];
        }
    }];
}

@end
