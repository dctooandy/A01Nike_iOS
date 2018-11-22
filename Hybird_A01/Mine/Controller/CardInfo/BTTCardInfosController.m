//
//  BTTCardInfosController.m
//  Hybird_A01
//
//  Created by Domino on 23/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTCardInfosController.h"
#import "BTTCardInfoCell.h"
#import "BTTCardInfoAddCell.h"
#import "BTTVerifyTypeSelectController.h"
#import "BTTAddCardController.h"
#import "BTTBankModel.h"
#import "BTTAddBTCController.h"
#import "BTTBindingMobileController.h"
#import "BTTUnBindingMobileNoticeController.h"
@interface BTTCardInfosController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, copy) NSArray<BTTBankModel *> *bankList;
@property (nonatomic, assign) BOOL isChecking; //正在审核
@property (nonatomic, assign) BTTCanAddCardType canAddType;
@end

@implementation BTTCardInfosController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行卡资料";
    [self setupCollectionView];
    [self setupElements];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshBankList];
}
- (void)setupCollectionView {
    [super setupCollectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTCardInfoCell" bundle:nil] forCellWithReuseIdentifier:@"BTTCardInfoCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTCardInfoAddCell" bundle:nil] forCellWithReuseIdentifier:@"BTTCardInfoAddCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != self.bankList.count) {
        BTTCardInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTCardInfoCell" forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.isChecking = self.isChecking;
        BTTBankModel *model = self.bankList[indexPath.row];
        cell.model = model;
        weakSelf(weakSelf)
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf)
            [[NSUserDefaults standardUserDefaults] setValue:model.customer_bank_id forKey:BTTSelectedBankId];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (button.tag == 6005) {//修改
                [strongSelf modifyBtnClicked];
            } else if(button.tag == 6006) {//删除
                [strongSelf deleteBtnClicked];
            } else if(button.tag == 6007) {//设置默认卡
                [strongSelf setDefaultBtnClicked];
            }
        };
        return cell;
    } else {
        BTTCardInfoAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTCardInfoAddCell" forIndexPath:indexPath];
        switch (self.canAddType) {
            case BTTCanAddCardTypeBTC:
                cell.titleLabel.text = @"添加比特币钱包";
                break;
            case BTTCanAddCardTypeBank:
                cell.titleLabel.text = @"添加银行卡";
                break;
            default:
                cell.titleLabel.text = @"添加银行卡/比特币钱包";
                break;
        }
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    weakSelf(weakSelf)
    if (indexPath.row == self.bankList.count) {
        switch (self.canAddType) {
            case BTTCanAddCardTypeAll:{
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"请选择以下方式" preferredStyle:UIAlertControllerStyleAlert];
                NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"请选择以下方式"];
                [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"747474"] range:NSMakeRange(0, 7)];
                [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 7)];
                [alertVC setValue:alertControllerMessageStr forKey:@"attributedMessage"];
                
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"银行卡" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf addBankCard];
                }];
                [action1 setValue:[UIColor colorWithHexString:@"0066ff"] forKey:@"titleTextColor"];
                [alertVC addAction:action1];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"比特币钱包" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf addBTC];
                }];
                [action2 setValue:[UIColor colorWithHexString:@"0066ff"] forKey:@"titleTextColor"];
                [alertVC addAction:action2];
                [self presentViewController:alertVC animated:YES completion:nil];
            }
                break;
            case BTTCanAddCardTypeBank:{
                [self addBankCard];
            }
                break;
            case BTTCanAddCardTypeBTC:{
                [self addBTC];
            }
                break;
            default:
                break;
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
    [self.elementsHight removeAllObjects];
    for (int i = 0; i <= self.bankList.count; i++) {
        if (i != self.bankList.count) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 240)]];
        } else {
            if (self.isChecking || self.canAddType == BTTCanAddCardTypeNone) {
                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 0)]];
            } else {
                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 174)]];
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}
- (void)refreshBankList
{
    NSArray *array = [[IVCacheManager sharedInstance] nativeReadDictionaryForKey:BTTCacheBankListKey];
    if (isArrayWithCountMoreThan0(array)) {
        NSArray<BTTBankModel *> *bankList  = [BTTBankModel arrayOfModelsFromDictionaries:array error:nil];
        if (isArrayWithCountMoreThan0(bankList)) {
            self.bankList = isArrayWithCountMoreThan0(bankList) ? bankList : @[];
        }
        for (BTTBankModel *model in self.bankList) {
            if (model.flag == 9) {
                self.isChecking = YES;
                break;
            }
        }
        [self setupElements];
    }
}
- (void)addBankCard
{
    if (self.bankList.count > 0) {
        if ([IVNetwork userInfo].isPhoneBinded) {
            BTTVerifyTypeSelectController *vc = [[BTTVerifyTypeSelectController alloc] init];
            vc.verifyType = BTTSafeVerifyTypeMobileAddBankCard;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            BTTUnBindingMobileNoticeController *vc = [[BTTUnBindingMobileNoticeController alloc] init];
            vc.mobileCodeType = BTTSafeVerifyTypeMobileBindAddBankCard;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        BTTAddCardController *vc = [BTTAddCardController new];
        vc.addCardType = BTTSafeVerifyTypeNormalAddBankCard;
        vc.cardCount = self.bankList.count;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (void)addBTC
{
    if (self.bankList.count > 0) {
        if ([IVNetwork userInfo].isPhoneBinded) {
            BTTVerifyTypeSelectController *vc = [[BTTVerifyTypeSelectController alloc] init];
            vc.verifyType = BTTSafeVerifyTypeMobileAddBTCard;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            BTTUnBindingMobileNoticeController *vc = [[BTTUnBindingMobileNoticeController alloc] init];
            vc.mobileCodeType = BTTSafeVerifyTypeMobileBindAddBTCard;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        BTTAddBTCController *vc = [BTTAddBTCController new];
        vc.addCardType = BTTSafeVerifyTypeNormalAddBTCard;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)modifyBtnClicked
{
    if ([IVNetwork userInfo].isPhoneBinded) {
        BTTBindingMobileController *vc = [[BTTBindingMobileController alloc] init];
        vc.mobileCodeType = BTTSafeVerifyTypeMobileChangeBankCard;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        BTTUnBindingMobileNoticeController *vc = [[BTTUnBindingMobileNoticeController alloc] init];
        vc.mobileCodeType = BTTSafeVerifyTypeMobileBindChangeBankCard;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)deleteBtnClicked
{
    if (self.bankList.count == 1) {
        [MBProgressHUD showMessagNoActivity:@"仅有一张银行卡可用时，无法删除\n请在添加其他银行卡后删除该卡" toView:self.view];
        return;
    }
    BTTBankModel *selectModel = nil;
    NSString *bankId = [[NSUserDefaults standardUserDefaults] valueForKey:BTTSelectedBankId];
    for (BTTBankModel *model in self.bankList) {
        if ([bankId isEqualToString:model.customer_bank_id]) {
            selectModel = model;
            break;
        }
    }
    IVActionHandler handler = ^(UIAlertAction *action){};
    weakSelf(weakSelf)
    IVActionHandler handler1 = ^(UIAlertAction *action){
        if ([IVNetwork userInfo].isPhoneBinded) {
            BTTBindingMobileController *vc = [[BTTBindingMobileController alloc] init];
            vc.mobileCodeType = selectModel.isBTC ? BTTSafeVerifyTypeMobileDelBTCard : BTTSafeVerifyTypeMobileDelBankCard;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else {
            BTTUnBindingMobileNoticeController *vc = [[BTTUnBindingMobileNoticeController alloc] init];
            vc.mobileCodeType = selectModel.isBTC ? BTTSafeVerifyTypeMobileBindDelBTCard : BTTSafeVerifyTypeMobileBindDelBankCard;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    NSString *title = @"要删除银行卡?";
    NSString *message = @"若以后继续使用该银行卡需要重新添加并审核";
    if (selectModel.isBTC) {
        title = @"要删除比特币钱包?";
        message = @"若以后继续使用该钱包需要重新添加并审核";
    }
    [IVUtility showAlertWithActionTitles:@[@"取消",@"删除"] handlers:@[handler,handler1] title:title message:message];
    
}
- (void)setDefaultBtnClicked
{
    NSString *bankId = [[NSUserDefaults standardUserDefaults] valueForKey:BTTSelectedBankId];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"customer_bank_id"] = bankId;
    params[@"save_default"] = @(1);
    weakSelf(weakSelf)
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    [BTTHttpManager updateBankCardWithUrl:@"public/bankcard/updateAuto" params:params.copy completion:^(IVRequestResultModel *result, id response) {
        if (result.status) {
            [BTTHttpManager fetchBankListWithUseCache:NO completion:^(IVRequestResultModel *result, id response) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
                [MBProgressHUD showSuccess:@"设置成功!" toView:weakSelf.view];
                [weakSelf refreshBankList];
            }];
        } else {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
            [MBProgressHUD showError:result.message toView:weakSelf.view];
        }
    }];
}
- (BTTCanAddCardType)canAddType
{
    if (self.bankList.count == 4) {
        return BTTCanAddCardTypeNone;
    }
    int bankCardCount = 0;
    int btcCardCount = 0;
    for (BTTBankModel *model in self.bankList) {
        model.isBTC ? btcCardCount++ : bankCardCount++;
    }
    if (btcCardCount == 1) {
        return BTTCanAddCardTypeBank;
    }
    if (bankCardCount == 3) {
        return BTTCanAddCardTypeBTC;
    }
    return BTTCanAddCardTypeAll;
}
@end
