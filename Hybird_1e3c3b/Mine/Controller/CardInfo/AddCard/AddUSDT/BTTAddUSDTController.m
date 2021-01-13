//
//  BTTAddUSDTController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 24/12/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTAddUSDTController.h"
#import "BTTUSDTItemCell.h"
#import "BTTHomePageSeparateCell.h"
#import "BTTPublicBtnCell.h"
#import "BTTBindingMobileOneCell.h"
#import "BTTMeMainModel.h"
#import "BTTAddUSDTController+LoadData.h"
#import "CNPayRequestManager.h"
#import "BTTChangeMobileSuccessController.h"
#import "BTTAddUsdtHeaderCell.h"
#import "BTTUSDTWalletTypeModel.h"
#import "BTTOneKeyRegisterBitollCell.h"
#import "BTTKSAddBfbWalletController.h"
#import "BTTWithdrawalController.h"
#import "HAInitConfig.h"

@interface BTTAddUSDTController ()<BTTElementsFlowLayoutDelegate>
@property (nonatomic, copy) NSString *walletString;
@property (nonatomic, copy) NSString *confirmString;
@property (nonatomic, assign) NSInteger selectedType;
@property (nonatomic, copy) NSString *selectedProtocol;
@property (nonatomic, assign) BOOL isWithDraw;
@end

@implementation BTTAddUSDTController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isWithDraw = [[NSUserDefaults standardUserDefaults]boolForKey:@"bitollAddCard"];
    self.title = @"添加USDT钱包";
    _walletString = @"";
    _confirmString = @"";
    _selectedType = 0;
    [self setupCollectionView];
    [self loadUSDTData];
    [self setupElements];
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTUSDTItemCell" bundle:nil] forCellWithReuseIdentifier:@"BTTUSDTItemCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageSeparateCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageSeparateCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTBindingMobileOneCell" bundle:nil] forCellWithReuseIdentifier:@"BTTBindingMobileOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTPublicBtnCell" bundle:nil] forCellWithReuseIdentifier:@"BTTPublicBtnCell"];
    [self.collectionView registerClass:[BTTAddUsdtHeaderCell class] forCellWithReuseIdentifier:@"BTTAddUsdtHeaderCell"];
    [self.collectionView registerClass:[BTTOneKeyRegisterBitollCell class] forCellWithReuseIdentifier:@"BTTOneKeyRegisterBitollCell"];
}

#pragma mark - collectionview delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    weakSelf(weakSelf)
    if (indexPath.row == 0) {
        BTTUSDTItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTUSDTItemCell" forIndexPath:indexPath];
        [cell setUsdtDatasWithArray:self.usdtDatas];
        cell.selectPayType = ^(NSInteger tag) {
            NSLog(@"%ld",(long)tag);
            weakSelf.selectedType = tag;
            BTTUSDTWalletTypeModel *model = [BTTUSDTWalletTypeModel yy_modelWithDictionary:self.usdtDatas[tag]];
            if ([model.code isEqualToString:@"bitoll"]) {
                [self.elementsHight replaceObjectAtIndex:1 withObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 0)]];
                [self.elementsHight replaceObjectAtIndex:4 withObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 0)]];
            }else{
                [self.elementsHight replaceObjectAtIndex:1 withObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 85)]];
                [self.elementsHight replaceObjectAtIndex:4 withObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
            }
            
            [weakSelf.collectionView reloadData];
        };
        return cell;
    } else if (indexPath.row == 1) {
        BTTAddUsdtHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTAddUsdtHeaderCell" forIndexPath:indexPath];
        if (self.usdtDatas.count>0) {
            BTTUSDTWalletTypeModel *model = [BTTUSDTWalletTypeModel yy_modelWithJSON:self.usdtDatas[_selectedType]];
            [cell setTypeData:model.protocol];
        }
        cell.tapProtocol = ^(NSString * _Nonnull protocol) {
            self.selectedProtocol = protocol;
        };
        return cell;
    }else if (indexPath.row == 2) {
        BTTHomePageSeparateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageSeparateCell" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 3 || indexPath.row == 4) {
        BTTBindingMobileOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTBindingMobileOneCell" forIndexPath:indexPath];
        BTTMeMainModel *model = [BTTMeMainModel new];
        
        if (indexPath.row == 3) {
            if (self.usdtDatas.count>0) {
                BTTUSDTWalletTypeModel *typeModel = [BTTUSDTWalletTypeModel yy_modelWithDictionary:self.usdtDatas[_selectedType]];
                model.name = [typeModel.code isEqualToString:@"bitoll"] ? @"币付宝ID" : @"钱包地址";
                model.iconName = [typeModel.code isEqualToString:@"bitoll"] ? @"请输入币付宝ID" : @"请输入钱包地址";
            }else{
                model.name =  @"钱包地址";
                model.iconName = @"请输入钱包地址";
            }
            
            
            cell.textFieldChanged = ^(NSString * _Nonnull text) {
                weakSelf.walletString = text;
            };
        } else {
            model.name = @"确认地址";
            model.iconName = @"请确认地址";
            cell.textFieldChanged = ^(NSString * _Nonnull text) {
                weakSelf.confirmString = text;
            };
        }
        cell.model = model;
        cell.textField.textAlignment = NSTextAlignmentLeft;
        if (weakSelf.walletString.length>0) {
            cell.textField.text = weakSelf.walletString;
        }
        return cell;
    } else if (indexPath.row == 4) {
        BTTPublicBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTPublicBtnCell" forIndexPath:indexPath];
        cell.btnType = BTTPublicBtnTypeSave;
        cell.btn.enabled = YES;
        [cell.btn addTarget:self action:@selector(submitButton_Click:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if (indexPath.row==5){
        BTTPublicBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTPublicBtnCell" forIndexPath:indexPath];
        cell.btnType = BTTPublicBtnTypeSave;
        cell.btn.enabled = YES;
        [cell.btn addTarget:self action:@selector(submitButton_Click:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {
        BTTOneKeyRegisterBitollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTOneKeyRegisterBitollCell" forIndexPath:indexPath];
        if (self.usdtDatas.count>0) {
            BTTUSDTWalletTypeModel *model = [BTTUSDTWalletTypeModel yy_modelWithJSON:self.usdtDatas[_selectedType]];
            [cell setIsHidden:![model.code isEqualToString:@"bitoll"]];
        }else{
            [cell setIsHidden:YES];
        }
        
        cell.onekeyRegister = ^{
            BTTKSAddBfbWalletController *vc = [[BTTKSAddBfbWalletController alloc]init];
            vc.success = ^(NSString * _Nonnull accountNo) {
                weakSelf.walletString = accountNo;
                weakSelf.confirmString = accountNo;
                [self.collectionView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
        
    }
}

- (void)submitButton_Click:(id)sender{
    [self.view endEditing:YES];
    
    BTTUSDTWalletTypeModel *model = [BTTUSDTWalletTypeModel yy_modelWithJSON:self.usdtDatas[_selectedType]];
    NSString *url = BTTAddBankCard;
    NSString *firstChar = @"";
    NSString *firstTwochar = @"";
    
    if (_walletString.length<6||_walletString.length>100) {
        if ([model.code isEqualToString:@"bitoll"]) {
            [MBProgressHUD showError:@"币付宝ID只允许6-100位大小写英文字母+数字的组合" toView:self.view];
        }else{
            [MBProgressHUD showError:@"钱包地址只允许6-100位大小写英文字母+数字的组合" toView:self.view];
        }
        
        return;
    }
    
    if (![_walletString isEqualToString:@""]) {
        firstChar = [_walletString substringWithRange:NSMakeRange(0, 1)];
        firstTwochar = [_walletString substringWithRange:NSMakeRange(0, 2)];
    }
    
    weakSelf(weakSelf)
    if ([_confirmString isEqualToString:@""]&&![model.code isEqualToString:@"bitoll"]){
        [MBProgressHUD showError:@"确认地址不得为空" toView:self.view];
    }else if (![_confirmString isEqualToString:_walletString]&&![model.code isEqualToString:@"bitoll"]){
        [MBProgressHUD showError:@"两次输入不一致" toView:self.view];
    }else if ([self.selectedProtocol isEqualToString:@"OMNI"]&&!([firstChar isEqualToString:@"1"]||[firstChar isEqualToString:@"3"])&&![model.code isEqualToString:@"bitoll"]){
        [MBProgressHUD showError:@"OMNI协议钱包，请以1或3开头" toView:self.view];
    }else if ([self.selectedProtocol isEqualToString:@"ERC20"]&&![firstTwochar isEqualToString:@"0x"]&&![model.code isEqualToString:@"bitoll"]){
        [MBProgressHUD showError:@"ERC20协议钱包，请以0x开头" toView:self.view];
    }else{
        [self showLoading];
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"accountNo"] = _walletString;
        params[@"accountType"] = [model.code isEqualToString:@"bitoll"]? @"BITOLL" : @"USDT";
        params[@"bankName"] = model.code;
        params[@"expire"] = @0;
        params[@"messageId"] = self.messageId;
        params[@"validateId"] = self.validateId;
        if (![model.code isEqualToString:@"bitoll"]) {
            params[@"protocol"] = self.selectedProtocol;
        }
        
        [IVNetwork requestPostWithUrl:url paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
            IVJResponseObject *result = response;
            [self hideLoading];
            [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
            if ([result.head.errCode isEqualToString:@"0000"]) {
                [IVLAManager singleEventId:@"A01_bankcard_update" errorCode:@"" errorMsg:@"" customsData:@{}];
                if (self.isWithDraw&&[model.code isEqualToString:@"bitoll"]) {
                    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"bitollAddCard"];
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
                    [BTTHttpManager fetchBankListWithUseCache:NO completion:^(IVRequestResultModel *result, id response) {
                        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoTakeMoneyNotification" object:nil];
                    }];
                    
                }else{
                    [BTTHttpManager fetchBindStatusWithUseCache:NO completionBlock:nil];
                    [BTTHttpManager fetchBankListWithUseCache:NO completion:^(id  _Nullable response, NSError * _Nullable error) {
                        if ([IVNetwork savedUserInfo].bankCardNum > 0 || [IVNetwork savedUserInfo].usdtNum > 0||[IVNetwork savedUserInfo].bfbNum>0||[IVNetwork savedUserInfo].dcboxNum>0) {
                            BTTChangeMobileSuccessController *vc = [BTTChangeMobileSuccessController new];
                            vc.mobileCodeType = self.addCardType;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        } else {
                            [self.navigationController popToRootViewControllerAnimated:true];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoCardInfoNotification" object:@{@"showAlert":[NSNumber numberWithBool:true]}];
                        }
                    }];
                }
                
            }else{
                [MBProgressHUD showError:result.head.errMsg toView:weakSelf.view];
            }
        }];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    _selectedType = indexPath.row;
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
    return UIEdgeInsetsMake(0, 0, 40, 0);
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
    NSMutableArray *elementsHight = [NSMutableArray array];
    NSInteger total = 7;
    for (int i = 0; i < total; i++) {
        if (i == 0) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 60)]];
        } else if (i == 1) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 85)]];
        }else if (i == 2) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 15)]];
        } else if (i == 3) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
        } else if (i == 4) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
        }else if (i==5){
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
        } else {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    });
}

@end