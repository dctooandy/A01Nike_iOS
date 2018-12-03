//
//  CNPayBankView.m
//  Hybird_A01
//
//  Created by cean.q on 2018/11/29.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "CNPayBankView.h"
#import "CNPayDepostiBankCell.h"
#import "CNPayRequestManager.h"
#import "CNPayDepositNameModel.h"

#define kBankCellIndentifier  @"CNPayDepostiBankCell"

@interface CNPayBankView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *chargeBtn;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (copy, nonatomic) NSMutableArray <CNPayDepositNameModel *> *modelArray;
@end

@implementation CNPayBankView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadViewFromXib];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self loadViewFromXib];
    }
    return self;
}

- (void)loadViewFromXib {
    UIView *contentView = [[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    if (!contentView) {
        return;
    }
    contentView.frame = self.bounds;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    [self addSubview:contentView];
    [self.collectionView registerNib:[UINib nibWithNibName:kBankCellIndentifier bundle:nil] forCellWithReuseIdentifier:kBankCellIndentifier];
}

#pragma mark- UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CNPayDepostiBankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBankCellIndentifier forIndexPath:indexPath];
    
    CNPayDepositNameModel *model = _modelArray[indexPath.row];
    [cell updateContent:model];
    cell.deteletBtn.hidden = !self.chargeBtn.selected;
    __weak typeof(self) weakSelf = self;
    cell.deleteHandler = ^{
        [weakSelf removeItem:indexPath.row];
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(315, 115);
}

- (IBAction)submit:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.collectionView reloadData];
}

- (void)reloadData:(NSArray *)array {
    _modelArray = [array mutableCopy];
    [self.collectionView reloadData];
}

- (void)removeItem:(NSInteger)index {
    CNPayDepositNameModel *model = _modelArray[index];
    __weak typeof(self) weakSelf = self;
    [CNPayRequestManager paymentDeleteDepositNameWithId:model.request_id CompleteHandler:^(IVRequestResultModel *result, id response) {
        if (result.data) {
            [weakSelf.modelArray removeObject:model];
            [weakSelf.collectionView reloadData];
        }
    }];
}
@end
