//
//  BTTForgetFinalController.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/18/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTForgetFinalController.h"
#import "BTTBindingMobileBtnCell.h"
#import "BTTLoginOrRegisterViewController.h"
#import "BTTForgetPasswordStepThreeController.h"

@interface BTTForgetFinalController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTForgetFinalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self setupCollectionView];
    [self setupElements];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:BTTVerifyCodeEnableNotification object:@"verifycode"];
}

-(void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    NSString * titleStr = @"";
    if (self.accountStr) {
        if (self.isBothLastStep) {
            titleStr = [NSString stringWithFormat:@"  恭喜玩家 %@ 完成找回账号并重置密码，请点击立即登录开始游戏", self.accountStr];
        } else {
            titleStr = [NSString stringWithFormat:@"  再次确认是否使用 %@ 登录游戏。", self.accountStr];
        }
    } else {
        titleStr = @"  恭喜您完成密码重置，请点击立即登录开始游戏";
    }
    
    UILabel * lab = [[UILabel alloc] init];
    lab.numberOfLines = 0;
    lab.font = [UIFont systemFontOfSize:14];
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
    /**
     添加图片到指定的位置
     */
    NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
    // 表情图片
    attchImage.image = [UIImage imageNamed:@"ic_forget_warring_logo"];
    // 设置图片大小
    attchImage.bounds = CGRectMake(0, -3, 15, 15);
    NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
    [attriStr insertAttributedString:stringImage atIndex:0];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:5];
    [attriStr addAttribute:NSParagraphStyleAttributeName
        value:style
        range:NSMakeRange(0, titleStr.length)];
    
    lab.attributedText = attriStr;
    
    lab.textColor = [UIColor redColor];
    [self.view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
    [cell.btn setTitle:self.btnTitleArr[indexPath.row] forState:UIControlStateNormal];
    cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
        [self btnAction:button.currentTitle];
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:BTTVerifyCodeEnableNotification object:@"verifycode"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"%zd", indexPath.item);
}

-(void)btnAction:(NSString *)title {
    if ([title isEqualToString:@"返回重新选择"]) {
        [self.navigationController popViewControllerAnimated:true];
    } else if ([title isEqualToString:@"立即登录"]) {
        BTTLoginOrRegisterViewController * vc = [[BTTLoginOrRegisterViewController alloc] init];
        vc.accountStr = self.accountStr;
        [self.navigationController pushViewController:vc animated:true];
    } else if ([title isEqualToString:@"重置密码"]) {
        BTTForgetPasswordStepThreeController * vc = [[BTTForgetPasswordStepThreeController alloc] init];
        vc.messageId = self.messageId;
        vc.validateId = self.validateId;
        vc.account = self.accountStr;
        vc.forgetType = self.forgetType;
        [self.navigationController pushViewController:vc animated:true];
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
    return 20;
}

- (void)setupElements {
    if (self.elementsHight.count) {
        [self.elementsHight removeAllObjects];
    }
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < self.btnTitleArr.count; i++) {
        [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH - 40, 50)]];
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

@end
