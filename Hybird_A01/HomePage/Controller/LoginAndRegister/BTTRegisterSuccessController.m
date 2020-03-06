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
#import "IVRsaEncryptWrapper.h"

typedef enum {
    BTTRegisterSuccessTypeNormal,
    BTTRegisterSuccessTypeChangePwd
}BTTRegisterSuccessType;

@interface BTTRegisterSuccessController ()<BTTElementsFlowLayoutDelegate> {
    NSString *_newPwd;
}


@property (nonatomic, assign) BTTRegisterSuccessType registerSuccessType;
@property (nonatomic, assign) BOOL isModifyPwd;
@property (nonatomic, assign) BOOL isSavedPwd;
@end

@implementation BTTRegisterSuccessController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isModifyPwd = NO;
    self.isSavedPwd = NO;
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
//    UIImageView *adImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - SCREEN_WIDTH / 375 * 127 - (KIsiPhoneX ? 88 : 64), SCREEN_WIDTH, SCREEN_WIDTH / 375 * 127)];
//    [self.view addSubview:adImageview];
//    adImageview.image = ImageNamed(@"login_ad");
}

- (void)showCropAlert{
    weakSelf(weakSelf)
    self.isSavedPwd = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存账号密码截图到相册" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf cropThePasswordView];
    }];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)cropThePasswordView{
   UICollectionView *shadowView = self.collectionView;
    // 开启图片上下文
    UIGraphicsBeginImageContextWithOptions(shadowView.contentSize, NO, 0.f);
    // 保存现在视图的位置偏移信息
    CGPoint saveContentOffset = shadowView.contentOffset;
    // 保存现在视图的frame信息
    CGRect saveFrame = shadowView.frame;
    // 把要截图的视图偏移量设置为0
    shadowView.contentOffset = CGPointZero;
    // 设置要截图的视图的frame为内容尺寸大小
    shadowView.frame = CGRectMake(0, 0, shadowView.contentSize.width, shadowView.contentSize.height);
    // 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 截图:实际是把layer上面的东西绘制到上下文中
    [shadowView.layer renderInContext:ctx];
    //iOS7+ 推荐使用的方法，代替上述方法
    // [shadowView drawViewHierarchyInRect:shadowView.frame afterScreenUpdates:YES];
    // 获取截图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    // 将视图的偏移量设置回原来的状态
    shadowView.contentOffset = saveContentOffset;
    // 将视图的frame信息设置回原来的状态
    shadowView.frame = saveFrame;
    // 保存相册
    UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
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
            BTTRegisterSuccessTwoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTRegisterSuccessTwoCell" forIndexPath:indexPath];
            NSString *tipStr = self.isModifyPwd ? @"密码修改成功" : @"恭喜您,开户成功";
            cell.tipLabel.text = tipStr;
            NSString *accountStr = [NSString stringWithFormat:@"您的账号: %@",self.account];
            NSRange accountRange = [accountStr rangeOfString:self.account];
            NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:accountStr];
            [attstr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"f4e933"]} range:accountRange];
            cell.accountLabel.attributedText = attstr;
            
            NSString *pwdStr = self.isModifyPwd ? [NSString stringWithFormat:@"您的密码: %@",self.pwd] : [NSString stringWithFormat:@"初始密码: %@",self.pwd];
            NSRange pwdRange = [accountStr rangeOfString:self.pwd];
            NSMutableAttributedString *pwdattstr = [[NSMutableAttributedString alloc] initWithString:pwdStr];
            [pwdattstr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"f4e933"]} range:pwdRange];
            cell.pwdLabel.attributedText = pwdattstr;
            cell.modifyBtn.hidden = self.isModifyPwd;
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                strongSelf.registerSuccessType = BTTRegisterSuccessTypeChangePwd;
                [strongSelf.collectionView reloadData];
            };
            
            return cell;
            
        } else {
            BTTRegisterSuccessBtnsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTRegisterSuccessBtnsCell" forIndexPath:indexPath];
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                if (strongSelf.isSavedPwd) {
                    [strongSelf.navigationController popToRootViewControllerAnimated:YES];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (button.tag == 40010) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:BTTRegisterSuccessGotoHomePageNotification object:nil];
                        } else if (button.tag == 40011) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:BTTRegisterSuccessGotoMineNotification object:nil];
                        }
                    });
                }else{
                    [strongSelf showCropAlert];
                }
                
            };
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            BTTRegisterSuccessChangePwdCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTRegisterSuccessChangePwdCell" forIndexPath:indexPath];
            [cell.pwdTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
            NSString *accountStr = [NSString stringWithFormat:@"您的账号: %@",self.account];
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
                    strongSelf(strongSelf);
                    strongSelf.registerSuccessType = BTTRegisterSuccessTypeNormal;
                    [strongSelf.collectionView reloadData];
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
    if ([PublicMethod checkIsHaveNumAndLetter:_newPwd] == BTTStringFormatStyleChar) {
        [MBProgressHUD showError:@"8-10位数字和字母" toView:nil];
        return;
    }
    NSString *url = @"customer/modifyPwd";
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"loginName"] = self.account;
    params[@"oldPassword"] = [IVRsaEncryptWrapper encryptorString:self.pwd];
    params[@"newPassword"] = [IVRsaEncryptWrapper encryptorString:_newPwd];
    params[@"type"] = @1;
    weakSelf(weakSelf)
    NSString *npwd = _newPwd;
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    [IVNetwork requestPostWithUrl:url paramters:params.copy completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"密码修改成功!" toView:nil];
            strongSelf(strongSelf);
            strongSelf.pwd = npwd;
            strongSelf.isModifyPwd = YES;
            strongSelf.registerSuccessType = BTTRegisterSuccessTypeNormal;
            [strongSelf.collectionView reloadData];
            [strongSelf showCropAlert];
//            BTTRegisterChangePwdSuccessController *vc = (BTTRegisterChangePwdSuccessController *)[BTTRegisterChangePwdSuccessController getVCFromStoryboard];
//            vc.account = self.account;
//            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

- (void)setupElements {
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        if (i == 0) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 274)]];
        } else if (i == 1) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 71)]];
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

@end
