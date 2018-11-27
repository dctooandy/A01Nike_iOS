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

@interface BTTVideoGamesListController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTVideoGamesListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电子游戏";
    [self setupCollectionView];
    [self setupElements];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageBannerCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageBannerCell"];
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
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor yellowColor];
    if (![cell.contentView viewWithTag:100]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        label.tag = 100;
        label.textColor = [UIColor redColor];
        label.font = [UIFont boldSystemFontOfSize:17];
        [cell.contentView addSubview:label];
    }
    UILabel *label = [cell.contentView viewWithTag:100];
    label.text = [NSString stringWithFormat:@"%zd", indexPath.item];
    return cell;
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
    NSInteger total = 0;
    total = 2;
    
    for (int i = 0; i < total; i++) {
        if (i == 0) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, BTTBnnnerDefaultHeight * (SCREEN_WIDTH / BTTBannerDefaultWidth))]];
        } else if (i == 1) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 45)]];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}



@end
