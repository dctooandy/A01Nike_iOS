//
//  BTTUSDTItemCell.m
//  Hybird_A01
//
//  Created by Domino on 24/12/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTUSDTItemCell.h"
#import "BTTUSDTButton.h"
#import "CNPayConstant.h"
#import "USDTWalletCollectionCell.h"

@interface BTTUSDTItemCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) NSMutableArray *nameArray;
@property (weak, nonatomic) IBOutlet UIView *walletView;
@property (nonatomic, strong) UICollectionView *walletCollectionView;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation BTTUSDTItemCell

- (UICollectionView *)walletCollectionView
{
    if (!_walletCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 4;  //行间距
        flowLayout.minimumInteritemSpacing = 15; //列间距
//        flowLayout.estimatedItemSize = CGSizeMake((SCREEN_WIDTH-60)/3, 36);  //预定的itemsize
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-60)/3, 36); //固定的itemsize
        flowLayout.headerReferenceSize = CGSizeMake(0, 43);
        //初始化 UICollectionView
        _walletCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _walletCollectionView.delegate = self; //设置代理
        _walletCollectionView.dataSource = self;   //设置数据来源
        _walletCollectionView.backgroundColor = kBlackLightColor;
        
        [_walletCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
 
        _walletCollectionView.bounces = NO;   //设置弹跳
        _walletCollectionView.alwaysBounceVertical = NO;  //只允许垂直方向滑动
        //注册 cell  为了cell的重用机制  使用NIB  也可以使用代码 registerClass xxxx
        [_walletCollectionView registerClass:[USDTWalletCollectionCell class] forCellWithReuseIdentifier:@"USDTWalletCollectionCell"];
    }
    return _walletCollectionView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.walletCollectionView.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, 170);
    [self.walletView addSubview:self.walletCollectionView];
    

}


- (void)resetAllBtnWithTag:(NSInteger)tag {
    for (int i = 0; i < 9; i ++) {
        BTTUSDTButton *btn1 = (BTTUSDTButton *)[self viewWithTag:i + 1000];
        btn1.selected = NO;
        BTTUSDTButton *btn = (BTTUSDTButton *)[self viewWithTag:tag];
        if (!btn.selected) {
            btn.selected = YES;
        }
    }
}

-(void)setUsdtDatasWithArray:(NSArray *)usdtDatas{
    self.imgArray = [[NSMutableArray alloc]init];
    self.nameArray = [[NSMutableArray alloc]init];
    self.usdtDatas = usdtDatas;
    for (int i = 0; i<usdtDatas.count; i++) {
        NSDictionary *dict = usdtDatas[i];
        NSString *dictCode = [NSString stringWithFormat:@"%@",dict[@"dictCode"]];
        if ([dictCode containsString:@"other"]) {
            [self.imgArray addObject:@"me_usdt_otherwallet"];
            [self.nameArray addObject:@"其它钱包"];
        }else{
            [self.imgArray addObject:[NSString stringWithFormat:@"me_usdt_%@",dictCode]];
            [self.nameArray addObject:dictCode];
        }
        if (i==usdtDatas.count-1) {
            [self.walletCollectionView reloadData];
            [self.walletCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.usdtDatas.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectPayType) {
        self.selectPayType(indexPath.row);
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    USDTWalletCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"USDTWalletCollectionCell" forIndexPath:indexPath];
    [cell setCellWithName:_nameArray[indexPath.row] imageName:_imgArray[indexPath.row]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                withReuseIdentifier:@"UICollectionViewHeader"
                                                                                       forIndexPath:indexPath];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, 60, 14)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"推荐钱包";
    [headView addSubview:titleLabel];
        
    return headView;
}

@end
