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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewH;
/// 今日可以使用该通道
@property (weak, nonatomic) IBOutlet UILabel *allowUseCount;
/// 今日可以取消/超时次数
@property (weak, nonatomic) IBOutlet UILabel *allowCancelCount;

@property (weak, nonatomic) IBOutlet UIButton *depositBtn;

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;
@property (weak, nonatomic) IBOutlet UIButton *recommendBtn;

/// 金额列表
@property (nonatomic, copy) NSArray *amountList;
/// 推荐金额列表
@property (nonatomic, copy) NSArray *recommendAmountList;
/// 推荐金额
@property (nonatomic, copy) NSString *recommendAmount;
/// 选中金额
@property (nonatomic, copy) NSString *selectAmount;
@end

@implementation CNMFastPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    self.amountList = @[@"500", @"1000", @"2000", @"5000", @"10000", @"50000"];
    self.recommendAmountList = @[@"2000", @"5000"];
    self.collectionViewH.constant = 80 * ceilf(self.amountList.count/3.0);
}
    
- (void)setupUI {
    [self setViewHeight:650 fullScreen:NO];
    
    self.buttonView.hidden = YES;
    self.continueBtn.layer.borderWidth = 1;
    self.continueBtn.layer.borderColor = kHexColor(0xF7F952).CGColor;
    self.continueBtn.layer.cornerRadius = 8;
    self.depositBtn.enabled = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:kCNMAmountSelectCCell bundle:nil] forCellWithReuseIdentifier:kCNMAmountSelectCCell];
}

- (IBAction)depositAction:(UIButton *)sender {
    NSLog(@"====%@", self.selectAmount);
}

- (IBAction)recommendAction:(UIButton *)sender {
    self.selectAmount = self.recommendAmount;
    [self depositAction:self.depositBtn];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.amountList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CNMAmountSelectCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCNMAmountSelectCCell forIndexPath:indexPath];
    NSString *amount = self.amountList[indexPath.row];
    cell.amountLb.text = amount;
    cell.recommendTag.hidden = ![self.recommendAmountList containsObject:amount];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectAmount = self.amountList[indexPath.row];
    // 判断是否推荐
    BOOL recommend = [self.recommendAmountList containsObject:self.selectAmount];
    if (recommend) {
        self.buttonView.hidden = YES;
        self.depositBtn.enabled = YES;
        self.depositBtn.hidden = NO;
        self.warningView.hidden = YES;
        self.warningViewH.constant = 0;
    } else {
        self.buttonView.hidden = NO;
        self.depositBtn.hidden = YES;
        self.warningView.hidden = NO;
        self.warningViewH.constant = 40;
        
        // 计算合理推荐金额
        self.recommendAmount = [self getRecommendAmountFromAmount:self.selectAmount];
        [self.continueBtn setTitle:[NSString stringWithFormat:@"继续存%@元", self.selectAmount] forState:UIControlStateNormal];
        [self.recommendBtn setTitle:[NSString stringWithFormat:@"存%@元", self.recommendAmount] forState:UIControlStateNormal];
        self.warningLb.text = [NSString stringWithFormat:@"存款 %@ 的用户过多，为了确保存款快速到账，推荐您选择 %@ 元存款金额。", self.selectAmount, self.recommendAmount];
    }
}

/// 计算合理推荐金额
- (NSString *)getRecommendAmountFromAmount:(NSString *)amount {
    if ([self.recommendAmountList containsObject:amount]) {
        return amount;
    }
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.recommendAmountList];
    [array addObject:amount];
    
    NSArray *sortArr = [array sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
        if (obj1.intValue > obj2.intValue) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    NSInteger index = [sortArr indexOfObject:amount];
    if (index == (sortArr.count-1)) {
        return sortArr[index-1];
    } else {
        return sortArr[index+1];
    }
}
@end
