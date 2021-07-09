//
//  BTTUserForzenVerityViewController.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/6/30.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTUserForzenVerityViewController.h"
#import "BTTUserForzenVerityViewController+LoadData.h"
#import "BTTMeMainModel.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTBindingMobileBtnCell.h"
#import "BTTCardInfosController.h"
#import "BTTChangeMobileSuccessController.h"
#import "HAInitConfig.h"
#import "BTTPasswordCell.h"
#import "BTTUserForzenManager.h"
#import "BTTUserForzenBGView.h"

@interface BTTUserForzenVerityViewController ()<BTTElementsFlowLayoutDelegate>
@property (nonatomic, copy) NSString *withdrawPwdString;
@property (nonatomic, copy) NSString *sCodeString;
@property (nonatomic, strong) NSMutableArray *sheetDatas;
@property (nonatomic, assign) BOOL isSuccess;
@end


@implementation BTTUserForzenVerityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"解锁账户";
    self.withdrawPwdString = @"";
    self.sCodeString = @"";
    if (!_sheetDatas) {
        _sheetDatas = [NSMutableArray array];
    }
    [self setupCollectionView];
    [self setupBackGroundView];
    [self loadMainData];
    _isSuccess = NO;
}
- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileTwoCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileTwoCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTPasswordCell" bundle:nil] forCellWithReuseIdentifier:@"BTTPasswordCell"];
}
- (void)setupBackGroundView
{
    BTTUserForzenBGView *bgView = [BTTUserForzenBGView viewFromXib];
    [bgView setupViewController:self];
    [self.collectionView setBackgroundView:bgView];
    [[self.collectionView backgroundView] setHidden:YES];
}
- (void)loadMainData {
    NSArray *names = @[@"已绑定手机",@"验证码",@"资金密码"];
    NSArray *placeholders = @[@"请输入待绑定手机号码",@"请输入验证码",@"6位数数字组合"];
    NSString * phone = [IVNetwork savedUserInfo].mobileNo;
    NSArray *phoneValues = @[phone,@"",@""];
    
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = placeholders[index];
        model.desc = phoneValues[index];
        [_sheetDatas addObject:model];
    }
    [self setupElements];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isSuccess == NO)
    {
        return self.elementsHight.count;
    }else
    {
        return 0;
    }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    weakSelf(weakSelf)
    if (indexPath.row == 0) {
        BTTBindingMobileOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileOneCell" forIndexPath:indexPath];
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        cell.model = model;
        return cell;
    } else if (indexPath.row == 1) {
        BTTBindingMobileTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileTwoCell" forIndexPath:indexPath];
        [cell.textField setEnabled:false];
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        cell.model = model;
        cell.textField.tag = 1001;
        [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf sendCode];
        };
        return cell;
    } else if (indexPath.row == 2)
    {
        BTTPasswordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTPasswordCell" forIndexPath:indexPath];
        [cell disableSecureText:YES withTextAlign:NSTextAlignmentRight];
        BTTMeMainModel *model = [BTTMeMainModel new];
        model.name = @"资金密码";
        model.iconName = @"请输入资金密码";
        cell.textField.tag = 1000;
        [cell.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.model = model;
        cell.textField.textAlignment = NSTextAlignmentLeft;
        return cell;
    }else{
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        [cell setButtonType:BTTButtonTypeUserForzen];
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf saveBtnClickded:button];
        };
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
    if (textField.tag == 1001) {
        self.sCodeString = textField.text;
    }
    BOOL withDrawalEnable = [PublicMethod isValidateWithdrawPwdNumber:self.withdrawPwdString];
    BOOL messageIDEnable = !(self.messageId==nil || [self.messageId isEqualToString:@""]);
    BOOL sCodeEnable = !(self.sCodeString==nil || [self.sCodeString isEqualToString:@""]);
    
    [self getSubmitBtn].enabled = (withDrawalEnable && messageIDEnable && sCodeEnable);
}
- (UIButton *)getSubmitBtn
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    BTTBindingMobileBtnCell *cell = (BTTBindingMobileBtnCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.btn;
}
- (void)saveBtnClickded:(UIButton *)sender
{
    weakSelf(weakSelf)
    [[BTTUserForzenManager sharedInstance] unBindUserForzenAccount:[IVRsaEncryptWrapper encryptorString:self.withdrawPwdString] withMessageID:self.messageId withSCode:self.sCodeString completionBlock:^(NSString * _Nullable response, NSString * _Nullable error) {
        if (error)
        {
            
        }else
        {
            [weakSelf successActions:response];
        }
    }] ;

    // 测试
//    [self successActions];
}
- (void)successActions:(NSString *)msgString
{
    [MBProgressHUD showMessagNoActivity:msgString toView:nil];
    _isSuccess = YES;
    [[self.collectionView backgroundView] setHidden:NO];
    [self setupElements];
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
//    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
//    });
}


-(UITextField *)getCodeTF {
    return [self getVerifyCell].textField;
}
- (BTTBindingMobileTwoCell *)getVerifyCell {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    BTTBindingMobileTwoCell *cell = (BTTBindingMobileTwoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell;
}

@end
