//
//  BTTHomePageAppsCell.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/11.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTHomePageAppsCell.h"
#import "BTTAppCollectionViewCell.h"
#import "BTTAppIconModel.h"

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
    return self.appsIcons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BTTAppCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTAppCollectionViewCell" forIndexPath:indexPath];
    BTTAppIconModel *model = self.appsIcons[indexPath.row];
    cell.appIconModel = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BTTAppIconModel *model = self.appsIcons[indexPath.row];
}

- (NSMutableArray *)appsIcons {
    if (!_appsIcons) {
        _appsIcons = [NSMutableArray array];
        NSArray *titles = @[@"AG旗舰厅",@"AG国际厅",@"捕鱼王",@"PT电游",@"MG电游",@"AG快乐彩",@"德州扑克"];
        NSArray *images = @[@"APP_AGQJ",@"APP_AGIN",@"APP_FishingKing",@"APP_PT",@"APP_MG",@"APP_Lottery",@"APP_Texaspoker"];
        NSArray *urls = @[@"https://www.aggameapp.com/home.jsp?pd=Z0EwMWg",@"",@"http://hunter2.agmjs.com/?pid=A01",@"",@"",@"https://www.aggameapp.com/lottery.jsp?pd=Z0EwMWg=",@"https://m.bx827.com/dzpk_agent.html"];
        for (NSString *name in titles) {
            NSInteger index = [titles indexOfObject:name];
            NSString *imageName = images[index];
            NSString *url = urls[index];
            BTTAppIconModel *model = [[BTTAppIconModel alloc] init];
            model.name = name;
            model.icon = imageName;
            model.url = url;
            [_appsIcons addObject:model];
        }
    }
    return _appsIcons;
}


@end
