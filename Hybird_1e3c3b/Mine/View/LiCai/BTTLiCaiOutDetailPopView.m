//
//  BTTLiCaiOutDetailPopView.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/28/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTLiCaiOutDetailPopView.h"
#import "BTTLiCaiOutDetailPopViewCell.h"

@interface BTTLiCaiOutDetailPopView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (weak, nonatomic) IBOutlet UIView *collectionTopLine;
@property (weak, nonatomic) IBOutlet UIButton *transferBtn;

@end

@implementation BTTLiCaiOutDetailPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    CGFloat height = KIsiPhoneX ? 355:320;
    self.whiteView.frame = CGRectMake(0, self.frame.size.height + height, SCREEN_WIDTH, height);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.whiteView.frame = CGRectMake(0, self.frame.size.height - height, SCREEN_WIDTH, height);
    } completion:nil];
    
    [self.whiteView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionTopLine.mas_bottom);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.transferBtn.mas_top).offset(-10);
    }];
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    if (self.closeBtnClickBlock) {
        self.closeBtnClickBlock(sender);
    }
}

- (IBAction)btnClick:(UIButton *)sender {
    if (self.transferOutBtnClickBlock) {
        self.transferOutBtnClickBlock(sender);
    }
}

-(void)setModelArr:(NSMutableArray<BTTLiCaiTransferRecordItemModel *> *)modelArr {
    _modelArr = modelArr;
    [self.collectionView reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    BTTLiCaiOutDetailPopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTLiCaiOutDetailPopViewCell" forIndexPath:indexPath];
    cell.endDateStr = self.serverTimeStr;
    cell.model = self.modelArr[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;  //行间距
        flowLayout.minimumInteritemSpacing = 0; //列间距
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, 50); //固定的itemsize
        flowLayout.headerReferenceSize = CGSizeMake(0, 0);
        //初始化 UICollectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_collectionView registerNib:[UINib nibWithNibName:@"BTTLiCaiOutDetailPopViewCell" bundle:nil] forCellWithReuseIdentifier:@"BTTLiCaiOutDetailPopViewCell"];
        _collectionView.delegate = self; //设置代理
        _collectionView.dataSource = self;   //设置数据来源
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;   //设置弹跳
    }
    return _collectionView;
}

@end
