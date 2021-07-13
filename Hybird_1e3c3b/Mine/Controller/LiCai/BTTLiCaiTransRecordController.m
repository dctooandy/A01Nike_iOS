//
//  BTTLiCaiTransRecordController.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/27/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTLiCaiTransRecordController.h"
#import "BTTLiCaiTransRecordTopBtnView.h"
#import "BTTLiCaiInterestRateBillCell.h"
#import "BTTVideoGamesNoDataCell.h"
#import "BTTLiCaiInRecordCell.h"
#import "BTTLiCaiOutRecordCell.h"
#import "BTTLiCaiTransRecordController+LoadData.h"
#import "CLive800Manager.h"

@interface BTTLiCaiTransRecordController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, strong) BTTLiCaiTransRecordTopBtnView *btnView;
@property (nonatomic, copy) NSArray *titleArr;

@end

@implementation BTTLiCaiTransRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转账记录";
    self.titleArr = @[@"转出时间", @"订单编号", @"状态", @"转出金额", @"本金", @"利息"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.page = 1;
    self.modelArr = [[NSMutableArray alloc] init];
    self.interestModelArr = [[NSMutableArray alloc] init];
    [self setUpNav];
    [self loadRecords];
    weakSelf(weakSelf);
    [self loadmoreWithBlock:^{
        strongSelf(strongSelf);
        strongSelf.page+=1;
        if (weakSelf.btnView.billBtn.selected) {
            [weakSelf loadInterestRecords];
        } else {
            [weakSelf loadRecords];
        }
    }];
}

-(void)setUpNav {
    UIButton * rightBtn = [[UIButton alloc] init];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    rightBtn.adjustsImageWhenHighlighted = false;
    [rightBtn setTitle:@" 咨询客服" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"homepage_service"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(kefuBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

-(void)kefuBtnAction {
    [CSVisitChatmanager startWithSuperVC:self finish:^(CSServiceCode errCode) {
        if (errCode != CSServiceCode_Request_Suc) {//异常处理
            BTTActionSheet *actionSheet = [[BTTActionSheet alloc] initWithTitle:@"请选择问题类型" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"存款问题",@"其他问题"] actionSheetBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    [[CLive800Manager sharedInstance] startLive800ChatSaveMoney:self];
                }else if (buttonIndex == 1){
                    [[CLive800Manager sharedInstance] startLive800Chat:self];
                }
            }];
            [actionSheet show];
        }
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
        [weakSelf.interestModelArr removeAllObjects];
        switch (button.tag) {
            case 0:
                weakSelf.titleArr = @[@"转出时间", @"订单编号", @"状态", @"转出金额", @"本金", @"利息"];
                weakSelf.page = 1;
                weakSelf.transferType = 2;
                [weakSelf loadRecords];
                break;
            case 1:
                weakSelf.titleArr = @[@"转入时间", @"订单编号", @"状态", @"转入金额", @"余额"];
                weakSelf.page = 1;
                weakSelf.transferType = 1;
                [weakSelf loadRecords];
                break;
            case 2:
                weakSelf.titleArr = @[@"利息账单时间", @"订单编号", @"状态", @"利息", @"年利率", @"计息时长"];
                weakSelf.page = 1;
                [weakSelf loadInterestRecords];
                break;
                
            default:
                break;
        }
    };
    
    self.btnView.dayBtnClickBlock = ^(UIButton * _Nonnull button) {
        //0->1 1->7 2->halfYear 3->oneYear
        [weakSelf.modelArr removeAllObjects];
        [weakSelf.interestModelArr removeAllObjects];
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
        weakSelf.page = 1;
        if (weakSelf.btnView.billBtn.selected) {
            [weakSelf loadInterestRecords];
        } else {
            [weakSelf loadRecords];
        }
    };
    
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTLiCaiInterestRateBillCell" bundle:nil] forCellWithReuseIdentifier:@"BTTLiCaiInterestRateBillCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTVideoGamesNoDataCell" bundle:nil] forCellWithReuseIdentifier:@"BTTVideoGamesNoDataCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTLiCaiInRecordCell" bundle:nil] forCellWithReuseIdentifier:@"BTTLiCaiInRecordCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTLiCaiOutRecordCell" bundle:nil] forCellWithReuseIdentifier:@"BTTLiCaiOutRecordCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.btnView.billBtn.selected) {
        if (self.interestModelArr.count > 0) {
            BTTLiCaiInterestRateBillCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTLiCaiInterestRateBillCell" forIndexPath:indexPath];
            cell.model = self.interestModelArr[indexPath.row];
            return cell;
        } else {
            BTTVideoGamesNoDataCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesNoDataCell" forIndexPath:indexPath];
            cell.noDataLabel.text = @"暂无记录";
            return cell;
        }
        
    } else if(self.btnView.outRecordBtn.selected) {
        if (self.modelArr.count > 0) {
            BTTLiCaiOutRecordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTLiCaiOutRecordCell" forIndexPath:indexPath];
            cell.titleArr = self.titleArr;
            cell.model = self.modelArr[indexPath.row];
            return cell;
        } else {
            BTTVideoGamesNoDataCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesNoDataCell" forIndexPath:indexPath];
            cell.noDataLabel.text = @"暂无记录";
            return cell;
        }
        
    } else {
        if (self.modelArr.count > 0) {
            BTTLiCaiInRecordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTLiCaiInRecordCell" forIndexPath:indexPath];
            cell.titleArr = self.titleArr;
            cell.model = self.modelArr[indexPath.row];
            return cell;
        } else {
            BTTVideoGamesNoDataCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVideoGamesNoDataCell" forIndexPath:indexPath];
            cell.noDataLabel.text = @"暂无记录";
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
    NSInteger total = 0;
    NSInteger height = 138;
    if (self.btnView.billBtn.selected) {
        total = self.interestModelArr.count;
    } else {
        total = self.modelArr.count;
    }
    if (total == 0) {
        total = 1;
        height = 111;
    }
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, height)]];
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (total < self.page * 10) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self endRefreshing];
        }
        [self.collectionView reloadData];
    });
}

@end
