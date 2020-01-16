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
#import "BTTAddUSDTController.h"
#import <IVCacheLibrary/IVCacheWrapper.h>
#import "IVUtility.h"

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
        cell.isOnlyOneCard = self.bankList.count == 1;
        BTTBankModel *model = self.bankList[indexPath.row];
        cell.model = model;
        weakSelf(weakSelf)
        cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
            strongSelf(strongSelf)
            [[NSUserDefaults standardUserDefaults] setValue:model.accountId forKey:BTTSelectedBankId];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (button.tag == 6005) {//修改
                [strongSelf modifyBtnClickedBankModel:model];
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
            case BTTCanAddCardTypeUSDT:
                cell.titleLabel.text = @"添加USDT钱包";
                break;
            case BTTCanAddCardTypeBTCORUSDT:
                cell.titleLabel.text = @"添加比特币钱包/USDT钱包";
                break;
            case BTTCanAddCardTypeBankORUSDT:
                cell.titleLabel.text = @"添加银行卡/USDT钱包";
                break;
            case BTTCanAddCardTypeBankORBTC:
                cell.titleLabel.text = @"添加银行卡/比特币钱包";
                break;
            default:
                cell.titleLabel.text = @"添加银行卡/比特币钱包/USDT钱包";
                break;
        }
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return;
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.row == self.bankList.count) {
        switch (self.canAddType) {
            case BTTCanAddCardTypeAll:{
                [self showCanAddSheetWithCard:YES btc:YES usdt:YES];
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
            case BTTCanAddCardTypeUSDT:{
                [self addUSDT];
            }
                break;
            case BTTCanAddCardTypeBankORBTC:{
                [self showCanAddSheetWithCard:YES btc:YES usdt:NO];
            }
                break;
            case BTTCanAddCardTypeBankORUSDT:{
                [self showCanAddSheetWithCard:YES btc:NO usdt:YES];
            }
                break;
            case BTTCanAddCardTypeBTCORUSDT:{
                [self showCanAddSheetWithCard:NO btc:YES usdt:YES];
            }
                break;
            default:
                break;
        }
        
        
    }
}

- (void)showCanAddSheetWithCard:(BOOL)card btc:(BOOL)btc usdt:(BOOL)usdt{
    weakSelf(weakSelf)
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"请选择以下方式" preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"请选择以下方式"];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"333333"] range:NSMakeRange(0, 7)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 7)];
    [alertVC setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"银行卡" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf addBankCard];
    }];
    [action1 setValue:[UIColor colorWithHexString:@"212229"] forKey:@"titleTextColor"];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"比特币钱包" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf addBTC];
    }];
    
    [action2 setValue:[UIColor colorWithHexString:@"212229"] forKey:@"titleTextColor"];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"USDT钱包" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf addUSDT];
    }];
    [action4 setValue:[UIColor colorWithHexString:@"212229"] forKey:@"titleTextColor"];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [action3 setValue:[UIColor colorWithHexString:@"212229"] forKey:@"titleTextColor"];
    
    if (card&&btc&&usdt) {
        [alertVC addAction:action1];
        [alertVC addAction:action2];
        [alertVC addAction:action4];
        [alertVC addAction:action3];
    }else if (!card&&btc&&usdt){
        [alertVC addAction:action2];
        [alertVC addAction:action4];
        [alertVC addAction:action3];
    }else if (card&&!btc&&usdt){
        [alertVC addAction:action1];
        [alertVC addAction:action4];
        [alertVC addAction:action3];
    }else if (card&&btc&&!usdt){
        [alertVC addAction:action1];
        [alertVC addAction:action2];
        [alertVC addAction:action3];
    }
    
    [self presentViewController:alertVC animated:YES completion:nil];
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
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i <= self.bankList.count; i++) {
        if (i != self.bankList.count) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 240)]];
        } else {
            if (self.isChecking || self.canAddType == BTTCanAddCardTypeNone) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 0)]];
            } else {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 174)]];
            }
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}
- (void)refreshBankList
{
    NSDictionary *json = [IVCacheWrapper objectForKey:BTTCacheBankListKey];
    if (json!=nil) {
        NSArray *array = json[@"accounts"];
        if (isArrayWithCountMoreThan0(array)) {
            NSMutableArray *bankList = [[NSMutableArray alloc]init];
            for (int i =0 ; i<array.count; i++) {
                NSDictionary *json = array[i];
                BTTBankModel *model = [BTTBankModel yy_modelWithDictionary:json];
                [bankList addObject:model];
                if (i==bankList.count-1) {
                    self.bankList = bankList;
                }
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
    
}
- (void)addBankCard
{
    if (self.bankList.count > 0) {
        if ([IVNetwork savedUserInfo].mobileNoBind==1) {
            BTTVerifyTypeSelectController *vc = [[BTTVerifyTypeSelectController alloc] init];
            vc.verifyType = BTTSafeVerifyTypeMobileAddBankCard;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showMessagNoActivity:@"请先绑定手机号!" toView:nil];
            BTTBindingMobileController *vc = [BTTBindingMobileController new];
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
        if ([IVNetwork savedUserInfo].mobileNoBind==1) {
            BTTVerifyTypeSelectController *vc = [[BTTVerifyTypeSelectController alloc] init];
            vc.verifyType = BTTSafeVerifyTypeMobileAddBTCard;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            
            [MBProgressHUD showMessagNoActivity:@"请先绑定手机号!" toView:nil];
            BTTBindingMobileController *vc = [BTTBindingMobileController new];
            vc.mobileCodeType = BTTSafeVerifyTypeMobileBindAddBTCard;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        BTTAddBTCController *vc = [BTTAddBTCController new];
        vc.addCardType = BTTSafeVerifyTypeNormalAddBTCard;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)addUSDT
{
    if (self.bankList.count > 0) {
        if ([IVNetwork savedUserInfo].mobileNoBind==1) {
            BTTVerifyTypeSelectController *vc = [[BTTVerifyTypeSelectController alloc] init];
            vc.verifyType = BTTSafeVerifyTypeMobileAddUSDTCard;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            
            [MBProgressHUD showMessagNoActivity:@"请先绑定手机号!" toView:nil];
            BTTBindingMobileController *vc = [BTTBindingMobileController new];
            vc.mobileCodeType = BTTSafeVerifyTypeMobileBindAddUSDTCard;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        BTTAddUSDTController *vc = [BTTAddUSDTController new];
        vc.addCardType = BTTSafeVerifyTypeNormalAddUSDTCard;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)modifyBtnClickedBankModel:(BTTBankModel *)bankModel
{
    if ([IVNetwork savedUserInfo].mobileNoBind==1) {
        BTTVerifyTypeSelectController *vc = [[BTTVerifyTypeSelectController alloc] init];
        vc.verifyType = BTTSafeVerifyTypeMobileChangeBankCard;
        vc.bankModel = bankModel;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
        [MBProgressHUD showMessagNoActivity:@"请先绑定手机号!" toView:nil];
        BTTBindingMobileController *vc = [BTTBindingMobileController new];
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
        if ([bankId isEqualToString:model.accountId]) {
            selectModel = model;
            break;
        }
    }
    IVActionHandler handler = ^(UIAlertAction *action){};
    weakSelf(weakSelf)
    IVActionHandler handler1 = ^(UIAlertAction *action){
        if ([IVNetwork savedUserInfo].mobileNoBind==1) {
            BTTBindingMobileController *vc = [[BTTBindingMobileController alloc] init];
            vc.bankModel = selectModel;
            if ([selectModel.accountType isEqualToString:@"借记卡"]||[selectModel.accountType isEqualToString:@"信用卡"]||[selectModel.accountType isEqualToString:@"存折"]) {
                vc.mobileCodeType = BTTSafeVerifyTypeMobileDelBankCard;
            }else if ([selectModel.accountType isEqualToString:@"BTC"]){
                vc.mobileCodeType = BTTSafeVerifyTypeMobileDelBTCard;
            }else{
                vc.mobileCodeType = BTTSafeVerifyTypeMobileDelUSDTCard;
            }
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else {

            [MBProgressHUD showMessagNoActivity:@"请先绑定手机号!" toView:nil];
            BTTBindingMobileController *vc = [BTTBindingMobileController new];
            if ([selectModel.accountType isEqualToString:@"USDT"]) {
                vc.mobileCodeType = BTTSafeVerifyTypeMobileBindDelUSDTCard;
            }else if ([selectModel.accountType isEqualToString:@"BTC"]){
                vc.mobileCodeType = BTTSafeVerifyTypeMobileBindDelBTCard;
            }else{
                vc.mobileCodeType = BTTSafeVerifyTypeMobileBindDelBankCard;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    NSString *title = @"要删除银行卡?";
    NSString *message = @"若以后继续使用该银行卡需要重新添加并审核";
    if ([selectModel.accountType isEqualToString:@"BTC"]) {
        title = @"要删除比特币钱包?";
        message = @"若以后继续使用该钱包需要重新添加并审核";
    }
    if ([selectModel.accountType isEqualToString:@"USDT"]) {
        title = @"要删除USDT钱包?";
        message = @"若以后继续使用该钱包需要重新添加并审核";
    }
    [IVUtility showAlertWithActionTitles:@[@"取消",@"删除"] handlers:@[handler,handler1] title:title message:message];
    
}
- (void)setDefaultBtnClicked
{
    NSString *bankId = [[NSUserDefaults standardUserDefaults] valueForKey:BTTSelectedBankId];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"accountId"] = bankId;
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    weakSelf(weakSelf)
    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
    [IVNetwork requestPostWithUrl:BTTSetDefaultCard paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [BTTHttpManager fetchBankListWithUseCache:NO completion:^(IVRequestResultModel *result, id response) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
                [MBProgressHUD showSuccess:@"设置成功!" toView:weakSelf.view];
                [weakSelf refreshBankList];
            }];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:weakSelf.view];
        }
    }];
}
- (BTTCanAddCardType)canAddType
{
    if (self.bankList.count == 9) {
        return BTTCanAddCardTypeNone;
    }
    int bankCardCount = 0;
    int btcCardCount = 0;
    for (BTTBankModel *model in self.bankList) {
        if ([model.accountType isEqualToString:@"BTC"]) {
            btcCardCount++;
        }else if ([model.accountType isEqualToString:@"借记卡"]||[model.accountType isEqualToString:@"信用卡"]||[model.accountType isEqualToString:@"存折"]){
            bankCardCount++;
        }
    }
    if (btcCardCount == 1) {
        if (bankCardCount < 3) {
            return BTTCanAddCardTypeBankORUSDT;
        }else{
            return BTTCanAddCardTypeUSDT;
        }
        
    }
    if (bankCardCount == 3) {
        return BTTCanAddCardTypeBTCORUSDT;
    }
    return BTTCanAddCardTypeAll;
}
@end
