//
//  BTTChangeMobileManualController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 19/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTChangeMobileManualController.h"
#import "BTTChangeMobileManualController+LoadData.h"
#import "BTTCardModifyTitleCell.h"
#import "BTTCardModifyCell.h"
#import "BTTBindingMobileBtnCell.h"
#import "BTTMeMainModel.h"
#import "BTTChangeMobileNextController.h"
#import "BTTCardInfosController.h"
@interface BTTChangeMobileManualController ()<BTTElementsFlowLayoutDelegate>
@property(nonatomic, copy)NSString *bankNumber;
@property(nonatomic, copy)NSString *phone;
@end

@implementation BTTChangeMobileManualController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"人工服务";
    [self setupCollectionView];
    [self loadMainData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    if (indexPath.row == 0 || indexPath.row == 2) {
        BTTCardModifyTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTCardModifyTitleCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.titleLabel.text = [NSString stringWithFormat:@"请输入%@的完整号码",self.phone];
        } else {
            if ([NSString isBlankString:self.bankNumber]) {
                NSString *str = @"请先  绑定银行卡";
                //创建NSMutableAttributedString
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
                //添加文字颜色
                [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(4, 5)];
                cell.titleLabel.attributedText = attrStr;
            } else {
                cell.titleLabel.text = [NSString stringWithFormat:@"请输入%@的完整银行卡号",self.bankNumber];
            }
        }
        return cell;
    } else if (indexPath.row == 1 || indexPath.row == 3) {
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        BTTCardModifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTCardModifyCell" forIndexPath:indexPath];
        if (indexPath.row == 1) {
            cell.textField.placeholder = model.name;
            cell.textField.userInteractionEnabled = YES;
        } else {
            cell.textField.text = @"";
            cell.textField.placeholder = model.name;
            cell.textField.userInteractionEnabled = YES;
        }
        [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2 && self.bankNumber.length == 0) {
        BTTCardInfosController *cardInfoVC = [BTTCardInfosController new];
        [self.navigationController pushViewController:cardInfoVC animated:YES];
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
    NSMutableArray *elementsHight = [NSMutableArray array];
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
    BOOL enable = [PublicMethod isValidateBankNumber:[self getVerifyBankNumTF].text] &&
                  [PublicMethod isValidatePhone:[self getVerifyPhoneTF].text];
    [self getSubmitBtn].enabled = enable;
}
- (UITextField *)getVerifyPhoneTF
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    BTTCardModifyCell *cell = (BTTCardModifyCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.textField;
}
- (UITextField *)getVerifyBankNumTF
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    BTTCardModifyCell *cell = (BTTCardModifyCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.textField;
}
- (UIButton *)getSubmitBtn
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    BTTBindingMobileBtnCell *cell = (BTTBindingMobileBtnCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.btn;
}
- (void)fetchHumanBankAndPhone
{
    weakSelf(weakSelf)
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    [BTTHttpManager fetchHumanBankAndPhoneWithBankId:nil Completion:^(IVRequestResultModel *result, id response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (result.data && [result.data isKindOfClass:[NSDictionary class]]) {
            weakSelf.bankNumber = [result.data valueForKey:@"bank_account_no"];
            weakSelf.phone = [result.data valueForKey:@"phone"];
        } else {
            [MBProgressHUD showError:result.message toView:weakSelf.view];
        }
        [weakSelf.collectionView reloadData];
    }];
}
- (void)submitVerify
{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"login_name"] = [IVNetwork savedUserInfo].loginName;
    params[@"bank_account_no"] = [self getVerifyBankNumTF].text;
    params[@"phone"] = [self getVerifyPhoneTF].text;
    weakSelf(weakSelf)
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    [BTTHttpManager verifyHumanBankAndPhoneWithParams:params.copy completion:^(IVRequestResultModel *result, id response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (result.status) {
            [MBProgressHUD showSuccess:@"验证成功!" toView:nil];
            BTTChangeMobileNextController *vc = [[BTTChangeMobileNextController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showError:result.message toView:nil];
        }
    }];
}

@end
