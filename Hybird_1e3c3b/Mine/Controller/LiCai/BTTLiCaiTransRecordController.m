//
//  BTTLiCaiTransRecordController.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/27/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTLiCaiTransRecordController.h"
#import "BTTLiCaiTransRecordTopBtnView.h"
#import "BTTLiCaiRecordCell.h"
#import "BTTLiCaiInterestRateBillCell.h"
#import "BTTVideoGamesNoDataCell.h"
#import "BTTLiCaiTransRecordController+LoadData.h"

@interface BTTLiCaiTransRecordController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, strong) BTTLiCaiTransRecordTopBtnView *btnView;
@property (nonatomic, copy) NSArray *titleArr;

@end

@implementation BTTLiCaiTransRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转账记录";
    self.titleArr = @[@"转出时间", @"订单编号", @"状态", @"金额"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.page = 1;
    self.modelArr = [[NSMutableArray alloc] init];
    [self loadRecords];
    weakSelf(weakSelf);
    [self loadmoreWithBlock:^{
        strongSelf(strongSelf);
        strongSelf.page+=1;
        [strongSelf loadRecords];
    }];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.btnView = [BTTLiCaiTransRecordTopBtnView viewFromXib];
    [self.view addSubview:self.btnView];
    [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(117);
        make.width.offset(SCREEN_WIDTH);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(0);
    }];
    
    weakSelf(weakSelf);
    self.btnView.typeBtnClickBlock = ^(UIButton * _Nonnull button) {
        //0->out 1->in 2->bill
        [weakSelf.modelArr removeAllObjects];
        switch (button.tag) {
            case 0:
                weakSelf.titleArr = @[@"转出时间", @"订单编号", @"状态", @"金额"];
                weakSelf.transferType = 2;
                [weakSelf loadRecords];
                break;
            case 1:
                weakSelf.titleArr = @[@"转入时间", @"订单编号", @"状态", @"金额"];
                weakSelf.transferType = 1;
                [weakSelf loadRecords];
                break;
            case 2:
                weakSelf.titleArr = @[@"利息账单时间", @"订单编号", @"状态", @"利息", @"年利率", @"计息时长"];
                [weakSelf setupElements];
                break;
                
            default:
                break;
        }
    };
    
    self.btnView.dayBtnClickBlock = ^(UIButton * _Nonnull button) {
        //0->1 1->7 2->halfYear 3->oneYear
        [weakSelf.modelArr removeAllObjects];
        switch (button.tag) {
            case 0:
                weakSelf.lastDays = 1;
                break;
            case 1:
                weakSelf.lastDays = 7;
                break;
            case 2:
                weakSelf.lastDays = 183;
                break;
            case 3:
                weakSelf.lastDays = 365;
                break;
                
            default:
                break;
        }
        [weakSelf loadRecords];
    };
    
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTLiCaiRecordCell" bundle:nil] forCellWithReuseIdentifier:@"BTTLiCaiRecordCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTLiCaiInterestRateBillCell" bundle:nil] forCellWithReuseIdentifier:@"BTTLiCaiInterestRateBillCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTVideoGamesNoDataCell" bundle:nil] forCellWithReuseIdentifier:@"BTTVideoGamesNoDataCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.btnView.billBtn.selected) {
        BTTLiCaiInterestRateBillCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTLiCaiInterestRateBillCell" forIndexPath:indexPath];
        return cell;
    } else {
        if (self.modelArr.count > 0) {
            BTTLiCaiRecordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTLiCaiRecordCell" forIndexPath:indexPath];
            cell.titleArr = self.titleArr;
            cell.model = self.modelArr[indexPath.row];
            return cell;
        } else {
            BTTVideoGamesNoDataCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesNoDataCell" forIndexPath:indexPath];
            return cell;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - LMJCollectionViewControllerDataSource

- (UICollectionViewLayout *)collectionViewController:(BTTCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView {
    BTTCollectionViewFlowlayout *elementsFlowLayout = [[BTTCollectionViewFlowlayout alloc] initWithDelegate:self];
    return elementsFlowLayout;
}

#pragma mark - LMJElementsFlowLayoutDelegate

- (CGSize)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.elementsHight[indexPath.item].CGSizeValue;
}

- (UIEdgeInsets)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/**
 *  列间距, 默认10
 */
- (CGFloat)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView columnsMarginForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

/**
 *  行间距, 默认10
 */
- (CGFloat)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 10;
}

- (void)setupElements {
    if (self.elementsHight.count) {
        [self.elementsHight removeAllObjects];
    }
    NSInteger total = self.btnView.billBtn.selected? 4:self.modelArr.count;
    if (total == 0) {
        total = 1;
    }
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        if (self.btnView.billBtn.selected) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 138)]];
        } else {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 111)]];
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.modelArr.count < self.page * 10) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self endRefreshing];
        }
        [self.collectionView reloadData];
    });
}

@end
