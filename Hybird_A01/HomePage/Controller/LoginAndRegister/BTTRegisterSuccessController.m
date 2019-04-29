//
//  BTTRegisterSuccessController.m
//  Hybird_A01
//
//  Created by Domino on 14/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTRegisterSuccessController.h"
#import "BTTRegisterSuccessOneCell.h"
#import "BTTRegisterSuccessBtnsCell.h"
#import "BTTRegisterSuccessTwoCell.h"
#import "BTTRegisterSuccessChangePwdCell.h"
#import "BTTPublicBtnCell.h"
#import "BTTChangePwdBtnsCell.h"
#import "BTTRegisterChangePwdSuccessController.h"

typedef enum {
    BTTRegisterSuccessTypeNormal,
    BTTRegisterSuccessTypeChangePwd
}BTTRegisterSuccessType;

@interface BTTRegisterSuccessController ()<BTTElementsFlowLayoutDelegate> {
    NSString *_newPwd;
}


@property (nonatomic, assign) BTTRegisterSuccessType registerSuccessType;

@end

@implementation BTTRegisterSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem new];
    self.title = @"注册成功";
    self.registerSuccessType = BTTRegisterSuccessTypeNormal;
    [self setupCollectionView];
    [self setupElements];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_WIDTH / 375 * 127);
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTRegisterSuccessOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTRegisterSuccessOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTRegisterSuccessBtnsCell" bundle:nil] forCellWithReuseIdentifier:@"BTTRegisterSuccessBtnsCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTRegisterSuccessTwoCell" bundle:nil] forCellWithReuseIdentifier:@"BTTRegisterSuccessTwoCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTRegisterSuccessChangePwdCell" bundle:nil] forCellWithReuseIdentifier:@"BTTRegisterSuccessChangePwdCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTPublicBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTPublicBtnCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTChangePwdBtnsCell" bundle:nil] forCellWithReuseIdentifier:@"BTTChangePwdBtnsCell"];
    UIImageView *adImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - SCREEN_WIDTH / 375 * 127 - (KIsiPhoneX ? 88 : 64), SCREEN_WIDTH, SCREEN_WIDTH / 375 * 127)];
    [self.view addSubview:adImageview];
    adImageview.image = ImageNamed(@"login_ad");
}

- (void)goToBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.registerSuccessType == BTTRegisterSuccessTypeNormal) {
        if (indexPath.row == 0) {
            if (self.registerOrLoginType == BTTRegisterOrLoginTypeRegisterNormal || self.registerOrLoginType == BTTRegisterOrLoginTypeLogin) {
                BTTRegisterSuccessOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTRegisterSuccessOneCell" forIndexPath:indexPath];
                NSString *accountStr = [NSString stringWithFormat:@"您的账号为: %@",self.account];
                NSRange accountRange = [accountStr rangeOfString:self.account];
                NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:accountStr];
                [attstr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"f4e933"]} range:accountRange];
                cell.accountLabel.attributedText = attstr;
                return cell;
            } else {
                BTTRegisterSuccessTwoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTRegisterSuccessTwoCell" forIndexPath:indexPath];
                NSString *accountStr = [NSString stringWithFormat:@"您的账号为: %@",self.account];
                NSRange accountRange = [accountStr rangeOfString:self.account];
                NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:accountStr];
                [attstr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"f4e933"]} range:accountRange];
                cell.accountLabel.attributedText = attstr;
                
                NSString *pwdStr = [NSString stringWithFormat:@"原始密码: %@",self.pwd];
                NSRange pwdRange = [accountStr rangeOfString:self.pwd];
                NSMutableAttributedString *pwdattstr = [[NSMutableAttributedString alloc] initWithString:pwdStr];
                [pwdattstr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"f4e933"]} range:pwdRange];
                cell.pwdLabel.attributedText = pwdattstr;
                weakSelf(weakSelf);
                cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                    strongSelf(strongSelf);
                    strongSelf.registerSuccessType = BTTRegisterSuccessTypeChangePwd;
                    [strongSelf.collectionView reloadData];
                };
                
                return cell;
            }
            
        } else {
            BTTRegisterSuccessBtnsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTRegisterSuccessBtnsCell" forIndexPath:indexPath];
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                [strongSelf.navigationController popToRootViewControllerAnimated:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (button.tag == 40010) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:BTTRegisterSuccessGotoHomePageNotification object:nil];
                    } else if (button.tag == 40011) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:BTTRegisterSuccessGotoMineNotification object:nil];
                    }
                });
                
            };
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            BTTRegisterSuccessChangePwdCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTRegisterSuccessChangePwdCell" forIndexPath:indexPath];
            [cell.pwdTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
            NSString *accountStr = [NSString stringWithFormat:@"您的账号为: %@",self.account];
            NSRange accountRange = [accountStr rangeOfString:self.account];
            NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:accountStr];
            [attstr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"f4e933"]} range:accountRange];
            cell.accountLabel.attributedText = attstr;
            return cell;
        } else {
            BTTChangePwdBtnsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTChangePwdBtnsCell" forIndexPath:indexPath];
//            cell.btnType = BTTPublicBtnTypeConfirmSave;
//            cell.backgroundColor = COLOR_RGBA(41, 45, 54, 1);
//            cell.btn.enabled = YES;
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                if (button.tag == 20012) {
                    [strongSelf changePwd];
                } else {
                    [strongSelf.navigationController popToRootViewControllerAnimated:YES];
                }
                
            };
            return cell;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%zd", indexPath.item);
}

- (void)textChange:(UITextField *)textField {
    if (textField.text.length > 10) {
        textField.text = [textField.text substringToIndex:10];
    }
    _newPwd = textField.text;
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

- (void)changePwd {
    if (!_newPwd.length) {
        [MBProgressHUD showError:@"请输入新密码" toView:nil];
        return;
    }
    if (_newPwd.length < 8) {
        [MBProgressHUD showError:@"请输入8-10位数字和字母" toView:nil];
        return;
    }
    if ([PublicMethod isNum:_newPwd]) {
        [MBProgressHUD showError:@"8-10位数字和字母" toView:nil];
        return;
    }
    if (!_newPwd.integerValue) {
        [MBProgressHUD showError:@"8-10位数字和字母" toView:nil];
        return;
    }
    NSString *url = @"public/users/updatePassword";
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"oldpwd"] = self.pwd;
    params[@"pwd"] = _newPwd;
    weakSelf(weakSelf)
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    [IVNetwork sendRequestWithSubURL:url paramters:params.copy completionBlock:^(IVRequestResultModel *result, id response) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (result.status) {
            [MBProgressHUD showSuccess:@"密码修改成功!" toView:nil];
            BTTRegisterChangePwdSuccessController *vc = (BTTRegisterChangePwdSuccessController *)[BTTRegisterChangePwdSuccessController getVCFromStoryboard];
            vc.account = self.account;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showError:result.message toView:nil];
        }
    }];
}

- (void)setupElements {
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        if (i == 0) {
            if (self.registerOrLoginType == BTTRegisterOrLoginTypeRegisterNormal || self.registerOrLoginType == BTTRegisterOrLoginTypeLogin) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 234)]];
            } else {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 274)]];
            }
        } else if (i == 1) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 71)]];
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}



@end
