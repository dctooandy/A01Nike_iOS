//
//  BTTMeBigSaveMoneyCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 26/12/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTMeBigSaveMoneyCell.h"
#import "BTTMeSaveMoneyAlipayCell.h"
#import "BTTMeSaveMoneyWechatCell.h"
#import "BTTMeMainModel.h"

typedef enum {
    BTTMeBigSaveMoneyTypeNormal, ///< 通用模式
    BTTMeBigSaveMoneyTypeTen,    ///< 存款超过10次显示模式
}BTTMeBigSaveMoneyType;

@interface BTTMeBigSaveMoneyCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) BTTMeBigSaveMoneyType saveMoneyType;

@property (weak, nonatomic) IBOutlet UIButton *xiaozhushouBtn;


@end

@implementation BTTMeBigSaveMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTMeSaveMoneyWechatCell" bundle:nil] forCellWithReuseIdentifier:@"BTTMeSaveMoneyWechatCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTMeSaveMoneyAlipayCell" bundle:nil] forCellWithReuseIdentifier:@"BTTMeSaveMoneyAlipayCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
//    self.collectionView.backgroundColor = COLOR_RGBA(41, 45, 54, 1);
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(90, 160);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 15;
    self.collectionView.collectionViewLayout = layout;
//    BTTMeSaveMoneyShowTypeAll = 0,
//    BTTMeSaveMoneyShowTypeBig = 1,
//    BTTMeSaveMoneyShowTypeBigOneMore,
    if (self.saveMoneyShowType == BTTMeSaveMoneyShowTypeAll ||
        self.saveMoneyShowType == BTTMeSaveMoneyShowTypeBig ||
        self.saveMoneyShowType == BTTMeSaveMoneyShowTypeBigOneMore) {
        self.xiaozhushouBtn.hidden = YES;
    } else {
        self.xiaozhushouBtn.hidden = YES;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BTTMeMainModel *model = self.dataSource.count ? self.dataSource[indexPath.row] : nil;
//    if (indexPath.row == 0) {
        BTTMeSaveMoneyAlipayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeSaveMoneyAlipayCell" forIndexPath:indexPath];
        cell.model = model;
        return cell;
//    } else {
//        BTTMeSaveMoneyWechatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeSaveMoneyWechatCell" forIndexPath:indexPath];
//        cell.model = model;
//        return cell;
//    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    BTTMeMainModel *model = self.dataSource.count>0 ? self.dataSource[indexPath.row] : nil;
    if (model!=nil) {
        if (self.clickEventBlock) {
            self.clickEventBlock(model);
        }
    }
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    if (_dataSource.count > 2) {
        self.saveMoneyType = BTTMeBigSaveMoneyTypeTen;
    } else {
        self.saveMoneyType = BTTMeBigSaveMoneyTypeNormal;
    }
    [self.collectionView reloadData];
}
- (IBAction)assistantBtn_click:(id)sender {
    if (self.assistantTap) {
        self.assistantTap();
    }
}

@end
