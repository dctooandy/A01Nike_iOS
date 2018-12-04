//
//  BTTDiscountsViewController.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/1.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTDiscountsViewController.h"
#import "BTTHomePageDiscountCell.h"
#import "BTTHomePageHeaderView.h"
#import "BTTDiscountsViewController+LoadData.h"
#import "BTTPromotionModel.h"
#import "BTTPromotionDetailController.h"

@interface BTTDiscountsViewController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTDiscountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠";
    [self setupCollectionView];
    if (self.discountsVCType == BTTDiscountsVCTypeFirst) {
        [self setupNav];
        weakSelf(weakSelf);
        [self pulldownRefreshWithRefreshBlock:^{
            NSLog(@"下拉刷新");
            strongSelf(strongSelf);
            [strongSelf loadMainData];
        }];
    }
    [self showLoading];
    [self loadMainData];
    
}

- (void)setupNav {
    [self.navigationController setNavigationBarHidden:YES];
    BTTHomePageHeaderView *nav = [[BTTHomePageHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KIsiPhoneX ? 88 : 64) withNavType:BTTNavTypeOnlyTitle];
    nav.titleLabel.text = @"优惠";
    [self.view addSubview:nav];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.discountsVCType == BTTDiscountsVCTypeFirst) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}


- (void)setupCollectionView {
    [super setupCollectionView];
    if (self.discountsVCType == BTTDiscountsVCTypeFirst) {
        self.collectionView.frame = CGRectMake(0, KIsiPhoneX ? 88 : 64, SCREEN_WIDTH, SCREEN_HEIGHT - (KIsiPhoneX ? 88 : 64));
    }
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageDiscountCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageDiscountCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BTTHomePageDiscountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageDiscountCell" forIndexPath:indexPath];
    if (indexPath.row == self.elementsHight.count - 1) {
        cell.mineSparaterType = BTTMineSparaterTypeNone;
    } else {
        cell.mineSparaterType = BTTMineSparaterTypeSingleLine;
    }
    BTTPromotionModel *model = self.sheetDatas.count ? self.sheetDatas[indexPath.row] : nil;
    cell.model = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    BTTPromotionModel *model = self.sheetDatas[indexPath.row];
    BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
    vc.webConfigModel.url = model.href;
    vc.webConfigModel.newView = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
    return UIEdgeInsetsMake(0, 0, KIsiPhoneX ? 83 : 49, 0);
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
    
    NSInteger total = self.sheetDatas.count;
    for (int i = 0; i < total; i++) {
        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 130)]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}


@end
