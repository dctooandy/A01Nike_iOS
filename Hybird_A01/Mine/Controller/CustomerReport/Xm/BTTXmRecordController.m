//
//  BTTXmRecordController.m
//  Hybird_A01
//
//  Created by Jairo on 22/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTXmRecordController.h"
#import "BTTXmRecordController+LoadData.h"
#import "BTTPromoRecordFooterView.h"
#import "BTTXmRecordHeaderCell.h"
#import "BTTXmRecordCell.h"

@interface BTTXmRecordController ()<BTTElementsFlowLayoutDelegate>
@property (nonatomic, strong)BTTPromoRecordFooterView * footerView;
@property (nonatomic, strong) NSMutableDictionary * cellDic;
@property (nonatomic, assign) BOOL isSelectAll;
@end

@implementation BTTXmRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"洗码记录";
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
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTXmRecordHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTXmRecordHeaderCell"];
    
    weakSelf(weakSelf);
    [self.footerView setAllBtnClickBlock:^(BOOL selected) {
        strongSelf(strongSelf);
        [strongSelf.requestIdArr removeAllObjects];
        if (selected) {
            if (strongSelf.requestIdArr.count == strongSelf.modelArr.count ) {
                return;
            }
             for (BTTXmRecordItemModel * model in strongSelf.modelArr) {
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
        BTTXmRecordHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTXmRecordHeaderCell" forIndexPath:indexPath];
        return cell;
    } else {
        NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
        if (identifier == nil) {
            identifier = [NSString stringWithFormat:@"%@%@", @"BTTXmRecordCell", [NSString stringWithFormat:@"%@", indexPath]];
            [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
            [self.collectionView registerNib:[UINib nibWithNibName:@"BTTXmRecordCell" bundle:nil] forCellWithReuseIdentifier:identifier];
        }
        BTTXmRecordCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        [cell setData:self.modelArr[indexPath.row - 1]];
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
    self.footerView.totalAmount = @"0.00";
    for (BTTXmRecordItemModel * model in self.modelArr) {
        [self.footerView calculateAmount:model.amount];
    }
    NSInteger total = self.modelArr.count + 1;
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        if (i == 0) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 30)]];
        } else {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 80)]];
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
