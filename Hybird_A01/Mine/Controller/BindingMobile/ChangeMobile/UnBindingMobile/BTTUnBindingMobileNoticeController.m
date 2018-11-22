//
//  BTTUnBindingMobileNoticeController.m
//  Hybird_A01
//
//  Created by Domino on 20/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTUnBindingMobileNoticeController.h"
#import "BTTUnBindingHeaderCell.h"
#import "BTTUnBindingBtnCell.h"
#import "BTTBindingMobileController.h"
@interface BTTUnBindingMobileNoticeController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTUnBindingMobileNoticeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    [self setupElements];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTUnBindingHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTUnBindingHeaderCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTUnBindingBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTUnBindingBtnCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BTTUnBindingHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTUnBindingHeaderCell" forIndexPath:indexPath];
        return cell;
    } else {
        BTTUnBindingBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTUnBindingBtnCell" forIndexPath:indexPath];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        BTTBindingMobileController *vc = [BTTBindingMobileController new];
        vc.mobileCodeType = self.mobileCodeType;
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
    NSInteger total = 2;
    for (int i = 0; i < total; i++) {
        if (i == 1) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
        } else {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 240)]];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}



@end
