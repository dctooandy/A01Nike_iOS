//
//  BTTNotCompleteInfoController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 23/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTNotCompleteInfoController.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTNotCompleteInfoController+LoadData.h"
#import "BTTBindingMobileBtnCell.h"
#import "BTTMeMainModel.h"
#import "BTTCardInfosController.h"

@interface BTTNotCompleteInfoController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTNotCompleteInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    [self setupCollectionView];
    [self loadMainData];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    [self setupHeaderLabel];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
}

- (void)setupHeaderLabel {
    UILabel *noticeLabel = [UILabel new];
    [self.collectionView addSubview:noticeLabel];
    noticeLabel.frame = CGRectMake(15, 0, SCREEN_WIDTH - 30, 44);
    noticeLabel.font = kFontSystem(12);
    noticeLabel.textColor = [UIColor colorWithHexString:@"FFCC99"];
    noticeLabel.text = @"为了您的取款的安全性及优惠的及时添加, 请先完善个人信息";
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.elementsHight.count - 1) {
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        weakSelf(weakSelf)
        cell.buttonType = BTTButtonTypeSave;
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf submitChange];
        };
        return cell;
    } else {
        BTTBindingMobileOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileOneCell" forIndexPath:indexPath];
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        cell.model = model;
        cell.textField.text = [IVNetwork savedUserInfo].realName;
        if (cell.textField.text.length > 0) {
            [cell.textField setEnabled:false];
        } else {
            [cell.textField setEnabled:true];
            [cell.textField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
        }
        return cell;
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
    return UIEdgeInsetsMake(44, 0, 40, 0);
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
    NSInteger count = self.sheetDatas.count + 1;
    for (int i = 0; i < count; i++) {
        if (i == count - 1) {
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

- (void)textChanged
{
    UITextField *realNameTF = [self getCellTextFieldWithIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.elementsHight.count - 1 inSection:0];
    BTTBindingMobileBtnCell *cell = (BTTBindingMobileBtnCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.btn.enabled = [PublicMethod checkRealName:realNameTF.text];
}
- (void)submitChange
{
    UITextField *realNameTF = [self getCellTextFieldWithIndex:0];
    weakSelf(weakSelf)
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    if ([IVNetwork savedUserInfo].realName.length == 0) {
        params[@"realName"] = realNameTF.text;
    }
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    [IVNetwork requestPostWithUrl:BTTModifyCustomerInfo paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"完善成功!" toView:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:self.view];
        }
    }];
}
- (UITextField *)getCellTextFieldWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    BTTBindingMobileOneCell *cell = (BTTBindingMobileOneCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.textField;
}
@end
