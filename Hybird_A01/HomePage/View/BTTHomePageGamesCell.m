//
//  BTTHomePageGamesCell.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/11.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTHomePageGamesCell.h"
#import "BTTGameCollectionViewCell.h"

@interface BTTHomePageGamesCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *gameIcons;

@property (nonatomic, strong) NSMutableArray *gameNames;

@end

@implementation BTTHomePageGamesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTGameCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BTTGameCollectionViewCell"];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = COLOR_RGBA(41, 45, 54, 1);
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(150, 113);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 15;
    self.collectionView.collectionViewLayout = layout;
    [self registerNotification];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess:) name:LogoutSuccessNotification object:nil];
}

- (void)loginSuccess:(NSNotification *)notifi {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
}

- (void)logoutSuccess:(NSNotification *)notifi {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gameIcons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BTTGameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTGameCollectionViewCell" forIndexPath:indexPath];
    cell.gameIcon = self.gameIcons[indexPath.row];
    cell.gameName = self.gameNames[indexPath.row];
    return cell;
}


#pragma mark - getter

- (NSMutableArray *)gameIcons {
    if (!_gameIcons) {
        NSArray *games = @[@"AGQJ",@"AS",@"Chess",@"Fishing_king",@"game",@"shaba"];
        _gameIcons = [NSMutableArray arrayWithArray:games];
    }
    return _gameIcons;
}

- (NSMutableArray *)gameNames {
    if (!_gameNames) {
        NSArray *gameNames = @[@"AG旗舰厅",@"AS",@"棋牌",@"捕鱼王",@"电子游戏",@"沙巴体育"];
        _gameNames = [NSMutableArray arrayWithArray:gameNames];
    }
    return _gameNames;
}

@end
