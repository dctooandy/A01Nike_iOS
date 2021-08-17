//
//  BTTCardInfosController.m
//  Hybird_1e3c3b
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
#import "BTTKSAddBfbWalletController.h"
#import "BTTAddBitollCardController.h"
#import "BTTActionSheet.h"
#import "AppDelegate.h"
#import "BTTActionSheet.h"
#import "BTTPasswordChangeController.h"

@interface BTTCardInfosController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, copy) NSArray<BTTBankModel *> *bankList;
@property (nonatomic, assign) BOOL isChecking; //正在审核
@property (nonatomic, assign) BOOL haveBFB;
@property (nonatomic, assign) NSInteger bankNum;
@property (nonatomic, assign) NSInteger bitNum;
@property (nonatomic, assign) NSInteger dcboxNum;
@property (nonatomic, copy) NSString *titleString;
@end

@implementation BTTCardInfosController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"钱包管理" : @"银行卡资料";
    _haveBFB = NO;
    [self setUpNoticeView];
    [self setupElements];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _bankNum = 0;
    _bitNum = 0;
    _dcboxNum = 0;
    [self refreshBankList];
    if ([[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] && self.showAlert) {
        IVActionHandler home = ^(UIAlertAction *action){
            dispatch_time_t dipatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5));
            dispatch_after(dipatchTime, dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:true];
            });
            AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate jumpToTabIndex:BTTHome];
        };
        IVActionHandler withdraw = ^(UIAlertAction *action){
//            [self.navigationController popToRootViewControllerAnimated:true];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoTakeMoneyNotification" object:nil];
        };
        IVActionHandler cancel = ^(UIAlertAction *action){};
        NSString *title = @"老板～您想继续提交取款嘛？";
        [IVUtility showAlertWithActionTitles:@[@"返回首页", @"前往取款", @"取消"] handlers:@[home, withdraw, cancel] title:title message:@""];
    }
    if (self.showToast) {
        [MBProgressHUD showSuccess:@"删除成功" toView:nil];
    }
}

-(void)setUpNoticeView {
    if (self.showNotice) {
        UILabel * lab = [[UILabel alloc] init];
        lab.text = @"老板请您先绑定钱包再提款哦";
        lab.textColor = [UIColor colorWithHexString:@"fab765"];
        lab.font = [UIFont systemFontOfSize:16];
        lab.textAlignment = NSTextAlignmentCenter;
        CGSize size = [lab sizeThatFits:CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX)];
        [self.view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(10);
            make.width.offset(SCREEN_WIDTH);
            make.height.offset(size.height);
        }];
        
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lab.mas_bottom);
            make.left.bottom.right.equalTo(self.view);
        }];
    }
    [self setupCollectionView];
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
    if (indexPath.row < self.bankList.count) {
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
    }else if (indexPath.row==self.bankList.count){
        BTTCardInfoAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTCardInfoAddCell" forIndexPath:indexPath];
        cell.titleLabel.text = @"快速添加小金库钱包";
        return cell;
    } else {
        BTTCardInfoAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTCardInfoAddCell" forIndexPath:indexPath];
        NSString *bankString = _bankNum<3 && ![[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"银行卡/" : @"";
        NSString *bitString = _bitNum==1 ? @"" : @"比特币钱包/";
        NSString *usdtString = @"USDT钱包/";
        NSString *dcboxString = _dcboxNum==1 ? @"" : @"小金库钱包/";
        NSString *bindString = [NSString stringWithFormat:@"添加%@%@%@%@",bankString,bitString,usdtString,dcboxString];
        if (![[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"]) {
            bindString = [NSString stringWithFormat:@"添加%@",bankString];
        } else {
            bindString = [NSString stringWithFormat:@"添加%@%@%@",bitString,usdtString,dcboxString];
        }
        NSString *textString = [bindString substringToIndex:bindString.length-1];
        self.titleString = textString;
        cell.titleLabel.text = textString;
        
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return;
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.row == self.bankList.count+1) {
        NSString *titleString = [self.titleString stringByReplacingOccurrencesOfString:@"添加" withString:@""];
        [self showCanAddSheetWithTitles:titleString];
        
                
    }else if (indexPath.row == self.bankList.count){
        
    }
}

- (void)showCanAddSheetWithTitles:(NSString *)titles{
    weakSelf(weakSelf)
    NSArray *titleArray = [titles componentsSeparatedByString:@"/"];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"请选择以下方式" preferredStyle:UIAlertControllerStyleActionSheet];
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"请选择以下方式"];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"333333"] range:NSMakeRange(0, 7)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 7)];
    [alertVC setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    if (alertVC.popoverPresentationController) {
        [alertVC.popoverPresentationController setPermittedArrowDirections:0];//去掉arrow箭头
        alertVC.popoverPresentationController.sourceView = self.view;
        alertVC.popoverPresentationController.sourceRect=CGRectMake(0, self.view.height, self.view.width, self.view.height);
    }
    if (titleArray.count == 1) {
        NSString *title = titleArray[0];
        if ([IVNetwork savedUserInfo].withdralPwdFlag == 1) {
            //bindPhone = 1 withdralPwdFlag = 1
            if ([title isEqualToString:@"银行卡"]) {
                [weakSelf addBankCard];
            }else if ([title isEqualToString:@"比特币钱包"]){
                [weakSelf addBTC];
            }else if ([title isEqualToString:@"USDT钱包"]){
                [weakSelf addUSDT];
            }else if ([title isEqualToString:@"小金库钱包"]){
                [weakSelf addDCBOX];
            }
        } else {
            //bindPhone = 1 withdralPwdFlag != 1
            BTTPasswordChangeController *vc = [[BTTPasswordChangeController alloc] init];
            vc.selectedType = BTTChangeWithdrawPwd;
            vc.isGoToMinePage = false;
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
    for (int i = 0; i<titleArray.count; i++) {
        NSString *title = titleArray[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if ([IVNetwork savedUserInfo].mobileNoBind == 1) {
                if ([IVNetwork savedUserInfo].withdralPwdFlag == 1) {
                    //bindPhone = 1 withdralPwdFlag = 1
                    if ([title isEqualToString:@"银行卡"]) {
                        [weakSelf addBankCard];
                    }else if ([title isEqualToString:@"比特币钱包"]){
                        [weakSelf addBTC];
                    }else if ([title isEqualToString:@"USDT钱包"]){
                        [weakSelf addUSDT];
                    }else if ([title isEqualToString:@"小金库钱包"]){
                        [weakSelf addDCBOX];
                    }
                } else {
                    //bindPhone = 1 withdralPwdFlag != 1
                    BTTPasswordChangeController *vc = [[BTTPasswordChangeController alloc] init];
                    vc.selectedType = BTTChangeWithdrawPwd;
                    vc.isGoToMinePage = false;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            } else {
                //bindPhone != 1
                BTTSafeVerifyType type = BTTSafeVerifyTypeMobileBindAddBankCard;
                if ([title isEqualToString:@"银行卡"]) {
                    type = BTTSafeVerifyTypeMobileBindAddBankCard;
                }else if ([title isEqualToString:@"比特币钱包"]){
                    type = BTTSafeVerifyTypeMobileBindAddBTCard;
                }else if ([title isEqualToString:@"USDT钱包"]){
                    type = BTTSafeVerifyTypeMobileBindAddUSDTCard;
                }else if ([title isEqualToString:@"小金库钱包"]){
                    type = BTTSafeVerifyTypeMobileBindAddDCBOXCard;
                }
                [self showNoBindAlert:type selectModel:nil];
            }
        }];
        [action setValue:[UIColor colorWithHexString:@"212229"] forKey:@"titleTextColor"];
        [alertVC addAction:action];
        if (i==titleArray.count-1) {
            UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [action3 setValue:[UIColor colorWithHexString:@"212229"] forKey:@"titleTextColor"];
            [alertVC addAction:action3];
        }
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
    BOOL isShowAddCell = true;
    if (![[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] && _bankNum==3) {
        isShowAddCell = false;
    }
    for (int i = 0; i <= self.bankList.count+1; i++) {
        if (i < self.bankList.count) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 240)]];
        } else {
            if (i==self.bankList.count) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 0)]];
            }else{
                if (self.isChecking || !isShowAddCell) {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 0)]];
                } else {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 174)]];
                }
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
    BOOL isUSDTAcc = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"];
    if (json!=nil) {
        NSArray *array = json[@"accounts"];
        if (isArrayWithCountMoreThan0(array)) {
            NSMutableArray *bankList = [[NSMutableArray alloc]init];
            for (int i =0 ; i<array.count; i++) {
                NSDictionary *json = array[i];
                BTTBankModel *model = [BTTBankModel yy_modelWithDictionary:json];
                if (![model.accountType isEqualToString:@"Bitbase"]) {
                    if (isUSDTAcc) {
                        if (![model.accountType isEqualToString:@"信用卡"]&&![model.accountType isEqualToString:@"借记卡"]&&![model.accountType isEqualToString:@"存折"]) {
                            [bankList addObject:model];
                        }
                    } else {
                        if ([model.accountType isEqualToString:@"存折"] || [model.accountType isEqualToString:@"借记卡"] || [model.accountType isEqualToString:@"信用卡"]) {
                                [bankList addObject:model];
                        }
                    }
                }
            }
            self.bankList = bankList;
            for (BTTBankModel *model in self.bankList) {
                if (model.flag == 9) {
                    self.isChecking = YES;
                    break;
                }
            }
            [self handleCardNum];
            
        }
    }
    
}

- (void)addBankCard
{
    BTTVerifyTypeSelectController *vc = [[BTTVerifyTypeSelectController alloc] init];
    vc.verifyType = BTTSafeVerifyTypeMobileAddBankCard;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addBTC
{
    [[NSUserDefaults standardUserDefaults]setBool:self.showNotice forKey:@"pressWithdrawAddUSDTCard"];
    BTTVerifyTypeSelectController *vc = [[BTTVerifyTypeSelectController alloc] init];
    vc.verifyType = BTTSafeVerifyTypeMobileAddBTCard;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)addUSDT
{
    [[NSUserDefaults standardUserDefaults]setBool:self.showNotice forKey:@"pressWithdrawAddUSDTCard"];
    BTTVerifyTypeSelectController *vc = [[BTTVerifyTypeSelectController alloc] init];
    vc.verifyType = BTTSafeVerifyTypeMobileAddUSDTCard;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addDCBOX
{
    [[NSUserDefaults standardUserDefaults]setBool:self.showNotice forKey:@"pressWithdrawAddUSDTCard"];
    [[NSUserDefaults standardUserDefaults]setInteger:5 forKey:@"BITOLLBACK"];
    BTTVerifyTypeSelectController *vc = [[BTTVerifyTypeSelectController alloc] init];
    vc.verifyType = BTTSafeVerifyTypeMobileAddDCBOXCard;
    [self.navigationController pushViewController:vc animated:YES];
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
            if ([selectModel.accountType isEqualToString:@"借记卡"]||[selectModel.accountType isEqualToString:@"信用卡"]||[selectModel.accountType isEqualToString:@"存折"]) {
                BTTBindingMobileController *vc = [BTTBindingMobileController new];
                vc.bankModel = selectModel;
                [MBProgressHUD showMessagNoActivity:@"请先绑定手机号!" toView:nil];
                vc.mobileCodeType = BTTSafeVerifyTypeMobileBindDelBankCard;
                [self.navigationController pushViewController:vc animated:YES];
            } else if ([selectModel.accountType isEqualToString:@"BTC"]) {
                [self showNoBindAlert:BTTSafeVerifyTypeMobileBindDelBTCard selectModel:selectModel];
            } else {
                [self showNoBindAlert:BTTSafeVerifyTypeMobileBindDelUSDTCard selectModel:selectModel];
            }
        }
    };
    NSString *title = @"要删除银行卡?";
    NSString *message = @"若以后继续使用该银行卡需要重新添加并审核";
    if ([selectModel.accountType isEqualToString:@"借记卡"]||[selectModel.accountType isEqualToString:@"信用卡"]||[selectModel.accountType isEqualToString:@"存折"]) {
        title = @"要删除银行卡?";
        message = @"若以后继续使用该银行卡需要重新添加并审核";
    } else if ([selectModel.accountType isEqualToString:@"BTC"]) {
        title = @"要删除比特币钱包?";
        message = @"若以后继续使用该钱包需要重新添加并审核";
    } else {
        title = @"要删除此取款钱包？";
        message = @"若以后继续使用该取款钱包需重新添加";
    }
    [IVUtility showAlertWithActionTitles:@[@"取消",@"删除"] handlers:@[handler,handler1] title:title message:message];
    
}

-(void)showNoBindAlert:(BTTSafeVerifyType)type selectModel:(BTTBankModel*)selectModel {
    IVActionHandler bind = ^(UIAlertAction *action){
        BTTBindingMobileController *vc = [BTTBindingMobileController new];
        vc.mobileCodeType = type;
        vc.bankModel = selectModel;
        [self.navigationController pushViewController:vc animated:YES];
    };
    IVActionHandler kf = ^(UIAlertAction *action){
        [CSVisitChatmanager startWithSuperVC:self finish:^(CSServiceCode errCode) {
            if (errCode != CSServiceCode_Request_Suc) {
                [MBProgressHUD showErrorWithTime:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持" toView:nil duration:3];
            } else {

            }
        }];
    };
    
    IVActionHandler cancel = ^(UIAlertAction *action){};
    NSString *title = @"该账号尚未绑定或验证手机，无法使用手机短信验证删除取款钱包";
    [IVUtility showAlertWithActionTitles:@[@"绑定手机", @"联系客服", @"取消"] handlers:@[bind, kf, cancel] title:title message:@""];
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
- (void)handleCardNum
{
    NSMutableArray *bList = [[NSMutableArray alloc]initWithArray:self.bankList];
    for (BTTBankModel *model in self.bankList) {
        
        if ([model.accountType isEqualToString:@"BTC"]) {
            _bitNum=1;
        }else if ([model.accountType isEqualToString:@"借记卡"]||[model.accountType isEqualToString:@"信用卡"]||[model.accountType isEqualToString:@"存折"]){
            _bankNum++;
        }else if ([model.accountType isEqualToString:@"DCBOX"]){
            _dcboxNum++;
        }
        if ([model.isOpen isEqualToString:@"0"]) {
            [bList removeObject:model];
        }
    }
    self.bankList = bList;
    if ([[IVNetwork savedUserInfo].depositLevel isEqualToString:@"-19"] || [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"]) {
        _bankNum=3;
    }
    [self setupElements];
    
}
@end
