//
//  BTTCreditRecordController.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 22/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTCreditRecordController.h"
#import "BTTCreditRecordController+LoadData.h"
#import "BTTPromoRecordFooterView.h"
#import "BTTCreditRecordHeaderCell.h"
#import "BTTCreditRecordCell.h"

@interface BTTCreditRecordController ()<BTTElementsFlowLayoutDelegate>
@property (nonatomic, strong)BTTPromoRecordFooterView * footerView;
@property (nonatomic, strong) NSMutableDictionary * cellDic;
@property (nonatomic, assign) BOOL isSelectAll;
@end

@implementation BTTCreditRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转账记录";
    self.isSelectAll = false;
    self.referenceIdsArr = [[NSMutableArray alloc] init];
    self.cellDic = [[NSMutableDictionary alloc] init];
    self.modelArr = [[NSMutableArray alloc] init];
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
    self.footerView.totalAmountLab.hidden = true;
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
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTCreditRecordHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTCreditRecordHeaderCell"];
    
    weakSelf(weakSelf);
    [self.footerView setAllBtnClickBlock:^(BOOL selected) {
        strongSelf(strongSelf);
        [strongSelf.referenceIdsArr removeAllObjects];
        if (selected) {
            if (strongSelf.referenceIdsArr.count == strongSelf.modelArr.count) {
                return;
            }
            for (BTTCreditRecordItemModel * model in strongSelf.modelArr) {
                [strongSelf.referenceIdsArr addObject:model.referenceId];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SELECTALL" object:selected? @"0":@"1"];
    }];
    
    [self.footerView setCancelBtnClickBlock:^{
        strongSelf(strongSelf);
        if (strongSelf.referenceIdsArr.count == 0) {
            [MBProgressHUD showError:@"没有可删除的选项" toView:nil];
            return;
        }
        strongSelf.deleteParams = [[NSMutableDictionary alloc] init];
        strongSelf.deleteParams[@"referenceIds"] = strongSelf.referenceIdsArr;
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
        BTTCreditRecordHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTCreditRecordHeaderCell" forIndexPath:indexPath];
        return cell;
    } else {
        NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
        if (identifier == nil) {
            identifier = [NSString stringWithFormat:@"%@%@", @"BTTCreditRecordCell", [NSString stringWithFormat:@"%@", indexPath]];
            [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
            [self.collectionView registerNib:[UINib nibWithNibName:@"BTTCreditRecordCell" bundle:nil] forCellWithReuseIdentifier:identifier];
        }
        BTTCreditRecordCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        [cell setData:self.modelArr[indexPath.row - 1]];
        if (cell.checkBtn.enabled) {
            [cell.checkBtn setSelected:self.isSelectAll];
        }
        weakSelf(weakSelf);
        [cell setCheckBtnClickBlock:^(NSString * _Nonnull requestId, BOOL selected) {
            strongSelf(strongSelf);
            if (selected) {
                [strongSelf.referenceIdsArr addObject:requestId];
            } else {
                for (NSString * str in strongSelf.referenceIdsArr) {
                    if ([str isEqualToString:requestId]) {
                        [strongSelf.referenceIdsArr removeObject:str];
                        break;
                    }
                }
            }
            [strongSelf.footerView allBtnselect:strongSelf.referenceIdsArr.count == strongSelf.modelArr.count];
        }];
        return cell;
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"%zd", indexPath.item);
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
    NSInteger total = self.modelArr.count + 1;
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        if (i == 0) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 30)]];
        } else {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.modelArr.count < self.pageNo * 10) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self endRefreshing];
        }
        [self.referenceIdsArr removeAllObjects];
        [self.footerView allBtnselect:false];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SELECTALL" object:@"1"];
        [self.collectionView reloadData];
    });
}

@end
