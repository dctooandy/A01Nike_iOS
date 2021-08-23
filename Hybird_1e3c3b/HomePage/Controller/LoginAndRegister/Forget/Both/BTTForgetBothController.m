//
//  BTTForgetBothController.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/12/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTForgetBothController.h"
#import "BTTForgetBothController+LoadData.h"
#import "BTTForgetBothController+Nav.h"
#import "BTTForgetPwdOneCell.h"
#import "BTTBindingMobileBtnCell.h"

@interface BTTForgetBothController ()<BTTElementsFlowLayoutDelegate,UITextFieldDelegate>
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *code;
@end

@implementation BTTForgetBothController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.findType == BTTFindWithPhone ? @"使用手机号找回账号, 密码":@"使用邮箱找回账号, 密码";
    [self setupCollectionView];
    [self setUpNav];
    [self loadMainData];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTForgetPwdOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTForgetPwdOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTForgetPwdPhoneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTForgetPwdPhoneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.elementsHight.count - 1) {
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        cell.buttonType = BTTButtonTypeConfirm;
        weakSelf(weakSelf);
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf);
            [strongSelf.view endEditing:true];
            [strongSelf checkCustomerBySmsCode:self.code];
        };
        return cell;
    } else if (indexPath.row == self.elementsHight.count - 2) {
        BTTMeMainModel *model = self.mainData[indexPath.row];
        BTTForgetPwdPhoneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTForgetPwdPhoneCell" forIndexPath:indexPath];
        [cell.detailTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        cell.detailTextField.delegate = self;
        cell.model = model;
        [cell.sendSmsBtn addTarget:self action:@selector(sendSmsBtnAction) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {
        BTTMeMainModel *model = self.mainData[indexPath.row];
        BTTForgetPwdOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTForgetPwdOneCell" forIndexPath:indexPath];
        cell.detailTextField.delegate = self;
        cell.detailTextField.tag = 30010 + indexPath.row;
        [cell.detailTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
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
    return UIEdgeInsetsMake(30, 20, 0, 0);
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
    return 20;
}

-(BTTForgetPwdPhoneCell *)getForgetPhoneCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.elementsHight.count - 2 inSection:0];
    BTTForgetPwdPhoneCell *cell = (BTTForgetPwdPhoneCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell;
}

-(void)sendSmsBtnAction {
    [self.view endEditing:YES];
    if (![PublicMethod isValidatePhone:self.phone]) {
        [MBProgressHUD showError:@"请输入正确的手机号" toView:nil];
        return;
    }
    [self sendCodeByPhone:self.phone];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldChange:(UITextField *)textField {
    NSLog(@"%@",textField.text);
    if (textField.tag == 30010) {
        textField.text = [textField.text lowercaseString];
        self.phone = textField.text;
        
    } else if (textField.tag == 30012) {
        self.code = textField.text;
    }
    BOOL isPhone = self.findType == BTTFindWithPhone ? [PublicMethod isValidatePhone:self.phone]:[PublicMethod isValidateEmail:self.phone];
    if (self.code.length >= 4 && isPhone) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BTTVerifyCodeEnableNotification object:@"verifycode"];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:BTTVerifyCodeDisableNotification object:@"verifycode"];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 30010) {
        if (textField.text.length >= 11 && string.length > 0 && self.findType == BTTFindWithPhone) {
            return false;
        }
    }
    return YES;
}

- (void)setupElements {
    if (self.elementsHight.count) {
        [self.elementsHight removeAllObjects];
    }
    NSMutableArray *elementsHight = [NSMutableArray array];
    NSInteger count = self.mainData.count + 1;
    for (int i = 0; i < count; i++) {
        if (i == count - 1) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH - 10, 100)]];
        } else {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH - 40, 44)]];
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

@end
