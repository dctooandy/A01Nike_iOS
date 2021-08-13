//
//  BTTForgetPasswordController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 15/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTForgetPasswordController.h"
#import "BTTForgetPwdOneCell.h"
#import "BTTForgetPwdCodeCell.h"
#import "BTTBindingMobileBtnCell.h"
#import "BTTMeMainModel.h"
#import "BTTForgetPasswordController+LoadData.h"
#import "BTTForgetPasswordStepTwoController.h"

@interface BTTForgetPasswordController ()<BTTElementsFlowLayoutDelegate,UITextFieldDelegate>

@property (nonatomic, copy) NSString *account;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *code;

@end

@implementation BTTForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.findType == BTTFindWithPhone ? @"选择手机找回密码方式":@"选择邮箱找回密码方式";
    [self setupCollectionView];
    [self loadMainData];
    [self loadVerifyCode];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTForgetPwdOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTForgetPwdOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTForgetPwdCodeCell" bundle:nil] forCellWithReuseIdentifier:@"BTTForgetPwdCodeCell"];
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
            [strongSelf showLoading];
            [strongSelf verifyPhotoCode:self.code loginName:strongSelf.account WithCaptchaId:strongSelf.uuid mobileNo:strongSelf.phone completeBlock:^(id  _Nullable response, NSError * _Nullable error) {
                IVJResponseObject *result = response;
                [strongSelf hideLoading];
                if ([result.head.errCode isEqualToString:@"0000"]) {
                    BTTForgetPasswordStepTwoController *vc = [[BTTForgetPasswordStepTwoController alloc] init];
                    vc.account = strongSelf.account;
                    vc.validateId = result.body[@"validateId"];
                    vc.findType = strongSelf.findType;
                    vc.BindStr = strongSelf.phone;
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }else{
                    [MBProgressHUD showError:result.head.errMsg toView:strongSelf.view];
                    [self loadVerifyCode];
                }
            }];
        };
        return cell;
    } else if (indexPath.row == self.elementsHight.count - 2) {
        BTTMeMainModel *model = self.mainData[indexPath.row];
        BTTForgetPwdCodeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTForgetPwdCodeCell" forIndexPath:indexPath];
        [cell.detailTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        cell.codeImage.image = self.codeImage;
        cell.detailTextField.delegate = self;
        cell.model = model;
        weakSelf(weakSelf);
        cell.clickEventBlock = ^(id  _Nonnull value) {
            strongSelf(strongSelf);
            [strongSelf loadVerifyCode];
        };
        return cell;
    } else {
        BTTMeMainModel *model = self.mainData[indexPath.row];
        BTTForgetPwdOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTForgetPwdOneCell" forIndexPath:indexPath];
        cell.detailTextField.delegate = self;
        cell.detailTextField.tag = 30010 + indexPath.row;
        cell.detailTextField.text = cell.detailTextField.tag == 30010 ? self.account:self.phone;
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

#pragma mark - textfielddelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldChange:(UITextField *)textField {
    NSLog(@"%@",textField.text);
    if (textField.tag == 30010) {
        textField.text = [textField.text lowercaseString];
        self.account = textField.text;
        
    } else if (textField.tag == 30011) {
        self.phone = textField.text;
        
    } else if (textField.tag == 30012) {
        self.code = textField.text;
    }
    
    NSString *regex = @"^[a-zA-Z0-9]{4,11}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isAccount = [predicate evaluateWithObject:self.account];
    BOOL isPhone = self.findType == BTTFindWithPhone ? [PublicMethod isValidatePhone:self.phone]:[PublicMethod isValidateEmail:self.phone];
    if (self.code.length >= 5 && isAccount && isPhone) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BTTVerifyCodeEnableNotification object:@"verifycode"];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:BTTVerifyCodeDisableNotification object:@"verifycode"];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 30012) {
        if (textField.text.length >= 5 && string.length > 0) {
            return false;
        }
    } else if (textField.tag == 30011) {
        if (textField.text.length >= 11 && string.length > 0 && self.findType == BTTFindWithPhone) {
            return false;
        }
    } else {
        if (textField.text.length >= 11 && string.length > 0) {
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
