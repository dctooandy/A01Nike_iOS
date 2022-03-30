//
//  BTTMineViewController.m
//  Hybird_1e3c3b
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
#import "WebViewUserAgaent.h"
#import "BTTBaseWebViewController.h"
#import "BTTSettingsController.h"
#import "BTTXimaController.h"
#import "BTTLoginOrRegisterViewController.h"
#import "BTTBindStatusModel.h"
#import "BTTVerifyTypeSelectController.h"
#import "BTTHomePageViewController+LoadData.h"
#import "BTTUserStatusManager.h"
#import "IVNetworkStatusDetailViewController.h"
#import "CNPayVC.h"
#import "BTTPromotionDetailController.h"
#import "BTTMeMoreSaveMoneyHeaderCell.h"
#import "BTTMeBigSaveMoneyCell.h"
#import "BTTMeMoreSaveMoneyCell.h"
#import "BTTSaveMoneyModifyViewController.h"
#import "BTTSaveMoneySuccessController.h"
#import "BTTCompleteMeterialController.h"
#import "BTTNicknameSetController.h"
#import "BTTMeHeadernNicknameLoginCell.h"
#import "BTTActionSheet.h"
#import "BTTUsdtTodayNoticeView.h"
#import "IVCNetworkStatusView.h"
#import "IVCDetailViewController.h"
//#import "OTCInsideController.h"//充值/购买USDT
#import "USDTRechargeController.h"
#import "USDTBuyController.h"
#import "BTTCustomerReportController.h"
#import "BTTLiCaiViewController.h"
#import "BTTUserForzenManager.h"
#import "BTTMeGoldenCCell.h"
#import "KYMWithdrewRequest.h"
#import "CNMAlertView.h"
#import "CNMUSDTChannelVC.h"

@interface BTTMineViewController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, assign) BOOL isChangeMobile; // 是否改变手机号

@property (nonatomic, assign) BOOL isCompletePersonalInfo; // 是否完善个人信息
@property (nonatomic, strong) NSArray *dataList;
@end

@implementation BTTMineViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.saveMoneyCount = 0;
    self.isOpenSellUsdt = NO;
    self.title = @"会员中心";
    self.totalAmount = @"加载中";
    self.yebAmount = @"加载中";
    self.yebInterest = @"加载中";
    self.collectionView.bounces = NO;
    [self setupNav];
    self.isCompletePersonalInfo = [self isCompletePersonalInfo];
    self.isChangeMobile = NO;
    [self setupCollectionView];
    [self requestBuyUsdtLink];
    [self queryBiShangStatus];
    [self loadMeAllData];
    [self registerNotification];
    [self loadWeiXinRediect];
    BOOL isShowShareNotice = [[[NSUserDefaults standardUserDefaults] objectForKey:BTTShareNoticeTag] boolValue];
    if (!isShowShareNotice) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:BTTShareNoticeTag];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //        [self showShareNoticeView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if ([IVNetwork savedUserInfo]) {
        //usdt取款優惠彈窗
        //        [self loadGetPopWithDraw];
        [self loadUserInfo];
        [self loadBankList];
        if (!self.isLoading) {
            [self loadGamesListAndGameAmount];
        }
        [self loadMeAllData];
        [self loadPaymentData];
        [self loadRebateStatus];
        [self loadSaveMoneyTimes];
    } else {
        self.saveMoneyCount = 0;
        [self loadPaymentDefaultData];
    }
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.collectionView.frame = CGRectMake(0, KIsiPhoneX ? 88 : 64, SCREEN_WIDTH, SCREEN_HEIGHT - (KIsiPhoneX ? 88 : 64));
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTMeHeaderNotLoginCell" bundle:nil] forCellWithReuseIdentifier:@"BTTMeHeaderNotLoginCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTMeInfoCell" bundle:nil] forCellWithReuseIdentifier:@"BTTMeInfoCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageSeparateCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageSeparateCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTMeMoneyHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTMeMoneyHeaderCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTMeSaveMoneyCell" bundle:nil] forCellWithReuseIdentifier:@"BTTMeSaveMoneyCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTMeMainCell" bundle:nil] forCellWithReuseIdentifier:@"BTTMeMainCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTMeHeaderLoginCell" bundle:nil] forCellWithReuseIdentifier:@"BTTMeHeaderLoginCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTMeInfoHiddenCell" bundle:nil] forCellWithReuseIdentifier:@"BTTMeInfoHiddenCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTMeMoreSaveMoneyHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTMeMoreSaveMoneyHeaderCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTMeBigSaveMoneyCell" bundle:nil] forCellWithReuseIdentifier:@"BTTMeBigSaveMoneyCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTMeMoreSaveMoneyCell" bundle:nil] forCellWithReuseIdentifier:@"BTTMeMoreSaveMoneyCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTMeHeadernNicknameLoginCell" bundle:nil] forCellWithReuseIdentifier:@"BTTMeHeadernNicknameLoginCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTMeGoldenCCell" bundle:nil] forCellWithReuseIdentifier:@"BTTMeGoldenCCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BTTBaseNavigationController *navVC = self.tabBarController.viewControllers[0];
        BTTHomePageViewController *homeVC = navVC.viewControllers[0];
        if ([IVNetwork savedUserInfo]) {
            NSString *nickName = [IVNetwork savedUserInfo].nickName;
            if (!nickName.length) {
                BTTMeHeaderLoginCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeHeaderLoginCell" forIndexPath:indexPath];
                cell.noticeStr = homeVC.noticeStr.length ? homeVC.noticeStr : @"";
                if ([self.totalAmount isEqualToString:@"加载中"]) {
                    cell.totalAmount = self.totalAmount;
                    cell.liCaiAmount = self.yebAmount;
                    cell.liCaiPlusAmount = self.yebInterest;
                } else {
                    cell.totalAmount = [PublicMethod transferNumToThousandFormat:[self.totalAmount doubleValue]];
                    cell.liCaiAmount = [PublicMethod transferNumToThousandFormat:[self.yebAmount doubleValue]];
                    cell.liCaiPlusAmount = [PublicMethod transferNumToThousandFormat:[self.yebInterest doubleValue]];
                }
                
                cell.changModeImgStr = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"go_main_mode":@"go_usdt_mode";
                cell.nameLabel.text = [[IVNetwork savedUserInfo].loginName containsString:@"usdt"] ? [[IVNetwork savedUserInfo].loginName stringByReplacingOccurrencesOfString:@"usdt" withString:@""] : [IVNetwork savedUserInfo].loginName;
                cell.vipLevelLabel.text = ([IVNetwork savedUserInfo].starLevel == 7) ? @" 准VIP5 " : [NSString stringWithFormat:@" VIP%@ ", @([IVNetwork savedUserInfo].starLevel)];
                
                weakSelf(weakSelf);
                cell.changModeTap = ^(NSString * _Nonnull modeStr) {
                    strongSelf(strongSelf);
                    [strongSelf changeMode:modeStr isInGame:false];
                };
                cell.accountBlanceBlock = ^{
                    strongSelf(strongSelf);
                    BTTAccountBalanceController *accountBalance = [[BTTAccountBalanceController alloc] init];
                    [strongSelf.navigationController pushViewController:accountBalance animated:YES];
                };
                cell.liCaiBlock = ^{
                    strongSelf(strongSelf);
                    BTTLiCaiViewController *vc = [[BTTLiCaiViewController alloc] init];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                };
                cell.buttonClickBlock = ^(UIButton *_Nonnull button) {
                    strongSelf(strongSelf);
                    BTTNicknameSetController *vc = (BTTNicknameSetController *)[BTTNicknameSetController getVCFromStoryboard];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                };
                cell.clickEventBlock = ^(id _Nonnull value) {
                    strongSelf(strongSelf);
                    BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
                    vc.webConfigModel.url = @"common/ancement.htm";
                    vc.webConfigModel.newView = YES;
                    vc.webConfigModel.theme = @"inside";
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                };
                return cell;
            } else {
                BTTMeHeadernNicknameLoginCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeHeadernNicknameLoginCell" forIndexPath:indexPath];
                cell.noticeStr = homeVC.noticeStr.length ? homeVC.noticeStr : @"";
                if ([self.totalAmount isEqualToString:@"加载中"]) {
                    cell.totalAmount = self.totalAmount;
                    cell.liCaiAmount = self.yebAmount;
                    cell.liCaiPlusAmount = self.yebInterest;
                } else {
                    cell.totalAmount = [PublicMethod transferNumToThousandFormat:[self.totalAmount doubleValue]];
                    cell.liCaiAmount = [PublicMethod transferNumToThousandFormat:[self.yebAmount doubleValue]];
                    cell.liCaiPlusAmount = [PublicMethod transferNumToThousandFormat:[self.yebInterest doubleValue]];
                }
                cell.changModeImgStr = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"go_main_mode":@"go_usdt_mode";
                cell.nicknameLabel.text = nickName;
                cell.nameLabel.text = [IVNetwork savedUserInfo].loginName;
                cell.vipLevelLabel.text = ([IVNetwork savedUserInfo].starLevel == 7) ? @" 准VIP5 " : [NSString stringWithFormat:@" VIP%@ ", @([IVNetwork savedUserInfo].starLevel)];
                weakSelf(weakSelf);
                cell.changModeTap = ^(NSString * _Nonnull modeStr) {
                    strongSelf(strongSelf);
                    [strongSelf changeMode:modeStr isInGame:false];
                };
                cell.accountBlanceBlock = ^{
                    strongSelf(strongSelf);
                    BTTAccountBalanceController *accountBalance = [[BTTAccountBalanceController alloc] init];
                    [strongSelf.navigationController pushViewController:accountBalance animated:YES];
                };
                cell.liCaiBlock = ^{
                    strongSelf(strongSelf);
                    BTTLiCaiViewController *vc = [[BTTLiCaiViewController alloc] init];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                };
                cell.buttonClickBlock = ^(UIButton *_Nonnull button) {
                    strongSelf(strongSelf);
                    BTTNicknameSetController *vc = (BTTNicknameSetController *)[BTTNicknameSetController getVCFromStoryboard];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                };
                cell.clickEventBlock = ^(id _Nonnull value) {
                    strongSelf(strongSelf);
                    BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
                    vc.webConfigModel.url = @"common/ancement.htm";
                    vc.webConfigModel.newView = YES;
                    vc.webConfigModel.theme = @"inside";
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                };
                return cell;
            }
        } else {
            BTTMeHeaderNotLoginCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeHeaderNotLoginCell" forIndexPath:indexPath];
            cell.noticeStr = homeVC.noticeStr.length ? homeVC.noticeStr : @"";
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton *_Nonnull button) {
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
            cell.clickEventBlock = ^(id _Nonnull value) {
                strongSelf(strongSelf);
                BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
                vc.webConfigModel.url = @"common/ancement.htm";
                vc.webConfigModel.newView = YES;
                vc.webConfigModel.theme = @"inside";
                [strongSelf.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        }
    } else if (indexPath.row == 1) {
        BTTMeGoldenCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeGoldenCCell" forIndexPath:indexPath];
        __weak typeof(self) weakSelf = self;
        cell.clickAction = ^(NSInteger tag) {
            if (![IVNetwork savedUserInfo]) {//未登入
                [MBProgressHUD showError:@"请先登录" toView:nil];
                BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
                return;
            }
            switch (tag) {
                case 0: // 存款
                    [weakSelf goToDepositVC];
                    break;
                case 1: // 洗码
                    if (UserForzenStatus) {
                        [[BTTUserForzenManager sharedInstance] checkUserForzen];
                    } else {
                        BTTXimaController *vc = [[BTTXimaController alloc] init];
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }
                    break;
                case 2: { // 取款
                    [weakSelf goToWithdrawVC];
                }
                break;
            }
        };
        return cell;
        /*    if (indexPath.row == 2) {
                //推薦存款
                BTTMeBigSaveMoneyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeBigSaveMoneyCell" forIndexPath:indexPath];
                cell.saveMoneyShowType = self.saveMoneyShowType;
                cell.dataSource = self.bigDataSoure;
                weakSelf(weakSelf);

                cell.clickEventBlock = ^(id _Nonnull value) {
                    strongSelf(strongSelf);
                    BTTMeMainModel *model = value;
                    [strongSelf goSaveMoneyWithModel:model];
                };
                return cell;
            } else if (indexPath.row == 3) {
                //更多存款title
                BTTMeMoreSaveMoneyHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMoreSaveMoneyHeaderCell" forIndexPath:indexPath];
                cell.saveMoneyShowType = self.saveMoneyShowType;
                return cell;
            } else {
                //更多存款
                BTTMeMoreSaveMoneyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMoreSaveMoneyCell" forIndexPath:indexPath];
                if (indexPath.row == 4) {
                    cell.dataSource = self.normalDataSoure;
                } else {
                    cell.dataSource = self.normalDataTwo;
                }
                weakSelf(weakSelf);
                cell.clickEventBlock = ^(id _Nonnull value) {
                    strongSelf(strongSelf);
                    BTTMeMainModel *model = value;
                    [strongSelf goSaveMoneyWithModel:model];
                };
                return cell;
            }
        } else if (self.saveMoneyShowType == BTTMeSaveMoneyShowTypeBig) {
            BTTMeBigSaveMoneyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeBigSaveMoneyCell" forIndexPath:indexPath];
            cell.dataSource = self.bigDataSoure;
            cell.saveMoneyShowType = self.saveMoneyShowType;
            weakSelf(weakSelf);
            
            cell.clickEventBlock = ^(id _Nonnull value) {
                strongSelf(strongSelf);
                BTTMeMainModel *model = value;
                [strongSelf goSaveMoneyWithModel:model];
            };
            return cell;
        } else if (self.saveMoneyShowType == BTTMeSaveMoneyShowTypeMore) {
            BTTMeMoreSaveMoneyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMoreSaveMoneyCell" forIndexPath:indexPath];
            cell.dataSource = self.normalDataSoure.count ? self.normalDataSoure : self.normalDataTwo;
            weakSelf(weakSelf);
            cell.clickEventBlock = ^(id _Nonnull value) {
                strongSelf(strongSelf);
                BTTMeMainModel *model = value;
                [strongSelf goSaveMoneyWithModel:model];
            };
            return cell;
        } else if (self.saveMoneyShowType == BTTMeSaveMoneyShowTypeTwoMore) {
            BTTMeMoreSaveMoneyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMoreSaveMoneyCell" forIndexPath:indexPath];
            if (indexPath.row == 2) {
                cell.dataSource = self.normalDataSoure;
            } else {
                cell.dataSource = self.normalDataTwo;
            }
            weakSelf(weakSelf);
            cell.clickEventBlock = ^(id _Nonnull value) {
                strongSelf(strongSelf);
                BTTMeMainModel *model = value;
                [strongSelf goSaveMoneyWithModel:model];
            };
            return cell;
        } else if (self.saveMoneyShowType == BTTMeSaveMoneyShowTypeBigOneMore) {
            if (indexPath.row == 2) {
                BTTMeBigSaveMoneyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeBigSaveMoneyCell" forIndexPath:indexPath];
                cell.dataSource = self.bigDataSoure;
                cell.saveMoneyShowType = self.saveMoneyShowType;
                weakSelf(weakSelf);
                
                cell.clickEventBlock = ^(id _Nonnull value) {
                    strongSelf(strongSelf);
                    BTTMeMainModel *model = value;
                    [strongSelf goSaveMoneyWithModel:model];
                };
                return cell;
            } else if (indexPath.row == 3) {
                BTTMeMoreSaveMoneyHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMoreSaveMoneyHeaderCell" forIndexPath:indexPath];
                cell.saveMoneyShowType = self.saveMoneyShowType;
                return cell;
            } else {
                BTTMeMoreSaveMoneyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMoreSaveMoneyCell" forIndexPath:indexPath];
                
                cell.dataSource = self.normalDataSoure.count ? self.normalDataSoure : self.normalDataTwo;
                
                weakSelf(weakSelf);
                cell.clickEventBlock = ^(id _Nonnull value) {
                    strongSelf(strongSelf);
                    BTTMeMainModel *model = value;
                    [strongSelf goSaveMoneyWithModel:model];
                };
                return cell;
            }
        } else {
            return [UICollectionViewCell new];
        }*/
    } else if (indexPath.row == 2) {
        BTTMeMoneyHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMoneyHeaderCell" forIndexPath:indexPath];
        return cell;
    } else {
        BTTMeInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeInfoCell" forIndexPath:indexPath];
        cell.mineSparaterType = BTTMineSparaterTypeDoubleLineTwo;
        
        BTTMeMainModel *model = nil;
        if ((indexPath.row-3) < self.mainDataOne.count) {
            model = self.mainDataOne[indexPath.row-3];
        } else {
            model = self.mainDataTwo[indexPath.row-(3+self.mainDataOne.count)];
        }
        cell.isShowHot = self.isShowHot;
        cell.model = model;
        return cell;
    }
}

- (void)goSaveMoneyWithModel:(BTTMeMainModel *)model {
    if (![IVNetwork savedUserInfo]) {//未登入
        [MBProgressHUD showError:@"请先登录" toView:nil];
        BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (self.isShowDepositCheck) {
        if (![self judgmentBindPhoneAndName]) {
            return;
        }
    }
    if (!self.isCompletePersonalInfo && ![[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"]) {//未完善姓名
        [self showCompleteNamePopView];
        return;
    }
    if ([model.name isEqualToString:@"充值USDT"]){
        [CNTimeLog startRecordTime:CNEventPayLaunch];
        USDTRechargeController *vc = [[USDTRechargeController alloc]init];
        [self.navigationController pushViewController:vc animated:true];
        return;
    } else if ([model.name isEqualToString:@"购买USDT"]){
        [CNTimeLog startRecordTime:CNEventPayLaunch];
        USDTBuyController * vc = [[USDTBuyController alloc] init];
        [self.navigationController pushViewController:vc animated:true];
        return;
    }
    
    NSMutableArray *bigArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.bigDataSoure.count; i++) {
        BTTMeMainModel *otcmodel = self.bigDataSoure[i];
        if (![otcmodel.name isEqualToString:@"充值USDT"] && ![otcmodel.name isEqualToString:@"购买USDT"]) {
            [bigArray addObject:otcmodel];
        }
    }
    [CNTimeLog startRecordTime:CNEventPayLaunch];
    NSMutableArray *channelArray = [NSMutableArray new];
    [channelArray addObjectsFromArray:bigArray];
    [channelArray addObjectsFromArray:self.normalDataSoure];
    [channelArray addObjectsFromArray:self.normalDataTwo];
    
    CNPayVC *payVC = [[CNPayVC alloc] initWithChannel:model.paymentType channelArray:channelArray];
    payVC.fastModel = self.fastModel;
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (![IVNetwork savedUserInfo]) {
        [MBProgressHUD showError:@"请先登录" toView:nil];
        BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (indexPath.row < 2) {
        return;
    }
  
    // @"我的优惠"
    if (indexPath.row == 2) {
        BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
        vc.webConfigModel.theme = @"outside";
        vc.webConfigModel.newView = YES;
        vc.title = @"我的优惠";
        vc.webConfigModel.url = @"my_coupon";
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }

    
    
    BTTMeMainModel *model = nil;
    if ((indexPath.row-3) < self.mainDataOne.count) {
        model = self.mainDataOne[indexPath.row-3];
    } else {
        model = self.mainDataTwo[indexPath.row-(3+self.mainDataOne.count)];
    }
    
    if (model == nil) {
        return;
    }
    
    BOOL isUSDTAcc = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"];
    
    if ([model.name isEqualToString:@"版本更新"]) {
        [IVNetwork checkAppUpdate];
        return;
    }
    
    if ([model.name isEqualToString:@"网站检测"]) {
        IVCNetworkStatusView *statusView = [[IVCNetworkStatusView alloc] initWithFrame:self.view.frame];
        
        IVCheckNetworkModel *gatewayModel = [[IVCheckNetworkModel alloc] init];
        gatewayModel.title = @"当前业务线路";
        gatewayModel.urls = [IVHttpManager shareManager].gateways;
        gatewayModel.type = IVKCheckNetworkTypeGateway;
        IVCheckNetworkModel *domainModel = [[IVCheckNetworkModel alloc] init];
        domainModel.title = @"当前手机站";
        domainModel.urls = [IVHttpManager shareManager].domains;
        domainModel.type = IVKCheckNetworkTypeDomain;
        
        statusView.datas = @[gatewayModel, domainModel];
        
        statusView.detailBtnClickedBlock = ^{
            IVCDetailViewController *vc = [[IVCDetailViewController alloc] initWithThemeColor:[UIColor blueColor]];
            [self presentViewController:vc animated:YES completion:^{
                [vc start];
            }];
        };
        
        [self.view addSubview:statusView];
        [statusView startCheck];
        
        return;
    }
    
    
    if ([model.name isEqualToString:@"一键卖币"]) {
        if (self.sellUsdtLink!=nil&&![self.sellUsdtLink isEqualToString:@""]) {
            if ([IVNetwork savedUserInfo].mobileNoBind != 1) {
                BTTBindingMobileController *vc = [[BTTBindingMobileController alloc] init];
                vc.mobileCodeType = BTTSafeVerifyTypeBindMobile;
                vc.showNotice = isUSDTAcc;
                vc.isWithdrawIn = false;
                vc.isSellUsdtIn = true;
                [MBProgressHUD showMessagNoActivity:@"请先绑定手机号!" toView:nil];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
                vc.title = @"一键卖币";
                vc.webConfigModel.theme = @"outside";
                vc.webConfigModel.newView = YES;
                vc.webConfigModel.url = self.sellUsdtLink;
                [self.navigationController pushViewController:vc animated:YES];                
            }
        }
        return;
    }
    
    if ([model.name isEqualToString:@"银行卡资料"] || [model.name isEqualToString:@"钱包管理"]) {
        if (isUSDTAcc) {
            if (self.isCompletePersonalInfo) {
                BTTCardInfosController *vc = [[BTTCardInfosController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                BTTNotCompleteInfoController *vc = [[BTTNotCompleteInfoController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else {
            if ([self judgmentBindPhoneAndName]) {//都完善
                BTTCardInfosController *vc = [[BTTCardInfosController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
        return;
    }
    
    if ([model.name isEqualToString:@"绑定手机"]) {
        UIViewController *vc = nil;
        if ([IVNetwork savedUserInfo].mobileNoBind == 1) {
            BTTVerifyTypeSelectController *selectVC = [BTTVerifyTypeSelectController new];
            selectVC.verifyType = BTTSafeVerifyTypeChangeMobile;
            vc = selectVC;
        } else {
            BTTBindingMobileController *bindingMobileVC = [[BTTBindingMobileController alloc] init];
            bindingMobileVC.mobileCodeType = BTTSafeVerifyTypeBindMobile;
            vc = bindingMobileVC;
        }
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([model.name isEqualToString:@"个人资料"]) {
        BTTPersonalInfoController *personInfo = [[BTTPersonalInfoController alloc] init];
        [self.navigationController pushViewController:personInfo animated:YES];
        return;
    }
    
    if ([model.name isEqualToString:@"设置"]) {
        BTTSettingsController *vc = [[BTTSettingsController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        weakSelf(weakSelf);
        vc.refreshBlock = ^{
            strongSelf(strongSelf);
            [IVNetwork cleanUserInfo];
            [IVHttpManager shareManager].loginName = @"";
            [IVHttpManager shareManager].userToken = @"";
            [strongSelf.navigationController popToRootViewControllerAnimated:NO];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:BTTSaveMoneyTimesKey];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:BTTNicknameCache];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:BTTBiBiCunDate];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:BTTBeforeLoginDate];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:BTTShowSevenXi];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:BTTRegistDate];
            [BTTUserStatusManager logoutSuccess];
            strongSelf.saveMoneyCount = 0;
            [strongSelf loadMeAllData];
            [strongSelf loadPaymentDefaultData];
            strongSelf.totalAmount = @"-";
            strongSelf.yebAmount = @"-";
            strongSelf.yebInterest = @"-";
            [MBProgressHUD showSuccess:@"退出成功" toView:nil];
        };
        return;
    }
    
    if ([model.name isEqualToString:@"站内信"]) {
        BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
        vc.webConfigModel.newView = YES;
        vc.webConfigModel.url = @"mailApp?type=mail/inbox";
        vc.webConfigModel.theme = @"outside";
        vc.title = @"站內信";
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }

    if ([model.name isEqualToString:@"账号安全"]) {
        BTTAccountSafeController *vc = [[BTTAccountSafeController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([model.name isEqualToString:@"客户报表"]) {
        BTTCustomerReportController * vc = [[BTTCustomerReportController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

/// 点击存款
- (void)goToDepositVC {
    BOOL isUSDTAcc = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"];
    if (!isUSDTAcc) {
        [self goSaveMoneyWithModel:self.bigDataSoure.firstObject];
        return;
    }
    CNMUSDTChannelVC *vc = [[CNMUSDTChannelVC alloc] init];
    vc.list = self.bigDataSoure;
    __weak typeof(self)weakSelf = self;
    vc.selectedChannelCallback = ^(NSInteger index) {
        [weakSelf goSaveMoneyWithModel:weakSelf.bigDataSoure[index]];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

/// 点击取款
- (void)goToWithdrawVC {
    if (UserForzenStatus) {
        [[BTTUserForzenManager sharedInstance] checkUserForzen];
    } else {
        BOOL isUSDTAcc = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"];
        if (isUSDTAcc) {
            if (self.isCompletePersonalInfo) {
                if ([IVNetwork savedUserInfo].mobileNoBind != 1) {
                    BTTBindingMobileController *vc = [[BTTBindingMobileController alloc] init];
                    vc.mobileCodeType = BTTSafeVerifyTypeBindMobile;
                    vc.showNotice = isUSDTAcc;
                    vc.isWithdrawIn = true;
                    [MBProgressHUD showMessagNoActivity:@"请先绑定手机号!" toView:nil];
                    [self.navigationController pushViewController:vc animated:YES];
                } else if ([IVNetwork savedUserInfo].usdtNum > 0
                           || [IVNetwork savedUserInfo].bfbNum > 0
                           || [IVNetwork savedUserInfo].dcboxNum > 0) {
                    
                    BTTWithdrawalController *vc = [[BTTWithdrawalController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                } else {
                    [MBProgressHUD showMessagNoActivity:@"请先绑定小金库，USDT钱包或BTC钱包" toView:nil];
                    BTTCardInfosController *vc = [[BTTCardInfosController alloc] init];
                    vc.showNotice = isUSDTAcc;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            } else {
                [MBProgressHUD showMessagNoActivity:@"请先完善个人信息" toView:nil];
                BTTNotCompleteInfoController *vc = [[BTTNotCompleteInfoController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else {
            if ([self judgmentBindPhoneAndName]) {//都完善
                if ([IVNetwork savedUserInfo].bankCardNum > 0) {
                    [self canWithdraw];
                } else {
                    NSString * str = @"请先绑定银行卡";
                    [MBProgressHUD showMessagNoActivity:str toView:nil];
                    BTTCardInfosController *vc = [[BTTCardInfosController alloc] init];
                    vc.showNotice = isUSDTAcc;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    }
}
- (void)canWithdraw
{
    BOOL isUSDTAcc = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"];
    //是否为usdt账户
    if (isUSDTAcc) {
        //普通取款
        BTTWithdrawalController *vc = [[BTTWithdrawalController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    NSMutableDictionary *parmas = @{}.mutableCopy;
    parmas[@"merchant"] = @"A01";
    //网络库底层自带这两个参数，如果其他产品不带的需要加上
//                        parmas[@"loginName"] = @"xxx";
//                        parmas[@"productId"] = @"xxx";
    parmas[@"type"] = @"2";
    parmas[@"currency"] = @"CNY";
    [self showLoading];
    [KYMWithdrewRequest checkChannelWithParams:parmas.copy callback:^(BOOL status, NSString * _Nonnull msg, KYMWithdrewCheckModel  * _Nonnull model) {
        [self hideLoading];
  
        //移除比余额小的金额
        if (model && model.data) {
            [model.data removeAmountBiggerThanTotal:self.totalAmount];
        }
        
        BTTWithdrawalController *vc = [[BTTWithdrawalController alloc] init];
        vc.checkModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}
-(BOOL)judgmentBindPhoneAndName {
    if ([IVNetwork savedUserInfo].mobileNoBind != 1 && !self.isCompletePersonalInfo) {//未綁定手機號 ＆ 未完善姓名
        [self showBindNameAndPhonePopView];
        return false;
        
    } else if ([IVNetwork savedUserInfo].mobileNoBind != 1 && self.isCompletePersonalInfo) {//未綁定手機號 & 已完善姓名
        [self showBindNameAndPhonePopView];
        return false;
        
    } else if ([IVNetwork savedUserInfo].mobileNoBind == 1 && !self.isCompletePersonalInfo) {//已綁定手機號 & 未完善姓名
        [self showCompleteNamePopView];
        return false;
        
    } else {
        return true;
    }
}

#pragma mark - LMJCollectionViewControllerDataSource

- (UICollectionViewLayout *)collectionViewController:(BTTCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView {
    BTTCollectionViewFlowlayout *elementsFlowLayout = [[BTTCollectionViewFlowlayout alloc] initWithDelegate:self];
    
    return elementsFlowLayout;
}

#pragma mark - LMJElementsFlowLayoutDelegate

- (CGSize)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  (self.elementsHight.count && indexPath.row <= self.elementsHight.count - 1) ? self.elementsHight[indexPath.item].CGSizeValue : CGSizeZero;
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
    self.dataList = [self.mainDataOne arrayByAddingObjectsFromArray:self.mainDataTwo];
    NSMutableArray *elementsHight = [NSMutableArray array];
    
    if (SCREEN_WIDTH == 414) {
        [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 200)]];
    } else if (SCREEN_WIDTH == 320) {
        [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 190)]];
    } else {
        [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 190)]];
    }
    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 120)]];
    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH-35)*76/354.0+50)]];
    
    for (int i = 0; i < self.mainDataOne.count; i++) {
        [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH / 3, 100)]];
    }
    
    for (int i = 0; i < self.mainDataTwo.count; i++) {
        [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH / 3, 100)]];
    }
    
    self.elementsHight = elementsHight;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (BOOL)isCompletePersonalInfo
{
    BOOL isComplete = ![[IVNetwork savedUserInfo].realName isEqualToString:@""];
    return isComplete;
}

@end
