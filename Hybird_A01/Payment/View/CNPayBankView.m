//
//  CNPayBankView.m
//  Hybird_A01
//
//  Created by cean.q on 2018/11/29.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "CNPayBankView.h"
#import "CNPayDepostiBankCell.h"

#define kBankCellIndentifier  @"CNPayDepostiBankCell"

@interface CNPayBankView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *chargeBtn;
@property (weak, nonatomic) IBOutlet UILabel *label;

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
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CNPayDepostiBankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBankCellIndentifier forIndexPath:indexPath];
    cell.deteletBtn.hidden = !self.chargeBtn.selected;
    cell.deleteHandler = ^{
        
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

@end
