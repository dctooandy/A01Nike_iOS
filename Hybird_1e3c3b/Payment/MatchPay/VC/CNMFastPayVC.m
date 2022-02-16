//
//  CNMFastPayVC.m
//  Hybird_1e3c3b
//
//  Created by cean on 2/16/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNMFastPayVC.h"
#import "CNMAmountSelectCCell.h"

#define kCNMAmountSelectCCell  @"CNMAmountSelectCCell"

@interface CNMFastPayVC () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *warningView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warningViewH;
@property (weak, nonatomic) IBOutlet UILabel *warningLb;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/// 今日可以使用该通道
@property (weak, nonatomic) IBOutlet UILabel *allowUseCount;
/// 今日可以取消/超时次数
@property (weak, nonatomic) IBOutlet UILabel *allowCancelCount;

@property (weak, nonatomic) IBOutlet UIButton *depositBtn;

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;
@property (weak, nonatomic) IBOutlet UIButton *recommendBtn;

@end

@implementation CNMFastPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewHeight:650 fullScreen:NO];
    
    self.buttonView.hidden = YES;
    self.depositBtn.enabled = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:kCNMAmountSelectCCell bundle:nil] forCellWithReuseIdentifier:kCNMAmountSelectCCell];
}

- (IBAction)depositAction:(UIButton *)sender {
    NSLog(@"cunkun");
}

- (IBAction)continueAction:(UIButton *)sender {
    
}

- (IBAction)recommendAction:(UIButton *)sender {
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CNMAmountSelectCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCNMAmountSelectCCell forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.buttonView.hidden) {
        
        
        return;
    }
    // 点击任何直接支付
    [self depositAction:self.depositBtn];
}
@end
