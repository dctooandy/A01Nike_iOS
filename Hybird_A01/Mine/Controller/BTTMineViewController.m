//
//  BTTMineViewController.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/1.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTMineViewController.h"
#import "BTTMeHeaderNotLoginCell.h"
#import "BTTMeInfoCell.h"
#import "BTTHomePageSeparateCell.h"
#import "BTTMeMoneyHeaderCell.h"
#import "BTTMeSaveMoneyCell.h"
#import "BTTMeMainCell.h"
#import "BTTMeMainModel.h"
#import "BTTMineViewController+LoadData.h"
#import "BTTMineViewController+Nav.h"
#import "BTTMeHeaderLoginCell.h"
#import "BTTLoginAndRegisterViewController.h"
#import "BTTAccountBalanceController.h"
#import "BTTBindingMobileController.h"
#import "BTTMeInfoHiddenCell.h"
#import "BTTPersonalInfoController.h"
#import "BTTChangeMobileController.h"
#import "BTTHomePageHeaderView.h"
#import "BTTNotCompleteInfoController.h"
#import "BTTCardInfosController.h"
#import "BTTBindEmailController.h"
#import "BTTModifyEmailController.h"
#import "BTTWithdrawalController.h"
#import "BTTPTTransferController.h"
#import "BTTAccountSafeController.h"
#import "BTTSheetsViewController.h"
#import "WebViewUserAgaent.h"
#import "BTTBaseWebViewController.h"
#import "BTTSettingsController.h"
#import "BTTXimaController.h"
#import "BTTLoginOrRegisterViewController.h"
#import "BTTBindStatusModel.h"
#import "BTTVerifyTypeSelectController.h"
#import "BTTHomePageViewController+LoadData.h"

#import "BTTUserStatusManager.h"

@interface BTTMineViewController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, assign) BOOL isChangeMobile; // 是否改变手机号

@property (nonatomic, assign) BOOL isCompletePersonalInfo; // 是否完善个人信息

@property (nonatomic, strong) BTTBaseWebViewController *webViewVC;

@end

@implementation BTTMineViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    self.totalAmount = @"-";
    [self setupNav];
    self.isCompletePersonalInfo = NO;
    self.isChangeMobile = NO;
    [self setupCollectionView];
    [self loadMeAllData];
    [self setupNavBtn];
    [self registerNotification];
    _webViewVC = [[BTTBaseWebViewController alloc] init];
    
    
}

- (void)setupNav {
    [self.navigationController setNavigationBarHidden:YES];
    BTTHomePageHeaderView *nav = [[BTTHomePageHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KIsiPhoneX ? 88 : 64) withNavType:BTTNavTypeMessageAndService];
    nav.titleLabel.text = @"个人中心";
    [self.view addSubview:nav];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if ([IVNetwork userInfo]) {
        self.totalAmount = @"-";
        [self loadBindStatus];
        [self loadBankList];
        [self loadTotalAvailableData];
        [BTTHttpManager getOpenAccountStatus];
    }
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.frame = CGRectMake(0, KIsiPhoneX ? 88 : 64, SCREEN_WIDTH, SCREEN_HEIGHT - (KIsiPhoneX ? 88 : 64));
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTMeHeaderNotLoginCell" bundle:nil] forCellWithReuseIdentifier:@"BTTMeHeaderNotLoginCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTMeInfoCell" bundle:nil] forCellWithReuseIdentifier:@"BTTMeInfoCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageSeparateCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageSeparateCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTMeMoneyHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTMeMoneyHeaderCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTMeSaveMoneyCell" bundle:nil] forCellWithReuseIdentifier:@"BTTMeSaveMoneyCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTMeMainCell" bundle:nil] forCellWithReuseIdentifier:@"BTTMeMainCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTMeHeaderLoginCell" bundle:nil] forCellWithReuseIdentifier:@"BTTMeHeaderLoginCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTMeInfoHiddenCell" bundle:nil] forCellWithReuseIdentifier:@"BTTMeInfoHiddenCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BTTBaseNavigationController *navVC = self.tabBarController.viewControllers[0];
        BTTHomePageViewController *homeVC = navVC.viewControllers[0];
        if ([IVNetwork userInfo]) {
            BTTMeHeaderLoginCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeHeaderLoginCell" forIndexPath:indexPath];
            cell.noticeStr = homeVC.noticeStr.length ? homeVC.noticeStr : @"";
            cell.totalAmount = [PublicMethod transferNumToThousandFormat:[self.totalAmount floatValue]];
            cell.nameLabel.text = [IVNetwork userInfo].loginName;
            cell.vipLevelLabel.text = [NSString stringWithFormat:@"VIP%@",@([IVNetwork userInfo].customerLevel)];
            weakSelf(weakSelf);
            cell.accountBlanceBlock = ^{
                strongSelf(strongSelf);
                BTTAccountBalanceController *accountBalance = [[BTTAccountBalanceController alloc] init];
                [strongSelf.navigationController pushViewController:accountBalance animated:YES];
            };
            return cell;
        } else {
            BTTMeHeaderNotLoginCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeHeaderNotLoginCell" forIndexPath:indexPath];
            cell.noticeStr = homeVC.noticeStr.length ? homeVC.noticeStr : @"";
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                if (button.tag == 6003) {
                    BTTLoginOrRegisterViewController *loginAndRegister = [[BTTLoginOrRegisterViewController alloc] init];
                    loginAndRegister.registerOrLoginType = BTTRegisterOrLoginTypeLogin;
                    [strongSelf.navigationController pushViewController:loginAndRegister animated:YES];
                } else {
                    BTTLoginOrRegisterViewController *loginAndRegister = [[BTTLoginOrRegisterViewController alloc] init];
                    loginAndRegister.registerOrLoginType = BTTRegisterOrLoginTypeRegisterNormal;
                    [strongSelf.navigationController pushViewController:loginAndRegister animated:YES];
                }
            };
            return cell;
        }
    } else if (indexPath.row >= 1 && indexPath.row <= 1 + self.personalInfos.count - 1) {
        BTTMeMainModel *model = self.personalInfos[indexPath.row - 1];
        BTTMeInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeInfoCell" forIndexPath:indexPath];
        cell.model = model;
        return cell;
    } else if (indexPath.row == 1 + self.personalInfos.count ||
               indexPath.row == 3 + self.personalInfos.count + self.paymentDatas.count ||
               indexPath.row == 4 + self.mainDataOne.count + self.personalInfos.count + self.paymentDatas.count ||
               indexPath.row == 5 + self.mainDataTwo.count + self.mainDataOne.count + self.personalInfos.count + self.paymentDatas.count ||
               indexPath.row == 6 + self.mainDataTwo.count + self.mainDataOne.count + self.personalInfos.count + self.paymentDatas.count + self.mainDataThree.count) {
        BTTHomePageSeparateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageSeparateCell" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 2 + self.personalInfos.count) {
        BTTMeMoneyHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMoneyHeaderCell" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row >= 3 + self.personalInfos.count && indexPath.row <= 3 + self.personalInfos.count + self.paymentDatas.count - 1) {
        BTTMeSaveMoneyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeSaveMoneyCell" forIndexPath:indexPath];
        
        BTTMeMainModel *model = self.paymentDatas[indexPath.row - (3 + self.personalInfos.count)];
        cell.model = model;
        return cell;
    } else if (indexPath.row >= 4 + self.personalInfos.count + self.paymentDatas.count && indexPath.row <= 4 + self.mainDataOne.count + self.personalInfos.count + self.paymentDatas.count) {
        BTTMeMainModel *model = self.mainDataOne[indexPath.row - ( 4 + self.personalInfos.count + self.paymentDatas.count)];
        if (indexPath.row >= 8 + self.personalInfos.count + self.paymentDatas.count && indexPath.row <= 10 + self.personalInfos.count + self.paymentDatas.count && self.isShowHidden) {
            BTTMeInfoHiddenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeInfoHiddenCell" forIndexPath:indexPath];
            cell.mineArrowsDirectionType = BTTMineArrowsDirectionTypeRight;
            return cell;
        } else {
            BTTMeMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMainCell" forIndexPath:indexPath];
            if (indexPath.row == 4 + self.mainDataOne.count + self.personalInfos.count + self.paymentDatas.count) {
                cell.mineSparaterType = BTTMineSparaterTypeNone;
            } else {
                cell.mineSparaterType = BTTMineSparaterTypeSingleLine;
            }
            if (indexPath.row == 7 + self.personalInfos.count + self.paymentDatas.count && self.isShowHidden) {
                cell.mineArrowsDirectionType = BTTMineArrowsDirectionTypeUp;
            } else {
                cell.mineArrowsDirectionType = BTTMineArrowsDirectionTypeRight;
            }
            cell.model = model;
            return cell;
        }
    } else if (indexPath.row >= 5 + self.mainDataOne.count + self.personalInfos.count + self.paymentDatas.count && indexPath.row <= 5 + self.mainDataOne.count + self.personalInfos.count + self.paymentDatas.count + self.mainDataTwo.count) {
        BTTMeMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMainCell" forIndexPath:indexPath];
        BTTMeMainModel *model = self.mainDataTwo[indexPath.row - (5 + self.mainDataOne.count + self.personalInfos.count + self.paymentDatas.count)];
        cell.mineArrowsDirectionType = BTTMineArrowsDirectionTypeRight;
        if (indexPath.row == 5 + self.mainDataOne.count + self.personalInfos.count + self.paymentDatas.count + self.mainDataTwo.count) {
            cell.mineSparaterType = BTTMineSparaterTypeNone;
        } else {
            cell.mineSparaterType = BTTMineSparaterTypeSingleLine;
        }
        cell.model = model;
        return cell;
    } else  {
        BTTMeMainModel *model = self.mainDataThree[indexPath.row - (6 + self.mainDataOne.count + self.personalInfos.count + self.paymentDatas.count + self.mainDataTwo.count)];
        BTTMeMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMainCell" forIndexPath:indexPath];
        cell.model = model;
        cell.mineArrowsDirectionType = BTTMineArrowsDirectionTypeRight;
        cell.mineSparaterType = BTTMineSparaterTypeNone;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"%@",@(indexPath.row));
    if (![IVNetwork userInfo]) {
        BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.row == 2) {
        UIViewController *vc = nil;
        if ([IVNetwork userInfo].isPhoneBinded) {
            BTTVerifyTypeSelectController *selectVC = [BTTVerifyTypeSelectController new];
            selectVC.verifyType = BTTSafeVerifyTypeChangeMobile;
            vc = selectVC;
        } else {
            BTTBindingMobileController *bindingMobileVC = [[BTTBindingMobileController alloc] init];
            bindingMobileVC.mobileCodeType = BTTSafeVerifyTypeBindMobile;
            vc = bindingMobileVC;
        }
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 7 + self.personalInfos.count + self.paymentDatas.count) {
        self.isShowHidden = !self.isShowHidden;
        [self loadMeAllData];
    } else if (indexPath.row == 1) {
        BTTPersonalInfoController *personInfo = [[BTTPersonalInfoController alloc] init];
        [self.navigationController pushViewController:personInfo animated:YES];
    } else if (indexPath.row == 4) {
        if (self.isCompletePersonalInfo) {
            BTTCardInfosController *vc = [[BTTCardInfosController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            BTTNotCompleteInfoController *vc = [[BTTNotCompleteInfoController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (indexPath.row == 3) {
        UIViewController *vc = nil;
        if ([IVNetwork userInfo].isEmailBinded) {
            BTTModifyEmailController *modifyVC = [BTTModifyEmailController new];
            vc = modifyVC;
        } else {
            BTTBindEmailController *bindVC = [[BTTBindEmailController alloc] init];
            bindVC.codeType = BTTSafeVerifyTypeBindEmail;
            vc = bindVC;
        }
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 4 + self.personalInfos.count + self.paymentDatas.count) {
        if (self.isCompletePersonalInfo) {
            if ([IVNetwork userInfo].isBankBinded) {
                BTTWithdrawalController *vc = [[BTTWithdrawalController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [MBProgressHUD showMessagNoActivity:@"请先绑定银行卡" toView:nil];
                BTTCardInfosController *vc = [[BTTCardInfosController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else {
            [MBProgressHUD showMessagNoActivity:@"请先完善个人信息" toView:nil];
            BTTNotCompleteInfoController *vc = [[BTTNotCompleteInfoController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } else if (indexPath.row == 6 + self.personalInfos.count + self.paymentDatas.count) {
        BTTPTTransferController *vc = [[BTTPTTransferController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == self.personalInfos.count + self.paymentDatas.count + self.mainDataOne.count + 6) {
        BTTAccountSafeController *vc = [[BTTAccountSafeController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == self.personalInfos.count + self.paymentDatas.count + self.mainDataOne.count + 5) {
        BTTSheetsViewController *vc = [[BTTSheetsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == self.personalInfos.count + self.paymentDatas.count + self.mainDataOne.count + self.mainDataTwo.count + self.mainDataThree.count  + 5) {
        [BTTUserStatusManager logoutSuccess];
        self.totalAmount = @"-";
    } else if (indexPath.row == self.personalInfos.count + self.paymentDatas.count + self.mainDataOne.count + 7) {
        BTTSettingsController *vc = [[BTTSettingsController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 5 + self.personalInfos.count + self.paymentDatas.count) {
        BTTXimaController *vc = [[BTTXimaController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == self.personalInfos.count + self.paymentDatas.count + self.mainDataOne.count + 8) {
        
    } else if (indexPath.row == self.personalInfos.count + self.paymentDatas.count + self.mainDataOne.count + 9) {
        [IVNetwork checkAppUpdate];
    } else if (indexPath.row == self.personalInfos.count + self.paymentDatas.count + self.mainDataOne.count + 10) {
        // 网络监测
        [IVNetwork startCheckWithType:IVCheckNetworkTypeAll appWindow:[UIApplication sharedApplication].keyWindow detailBtnClickedBlock:^{
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
    return UIEdgeInsetsMake(0, 0, KIsiPhoneX ? 83 : 49, 0);
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
    NSInteger total = 0;
    if ([IVNetwork userInfo]) {
        total = self.personalInfos.count + 7 + self.paymentDatas.count + self.mainDataOne.count + self.mainDataTwo.count + self.mainDataThree.count;
    } else {
        total = self.personalInfos.count + 6 + self.paymentDatas.count + self.mainDataOne.count + self.mainDataTwo.count;
    }
    
    for (int i = 0; i < total; i++) {
        if (i == 0) {
            if (SCREEN_WIDTH == 414) {
                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 172)]];
            } else if (SCREEN_WIDTH == 320) {
                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 158)]];
            } else {
                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 158)]];
            }
        } else if (i >= 1 && i <= 1 + self.personalInfos.count - 1) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH / 4, 98)]];
        } else if (i == 1 + self.personalInfos.count ||
                   i == 3 + self.personalInfos.count + self.paymentDatas.count ||
                   i == 4 + self.mainDataOne.count + self.personalInfos.count + self.paymentDatas.count ||
                   i == 5 + self.mainDataTwo.count + self.mainDataOne.count + self.personalInfos.count + self.paymentDatas.count ||
                   i == 6 + self.mainDataTwo.count + self.mainDataOne.count + self.personalInfos.count + self.paymentDatas.count + self.mainDataThree.count) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 15)]];
        } else if (i == 2 + self.personalInfos.count) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 63)]];
        } else if (i >= 3 + self.personalInfos.count && i <= 3 + self.personalInfos.count + self.paymentDatas.count - 1) {
            if (SCREEN_WIDTH == 320) {
                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH / 4, 100)]];
            } else {
                [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH / 4, 110)]];
            }
            
        } else if ((i >= 4 + self.personalInfos.count + self.paymentDatas.count && i <= 4 + self.mainDataOne.count + self.personalInfos.count + self.paymentDatas.count) ||
                   (i >= 5 + self.mainDataOne.count + self.personalInfos.count + self.paymentDatas.count && i <= 5 + self.mainDataOne.count + self.personalInfos.count + self.paymentDatas.count + self.mainDataTwo.count)) {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
        } else {
            [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (BOOL)isCompletePersonalInfo
{
    return [IVNetwork userInfo].real_name && [IVNetwork userInfo].verify_code;
}
@end
