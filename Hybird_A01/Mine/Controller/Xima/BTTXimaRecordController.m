//
//  BTTXimaRecordController.m
//  Hybird_A01
//
//  Created by Domino on 10/10/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTXimaRecordController.h"
#import "BTTXimaRecordCell.h"
#import "BTTXimaRecordModel.h"
#import "BTTXimaRecordController+loadData.h"
#import "BTTXimaRecordButtonsView.h"

@interface BTTXimaRecordController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTXimaRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"洗码投注记录";
    [self loadXimaDataIsLastWeek:NO];
    [self setupButtonsView];
    [self setupCollectionView];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 50);
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTXimaRecordCell" bundle:nil] forCellWithReuseIdentifier:@"BTTXimaRecordCell"];
}



- (void)setupButtonsView {
    BTTXimaRecordButtonsView *buttonsView = [BTTXimaRecordButtonsView viewFromXib];
    buttonsView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    [self.view addSubview:buttonsView];
    weakSelf(weakSelf);
    buttonsView.btnClickBlock = ^(UIButton * _Nonnull button) {
        strongSelf(strongSelf);
        if (button.tag == 1000) {
            [strongSelf loadXimaDataIsLastWeek:YES];
        } else {
            [strongSelf loadXimaDataIsLastWeek:NO];
        }
    };
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BTTXimaRecordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXimaRecordCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.ximaRecordCellType = BTTXimaRecordCellTypeTitle;
    } else {
        if (indexPath.row == self.elementsHight.count - 1) {
            cell.ximaRecordCellType = BTTXimaRecordCellTypeLast;
            cell.amountLabel.text = self.model.total;
        }  else {
            if (indexPath.row % 2 == 0) {
                cell.ximaRecordCellType = BTTXimaRecordCellTypeFirst;
            } else {
                cell.ximaRecordCellType = BTTXimaRecordCellTypeSecond;
            }
            cell.model = self.model.list[indexPath.row - 1];
        }
    }
    return cell;
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
    NSInteger listCount = 0;
    if (self.model.list.count) {
        listCount = _model.list.count + 2;
    }
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < listCount; i++) {
        [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 40)]];
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

@end
