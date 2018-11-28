//
//  BTTVideoGamesListController.m
//  Hybird_A01
//
//  Created by Domino on 26/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTVideoGamesListController.h"
#import "BTTVideoGamesListController+LoadData.h"
#import "BTTHomePageBannerCell.h"
#import "BTTBannerModel.h"
#import "BTTPromotionDetailController.h"
#import "BTTVideoGamesFilterCell.h"
#import "BTTVideoGamesHeaderCell.h"
#import "BTTVideoGameCell.h"

@interface BTTVideoGamesListController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTVideoGamesListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电子游戏";
    [self setupCollectionView];
    [self setupElements];
    weakSelf(weakSelf);
    [self loadmoreWithBlock:^{
        strongSelf(strongSelf);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf endRefreshing];
        });
    }];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageBannerCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageBannerCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTVideoGamesFilterCell" bundle:nil] forCellWithReuseIdentifier:@"BTTVideoGamesFilterCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTVideoGamesHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTVideoGamesHeaderCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTVideoGameCell" bundle:nil] forCellWithReuseIdentifier:@"BTTVideoGameCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BTTHomePageBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageBannerCell" forIndexPath:indexPath];
        weakSelf(weakSelf);
        cell.clickEventBlock = ^(id  _Nonnull value) {
            strongSelf(strongSelf);
            BTTBannerModel *model = strongSelf.banners[[value integerValue]];
            BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
            vc.webConfigModel.url = model.action.detail;
            vc.webConfigModel.newView = YES;
            vc.webConfigModel.theme = @"outside";
            [strongSelf.navigationController pushViewController:vc animated:YES];
        };
        cell.imageUrls = self.imageUrls;
        return cell;
    } else if (indexPath.row == 1) {
        BTTVideoGamesFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesFilterCell" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 2) {
        BTTVideoGamesHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesHeaderCell" forIndexPath:indexPath];
        return cell;
    } else {
        BTTVideoGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGameCell" forIndexPath:indexPath];
        if (indexPath.row % 2) {
            cell.leftConstants.constant = 15;
            cell.rightConstants.constant = 7.5;
        } else {
            cell.leftConstants.constant = 7.5;
            cell.rightConstants.constant = 15;;
        }
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
    NSInteger total = 0;
    total = 20;
    
    for (int i = 0; i < total; i++) {
        if (i == 0) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, BTTBnnnerDefaultHeight * (SCREEN_WIDTH / BTTBannerDefaultWidth))]];
        } else if (i == 1) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 36)]];
        } else if (i == 2) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 45)]];
        } else {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH / 2, (SCREEN_WIDTH / 2 - 22.5) / 130 * 90 + 105)]];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}



@end
