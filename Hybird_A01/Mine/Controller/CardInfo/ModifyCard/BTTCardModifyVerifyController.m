//
//  BTTCardModifyVerifyController.m
//  Hybird_A01
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCardModifyVerifyController.h"
#import "BTTCardModifyVerifyController+LoadData.h"
#import "BTTMeMainModel.h"
#import "BTTCardModifyTitleCell.h"
#import "BTTCardModifyCell.h"
#import "BTTBindingMobileBtnCell.h"
#import "BTTAddCardController.h"

@interface BTTCardModifyVerifyController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTCardModifyVerifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行卡验证";
    [self setupCollectionView];
    [self loadMainData];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTCardModifyTitleCell" bundle:nil] forCellWithReuseIdentifier:@"BTTCardModifyTitleCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTCardModifyCell" bundle:nil] forCellWithReuseIdentifier:@"BTTCardModifyCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 2) {
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        BTTCardModifyTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTCardModifyTitleCell" forIndexPath:indexPath];
        cell.titleLabel.text = model.name;
        return cell;
    } else if (indexPath.row == 1 || indexPath.row == 3) {
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        BTTCardModifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTCardModifyCell" forIndexPath:indexPath];
        if (indexPath.row == 1) {
            cell.textField.text = model.name;
            cell.textField.userInteractionEnabled = NO;
        } else {
            cell.textField.text = @"";
            cell.textField.placeholder = model.name;
            cell.textField.userInteractionEnabled = YES;
        }
        return cell;
    } else {
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        cell.buttonType = BTTButtonTypeNext;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%zd", indexPath.item);
    if (indexPath.row == self.sheetDatas.count) {
        BTTAddCardController *vc = [[BTTAddCardController alloc] init];
        vc.addCardType = BTTAddCardTypeUpdate;
        [self.navigationController pushViewController:vc animated:YES];
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
    NSInteger total = self.sheetDatas.count + 1;
    for (int i = 0; i < total; i++) {
        if (i == self.sheetDatas.count) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
        } else {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}


@end
