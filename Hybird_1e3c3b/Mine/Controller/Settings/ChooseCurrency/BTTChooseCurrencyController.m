//
//  BTTChooseCurrencyController.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 26/11/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTChooseCurrencyController.h"
#import "BTTUserGameCurrencyModel.h"
#import "BTTChooseCurrencyCell.h"

@interface BTTChooseCurrencyController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *sheetDatas;
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@end

@implementation BTTChooseCurrencyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"游戏币种";
    [self setupCollectionView];
    self.sheetDatas = [[NSMutableArray alloc] initWithArray:[NSArray bg_arrayWithName:BTTGameCurrencysWithName]];
    if (self.sheetDatas.count == 0) {
        [self initSheetDatas];
        [self saveCurrencysArrToBGFMDB];
    }
    if (self.sheetDatas.count != BTTGameKeysArr.count) {
        [self updateCurrencysArrToBGFMDB];
        self.sheetDatas = [[NSMutableArray alloc] initWithArray:[NSArray bg_arrayWithName:BTTGameCurrencysWithName]];
    }
}

-(void)saveCurrencysArrToBGFMDB {
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    for (BTTUserGameCurrencyModel * model in self.sheetDatas) {
        [arr addObject:model];
    }
    [arr bg_saveArrayWithName:BTTGameCurrencysWithName];
}

-(void)initSheetDatas {
    self.sheetDatas = [[NSMutableArray alloc] init];
    NSArray *titles = BTTGameTitlesArr;
    NSArray *gameKeys = BTTGameKeysArr;
    for (NSString *gameKey in gameKeys) {
        NSInteger index = [gameKeys indexOfObject:gameKey];
        BTTUserGameCurrencyModel *model = [[BTTUserGameCurrencyModel alloc] init];
        model.title = titles[index];
        model.gameKey = gameKey;
        model.currency = @"";
        [_sheetDatas addObject:model];
    }
}

-(void)updateCurrencysArrToBGFMDB {
    NSMutableArray * saveArr = [[NSMutableArray alloc] init];
    if (self.sheetDatas.count < BTTGameKeysArr.count) {
        for (NSString * str in BTTGameKeysArr) {
            for (BTTUserGameCurrencyModel * model in self.sheetDatas) {
                if ([str isEqualToString:model.gameKey]) {
                    [saveArr addObject:model];
                    break;
                } else {
                    NSInteger index = [self.sheetDatas indexOfObject:model];
                    if (index == self.sheetDatas.count - 1) {
                        index = [BTTGameKeysArr indexOfObject:str];
                        BTTUserGameCurrencyModel * model = [[BTTUserGameCurrencyModel alloc] init];
                        model.title = BTTGameTitlesArr[index];
                        model.gameKey = str;
                        model.currency = @"";
                        [saveArr addObject:model];
                    }
                }
            }
        }
    } else {
        for (BTTUserGameCurrencyModel * model in self.sheetDatas) {
            for (NSString * str in BTTGameKeysArr) {
                if ([model.gameKey isEqualToString:str]) {
                    [saveArr addObject:model];
                    break;
                }
            }
        }
    }
    [NSArray bg_clearArrayWithName:BTTGameCurrencysWithName];
    [saveArr bg_saveArrayWithName:BTTGameCurrencysWithName];
}

- (void)setupCollectionView {
    [self.view addSubview:self.mainCollectionView];
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self.view);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sheetDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BTTChooseCurrencyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTChooseCurrencyCell" forIndexPath:indexPath];
    BTTUserGameCurrencyModel *model = self.sheetDatas[indexPath.row];
    cell.gameTitleStr = model.title;
    cell.model = model;
    [cell setBtnActionBlock:^(NSString * _Nonnull currencyStr) {
        model.currency = currencyStr;
        [NSArray bg_clearArrayWithName:BTTGameCurrencysWithName];
        [self saveCurrencysArrToBGFMDB];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                withReuseIdentifier:@"UICollectionViewHeader"
                                                                                       forIndexPath:indexPath];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-10, 15)];
        lab.textColor = [UIColor colorWithHexString:@"#818791"];
        lab.font = [UIFont boldSystemFontOfSize:13];
        lab.text = @"请您选择游戏时货币的展现方式:";
        lab.adjustsFontSizeToFitWidth = true;
        [headView addSubview:lab];
        return headView;
    } else {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                              withReuseIdentifier:@"UICollectionViewFooter"
                                                                                     forIndexPath:indexPath];
        UILabel *lab = [[UILabel alloc]init];
        lab.textColor = [UIColor colorWithHexString:@"#ffcc66"];
        lab.font = [UIFont boldSystemFontOfSize:13];
        lab.numberOfLines = 0;
        lab.text = @"温馨提示：选择游戏展现币种后，您进入游戏厅额度会自动按照汇率兑换";
        CGSize size = [lab sizeThatFits:CGSizeMake(SCREEN_WIDTH-10, CGFLOAT_MAX)];
        lab.frame = CGRectMake(10, 10, SCREEN_WIDTH-10, size.height);
        [footer addSubview:lab];
        return footer;
    }
}

// 设置Header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 35);
}

// 设置Footer的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 55);
}

- (UICollectionView *)mainCollectionView
{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;  //行间距
        flowLayout.minimumInteritemSpacing = 0; //列间距
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, 80); //固定的itemsize
        flowLayout.headerReferenceSize = CGSizeMake(0, 0);
        //初始化 UICollectionView
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_mainCollectionView registerNib:[UINib nibWithNibName:@"BTTChooseCurrencyCell" bundle:nil] forCellWithReuseIdentifier:@"BTTChooseCurrencyCell"];
        [_mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
        [_mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionViewFooter"];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.bounces = NO;
        _mainCollectionView.alwaysBounceVertical = NO;
    }
    return _mainCollectionView;
}

@end
