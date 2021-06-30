//
//  BTTUserForzenVerityViewController.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/6/30.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTUserForzenVerityViewController.h"
#import "BTTMeMainModel.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTBindingMobileBtnCell.h"
#import "BTTCardInfosController.h"
#import "BTTChangeMobileSuccessController.h"
#import "HAInitConfig.h"
#import "BTTPasswordCell.h"

@interface BTTUserForzenVerityViewController ()<BTTElementsFlowLayoutDelegate>
@property (nonatomic, copy) NSString *withdrawPwdString;
@property (nonatomic, strong) NSMutableArray *sheetDatas;
@end


@implementation BTTUserForzenVerityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"解锁账户";
    self.withdrawPwdString = @"";
    if (!_sheetDatas) {
        _sheetDatas = [NSMutableArray array];
    }
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
- (void)loadMainData {
    NSArray *names = @[@"资金密码"];
    NSArray *placeholders = @[@"6位数数字组合"];
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = placeholders[index];
        [_sheetDatas addObject:model];
    }
    [self setupElements];
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
    } else {
        BTTPasswordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTPasswordCell" forIndexPath:indexPath];
        BTTMeMainModel *model = [BTTMeMainModel new];
        model.name = @"资金密码";
        model.iconName = @"6位数数字组合";
        cell.textField.tag = 1000;
        [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.model = model;
        cell.textField.textAlignment = NSTextAlignmentLeft;
        return cell;
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

}
- (void)textChanged:(UITextField *)textField
{
    if (textField.tag == 1000) {
        self.withdrawPwdString = textField.text;
    }
    BOOL enable = [PublicMethod isValidateWithdrawPwdNumber:self.withdrawPwdString];
    [self getSubmitBtn].enabled = enable;
}
- (UIButton *)getSubmitBtn
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    BTTBindingMobileBtnCell *cell = (BTTBindingMobileBtnCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.btn;
}
- (void)saveBtnClickded:(UIButton *)sender
{
    NSString *url = BTTAddBankCard;
    NSMutableDictionary *params = @{}.mutableCopy;
//    params[@"accountNo"] = [self getSureAddressTF].text;
    params[@"password"] = [IVRsaEncryptWrapper encryptorString:self.withdrawPwdString];
    params[@"accountType"] = @"BTC";
    params[@"expire"] = @0;
//    params[@"messageId"] = self.messageId;
//    params[@"validateId"] = self.validateId;
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:url paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoUserForzenVC" object:nil];
        }else{
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
