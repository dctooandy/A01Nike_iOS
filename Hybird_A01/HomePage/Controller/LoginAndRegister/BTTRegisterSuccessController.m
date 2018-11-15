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

@interface BTTRegisterSuccessController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTRegisterSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    [self setupCollectionView];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTRegisterSuccessOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTRegisterSuccessOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTRegisterSuccessBtnsCell" bundle:nil] forCellWithReuseIdentifier:@"BTTRegisterSuccessBtnsCell"];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BTTRegisterSuccessOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTRegisterSuccessOneCell" forIndexPath:indexPath];
        return cell;
    } else {
        BTTRegisterSuccessBtnsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTRegisterSuccessBtnsCell" forIndexPath:indexPath];
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
    for (int i = 0; i < 2; i++) {
        if (i == 0) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 234)]];
        } else if (i == 1) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 71)]];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}



@end
