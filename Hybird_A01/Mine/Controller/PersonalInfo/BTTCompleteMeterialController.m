//
//  BTTCompleteMeterialController.m
//  Hybird_A01
//
//  Created by Domino on 18/03/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTCompleteMeterialController.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTPublicBtnCell.h"
#import "BTTMeMainModel.h"

@interface BTTCompleteMeterialController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *sheetDatas;

@end

@implementation BTTCompleteMeterialController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    [self loadData];
}

- (void)setupCollectionView {
    self.title = @"完善个人信息";
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTPublicBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTPublicBtnCell"];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 40)];
    [self.collectionView addSubview:topLabel];
    topLabel.text = @"为了您取款的安全性及优惠的及时添加, 请先完善个人信息";
    topLabel.textColor = [UIColor colorWithHexString:@"FFCC99"];
    topLabel.font = [UIFont systemFontOfSize:12];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.sheetDatas.count) {
        BTTPublicBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTPublicBtnCell" forIndexPath:indexPath];
        cell.btnType = BTTPublicBtnTypeSave;
        cell.btn.enabled = YES;
        weakSelf(weakSelf)
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf);
            [strongSelf submitInfo];
        };
        return cell;
    } else {
        BTTBindingMobileOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileOneCell" forIndexPath:indexPath];
        cell.model = self.sheetDatas[indexPath.row];
        if (indexPath.row == 0) {
            cell.mineSparaterType = BTTMineSparaterTypeSingleLine;
        } else {
            cell.mineSparaterType = BTTMineSparaterTypeNone;
        }
        return cell;
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
    return UIEdgeInsetsMake(40, 0, 0, 0);
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

- (void)submitInfo {
    [self.view endEditing:YES];
    UITextField *realNameTF = [self getCellTextFieldWithIndex:0];
    NSMutableDictionary *params = @{}.mutableCopy;
    if ([IVNetwork savedUserInfo].realName.length == 0) {
        if (![PublicMethod checkRealName:realNameTF.text]) {
            [MBProgressHUD showError:@"输入的真实姓名格式有误！" toView:self.view];
            return;
        } else {
            params[@"realName"] = realNameTF.text;
        }
    }
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    
    [IVNetwork requestPostWithUrl:BTTModifyCustomerInfo paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"完善资料成功!" toView:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:self.view];
        }
    }];
    
}

// 构造数据源
- (void)loadData {
    NSArray *nameArr = @[@"真实姓名"];
    NSArray *placeholders = @[@"需与取款银行卡持卡人姓名相同"];
    
    NSMutableArray *sheetData = [NSMutableArray array];
    for (NSString *name in nameArr) {
        NSInteger index = [nameArr indexOfObject:name];
        BTTMeMainModel *model = [BTTMeMainModel new];
        model.name = name;
        model.iconName = placeholders[index];
        [sheetData addObject:model];
    }
    self.sheetDatas = sheetData.mutableCopy;
    [self setupElements];
}

- (NSMutableArray *)sheetDatas {
    if (!_sheetDatas) {
        _sheetDatas = [NSMutableArray array];
    }
    return _sheetDatas;
}

- (void)setupElements {
    if (self.elementsHight.count) {
        [self.elementsHight removeAllObjects];
    }
    NSInteger total = self.sheetDatas.count + 1;
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        if (i == self.sheetDatas.count) {
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

- (UITextField *)getCellTextFieldWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    BTTBindingMobileOneCell *cell = (BTTBindingMobileOneCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.textField;
}

@end
