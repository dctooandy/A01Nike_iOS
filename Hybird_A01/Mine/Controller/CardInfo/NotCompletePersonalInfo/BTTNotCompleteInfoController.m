//
//  BTTNotCompleteInfoController.m
//  Hybird_A01
//
//  Created by Domino on 23/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTNotCompleteInfoController.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTNotCompleteInfoController+LoadData.h"
#import "BTTBindingMobileBtnCell.h"
#import "BTTMeMainModel.h"
#import "BTTCardInfosController.h"

@interface BTTNotCompleteInfoController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTNotCompleteInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完善个人信息";
    [self setupCollectionView];
    [self loadMainData];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    [self setupHeaderLabel];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
}

- (void)setupHeaderLabel {
    UILabel *noticeLabel = [UILabel new];
    [self.collectionView addSubview:noticeLabel];
    noticeLabel.frame = CGRectMake(15, 0, SCREEN_WIDTH - 30, 44);
    noticeLabel.font = kFontSystem(12);
    noticeLabel.textColor = [UIColor colorWithHexString:@"818791"];
    noticeLabel.text = @"为了您的取款的安全性及优惠的及时添加, 请先完善个人信息";
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        weakSelf(weakSelf)
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
          strongSelf(strongSelf)
        };
        return cell;
    } else {
        BTTBindingMobileOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileOneCell" forIndexPath:indexPath];
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        cell.model = model;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%zd", indexPath.item);
    if (indexPath.row == 2) {
        BTTCardInfosController *vc = [[BTTCardInfosController alloc] init];
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
    return UIEdgeInsetsMake(44, 0, 40, 0);
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
    for (int i = 0; i < 3; i++) {
        if (i == 2) {
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
