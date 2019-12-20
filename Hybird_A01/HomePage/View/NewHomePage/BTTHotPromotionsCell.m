//
//  BTTHotPromotionsCell.m
//  Hybird_A01
//
//  Created by Domino on 13/11/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTHotPromotionsCell.h"
#import "BTTHotPromotionCell.h"
#import "BTTPromotionModel.h"

@interface BTTHotPromotionsCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation BTTHotPromotionsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHotPromotionCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHotPromotionCell"];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = COLOR_RGBA(41, 45, 54, 1);
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(142.5, 75);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 15;
    self.collectionView.collectionViewLayout = layout;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.promotions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BTTHotPromotionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHotPromotionCell" forIndexPath:indexPath];
    BTTPromotionModel *model = self.promotions[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BTTPromotionModel *model = self.promotions[indexPath.row];
    if (self.clickEventBlock) {
        self.clickEventBlock(model);
    }
}

- (void)setPromotions:(NSMutableArray *)promotions {
    _promotions = promotions;
    [self.collectionView reloadData];
}

- (IBAction)moreBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}
@end
