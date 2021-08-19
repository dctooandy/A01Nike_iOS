//
//  BTTForgetPasswordStepTwoController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 15/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTForgetPasswordStepTwoController.h"
#import "BTTForgetPasswordStepTwoController+LoadData.h"
#import "BTTBindingMobileBtnCell.h"
#import "BTTForgetPasswordStepThreeController.h"

@interface BTTForgetPasswordStepTwoController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, copy) NSString *code;

@end

@implementation BTTForgetPasswordStepTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.title = self.findType == BTTFindWithPhone ? @"使用手机号找回密码":@"使用邮箱找回密码";
    [self setupCollectionView];
    [self loadMainData];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    NSString * titleStr = self.findType == BTTFindWithPhone ? @"绑定手机号":@"绑定邮箱";
    UILabel * lab = [[UILabel alloc] init];
    lab.text = [NSString stringWithFormat:@"%@:  %@", titleStr, self.BindStr];
    lab.textColor = [UIColor whiteColor];
    [self.view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.height.offset(44);
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTForgetPwdPhoneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTForgetPwdPhoneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BTTMeMainModel *model = self.mainData[indexPath.row];
        BTTForgetPwdPhoneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTForgetPwdPhoneCell" forIndexPath:indexPath];
        [cell.detailTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        cell.model = model;
        [cell.sendSmsBtn addTarget:self action:@selector(sendSmsBtnAction) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        cell.buttonType = BTTButtonTypeDone;
        weakSelf(weakSelf);
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf);
            [strongSelf showLoading];
            [strongSelf verifyCode:strongSelf.code account:strongSelf.account completeBlock:^(id  _Nullable response, NSError * _Nullable error) {
                [strongSelf hideLoading];
                IVJResponseObject *result = response;
                if ([result.head.errCode isEqualToString:@"0000"]) {
                    BTTForgetPasswordStepThreeController *vc = [[BTTForgetPasswordStepThreeController alloc] init];
                    vc.validateId = result.body[@"validateId"];
                    vc.messageId = result.body[@"messageId"];
                    vc.account = strongSelf.account;
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }else{
                    [MBProgressHUD showError:result.head.errMsg toView:strongSelf.view];
                }
            }];
        };
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
    return UIEdgeInsetsMake(20, 20, 0, 0);
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

-(BTTForgetPwdPhoneCell *)getForgetPhoneCell {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    BTTForgetPwdPhoneCell *cell = (BTTForgetPwdPhoneCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell;
}

-(void)sendSmsBtnAction {
    [self.view endEditing:YES];
    [self sendVerifyCodeWithAccount:self.account];
}

#pragma mark - textfielddelegate

- (void)textFieldChange:(UITextField *)textField {
    NSLog(@"%@",textField.text);
    self.code = textField.text;
    if (self.code.length >= 4) {
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
