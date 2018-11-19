//
//  BTTAddCardController.m
//  Hybird_A01
//
//  Created by Domino on 24/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTAddCardController.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTAddCardController+LoadData.h"
#import "BTTMeMainModel.h"
#import "BTTAddCardBtnsCell.h"
#import <BRPickerView/BRPickerView.h>


@interface BTTAddCardController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, strong) BRProvinceModel *provinceModel;

@end

@implementation BTTAddCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.addCardType == BTTAddCardTypeUpdate) {
        self.title = @"修改银行卡";
    } else {
        self.title = @"添加银行卡";
    }
    [self setupCollectionView];
    [self loadMainData];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTAddCardBtnsCell" bundle:nil] forCellWithReuseIdentifier:@"BTTAddCardBtnsCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    weakSelf(weakSelf)
    if (indexPath.row == self.sheetDatas.count) {
        BTTAddCardBtnsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTAddCardBtnsCell" forIndexPath:indexPath];
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            [weakSelf saveBtnClickded:button];
        };
        return cell;
    } else {
        BTTBindingMobileOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileOneCell" forIndexPath:indexPath];
        BTTMeMainModel *model = self.sheetDatas[indexPath.row];
        cell.model = model;
        if (indexPath.row == self.sheetDatas.count - 1) {
            cell.mineSparaterType = BTTMineSparaterTypeNone;
        } else {
            cell.mineSparaterType = BTTMineSparaterTypeSingleLine;
        }
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    BTTBindingMobileOneCell *cell = (BTTBindingMobileOneCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"%zd", indexPath.item);
    if (indexPath.item == 1) {
        NSArray *banks = @[@"招商银行", @"交通银行", @"农业银行", @"工商银行", @"建设银行", @"中国银行", @"民生银行", @"光大银行", @"兴业银行", @"平安银行", @"中信银行", @"浦发银行", @"广发银行", @"华夏银行", @"中国邮政银行", @"深圳发展银行", @"农村信用合作社"];
        [BRStringPickerView showStringPickerWithTitle:@"选择收款银行" dataSource:banks defaultSelValue:cell.textField.text resultBlock:^(id selectValue) {
            cell.textField.text = selectValue;
        }];
    } else if (indexPath.item == 2) {
        [BRStringPickerView showStringPickerWithTitle:@"卡片类别" dataSource:@[@"借记卡", @"信用卡", @"存折"] defaultSelValue:cell.textField.text resultBlock:^(id selectValue) {
            cell.textField.text = selectValue;
        }];
    } else if (indexPath.item == 4) {
        [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeProvince dataSource:nil defaultSelected:nil isAutoSelect:NO themeColor:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
            self.provinceModel = province;
            cell.textField.text = province.name;
        } cancelBlock:^{
            
        }];
    } else if (indexPath.item == 5) {
        if (self.provinceModel) {
            [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeCity dataSource:nil defaultSelected:@[self.provinceModel.name] isAutoSelect:NO themeColor:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
                cell.textField.text = city.name;
            } cancelBlock:^{
                
            }];
        } else {
            [MBProgressHUD showMessagNoActivity:@"请先选择省份" toView:self.view];
        }
        
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
    return UIEdgeInsetsMake(15, 0, 40, 0);
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
    NSInteger total = self.sheetDatas.count + 1;
    for (int i = 0; i < total; i++) {
        if (i == self.sheetDatas.count) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
        } else {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
        }
    }
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
- (void)saveBtnClickded:(UIButton *)sender
{
    BOOL setDefaultCard = ![sender.titleLabel.text isEqualToString:@"保存"];
    UITextField *realNameTF = [self getCellTextFieldWithIndex:0];
    UITextField *bankNameTF = [self getCellTextFieldWithIndex:1];
    UITextField *cardTypeTF = [self getCellTextFieldWithIndex:2];
    UITextField *cardNumberTF = [self getCellTextFieldWithIndex:3];
    UITextField *provinceTF = [self getCellTextFieldWithIndex:4];
    UITextField *cityTF = [self getCellTextFieldWithIndex:5];
    UITextField *locationTF = [self getCellTextFieldWithIndex:6];
    if (bankNameTF.text.length == 0) {
        [MBProgressHUD showError:@"请选择开户行" toView:self.view];
        return;
    }
    if (cardTypeTF.text.length == 0) {
        [MBProgressHUD showError:@"请选择卡片类型" toView:self.view];
        return;
    }
    if (cardNumberTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入正确的卡号" toView:self.view];
        return;
    }
    if (provinceTF.text.length == 0) {
        [MBProgressHUD showError:@"请选择开户省份" toView:self.view];
        return;
    }
    if (cityTF.text.length == 0) {
        [MBProgressHUD showError:@"请选择开户城市" toView:self.view];
        return;
    }
    if (locationTF.text.length == 0) {
        [MBProgressHUD showError:@"请填写正确的开户地点" toView:self.view];
        return;
    }
    NSMutableDictionary *params = @{}.mutableCopy;
    
    params[@"bank_account_name"] = realNameTF.text;
    params[@"bank_name"] = bankNameTF.text;
    params[@"bank_account_type"] = cardTypeTF.text;
    params[@"bank_account_no"] = cardNumberTF.text;
    params[@"bank_country"] = provinceTF.text;
    params[@"bank_city"] = cityTF.text;
    params[@"branch_name"] = locationTF.text;
    if (setDefaultCard) {
        params[@"save_default"] = @(self.cardCount + 1);
    }
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    [BTTHttpManager addBankCardWithParams:params.copy completion:^(IVRequestResultModel *result, id response) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        weakSelf(weakSelf)
        if (result.status) {
            [MBProgressHUD showSuccess:@"添加成功!" toView:nil];
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[NSClassFromString(@"BTTCardInfosController") class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
        } else {
            [MBProgressHUD showError:result.message toView:weakSelf.view];
        }
    }];
}
@end
