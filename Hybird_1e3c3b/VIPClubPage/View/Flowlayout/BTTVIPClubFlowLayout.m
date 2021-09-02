//
//  BTTVIPClubFlowLayout.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/5/18.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTVIPClubFlowLayout.h"
#import "VIPRightUpgradeCell.h"
@implementation BTTVIPClubFlowLayout
@synthesize cellType,confirmTransform;
-(id)init
{
    self = [super init];
    self.confirmTransform = NO;
    return self;
    
}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
//- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes API_AVAILABLE(ios(8.0))
//{
//
////     CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2;
////    if ([[[self.collectionView visibleCells] firstObject] isKindOfClass:[VIPRightUpgradeCell class]])
////    {
////        [self modifyAttributes:preferredAttributes centerX:centerX];
////    }
//
//    return  YES;
//}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //計算contentView最終停留位置
    CGRect lastRect;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    //取出這個飯為內所有item屬性
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    //計算最終屏幕的中心X
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width/2;
    //歷遍所有屬性,通過計算item與最終屏幕中心的最小距離,然後將item移動到屏幕的中心位置
    CGFloat adjustOffsetX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attris in array) {
        if (ABS(attris.center.x - centerX) < ABS(adjustOffsetX))
        {
            adjustOffsetX = attris.center.x - centerX;
        }
    }
    //返回要移動到的中心的item位置
    switch (cellType) {
        case VIPRightUpgradePage:
        {
            if (confirmTransform == YES)
            {
                return  CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
            }else
            {
                return  CGPointMake(proposedContentOffset.x , proposedContentOffset.y);
            }
        }
            break;
        case VIPRightTravelPage:
            return  CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
            break;
        default:
            return  CGPointMake(proposedContentOffset.x , proposedContentOffset.y);
            break;
    }
    
//    if ([[[self.collectionView visibleCells] firstObject] isKindOfClass:[VIPRightUpgradeCell class]])
//    {
//        return  CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
//    }else{
//        return  CGPointMake(proposedContentOffset.x , proposedContentOffset.y);
//    }
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    CGRect visiableRect ;
    visiableRect.size = self.collectionView.frame.size;
    visiableRect.origin = self.collectionView.contentOffset;
    
    NSArray* attributesInRect = [super layoutAttributesForElementsInRect:rect ];
   
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2;
    
    for (UICollectionViewLayoutAttributes * cellAttributes in attributesInRect)
    {
        if (!CGRectIntersectsRect(visiableRect, cellAttributes.frame)) continue;
        if (confirmTransform == YES)
        {
            switch (cellType) {
                case VIPRightUpgradePage:
                    [self modifyAttributes:cellAttributes centerX:centerX];
                    break;
                default:
                    cellAttributes.transform = CGAffineTransformIdentity;
                    break;
            }
        }else
        {
            cellAttributes.transform = CGAffineTransformIdentity;
        }
    }
    return attributesInRect;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect visiableRect ;
    visiableRect.size = self.collectionView.frame.size;

    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2;
    UICollectionViewLayoutAttributes * attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    if (confirmTransform == YES)
    {
        switch (cellType) {
            case VIPRightUpgradePage:
                [self modifyAttributes:attributes centerX:centerX];
                break;
            default:
                attributes.transform = CGAffineTransformIdentity;
                break;
        }
    }else
    {
        attributes.transform = CGAffineTransformIdentity;
    }
//    UICollectionViewCell * cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//    if ([cell isKindOfClass:[VIPRightUpgradeCell class]] || (self.minimumLineSpacing == -60))
//    {
//        [self modifyAttributes:attributes centerX:centerX];
//    }else
//    {
//        attributes.transform = CGAffineTransformIdentity;
//    }
    return attributes;
}
- (void)modifyAttributes:(UICollectionViewLayoutAttributes*)attributes centerX:(CGFloat)centerX
{
    CGFloat activeDistance = SCREEN_WIDTH * 0.75;//中心點距離多少就開始變形
    CGFloat scaleFactor = 0.2;//變形大小
    CGFloat itemCenterX = attributes.center.x;
    if (ABS(itemCenterX -centerX) <= activeDistance)
    {
        CGFloat ratio = ABS(itemCenterX - centerX) / activeDistance;
        CGFloat scale = 1 + scaleFactor * (1 - ratio);
        attributes.transform3D = CATransform3DMakeScale(scale, scale, 1.0);
    }else
    {
        attributes.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }
}
@end
