//
//  BTTSheetsViewController.m
//  Hybird_A01
//
//  Created by Domino on 27/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTSheetsViewController.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTBindingMobileBtnCell.h"
#import "BTTMeMainModel.h"
#import "BRPickerView.h"

@interface BTTSheetsViewController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *sheetDatas;

@end

@implementation BTTSheetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户报表";
    [self setupCollectionView];
    [self setupElements];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        cell.buttonType = BTTButtonTypeSearch;
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
    if (indexPath.row == 0) {
        BTTBindingMobileOneCell *cell = (BTTBindingMobileOneCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [BRStringPickerView showStringPickerWithTitle:@"请选择记录类型" dataSource:@[@"存款", @"取款",@"优惠",@"转账",@"洗码",@"银行卡更改"] defaultSelValue:cell.textField.text resultBlock:^(id selectValue, NSInteger index) {
            cell.textField.text = selectValue;
        }];
    } else if (indexPath.row == 1) {
        BTTBindingMobileOneCell *cell = (BTTBindingMobileOneCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [BRStringPickerView showStringPickerWithTitle:@"请选择时间范围" dataSource:@[@"近一天", @"近三天",@"近七天",@"近十五天"] defaultSelValue:cell.textField.text resultBlock:^(id selectValue, NSInteger index) {
            cell.textField.text = selectValue;
        }];
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
    return UIEdgeInsetsMake(20, 0, 40, 0);
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
    for (int i = 0; i < 3; i ++) {
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

- (NSMutableArray *)sheetDatas {
    if (!_sheetDatas) {
        _sheetDatas = [NSMutableArray array];
        NSArray *titles = @[@"记录类型",@"时间"];
        NSArray *placeholders = @[@"请选择记录类型",@"请选择时间范围"];
        for (NSString *title in titles) {
            NSInteger index = [titles indexOfObject:title];
            BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
            model.name = title;
            model.iconName = placeholders[index];
            [_sheetDatas addObject:model];
        }
    }
    return _sheetDatas;
}

@end
