//
//  BTTWithdrawRecordController.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 05/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTWithdrawRecordController.h"
#import "BTTWithdrawHeaderCell.h"
#import "BTTWithdrawHeaderTwoCell.h"
#import "BTTWithdrawRecordCell.h"
#import "BTTWithdrawRecordController+LoadData.h"
#import "BTTWithdrawRecordModel.h"
#import "BRPickerView.h"
#import "BTTPromoRecordFooterView.h"

@interface BTTWithdrawRecordController ()<BTTElementsFlowLayoutDelegate>
@property(nonatomic, copy)NSString * sortTypeStr;
@property (nonatomic, strong)BTTPromoRecordFooterView * footerView;
@property (nonatomic, strong) NSMutableDictionary * cellDic;
@property (nonatomic, assign) BOOL isSelectAll;
@end

@implementation BTTWithdrawRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"取款记录";
    self.isSelectAll = false;
    self.requestIdArr = [[NSMutableArray alloc] init];
    self.modelArr = [[NSMutableArray alloc] init];
    self.cellDic = [[NSMutableDictionary alloc] init];
    self.pageNo = 1;
    [self setupCollectionView];
    [self showLoading];
    [self loadRecords];
    [self loadmoreWithBlock:^{
        self.pageNo+=1;
        [self showLoading];
        [self loadRecords];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAll:) name:@"SELECTALL" object:nil];
}

-(void)selectAll:(NSNotification *)notification {
    self.isSelectAll = [notification.object isEqualToString:@"0"]? true:false;
    [self.collectionView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.footerView = [[BTTPromoRecordFooterView alloc] init];
    [self.view addSubview:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.offset(KIsiPhoneX ? 22+40 : 40);
    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.footerView.mas_top);
    }];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTWithdrawHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTWithdrawHeaderCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTWithdrawHeaderTwoCell" bundle:nil] forCellWithReuseIdentifier:@"BTTWithdrawHeaderTwoCell"];
    
    weakSelf(weakSelf);
    [self.footerView setAllBtnClickBlock:^(BOOL selected) {
        strongSelf(strongSelf);
        [strongSelf.requestIdArr removeAllObjects];
        if (selected) {
            if (strongSelf.requestIdArr.count == strongSelf.modelArr.count ) {
                return;
            }
             for (BTTWithdrawRecordItemModel * model in strongSelf.modelArr) {
                 if (!(model.flag == 0 || model.flag == 9)) {
                     [strongSelf.requestIdArr addObject:model.requestId];
                 }
             }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SELECTALL" object:selected? @"0":@"1"];
    }];
    
    [self.footerView setCancelBtnClickBlock:^{
        strongSelf(strongSelf);
        if (strongSelf.requestIdArr.count == 0) {
            [MBProgressHUD showError:@"没有可删除的选项" toView:nil];
            return;
        }
        strongSelf.deleteParams = [[NSMutableDictionary alloc] init];
        strongSelf.deleteParams[@"requestIds"] = strongSelf.requestIdArr;
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要删除选中的记录吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [strongSelf showLoading];
            [strongSelf deleteRecords];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:confirm];
        [alertVC addAction:cancel];
        [strongSelf presentViewController:alertVC animated:YES completion:nil];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BTTWithdrawHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTWithdrawHeaderCell" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 1) {
        BTTWithdrawHeaderTwoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTWithdrawHeaderTwoCell" forIndexPath:indexPath];
        return cell;
    }
    else {
        
        NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
        if (identifier == nil) {
            identifier = [NSString stringWithFormat:@"%@%@", @"BTTWithdrawRecordCell", [NSString stringWithFormat:@"%@", indexPath]];
            [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
            [self.collectionView registerNib:[UINib nibWithNibName:@"BTTWithdrawRecordCell" bundle:nil] forCellWithReuseIdentifier:identifier];
        }
        BTTWithdrawRecordCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        BTTWithdrawRecordItemModel * model = self.modelArr[indexPath.row-2];
        [cell setData:model];
        if (cell.checkBtn.enabled) {
            [cell.checkBtn setSelected:self.isSelectAll];
        }
        weakSelf(weakSelf);
        [cell setCheckBtnClickBlock:^(NSString * _Nonnull requestId, BOOL selected) {
            strongSelf(strongSelf);
            if (selected) {
                [strongSelf.requestIdArr addObject:requestId];
            } else {
                for (NSString * str in strongSelf.requestIdArr) {
                    if ([str isEqualToString:requestId]) {
                        [strongSelf.requestIdArr removeObject:str];
                        break;
                    }
                }
            }
            [strongSelf.footerView allBtnselect:strongSelf.requestIdArr.count == strongSelf.modelArr.count];
        }];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        BTTWithdrawHeaderCell *cell = (BTTWithdrawHeaderCell *)[collectionView cellForItemAtIndexPath:indexPath];
        weakSelf(weakSelf);
        [BRStringPickerView showStringPickerWithTitle:@"" dataSource:@[@"全部", @"受理中",@"待审核",@"支付中",@"完成", @"拒绝", @"取消"] defaultSelValue:cell.typeLab.text resultBlock:^(id selectValue, NSInteger index) {
            strongSelf(strongSelf);
            [strongSelf selectSortType:index];
            cell.typeLab.text = selectValue;
        }];
    } else {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
}

-(void)selectSortType:(NSInteger)index {
    // 0->全部 1->受理中 2->待审核 3->支付中 4->完成 5->拒绝 6->取消
    switch (index) {
        case 1:
            self.sortTypeStr = [NSString stringWithFormat:@"%d", 0];
            break;
        case 2:
            self.sortTypeStr = [NSString stringWithFormat:@"%d", 9];
            break;
        case 3:
            self.sortTypeStr = [NSString stringWithFormat:@"%d", 1];
            break;
        case 4:
            self.sortTypeStr = [NSString stringWithFormat:@"%d", 2];
            break;
        case 5:
            self.sortTypeStr = [NSString stringWithFormat:@"%d", -3];
            break;
        case 6:
            self.sortTypeStr = [NSString stringWithFormat:@"%d", -2];
            break;
        default:
            self.sortTypeStr = [NSString stringWithFormat:@"%d", 0];
            break;
    }
    if (index == 0) {
        self.params[@"flags"] = [[NSArray alloc] init];
    } else {
        self.params[@"flags"] = [NSArray arrayWithObject:self.sortTypeStr];
    }
    [self showLoading];
    [self loadRecords];
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
    return 0;
}

- (void)setupElements {
    
    if (self.elementsHight.count) {
        [self.elementsHight removeAllObjects];
    }
    self.footerView.totalAmount = @"0.00";
    for (BTTWithdrawRecordItemModel * model in self.modelArr) {
        [self.footerView calculateAmount:model.amount];
    }
    
    NSInteger total = self.modelArr.count + 2;
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        if (i == 0) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 50)]];
        } else if (i == 1) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 30)]];
        } else {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 60)]];
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.modelArr.count < self.pageNo * 10) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self endRefreshing];
        }
        [self.requestIdArr removeAllObjects];
        [self.footerView allBtnselect:false];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SELECTALL" object:@"1"];
        [self.collectionView reloadData];
    });
}

@end
