//
//  BTTPasswordChangeController.m
//  Hybird_A01
//
//  Created by Domino on 27/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTPasswordChangeController.h"
#import "BTTPasswordCell.h"
#import "BTTPasswordChangeBtnsCell.h"
#import "BTTHomePageSeparateCell.h"
#import "BTTBindingMobileBtnCell.h"
#import "BTTMeMainModel.h"
#import "IVRsaEncryptWrapper.h"

@interface BTTPasswordChangeController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *sheetDatas;

@end

@implementation BTTPasswordChangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    [self setupCollectionView];
    [self setupElements];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTPasswordCell" bundle:nil] forCellWithReuseIdentifier:@"BTTPasswordCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTPasswordChangeBtnsCell" bundle:nil] forCellWithReuseIdentifier:@"BTTPasswordChangeBtnsCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageSeparateCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageSeparateCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BTTPasswordChangeBtnsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTPasswordChangeBtnsCell" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 1) {
        BTTHomePageSeparateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageSeparateCell" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 4) {
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        weakSelf(weakSelf)
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf submitChange];
        };
        return cell;
    } else {
        BTTPasswordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTPasswordCell" forIndexPath:indexPath];
        [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        BTTMeMainModel *model = self.sheetDatas[indexPath.row - 2];
        cell.model = model;
        return cell;
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
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        if (i == 0) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 48)]];
        } else if (i == 1) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 15)]];
        } else if (i == 4) {
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
    BOOL enabel = ([PublicMethod isValidatePwd:[self getLoginPwd]] && [PublicMethod isValidatePwd:[self getNewPwd]]);
    [self getSubmitBtn].enabled = enabel;
    
}
- (NSString *)getLoginPwd
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    BTTPasswordCell *loginPwdCell = (BTTPasswordCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    NSString *loginPwd = loginPwdCell.textField.text;
    return loginPwd;
}
- (NSString *)getNewPwd
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    BTTPasswordCell *newCell = (BTTPasswordCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    NSString *new = newCell.textField.text;
    return new;
}
- (UIButton *)getSubmitBtn
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    BTTBindingMobileBtnCell *btnsCell = (BTTBindingMobileBtnCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return btnsCell.btn;
}
- (void)submitChange
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    BTTPasswordChangeBtnsCell *btnsCell = (BTTPasswordChangeBtnsCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    BOOL isPT = btnsCell.PTPwdBtn.selected;
    NSString *loginPwd = [self getLoginPwd];
    NSString *new = [self getNewPwd];
    if (![PublicMethod isValidatePwd:loginPwd]) {
        [MBProgressHUD showError:@"输入的登录密码格式有误！"toView:self.view];
        return;
    }
    if (![PublicMethod isValidatePwd:new]) {
        [MBProgressHUD showError:@"输入的新密码格式有误！"toView:self.view];
        return;
    }
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"newPassword"] = [IVRsaEncryptWrapper encryptorString:new];
    params[@"oldPassword"] = [IVRsaEncryptWrapper encryptorString:loginPwd];
    params[@"type"]= isPT ? @2 : @1;
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    weakSelf(weakSelf)
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    [IVNetwork requestPostWithUrl:BTTModifyLoginPwd paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"密码修改成功!" toView:nil];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:weakSelf.view];
        }
    }];
}
- (NSMutableArray *)sheetDatas {
    if (!_sheetDatas) {
        _sheetDatas = [NSMutableArray array];
        NSArray *titles = @[@"登录密码",@"新密码"];
        NSArray  *placeholders = @[@"请输入当前账号密码",@"8-10位字母和数字组合"];
        for (NSString *title in titles) {
            BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
            NSInteger index = [titles indexOfObject:title];
            model.name = title;
            model.iconName = placeholders[index];
            [_sheetDatas addObject:model];
        }
    }
    return _sheetDatas;
}

@end
