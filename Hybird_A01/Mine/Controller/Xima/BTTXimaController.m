//
//  BTTXimaController.m
//  Hybird_A01
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTXimaController.h"
#import "BTTXimaHeaderCell.h"
#import "BTTThisWeekBtnsCell.h"
#import "BTTThisWeekCell.h"
#import "BTTThisWeekTotalCell.h"
#import "BTTLastWeekCell.h"
#import "BTTXimaFooterCell.h"
#import "BTTXimaFooterCell.h"
#import "BTTXimaController+LoadData.h"
#import "BTTXimaItemModel.h"

typedef enum {
    BTTXimaDateTypeThisWeek, //本周
    BTTXimaDateTypeLastWeek  //上周
}BTTXimaDateType;

@interface BTTXimaController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, assign) BTTXimaDateType ximaDateType; // 洗码页面显示类型

@end

@implementation BTTXimaController

- (void)viewDidLoad {
    self.title = @"结算洗码";
    [super viewDidLoad];
    [self setupCollectionView];
    [self setupElements];
    [self loadMainData];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTXimaHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTXimaHeaderCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTThisWeekBtnsCell" bundle:nil] forCellWithReuseIdentifier:@"BTTThisWeekBtnsCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTThisWeekCell" bundle:nil] forCellWithReuseIdentifier:@"BTTThisWeekCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTThisWeekTotalCell" bundle:nil] forCellWithReuseIdentifier:@"BTTThisWeekTotalCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTLastWeekCell" bundle:nil] forCellWithReuseIdentifier:@"BTTLastWeekCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTXimaFooterCell" bundle:nil] forCellWithReuseIdentifier:@"BTTXimaFooterCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTXimaFooterCell" bundle:nil] forCellWithReuseIdentifier:@"BTTXimaFooterCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BTTXimaHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaHeaderCell" forIndexPath:indexPath];
        weakSelf(weakSelf)
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf)
            strongSelf.ximaDateType = (BTTXimaDateType)(button.tag - 80000);
            [strongSelf setupElements];
        };
        return cell;
    } else if (indexPath.row == 6) {
        BTTXimaFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaFooterCell" forIndexPath:indexPath];
        return cell;
    } else {
        if (self.ximaDateType == BTTXimaDateTypeLastWeek) {
            BTTLastWeekCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTLastWeekCell" forIndexPath:indexPath];
            return cell;
        } else {
            if (indexPath.row == 5) {
                BTTThisWeekBtnsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTThisWeekBtnsCell" forIndexPath:indexPath];
                return cell;
            } else if (indexPath.row == 4) {
                BTTThisWeekTotalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTThisWeekTotalCell" forIndexPath:indexPath];
                return cell;
            } else {
                BTTThisWeekCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTThisWeekCell" forIndexPath:indexPath];
                return cell;
            }
        }
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
    NSInteger total = 0;
    if (self.ximaDateType == BTTXimaDateTypeThisWeek) {
        total  = self.validModel.list.count + 4;
    } else {
    }
    for (int i = 0; i < 7; i ++) {
        if (i == 0) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 48)]];
        } else if (i == 6) {
            if (SCREEN_WIDTH == 414) {
                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 583)]];
            } else if (SCREEN_WIDTH == 320) {
                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 680)]];
            } else {
                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 613)]];
            }
        } else {
            if (self.ximaDateType == BTTXimaDateTypeLastWeek) {
                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 107)]];
            } else {
                if (i == 5) {
                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 137)]];
                } else if (i == 4) {
                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
                } else {
                    [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 107)]];
                }
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

@end
