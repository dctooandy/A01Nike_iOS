//
//  BTTCardBindMobileController.m
//  Hybird_A01
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCardBindMobileController.h"
#import "BTTBindingMobileBtnCell.h"
#import <Masonry/Masonry.h>
#import "BTTBindingMobileController.h"

@interface BTTCardBindMobileController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTCardBindMobileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机";
    [self setupCollectionView];
    [self setupElements];
}

- (void)setupHeaderView {
    UIView *headerView = [UIView new];
    [self.collectionView addSubview:headerView];
    headerView.backgroundColor = COLOR_RGBA(41, 45, 54, 1);
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 220);
    
    UIImageView *iconView = [UIImageView new];
    [headerView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(57);
        make.centerY.equalTo(headerView.mas_centerY).offset(-20);
        make.centerX.equalTo(headerView.mas_centerX);
    }];
    iconView.backgroundColor = [UIColor redColor];
    
    UILabel *nameLabel = [UILabel new];
    [headerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView.mas_bottom).offset(20);
        make.centerX.equalTo(iconView.mas_centerX);
    }];
    nameLabel.font = kFontSystem(16);
    nameLabel.textColor = [UIColor colorWithHexString:@"818791"];
    nameLabel.text = @"您还没有绑定手机, 请先绑定";
    
}

- (void)setupCollectionView {
    [super setupCollectionView];
    [self setupHeaderView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%zd", indexPath.item);
    if (indexPath.item == 0) {
        BTTBindingMobileController *vc = [[BTTBindingMobileController alloc] init];
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
    return UIEdgeInsetsMake(220, 0, 40, 0);
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
    for (int i = 0; i < 1; i++) {
        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}


@end
