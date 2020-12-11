//
//  BTTCustomerReportController.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 04/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTCustomerReportController.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTBindingMobileBtnCell.h"
#import "BTTMeMainModel.h"
#import "BRPickerView.h"
#import "BTTPromoRecordController.h"
#import "BTTWithdrawRecordController.h"
#import "BTTDepositRecordController.h"
#import "BTTCreditRecordController.h"
#import "BTTXmRecordController.h"
#import "BTTModifyBankRecordController.h"
#import "BTTXmTransferRecordController.h"

@interface BTTCustomerReportController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic,strong) NSMutableArray *sheetDatas;
@property (nonatomic,assign)NSInteger typeNum;
@property (nonatomic,assign)NSInteger timeNum;

@end

@implementation BTTCustomerReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户报表";
    [self setupCollectionView];
    [self setupElements];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileBtnCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        BTTBindingMobileBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileBtnCell" forIndexPath:indexPath];
        cell.buttonType = BTTButtonTypeSearch;
        cell.btn.enabled = YES;
        weakSelf(weakSelf);
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf);
            if (strongSelf.typeNum == 0) {
                [MBProgressHUD showError:@"请选择查询的记录类型" toView:nil];
                return;
            }
            if (strongSelf.timeNum == 0) {
                [MBProgressHUD showError:@"请选择查询的时间" toView:nil];
                return;
            }
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            params[@"pageSize"] = @10;
            params[@"lastDays"] = [NSNumber numberWithInteger:strongSelf.timeNum];
            params[@"flags"] = [[NSArray alloc] init];
            
            switch (strongSelf.typeNum) {
                case 1:
                {
                    BTTDepositRecordController * vc = [[BTTDepositRecordController alloc] init];
                    vc.params = params;
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 2:
                {
                    BTTWithdrawRecordController * vc = [[BTTWithdrawRecordController alloc] init];
                    vc.params = params;
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 3:
                {
                    BTTPromoRecordController * vc = [[BTTPromoRecordController alloc] init];
                    vc.params = params;
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }
                    
                    break;
                case 4:
                {
                    params[@"pageNo"] = @1;
                    params[@"pageSize"] = @100;
                    params[@"flags"] = @"";
                    BTTXmTransferRecordController * vc = [[BTTXmTransferRecordController alloc] init];
                    vc.params = params;
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 5:
                {
                    BTTXmRecordController * vc = [[BTTXmRecordController alloc] init];
                    vc.params = params;
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 6:
                {
                    [params removeAllObjects];
                    params[@"flag"] = @"MODIFY_BANK_REQUEST_FLAG_ALL";
                    BTTModifyBankRecordController * vc = [[BTTModifyBankRecordController alloc] init];
                    vc.params = params;
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 7:
                {
                    BTTCreditRecordController * vc = [[BTTCreditRecordController alloc] init];
                    vc.params = params;
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        };
        return cell;
    } else {
        BTTBindingMobileOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileOneCell" forIndexPath:indexPath];
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        cell.model = model;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%zd", indexPath.item);
    if (indexPath.row == 0) {
        BTTBindingMobileOneCell *cell = (BTTBindingMobileOneCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        weakSelf(weakSelf);
        [BRStringPickerView showStringPickerWithTitle:@"请选择记录类型" dataSource:@[@"存款", @"取款",@"优惠",@"洗码转账",@"洗码",@"银行卡更改", @"转账"] defaultSelValue:cell.textField.text resultBlock:^(id selectValue, NSInteger index) {
            strongSelf(strongSelf);
            cell.textField.text = selectValue;
            strongSelf.typeNum = index + 1;
        }];
    } else if (indexPath.row == 1) {
        BTTBindingMobileOneCell *cell = (BTTBindingMobileOneCell *)[collectionView cellForItemAtIndexPath:indexPath];
        weakSelf(weakSelf);
        [BRStringPickerView showStringPickerWithTitle:@"请选择时间范围" dataSource:@[@"近一天", @"近三天",@"近七天",@"近十五天"] defaultSelValue:cell.textField.text resultBlock:^(id selectValue, NSInteger index) {
            strongSelf(strongSelf);
            cell.textField.text = selectValue;
            switch (index) {
                case 0:
                    strongSelf.timeNum = 1;
                    break;
                case 1:
                    strongSelf.timeNum = 3;
                    break;
                case 2:
                    strongSelf.timeNum = 7;
                    break;
                case 3:
                    strongSelf.timeNum = 15;
                    break;
                default:
                    break;
            }
        }];
    }
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
    return UIEdgeInsetsMake(20, 0, 40, 0);
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
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < 3; i ++) {
        if (i == 2) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
        } else {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (NSMutableArray *)sheetDatas {
    if (!_sheetDatas) {
        _sheetDatas = [NSMutableArray array];
        NSArray *titles = @[@"记录类型",@"时间"];
        NSArray *placeholders = @[@"请选择记录类型",@"请选择时间范围"];
        for (NSString *title in titles) {
            NSInteger index = [titles indexOfObject:title];
            BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
            model.name = title;
            model.iconName = placeholders[index];
            [_sheetDatas addObject:model];
        }
    }
    return _sheetDatas;
}

@end
