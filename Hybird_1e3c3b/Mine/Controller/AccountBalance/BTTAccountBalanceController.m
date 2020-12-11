//
//  BTTAccountBalanceController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTAccountBalanceController.h"
#import "BTTAccountBlanceHeaderCell.h"
#import "BTTAccountBlanceCell.h"
#import "BTTAccountBlanceHiddenCell.h"
#import "BTTAccountBalanceController+LoadData.h"
#import "BTTGamesHallModel.h"
#import "BTTMeMainModel.h"

@interface BTTAccountBalanceController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, assign) BOOL isShowHidden;

@end

@implementation BTTAccountBalanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoadingData = NO;
    self.title = @"账户余额";
    self.amount = @"-";
    self.localAmount = @"加载中";
    self.hallAmount = @"加载中";
    [self setupCollectionView];
    [self setupElements];
    [self loadGamesListAndGameAmount:[UIButton new]];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTAccountBlanceHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTAccountBlanceHeaderCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTAccountBlanceCell" bundle:nil] forCellWithReuseIdentifier:@"BTTAccountBlanceCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTAccountBlanceHiddenCell" bundle:nil] forCellWithReuseIdentifier:@"BTTAccountBlanceHiddenCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BTTAccountBlanceHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTAccountBlanceHeaderCell" forIndexPath:indexPath];
        NSString *unitString = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"USDT" : @"¥";
        cell.totalLabel.text = [NSString stringWithFormat:@"%@ %@",unitString,[PublicMethod transferNumToThousandFormat:self.amount.floatValue]];
        weakSelf(weakSelf);
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf);
            [strongSelf loadTransferAllMoneyToLocal:button];
        };
        return cell;
    } else if (indexPath.row == 1 || indexPath.row == 2) {
        NSString *unitString = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"USDT" : @"¥";
        BTTMeMainModel *model = self.sheetDatas.count ? self.sheetDatas[indexPath.row - 1] : nil;
        BTTAccountBlanceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTAccountBlanceCell" forIndexPath:indexPath];
        cell.model = model;
        if (indexPath.row == 1) {
            cell.mineArrowsType = BTTMineArrowsTypeHidden;
            cell.amountLabel.text = [self.localAmount isEqualToString:@"加载中"] ? self.localAmount : [NSString stringWithFormat:@"%@ %@",unitString,[PublicMethod transferNumToThousandFormat:self.localAmount.floatValue]];
        } else {
            cell.mineArrowsType = BTTMineArrowsTypeNoHidden;
            cell.amountLabel.text = [self.hallAmount isEqualToString:@"加载中"] ? self.hallAmount : [NSString stringWithFormat:@"%@ %@",unitString,[PublicMethod transferNumToThousandFormat:self.hallAmount.floatValue]];
        }
        if (self.isShowHidden) {
            cell.mineArrowsDirectionType = BTTMineArrowsDirectionTypeUp;
        } else {
            cell.mineArrowsDirectionType = BTTMineArrowsDirectionTypeRight;
        }
        return cell;
    } else {
        BTTAccountBlanceHiddenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTAccountBlanceHiddenCell" forIndexPath:indexPath];
        platformBanlaceModel *model = [platformBanlaceModel yy_modelWithJSON:self.games[indexPath.row - 3]];
        cell.model = model;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.item == 2) {
        self.isShowHidden = !self.isShowHidden;
        [self setupElements];
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
    NSInteger count = 0;
    if (self.isShowHidden) {
        count = 3 + self.games.count;
    } else {
        count = 3;
    }
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        if (i == 0) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 192)]];
        } else if (i == 1 || i == 2) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 60)]];
        } else {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 42)]];
        }
        
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

@end
