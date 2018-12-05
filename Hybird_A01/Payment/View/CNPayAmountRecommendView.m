//
//  CNPayAmountRecommendView.m
//  A05_iPhone
//
//  Created by cean.q on 2018/10/2.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayAmountRecommendView.h"
#import "CNPayRecommendCell.h"

#define kCNPayRecommendCellId  @"CNPayRecommendCell"

@interface CNPayAmountRecommendView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation CNPayAmountRecommendView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    CGFloat width = 50;
    CGFloat space = 5;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setMinimumInteritemSpacing:space];
    [layout setMinimumLineSpacing:space];
    [layout setItemSize:CGSizeMake(width, 20)];
    [layout setScrollDirection: UICollectionViewScrollDirectionVertical];

    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_collectionView registerNib:[UINib nibWithNibName:kCNPayRecommendCellId bundle:nil] forCellWithReuseIdentifier:kCNPayRecommendCellId];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.bounces = NO;
    [self addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setDataSource:(NSArray<NSString *> *)dataSource {
    _dataSource = dataSource;
    [self.collectionView reloadData];
}

#pragma mark- UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CNPayRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCNPayRecommendCellId forIndexPath:indexPath];
    [cell settingAmount:[_dataSource objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _currentSelectRecommendValue = [_dataSource objectAtIndex:indexPath.row];
    if (_clickHandler) {
        _clickHandler(self.currentSelectRecommendValue, indexPath.row);
    }
}

@end
