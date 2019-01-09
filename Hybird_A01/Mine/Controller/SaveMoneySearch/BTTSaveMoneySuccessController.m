//
//  BTTSaveMoneySuccessController.m
//  Hybird_A01
//
//  Created by Domino on 03/01/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTSaveMoneySuccessController.h"
#import "BTTPublicBtnCell.h"
#import "BTTSaveMoneySuccessHeaderCell.h"

@interface BTTSaveMoneySuccessController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTSaveMoneySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"存款成功";
    [self setupCollectionView];
    [self setupElements];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTSaveMoneySuccessHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTSaveMoneySuccessHeaderCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTPublicBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTPublicBtnCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        BTTPublicBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTPublicBtnCell" forIndexPath:indexPath];
        cell.btnType = BTTPublicBtnTypeEnterGame;
        cell.btn.enabled = YES;
        weakSelf(weakSelf);
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf);
            
        };
        return cell;
    } else {
        BTTSaveMoneySuccessHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTSaveMoneySuccessHeaderCell" forIndexPath:indexPath];
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
    return UIEdgeInsetsMake(0, 0, 0, 0);
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
    for (int i = 0; i < 2; i++) {
        if (i == 0) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 250)]];
        } else {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 110)]];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}


@end
