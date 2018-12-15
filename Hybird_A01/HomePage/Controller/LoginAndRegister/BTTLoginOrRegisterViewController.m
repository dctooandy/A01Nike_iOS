//
//  BTTLoginOrRegisterViewController.m
//  Hybird_A01
//
//  Created by Domino on 12/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTLoginOrRegisterViewController.h"
#import "BTTLoginOrRegisterHeaderCell.h"
#import "BTTLoginOrRegisterTypeSelectCell.h"
#import "BTTLoginCell.h"
#import "BTTForgetPasswordCell.h"
#import "BTTLoginOrRegisterBtnCell.h"
#import "BTTRegisterNormalCell.h"
#import "BTTRegisterQuickAutoCell.h"
#import "BTTRegisterQuickManualCell.h"
#import "BTTLoginOrRegisterViewController+UI.h"
#import "BTTLoginCodeCell.h"
#import "BTTLoginOrRegisterViewController+API.h"
#import "BTTForgetPasswordController.h"

@interface BTTLoginOrRegisterViewController ()<BTTElementsFlowLayoutDelegate, UITextFieldDelegate>

@property (nonatomic, assign) CGRect activedTextFieldRect;

@property (nonatomic, copy) NSString *mobile; ///< 输入过的手机号码

@end

@implementation BTTLoginOrRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.qucikRegisterType = BTTQuickRegisterTypeAuto;
    self.loginCellType = BTTLoginCellTypeNormal;
    if (self.registerOrLoginType == BTTRegisterOrLoginTypeLogin) {
        self.title = @"登录";
    } else {
        self.title = @"立即开户";
        [self loadVerifyCode];
    }
    [self setupCollectionView];
    [self setupElements];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    //取出键盘最终的frame
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //取出键盘弹出需要花费的时间
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //获取最佳位置距离屏幕上方的距离
    if ((self.activedTextFieldRect.origin.y + self.activedTextFieldRect.size.height) >  ([UIScreen mainScreen].bounds.size.height - rect.size.height)) {//键盘的高度 高于textView的高度 需要滚动
        [UIView animateWithDuration:duration animations:^{
            self.collectionView.contentOffset = CGPointMake(0, 64 + self.activedTextFieldRect.origin.y + self.activedTextFieldRect.size.height - ([UIScreen mainScreen].bounds.size.height - rect.size.height));
        }];
    }
    
}

- (void)keyboardWillHide:(NSNotification *)notify {
    [UIView animateWithDuration:.25 animations:^{
        self.collectionView.contentOffset = CGPointMake(0, 0);
    }];
}

- (void)keyboardFrameChange:(NSNotification *)notify {
    NSLog(@"%@",notify.userInfo);
    //取出键盘最终的frame
    CGRect rect = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //取出键盘弹出需要花费的时间
    double duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //获取最佳位置距离屏幕上方的距离
    [UIView animateWithDuration:duration animations:^{
        self.collectionView.contentOffset = CGPointMake(0, 64 + self.activedTextFieldRect.origin.y + self.activedTextFieldRect.size.height - ([UIScreen mainScreen].bounds.size.height - rect.size.height));
    }];
    
}

- (void)setupCollectionView {
    [super setupCollectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTLoginOrRegisterHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTLoginOrRegisterHeaderCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTLoginOrRegisterTypeSelectCell" bundle:nil] forCellWithReuseIdentifier:@"BTTLoginOrRegisterTypeSelectCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTLoginCell" bundle:nil] forCellWithReuseIdentifier:@"BTTLoginCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTForgetPasswordCell" bundle:nil] forCellWithReuseIdentifier:@"BTTForgetPasswordCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTLoginOrRegisterBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTLoginOrRegisterBtnCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTRegisterNormalCell" bundle:nil] forCellWithReuseIdentifier:@"BTTRegisterNormalCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTRegisterQuickAutoCell" bundle:nil] forCellWithReuseIdentifier:@"BTTRegisterQuickAutoCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTRegisterQuickManualCell" bundle:nil] forCellWithReuseIdentifier:@"BTTRegisterQuickManualCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTLoginCodeCell" bundle:nil] forCellWithReuseIdentifier:@"BTTLoginCodeCell"];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BTTLoginOrRegisterHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTLoginOrRegisterHeaderCell" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 1) {
        BTTLoginOrRegisterTypeSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTLoginOrRegisterTypeSelectCell" forIndexPath:indexPath];
        cell.registerOrLoginType = self.registerOrLoginType;
        weakSelf(weakSelf);
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf);
            if (button.tag == 10011) {
                strongSelf.registerOrLoginType = BTTRegisterOrLoginTypeLogin;
            } else if (button.tag == 10012) {
                strongSelf.registerOrLoginType = BTTRegisterOrLoginTypeRegisterNormal;
                [strongSelf loadVerifyCode];
            }
            [strongSelf setupElements];
        };
        return cell;
    } else if (indexPath.row == 2) {
        if (self.registerOrLoginType == BTTRegisterOrLoginTypeLogin) {
            if (self.loginCellType == BTTLoginCellTypeNormal) {
                BTTLoginCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTLoginCell" forIndexPath:indexPath];
                cell.accountTextField.delegate = self;
                cell.pwdTextField.delegate = self;
                NSString *historyAccount = [[NSUserDefaults standardUserDefaults] objectForKey:BTTCacheAccountName];
                cell.accountTextField.text = historyAccount.length ? [historyAccount substringFromIndex:1] : @"";
                return cell;
            } else{
                BTTLoginCodeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTLoginCodeCell" forIndexPath:indexPath];
                cell.accountTextField.delegate = self;
                cell.pwdTextField.delegate = self;
                cell.codeTextField.delegate = self;
                cell.codeImageView.image = self.codeImage;
                [cell.codeTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
                NSString *historyAccount = [[NSUserDefaults standardUserDefaults] objectForKey:BTTCacheAccountName];
                cell.accountTextField.text = historyAccount.length ? [historyAccount substringFromIndex:1] : @"";
                weakSelf(weakSelf);
                cell.clickEventBlock = ^(id  _Nonnull value) {
                    strongSelf(strongSelf);
                    [strongSelf loadVerifyCode];
                };
                return cell;
            }
        } else {
            if (self.registerOrLoginType == BTTRegisterOrLoginTypeRegisterNormal) {
                BTTRegisterNormalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTRegisterNormalCell" forIndexPath:indexPath];
                cell.codeImageView.image = self.codeImage;
                cell.accountTextField.delegate = self;
                cell.pwdTextField.delegate = self;
                cell.phoneTextField.delegate = self;
                cell.verifyTextField.delegate = self;
                weakSelf(weakSelf);
                cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                    strongSelf(strongSelf);
                    if (button.tag == 10013) {
                        strongSelf.registerOrLoginType = BTTRegisterOrLoginTypeRegisterNormal;
                    } else if (button.tag == 10014) {
                        strongSelf.registerOrLoginType = BTTRegisterOrLoginTypeRegisterQuick;
                        strongSelf.qucikRegisterType = BTTQuickRegisterTypeAuto;
                    }
                    [strongSelf setupElements];
                };
                
                cell.clickEventBlock = ^(id  _Nonnull value) {
                    strongSelf(strongSelf);
                    [strongSelf loadVerifyCode];
                };
                return cell;
            } else {
                if (self.qucikRegisterType == BTTQuickRegisterTypeAuto) {
                    BTTRegisterQuickAutoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTRegisterQuickAutoCell" forIndexPath:indexPath];
                    cell.phoneTextField.delegate = self;
                    cell.verifyTextField.delegate = self;
                    [cell.phoneTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
                    if (self.mobile.length) {
                        cell.phoneTextField.text = self.mobile;
                    }
                    
                    weakSelf(weakSelf);
                    cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                        strongSelf(strongSelf);
                        
                        if (button.tag == 10015) {
                            strongSelf.registerOrLoginType = BTTRegisterOrLoginTypeRegisterNormal;
                        } else if (button.tag == 10016) {
                            strongSelf.registerOrLoginType = BTTRegisterOrLoginTypeRegisterQuick;
                            strongSelf.qucikRegisterType = BTTQuickRegisterTypeAuto;
                        } else if (button.tag == 10017) {
                            strongSelf.qucikRegisterType = BTTQuickRegisterTypeAuto;
                        } else if (button.tag == 10018) {
                            strongSelf.qucikRegisterType = BTTQuickRegisterTypeManual;
                        }
                        [strongSelf setupElements];
                        
                    };
                    
                    cell.verifyCodeBlock = ^(NSString *phone) {
                        strongSelf(strongSelf);
                        [strongSelf loadMobileVerifyCodeWithPhone:phone];
                    };
                    return cell;
                } else {
                    BTTRegisterQuickManualCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTRegisterQuickManualCell" forIndexPath:indexPath];
                    cell.phoneTextField.delegate = self;
                    cell.accountField.delegate = self;
                    cell.codeField.delegate = self;
                    [cell.phoneTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
                    if (self.mobile.length) {
                        cell.phoneTextField.text = self.mobile;
                    }
                    weakSelf(weakSelf);
                    cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                        strongSelf(strongSelf);
                        if (button.tag == 10019) {
                            strongSelf.registerOrLoginType = BTTRegisterOrLoginTypeRegisterNormal;
                        } else if (button.tag == 10020) {
                            strongSelf.registerOrLoginType = BTTRegisterOrLoginTypeRegisterQuick;
                            strongSelf.qucikRegisterType = BTTQuickRegisterTypeAuto;
                        } else if (button.tag == 10021) {
                            strongSelf.qucikRegisterType = BTTQuickRegisterTypeAuto;
                        } else if (button.tag == 10022) {
                            strongSelf.qucikRegisterType = BTTQuickRegisterTypeManual;
                        }
                        [strongSelf setupElements];
                    };
                    cell.verifyCodeBlock = ^(NSString *phone) {
                        strongSelf(strongSelf);
                        [strongSelf loadMobileVerifyCodeWithPhone:phone];
                    };
                    return cell;
                }
            }
        }
    } else {
        if (self.registerOrLoginType == BTTRegisterOrLoginTypeLogin) {
            if (indexPath.row == 3) {
                BTTForgetPasswordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTForgetPasswordCell" forIndexPath:indexPath];
                weakSelf(weakSelf);
                cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                    strongSelf(strongSelf);
                    BTTForgetPasswordController *vc = [[BTTForgetPasswordController alloc] init];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                };
                return cell;
            } else {
                BTTLoginOrRegisterBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTLoginOrRegisterBtnCell" forIndexPath:indexPath];
                cell.cellBtnType = BTTBtnCellTypeLogin;
                weakSelf(weakSelf);
                cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                    strongSelf(strongSelf);
                    [collectionView endEditing:YES];
                    [strongSelf login];
                };
                return cell;
            }
        } else {
            BTTLoginOrRegisterBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTLoginOrRegisterBtnCell" forIndexPath:indexPath];
            cell.cellBtnType = BTTBtnCellTypeRegister;
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                [collectionView endEditing:YES];
                [strongSelf registerAction];
            };
            return cell;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [collectionView endEditing:YES];
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


#pragma mark - textfielddelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activedTextFieldRect = [textField convertRect:textField.frame toView:self.collectionView];
}

- (void)textFieldChange:(UITextField *)textField {
    if (textField.tag == 2010 || textField.tag == 3010) {
        if ([PublicMethod isValidatePhone:textField.text]) {
            self.mobile = textField.text;
        }
    } else if (textField.tag == 1082) {
        if (textField.text.length > 4) {
            textField.text = [textField.text substringToIndex:4];
        }
    }
}


- (void)setupElements {
    if (self.elementsHight.count) {
        [self.elementsHight removeAllObjects];
    }
    NSInteger total = 0;
    if (self.registerOrLoginType == BTTRegisterOrLoginTypeLogin) {
        total = 5;
    } else {
        total = 4;
    }
    for (int i = 0; i < total; i++) {
        if (i == 0) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 182)]];
        } else if (i == 1) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
        } else if (i == 2) {
            if (self.registerOrLoginType == BTTRegisterOrLoginTypeRegisterNormal) {
                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 244)]];
            } else if (self.registerOrLoginType == BTTRegisterOrLoginTypeRegisterQuick) {
                if (self.qucikRegisterType == BTTQuickRegisterTypeAuto) {
                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 193)]];
                } else {
                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 244)]];
                }
            } else {
                if (self.loginCellType == BTTLoginCellTypeNormal) {
                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
                } else {
                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 150)]];
                }
            }
        } else {
            if (self.registerOrLoginType == BTTRegisterOrLoginTypeLogin) {
                if (i == 3) {
                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
                } else {
                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
                }
            } else {
                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
            }
        }
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

@end
