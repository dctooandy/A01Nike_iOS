//
//  BTTHomePageAppsCell.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/11.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTHomePageAppsCell.h"
#import "BTTAppCollectionViewCell.h"
#import "BTTDownloadModel.h"

@interface BTTHomePageAppsCell ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *appsIcons;

@end

@implementation BTTHomePageAppsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTAppCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BTTAppCollectionViewCell"];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = COLOR_RGBA(41, 45, 54, 1);
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(78, 110);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 15;
    self.collectionView.collectionViewLayout = layout;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.downloads.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BTTAppCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTAppCollectionViewCell" forIndexPath:indexPath];
    BTTDownloadModel *model = self.downloads[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BTTDownloadModel *model = self.downloads[indexPath.row];
    if (self.clickEventBlock) {
        self.clickEventBlock(model);
    }
}

- (void)setDownloads:(NSArray *)downloads {
    _downloads = downloads;
    [self.collectionView reloadData];
}



@end
