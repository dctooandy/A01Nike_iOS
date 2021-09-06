//
//  BTTForgetAccountStepTwoController.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/16/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTForgetAccountStepTwoController.h"
#import "BTTBindingMobileBtnCell.h"
#import "BTTForgetAccountChooseCell.h"
#import "BTTForgetFinalController.h"

@interface BTTForgetAccountStepTwoController ()<BTTElementsFlowLayoutDelegate>
@property (nonatomic, copy) NSString *chooseNameStr;
@end

@implementation BTTForgetAccountStepTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  @"完成找回账号";
    self.view.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self setupCollectionView];
    [self setupElements];
}

-(void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    
    NSString * titleStr = @"  恭喜您找回账号，请选择一个账号登录游戏，选择后其他账号会被禁用";
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
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTForgetAccountChooseCell" bundle:nil] forCellWithReuseIdentifier:@"BTTForgetAccountChooseCell"];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.elementsHight.count - 1) {
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        cell.buttonType = BTTButtonTypeConfirm;
        [[NSNotificationCenter defaultCenter] postNotificationName:BTTVerifyCodeEnableNotification object:@"verifycode"];
        weakSelf(weakSelf);
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf goToNextPage];
        };
        return cell;
    } else {
        __weak BTTForgetAccountChooseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTForgetAccountChooseCell" forIndexPath:indexPath];
        BTTCheckCustomerItemModel * model  = self.itemArr[indexPath.row];
        cell.accountNameStr = model.loginName;
        cell.chooseBtn.tag = indexPath.row;
        weakSelf(weakSelf);
        cell.chooseBtnClickBlock = ^(UIButton * _Nonnull button, NSString * _Nonnull str) {
            for (int i = 0; i < self.itemArr.count; i++) {
                [weakSelf getCorrectBtn:i].isSelect = cell.chooseBtn.tag == i && cell.correct_s.hidden;
            }
            weakSelf.chooseNameStr = str;
        };
        return cell;
    }
}

-(BTTForgetAccountChooseCell *)getCorrectBtn:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    BTTForgetAccountChooseCell *cell = (BTTForgetAccountChooseCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell;
}

-(void)goToNextPage {
    if (self.chooseNameStr.length) {
        BTTForgetFinalController * vc = [[BTTForgetFinalController alloc] init];
        vc.title = @"再次确认";
        vc.accountStr = self.chooseNameStr;
        NSArray * arr = self.forgetType == BTTForgetBoth ? @[@"返回重新选择", @"重置密码"]:@[@"返回重新选择", @"立即登录"];
        vc.btnTitleArr = arr;
        if (self.forgetType == BTTForgetBoth) {
            vc.messageId = self.messageId;
            vc.validateId = self.validateId;
            vc.forgetType = self.forgetType;
            vc.isBothLastStep = false;
        }
        [self.navigationController pushViewController:vc animated:true];
    } else {
        [MBProgressHUD showError:@"请选择一个账号登入游戏" toView:nil];
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
    return 20;
}

- (void)setupElements {
    if (self.elementsHight.count) {
        [self.elementsHight removeAllObjects];
    }
    NSMutableArray *elementsHight = [NSMutableArray array];
    NSInteger count = self.itemArr.count + 1;
    for (int i = 0; i < count; i++) {
        if (i == count - 1) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH - 10, 100)]];
        } else {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH - 40, 40)]];
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

@end
