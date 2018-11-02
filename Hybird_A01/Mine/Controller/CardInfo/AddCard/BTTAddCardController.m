//
//  BTTAddCardController.m
//  Hybird_A01
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTAddCardController.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTAddCardController+LoadData.h"
#import "BTTMeMainModel.h"
#import "BTTAddCardBtnsCell.h"
#import <BRPickerView/BRPickerView.h>


@interface BTTAddCardController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, strong) BRProvinceModel *provinceModel;

@end

@implementation BTTAddCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.addCardType == BTTAddCardTypeUpdate) {
        self.title = @"修改银行卡";
    } else {
        self.title = @"添加银行卡";
    }
    [self setupCollectionView];
    [self loadMainData];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTAddCardBtnsCell" bundle:nil] forCellWithReuseIdentifier:@"BTTAddCardBtnsCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.sheetDatas.count) {
        BTTAddCardBtnsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTAddCardBtnsCell" forIndexPath:indexPath];
        return cell;
    } else {
        BTTBindingMobileOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileOneCell" forIndexPath:indexPath];
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        cell.model = model;
        if (indexPath.row == self.sheetDatas.count - 1) {
            cell.mineSparaterType = BTTMineSparaterTypeNone;
        } else {
            cell.mineSparaterType = BTTMineSparaterTypeSingleLine;
        }
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    BTTBindingMobileOneCell *cell = (BTTBindingMobileOneCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"%zd", indexPath.item);
    if (indexPath.item == 1) {
        NSArray *banks = @[@"招商银行", @"交通银行", @"农业银行", @"工商银行", @"建设银行", @"中国银行", @"民生银行", @"光大银行", @"兴业银行", @"平安银行", @"中信银行", @"浦发银行", @"广发银行", @"华夏银行", @"中国邮政银行", @"深圳发展银行", @"农村信用合作社"];
        [BRStringPickerView showStringPickerWithTitle:@"选择收款银行" dataSource:banks defaultSelValue:cell.textField.text resultBlock:^(id selectValue) {
            cell.textField.text = selectValue;
        }];
    } else if (indexPath.item == 2) {
        [BRStringPickerView showStringPickerWithTitle:@"卡片类别" dataSource:@[@"借记卡", @"信用卡", @"存折"] defaultSelValue:cell.textField.text resultBlock:^(id selectValue) {
            cell.textField.text = selectValue;
        }];
    } else if (indexPath.item == 4) {
        [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeProvince dataSource:nil defaultSelected:nil isAutoSelect:NO themeColor:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
            self.provinceModel = province;
            cell.textField.text = province.name;
        } cancelBlock:^{
            
        }];
    } else if (indexPath.item == 5) {
        if (self.provinceModel) {
            [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeCity dataSource:nil defaultSelected:@[self.provinceModel.name] isAutoSelect:NO themeColor:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
                cell.textField.text = city.name;
            } cancelBlock:^{
                
            }];
        } else {
            [MBProgressHUD showMessagNoActivity:@"请先选择省份" toView:self.view];
        }
        
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
    return UIEdgeInsetsMake(15, 0, 40, 0);
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
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

@end
