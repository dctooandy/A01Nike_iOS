//
//  BTTWithdrawalController.m
//  Hybird_A01
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTWithdrawalController.h"
#import "BTTWithdrawalHeaderCell.h"
#import "BTTWithdrawalController+LoadData.h"
#import "BTTMeMainModel.h"
#import "BTTHomePageSeparateCell.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTBindingMobileBtnCell.h"
#import "BTTWithdrawalCardSelectCell.h"
#import <BRPickerView/BRPickerView.h>
#import "BTTWithdrawalSuccessController.h"
#import "BTTAccountBalanceController.h"

@interface BTTWithdrawalController ()<BTTElementsFlowLayoutDelegate>



@end

@implementation BTTWithdrawalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"取款";
    self.totalAvailable = @"-";
    [self setupCollectionView];
    [self loadMainData];
    [self loadCreditsTotalAvailable];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTWithdrawalHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTWithdrawalHeaderCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageSeparateCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageSeparateCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTWithdrawalCardSelectCell" bundle:nil] forCellWithReuseIdentifier:@"BTTWithdrawalCardSelectCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BTTWithdrawalHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTWithdrawalHeaderCell" forIndexPath:indexPath];
        cell.totalAvailable = self.totalAvailable;
        weakSelf(weakSelf);
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf);
            BTTAccountBalanceController *accountBalance = [[BTTAccountBalanceController alloc] init];
            [strongSelf.navigationController pushViewController:accountBalance animated:YES];
        };
        return cell;
    } else if (indexPath.row == 1) {
        BTTHomePageSeparateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageSeparateCell" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == self.sheetDatas.count) {
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        return cell;
    }  else {
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        if ([model.name isEqualToString:@"取款至"]) {
            BTTWithdrawalCardSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTWithdrawalCardSelectCell" forIndexPath:indexPath];
            return cell;
        } else {
            BTTBindingMobileOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileOneCell" forIndexPath:indexPath];
            cell.model = model;
            return cell;
        }
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%zd", indexPath.item);
    if (indexPath.row != self.sheetDatas.count) {
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        if ([model.name isEqualToString:@"取款至"]) {
            NSIndexPath *twoIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            BTTBindingMobileOneCell *twoCell = (BTTBindingMobileOneCell *)[collectionView cellForItemAtIndexPath:twoIndexPath];
            if (twoCell.textField.text.length) {
                BTTWithdrawalCardSelectCell *cell = (BTTWithdrawalCardSelectCell *)[collectionView cellForItemAtIndexPath:indexPath];
                [BRStringPickerView showStringPickerWithTitle:@"请选择银行卡" dataSource:@[@"招商银行-尾号***1234", @"工商银行-尾号***1234",@"农业银行-尾号***1234"] defaultSelValue:cell.detailLabel.text resultBlock:^(id selectValue) {
                    cell.detailLabel.text = selectValue;
                }];
            } else {
                [MBProgressHUD showError:@"请填写取款金额" toView:self.view];
            }
        }
    } else {
        BTTWithdrawalSuccessController *vc = [[BTTWithdrawalSuccessController alloc] init];
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
    NSInteger total = self.sheetDatas.count + 1;
    for (int i = 0; i < total; i++) {
        if (i == self.sheetDatas.count) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
        } else {
            if (i == 0) {
                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 205)]];
            } else if (i == 1) {
                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 15)]];
            } else {
                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}


@end
