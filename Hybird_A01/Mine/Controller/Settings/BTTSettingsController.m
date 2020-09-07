//
//  BTTSettingsController.m
//  Hybird_A01
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTSettingsController.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTMeMainModel.h"
#import "BTTPersonalInfoController.h"
#import "BTTCardInfosController.h"
#import "BTTModifyLimitViewController.h"
#import "BTTBookMessageController.h"

@interface BTTSettingsController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *sheetDatas;

@end

@implementation BTTSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self setupCollectionView];
    [self setupElements];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%zd", indexPath.item);
    if (indexPath.row == 0) {
        BTTPersonalInfoController *vc = [[BTTPersonalInfoController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        BTTCardInfosController *vc = [[BTTCardInfosController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        BTTModifyLimitViewController *vc = [[BTTModifyLimitViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 3) {
        BTTBookMessageController *vc = [[BTTBookMessageController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 4) {
        if (self.refreshBlock) {
            self.refreshBlock();
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
    for (int i = 0; i < 5; i ++) {
        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (NSMutableArray *)sheetDatas {
    if (!_sheetDatas) {
        _sheetDatas = [NSMutableArray array];
        NSString *cardString = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"提现地址管理" : @"银行卡资料";
        NSArray *titles = @[@"个人资料",cardString,@"修改限红",@"短信订阅",@"退出登录"];
        NSArray *placeholders = @[@"",@"",@"",@"",@""];
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
