//
//  BTTForgetPasswordStepThreeController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 15/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTForgetPasswordStepThreeController.h"
#import "BTTForgetPasswordStepThreeController+LoadData.h"
#import "BTTForgetPwdOneCell.h"
#import "BTTBindingMobileBtnCell.h"

@interface BTTForgetPasswordStepThreeController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, copy) NSString *againPwd;

@end

@implementation BTTForgetPasswordStepThreeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    [self setupCollectionView];
    [self loadMainData];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTForgetPwdOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTForgetPwdOneCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.elementsHight.count - 1) {
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        cell.buttonType = BTTButtonTypeDone;
        weakSelf(weakSelf);
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf);
            [strongSelf modifyPasswordWithPwd:strongSelf.pwd account:strongSelf.account validateId:strongSelf.validateId messageId:self.messageId];
        };
        return cell;
    } else {
        BTTMeMainModel *model = self.mainData[indexPath.row];
        BTTForgetPwdOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTForgetPwdOneCell" forIndexPath:indexPath];
        cell.showPwdBtn.hidden = false;
        cell.detailTextField.secureTextEntry = true;
        [cell.detailTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        cell.detailTextField.tag = indexPath.row;
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

#pragma mark - textfielddelegate

- (void)textFieldChange:(UITextField *)textField {
    if (textField.tag == 0) {
        self.pwd = textField.text;
    } else {
        self.againPwd = textField.text;
    }
    NSString *pwdregex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9a-zA-Z]{8,10}$";
    NSPredicate *pwdpredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdregex];
    BOOL ispwd = [pwdpredicate evaluateWithObject:self.pwd];
    BOOL isSame = [self.pwd isEqualToString:self.againPwd];
    if (ispwd && isSame) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BTTVerifyCodeEnableNotification object:@"verifycode"];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:BTTVerifyCodeDisableNotification object:@"verifycode"];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
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
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH - 40, 100)]];
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
