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
@property(nonatomic, assign) NSIndexPath *selectedIndexPath;

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
    CGFloat width = ([UIScreen mainScreen].bounds.size.width-72)/3.0;
    CGFloat space = 15;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setMinimumInteritemSpacing:space];
    [layout setMinimumLineSpacing:space];
    [layout setItemSize:CGSizeMake(width, width * 70/200.0)];
    [layout setScrollDirection: UICollectionViewScrollDirectionVertical];

    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_collectionView registerNib:[UINib nibWithNibName:kCNPayRecommendCellId bundle:nil] forCellWithReuseIdentifier:kCNPayRecommendCellId];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(space, 20, space, 20);
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
    [cell settingCellStatusIsSelected:[_selectedIndexPath isEqual:indexPath]];
    [cell settingAmount:[_dataSource objectAtIndex:indexPath.row]];
    [cell settingCellStatusIsSelected:NO];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CNPayRecommendCell *cell = (CNPayRecommendCell *)[collectionView cellForItemAtIndexPath:indexPath];
    _currentSelectRecommendValue = [_dataSource objectAtIndex:indexPath.row];
    if (_clickHandler) {
        _clickHandler(self.currentSelectRecommendValue, indexPath.row);
    }
    [cell settingCellStatusIsSelected:YES];
    _selectedIndexPath = indexPath;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    CNPayRecommendCell *cell = (CNPayRecommendCell *)[collectionView cellForItemAtIndexPath:indexPath];
    _currentSelectRecommendValue = nil;
    [cell settingCellStatusIsSelected:NO];
}

- (void)selectIndex:(NSInteger)index {
    if (index < self.dataSource.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
        _selectedIndexPath = indexPath;
        CNPayRecommendCell *cell = (CNPayRecommendCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [cell settingCellStatusIsSelected:YES];
    }
}

- (void)cleanSelectedState {
    _currentSelectRecommendValue = nil;
    [self collectionView:self.collectionView didDeselectItemAtIndexPath:_selectedIndexPath];
    _selectedIndexPath = nil;
}

@end
