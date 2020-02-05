//
//  BTTChangeMobileSuccessController.m
//  Hybird_A01
//
//  Created by Domino on 19/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTChangeMobileSuccessController.h"
#import "BTTChangeMobileSuccessOneCell.h"
#import "BTTChangeMobileSuccessBtnCell.h"

@interface BTTChangeMobileSuccessController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTChangeMobileSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    [self setupElements];
    switch (self.mobileCodeType) {
        case BTTSafeVerifyTypeNormalAddBankCard:
        case BTTSafeVerifyTypeNormalAddBTCard:
        case BTTSafeVerifyTypeMobileAddBankCard:
        case BTTSafeVerifyTypeMobileBindAddBankCard:
        case BTTSafeVerifyTypeMobileAddBTCard:
        case BTTSafeVerifyTypeMobileBindAddBTCard:
        case BTTSafeVerifyTypeNormalAddUSDTCard:
        case BTTSafeVerifyTypeMobileAddUSDTCard:
        case BTTSafeVerifyTypeMobileBindAddUSDTCard:
            self.title = @"添加银行卡成功!";
            break;
        case BTTSafeVerifyTypeMobileChangeBankCard:
        case BTTSafeVerifyTypeMobileBindChangeBankCard:
            self.title = @"修改银行卡成功!";
            break;
        case BTTSafeVerifyTypeChangeMobile:
            self.title = @"修改手机号成功!";
            break;
        case BTTSafeVerifyTypeChangeEmail:
            self.title = @"修改邮箱成功!";
            break;
        case BTTSafeVerifyTypeMobileDelBankCard:
        case BTTSafeVerifyTypeMobileBindDelBankCard:
        case BTTSafeVerifyTypeMobileDelBTCard:
        case BTTSafeVerifyTypeMobileDelUSDTCard:
        case BTTSafeVerifyTypeMobileBindDelBTCard:
        case BTTSafeVerifyTypeMobileBindDelUSDTCard:
            self.title = @"删除成功!";
            break;
        case BTTSafeVerifyTypeBindMobile:
            self.title = @"绑定手机号成功";
            break;
        case BTTSafeVerifyTypeBindEmail:
            self.title = @"绑定邮箱成功";
            break;
        case BTTSafeVerifyTypeHumanAddBankCard:
        case BTTSafeVerifyTypeHumanChangeBankCard:
        case BTTSafeVerifyTypeHumanDelBankCard:
        case BTTSafeVerifyTypeHumanAddBTCard:
        case BTTSafeVerifyTypeHumanDelBTCard:
        case BTTSafeVerifyTypeHumanAddUSDTCard:
        case BTTSafeVerifyTypeHumanDelUSDTCard:
        case BTTSafeVerifyTypeHumanChangeMoblie:
            self.title = @"申请已提交";
       
            break;
        default:
            self.title = @"处理成功";
            break;
    }
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTChangeMobileSuccessOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTChangeMobileSuccessOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTChangeMobileSuccessBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTChangeMobileSuccessBtnCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BTTChangeMobileSuccessOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTChangeMobileSuccessOneCell" forIndexPath:indexPath];
        cell.mobileCodeType = self.mobileCodeType;
        return cell;
    } else {
        BTTChangeMobileSuccessBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTChangeMobileSuccessBtnCell" forIndexPath:indexPath];
        weakSelf(weakSelf)
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            if (button.tag == 2301) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoCardInfoNotification" object:nil];
            }
        };
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
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

- (void)setupElements {
    if (self.elementsHight.count) {
        [self.elementsHight removeAllObjects];
    }
    
    NSMutableArray *elementsHight = [NSMutableArray array];
    
    NSInteger total = 2;
    for (int i = 0; i < total; i++) {
        if (i == 1) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
        } else {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 213)]];
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)goToBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
