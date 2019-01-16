//
//  BTTSaveMoneyModifyViewController.m
//  Hybird_A01
//
//  Created by Domino on 03/01/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTSaveMoneyModifyViewController.h"
#import "BTTMeMainModel.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTPublicBtnCell.h"
#import "BTTSaveMoneyErrorModel.h"
#import "NSArray+JSON.h"
#import "BTTSaveMoneySuccessController.h"

typedef enum : NSUInteger {
    BTTSaveMoneyEditTypeError,
    BTTSaveMoneyEditTypeEditing,
} BTTSaveMoneyEditType;


@interface BTTSaveMoneyModifyViewController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) BTTSaveMoneyEditType editType;

@end

@implementation BTTSaveMoneyModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.editType = BTTSaveMoneyEditTypeError;
    self.title = @"存款详情";
    [self setupCollectionView];
    [self setupTopView];
//    [self loadMainDataWithType:0];
    [self loadMainDataWithType:_model.trans_code];
}

- (void)setupTopView {
    UIImageView *imageView = [UIImageView new];
    [self.collectionView addSubview:imageView];
    imageView.frame = CGRectMake(15, 14.5, 15, 15);
    imageView.image = ImageNamed(@"pay_Exclamation");
    UILabel *noticeLabel = [UILabel new];
    [self.collectionView addSubview:noticeLabel];
    noticeLabel.frame = CGRectMake(35, 11, 200, 20);
    noticeLabel.textColor = [UIColor colorWithHexString:@"d13847"];
    noticeLabel.font = [UIFont systemFontOfSize:14];
    noticeLabel.text = @"信息填写错误, 请重新填写！";
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTPublicBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTPublicBtnCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataSource.count) {
        BTTPublicBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTPublicBtnCell" forIndexPath:indexPath];
        if (self.editType == BTTSaveMoneyEditTypeError) {
            cell.btnType = BTTPublicBtnTypeModify;
        } else {
            cell.btnType = BTTPublicBtnTypeSubmit;
        }
        cell.btn.enabled = YES;
        weakSelf(weakSelf);
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf);
            if ([button.titleLabel.text isEqualToString:@"提交"]) {
                [strongSelf submitRequest];
            } else {
                strongSelf.editType = BTTSaveMoneyEditTypeEditing;
                [strongSelf loadMainDataWithType:strongSelf->_model.trans_code];
            }
        };
        return cell;
    } else {
        BTTBindingMobileOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileOneCell" forIndexPath:indexPath];
        BTTMeMainModel *model = self.dataSource[indexPath.row];
        cell.model = model;
        return cell;
    }
}

- (void)submitRequest {
    NSString *url = @"";
    NSMutableDictionary *parma = [NSMutableDictionary dictionary];
    if (self.model.trans_code == 1) {
        url = BTTDepositResubmmitAPI;
        NSMutableArray *requestData = [NSMutableArray array];
        for (BTTMeMainModel *model in self.dataSource) {
            NSInteger index = [self.dataSource indexOfObject:model];
            BTTBindingMobileOneCell *cell = (BTTBindingMobileOneCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            if (model.resultCode.integerValue) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:model.resultCode forKey:@"resultCode"];
                [dict setObject:cell.textField.text forKey:@"newValue"];
                [requestData addObject:dict];
            }
            
        }
        NSString *dataStr = [requestData toJSONString];
        parma = @{@"login_name":self.model.login_name,@"requestId":self.model.reference_id,@"requestData":dataStr}.mutableCopy;
    } else {
        url = BTTBQAddOrderAPI;
        [parma setObject:self.model.product_id forKey:@"product"];
        [parma setObject:self.model.reference_id forKey:@"billno"];
        [parma setObject:self.model.login_name forKey:@"loginname"];
        if ([self.model.result_code containsString:@"900005"]) {
            BTTBindingMobileOneCell *cell = (BTTBindingMobileOneCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [parma setObject:cell.textField.text forKey:@"amount"];
        }
        
        if ([self.model.result_code containsString:@"900004"]) {
            BTTBindingMobileOneCell *cell = (BTTBindingMobileOneCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [parma setObject:cell.textField.text forKey:@"depositor"];
        } else {
            [parma setObject:self.model.deposit_by forKey:@"depositor"];
        }
    }
    [self showLoading];
    [IVNetwork sendRequestWithSubURL:url paramters:parma completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        [self hideLoading];
        if (result.status) {
//            [MBProgressHUD showSuccess:@"修改成功" toView:nil];
//            [self.navigationController popToRootViewControllerAnimated:YES];
            BTTSaveMoneySuccessController *vc = [BTTSaveMoneySuccessController new];
            vc.saveMoneyStatus = BTTSaveMoneyStatusTypeCuiSuccess;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            if (result.message.length) {
                [MBProgressHUD showError:result.message toView:nil];
            }
        }
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"%zd", indexPath.item);
    if (indexPath.row != self.dataSource.count) {
        BTTMeMainModel *model = self.dataSource[indexPath.row];
        if (([model.name isEqualToString:@"存款方式"] || [model.name isEqualToString:@"存款时间"] || [model.name isEqualToString:@"存款地点"]) && model.resultCode.integerValue) {
            if ([model.name isEqualToString:@"存款时间"]) {
                BTTBindingMobileOneCell *cell = (BTTBindingMobileOneCell *)[collectionView cellForItemAtIndexPath:indexPath];
                NSString *timeStr = cell.textField.text.length == 19 ? [cell.textField.text substringWithRange:NSMakeRange(0, cell.textField.text.length - 3)] : cell.textField.text;
                [BRDatePickerView showDatePickerWithTitle:@"请选择日期" dateType:BRDatePickerModeYMDHM defaultSelValue:timeStr minDate:nil maxDate:nil isAutoSelect:NO themeColor:nil resultBlock:^(NSString *selectValue) {
                    cell.textField.text = selectValue;
                } cancelBlock:^{
                    NSLog(@"点击了背景或取消按钮");
                }];
            } else if ([model.name isEqualToString:@"存款地点"]) {
                [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeCity dataSource:nil defaultSelected:nil isAutoSelect:NO themeColor:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
                    BTTBindingMobileOneCell *fourCell = (BTTBindingMobileOneCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                    fourCell.textField.text = [NSString stringWithFormat:@"%@%@",province.name,city.name];
                } cancelBlock:^{
                    
                }];
            } else {
                NSArray *arr = @[@"柜台转账",@"ATM现金转账",@"ATM跨行转账",@"网银转账",@"电话转账",@"跨行网银转账",@"手机转账",@"支付宝转账",@"微信转账",@"跨行手机转账",@"其他方式"];
                BTTBindingMobileOneCell *cell = (BTTBindingMobileOneCell *)[collectionView cellForItemAtIndexPath:indexPath];
                [BRStringPickerView showStringPickerWithTitle:@"请选择汇款方式" dataSource:arr defaultSelValue:cell.textField.text resultBlock:^(id selectValue, NSInteger index) {
                    cell.textField.text = selectValue;
                }];
            }
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
    return UIEdgeInsetsMake(44, 0, 0, 0);
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
    for (int i = 0; i < self.dataSource.count + 1; i++) {
        if (i == self.dataSource.count) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 110)]];
        } else {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}



- (void)loadMainDataWithType:(NSInteger)type {
    if (self.dataSource.count) {
        [self.dataSource removeAllObjects];
    }
    NSArray *nameArr = @[];
    NSArray *detailArr = @[];
    NSArray *icons = @[];
    if (type == 1) {
        nameArr = @[@"存款姓名",@"存款金额",@"存款方式",@"存款时间",@"存款地点",@"存款银行",@"存款卡号"];
        detailArr = @[self.model.deposit_by,self.model.amount,self.model.deposit_type,self.model.deposit_date,self.model.deposit_location,self.model.bank_name,self.model.bank_account_no];
    } else if (type == 0) {
        nameArr = @[@"存款姓名",@"存款金额",@"存款方式",@"存款时间",@"存款地点",@"存款银行",@"存款卡号"];
        icons = @[@"请输入存款姓名",@"请输入存款金额",@"请选择存款方式",@"请选择存款时间",@"请选择存款地点",@"请输入存款银行",@"请输入存款卡号"];
    } else {
        nameArr = @[@"存款姓名",@"存款金额"];
        detailArr= @[self.model.deposit_by,self.model.amount];
    }
    for (NSString *name in nameArr) {
        NSInteger index = [nameArr indexOfObject:name];
        BTTMeMainModel *model = [BTTMeMainModel new];
        model.name = name;
        if (detailArr.count) {
            model.desc = detailArr[index];
        }
        if (icons.count) {
            model.iconName = icons[index];
        }
        if (self.model.trans_code == 1) {
            if ([self.model.result_code containsString:@"900004"]) {
                if ([name isEqualToString:@"存款姓名"]) {
                    if (self.editType == BTTSaveMoneyEditTypeError) {
                        model.isError = YES;
                    } else {
                        model.isError = NO;
                    }
                    model.resultCode = @"900004";
                }
            }
            if ([self.model.result_code containsString:@"900005"]) {
                if ([name isEqualToString:@"存款金额"]) {
                    if (self.editType == BTTSaveMoneyEditTypeError) {
                        model.isError = YES;
                    } else {
                        model.isError = NO;
                    }
                    model.resultCode = @"900005";
                }
            }
            
            if ([self.model.result_code containsString:@"900006"]) {
                if ([name isEqualToString:@"存款方式"]) {
                    if (self.editType == BTTSaveMoneyEditTypeError) {
                        model.isError = YES;
                    } else {
                        model.isError = NO;
                    }
                    model.resultCode = @"900006";
                }
            }
            
            if ([self.model.result_code containsString:@"900008"]) {
                if ([name isEqualToString:@"存款时间"]) {
                    if (self.editType == BTTSaveMoneyEditTypeError) {
                        model.isError = YES;
                    } else {
                        model.isError = NO;
                    }
                    model.resultCode = @"900008";
                }
            }
            
            if ([self.model.result_code containsString:@"900007"]) {
                if ([name isEqualToString:@"存款地点"]) {
                    if (self.editType == BTTSaveMoneyEditTypeError) {
                         model.isError = YES;
                    } else {
                         model.isError = NO;
                    }
                   
                    model.resultCode = @"900007";
                }
            }
        } else {
            if ([self.model.result_code containsString:@"900004"]) {
                if ([name isEqualToString:@"存款姓名"]) {
                    if (self.editType == BTTSaveMoneyEditTypeError) {
                        model.isError = YES;
                    } else {
                        model.isError = NO;
                    }
                    model.resultCode = @"900004";
                }
            }
            
            if ([self.model.result_code containsString:@"900005"]) {
                if ([name isEqualToString:@"存款金额"]) {
                    if (self.editType == BTTSaveMoneyEditTypeError) {
                        model.isError = YES;
                    } else {
                        model.isError = NO;
                    }
                    model.resultCode = @"900005";
                }
            }
        }
        [self.dataSource addObject:model];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupElements];
    });
    
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setModel:(BTTSaveMoneyErrorModel *)model {
    _model = model;
    
}

@end
