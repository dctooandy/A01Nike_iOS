//
//  KYMWithdrewAmountCell.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/16.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrewAmountCell.h"
#import "KYMWithdrewAmountListCell.h"

@interface KYMWithdrewAmountCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@end
@implementation KYMWithdrewAmountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"KYMWithdrewAmountListCell" bundle:nil] forCellWithReuseIdentifier:@"KYMWithdrewAmountListCell"];
    self.lineHeight.constant = 1 / [UIScreen mainScreen].scale;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.amountArray && self.amountArray.count > 0) {
        return self.amountArray.count;
    }
    return 0;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.amountArray && self.amountArray.count > indexPath.row) {
        CGFloat amount = [self.amountArray[indexPath.row] doubleValue];
        KYMWithdrewAmountListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KYMWithdrewAmountListCell" forIndexPath:indexPath];
        cell.amount = amount;
        return  cell;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (CGRectGetWidth(collectionView.frame) - 20) / 3.0 ;
    return CGSizeMake(width, 32);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return  UIEdgeInsetsMake(8, 0, 8, 0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate matchWithdrewAmountCellDidSelected:self indexPath:indexPath];
}

@end
