//
//  BTTWithdrawalSuccessController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTWithdrawalSuccessController.h"
#import "BTTWithdrawalSuccessCell.h"
#import "BTTBindingMobileBtnCell.h"
#import "OnekeySellUsdtCell.h"

@interface BTTWithdrawalSuccessController ()<BTTElementsFlowLayoutDelegate>


@end

@implementation BTTWithdrawalSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    [self setupElements];
    if (self.isSell) {
        [self showConfirmAlert];
    }
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTWithdrawalSuccessCell" bundle:nil] forCellWithReuseIdentifier:@"BTTWithdrawalSuccessCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
    [self.collectionView registerClass:[OnekeySellUsdtCell class] forCellWithReuseIdentifier:@"OnekeySellUsdtCell"];
}

- (void)showConfirmAlert{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"USDT一键卖币可快速提现至银行卡" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancel];
    UIAlertAction *unlock = [UIAlertAction actionWithTitle:@"去卖币" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.sellLink!=nil&&![self.sellLink isEqualToString:@""]) {
            BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
            vc.title = @"一键卖币";
            vc.webConfigModel.theme = @"outside";
            vc.webConfigModel.newView = YES;
            vc.webConfigModel.url = self.sellLink;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    [alertVC addAction:unlock];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    weakSelf(weakSelf)
    if (indexPath.row == 0) {
        BTTWithdrawalSuccessCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTWithdrawalSuccessCell" forIndexPath:indexPath];
        cell.amountLabel.text = [PublicMethod getMoneyString:[self.amount doubleValue]];
        return cell;
    } else if (indexPath.row == 2){
        OnekeySellUsdtCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OnekeySellUsdtCell" forIndexPath:indexPath];
        [cell sellHidden:self.isSell];
        cell.oneKeySell = ^{
            if (self.sellLink!=nil&&![self.sellLink isEqualToString:@""]) {
                BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
                vc.title = @"一键卖币";
                vc.webConfigModel.theme = @"outside";
                vc.webConfigModel.newView = YES;
                vc.webConfigModel.url = self.sellLink;
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        return cell;
    } else {
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        cell.buttonType = BTTButtonTypeMemberCenter;
        cell.btn.enabled = YES;
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
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
    for (int i = 0; i < 3; i ++) {
        if (i == 0) {
             [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 344)]];
        }else if (i == 2) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
        } else {
             [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
}


@end
