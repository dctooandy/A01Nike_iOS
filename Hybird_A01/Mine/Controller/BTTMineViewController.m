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

@interface BTTMineViewController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, assign) BOOL isChangeMobile; // 是否改变手机号

@property (nonatomic, assign) BOOL isCompletePersonalInfo; // 是否完善个人信息

@end

@implementation BTTMineViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.saveMoneyCount = 4;
    self.isOpenSellUsdt = NO;
    self.saveMoneyShowType = BTTMeSaveMoneyShowTypeAll;
    self.saveMoneyTimesType = BTTSaveMoneyTimesTypeLessTen;
    self.title = @"会员中心";
    self.totalAmount = @"加载中";
    self.collectionView.bounces = NO;
    [self setupNav];
    self.isCompletePersonalInfo = [self isCompletePersonalInfo];
    self.isChangeMobile = NO;
    [self setupCollectionView];
    [self requestBuyUsdtLink];
    [self queryBiShangStatus];
    [self loadPaymentDefaultData];
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
        self.saveMoneyShowType = BTTMeSaveMoneyShowTypeAll;
        self.saveMoneyTimesType = BTTSaveMoneyTimesTypeLessTen;
        self.saveMoneyCount = 4;
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
                } else {
                    cell.totalAmount = [PublicMethod transferNumToThousandFormat:[self.totalAmount floatValue]];
                }
                

                cell.nameLabel.text = [[IVNetwork savedUserInfo].loginName containsString:@"usdt"] ? [[IVNetwork savedUserInfo].loginName stringByReplacingOccurrencesOfString:@"usdt" withString:@""] : [IVNetwork savedUserInfo].loginName;
                cell.vipLevelLabel.text = ([IVNetwork savedUserInfo].starLevel == 7) ? @" 准VIP5 " : [NSString stringWithFormat:@" VIP%@ ", @([IVNetwork savedUserInfo].starLevel)];
                weakSelf(weakSelf);
                cell.changmodeTap = ^{
//                    strongSelf(strongSelf);
                    
                };
                cell.accountBlanceBlock = ^{
                    strongSelf(strongSelf);
                    BTTAccountBalanceController *accountBalance = [[BTTAccountBalanceController alloc] init];
                    [strongSelf.navigationController pushViewController:accountBalance animated:YES];
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
                } else {
                    cell.totalAmount = [PublicMethod transferNumToThousandFormat:[self.totalAmount floatValue]];
                }
                cell.nicknameLabel.text = nickName;
                cell.nameLabel.text = [IVNetwork savedUserInfo].loginName;
                cell.vipLevelLabel.text = ([IVNetwork savedUserInfo].starLevel == 7) ? @" 准VIP5 " : [NSString stringWithFormat:@" VIP%@ ", @([IVNetwork savedUserInfo].starLevel)];
                weakSelf(weakSelf);
                cell.accountBlanceBlock = ^{
                    strongSelf(strongSelf);
                    BTTAccountBalanceController *accountBalance = [[BTTAccountBalanceController alloc] init];
                    [strongSelf.navigationController pushViewController:accountBalance animated:YES];
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
        BTTMeMoneyHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMoneyHeaderCell" forIndexPath:indexPath];
        if ([IVNetwork savedUserInfo].loginName) {
            [cell setAssistantShow:[IVNetwork savedUserInfo].starLevel==0];
        }else{
            [cell setAssistantShow:NO];
        }
        weakSelf(weakSelf)
        cell.rechargeAssistantTap = ^{
            [weakSelf pushToRechargeAssistantViewController];
        };
        return cell;
    } else if (indexPath.row >= 2 && indexPath.row <= 2 + self.saveMoneyCount - 1) {
        if (self.saveMoneyShowType == BTTMeSaveMoneyShowTypeAll) {
            if (indexPath.row == 2) {
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
                BTTMeMoreSaveMoneyHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMoreSaveMoneyHeaderCell" forIndexPath:indexPath];
                cell.saveMoneyShowType = self.saveMoneyShowType;
                return cell;
            } else {
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
        }
    } else if (indexPath.row == 2 + self.saveMoneyCount ||
               indexPath.row == self.saveMoneyCount + 9) {
        BTTHomePageSeparateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageSeparateCell" forIndexPath:indexPath];
        return cell;
    } else {
        BTTMeInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeInfoCell" forIndexPath:indexPath];
        if ((indexPath.row > self.saveMoneyCount + 5 && indexPath.row <= self.saveMoneyCount + 8) ||
            (indexPath.row >= self.saveMoneyCount + 16 && indexPath.row <= self.saveMoneyCount + 18)) {
            cell.mineSparaterType = BTTMineSparaterTypeDoubleLineOne;
        } else {
            cell.mineSparaterType = BTTMineSparaterTypeDoubleLineTwo;
        }
        BTTMeMainModel *model = nil;
        if (indexPath.row >= self.saveMoneyCount + 3 && indexPath.row <= self.saveMoneyCount + 8) {
            model = self.mainDataOne[indexPath.row - self.saveMoneyCount - 3];
        } else {
            model = self.mainDataTwo[indexPath.row - self.saveMoneyCount - self.mainDataOne.count - 4];
        }
        cell.model = model;
        return cell;
    }
}

- (void)jumpToBuyUsdt{
    if (![IVNetwork savedUserInfo]) {
        [MBProgressHUD showError:@"请先登录" toView:nil];
        BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (self.buyUsdtLink!=nil&&![self.buyUsdtLink isEqualToString:@""]) {
        BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
        vc.title = @"充值/购买USDT";
        vc.webConfigModel.theme = @"outside";
        vc.webConfigModel.newView = YES;
        vc.webConfigModel.url = self.buyUsdtLink;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)pushToRechargeAssistantViewController{
    if (![IVNetwork savedUserInfo]) {
        [MBProgressHUD showError:@"请先登录" toView:nil];
        BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
    vc.title = @"存款小助手";
    vc.webConfigModel.theme = @"outside";
    vc.webConfigModel.newView = YES;
    vc.webConfigModel.url = [NSString stringWithFormat:@"%@%@", [IVNetwork h5Domain], @"#/rechargeAssistant"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)goSaveMoneyWithModel:(BTTMeMainModel *)model {
    if (![IVNetwork savedUserInfo]) {
        [MBProgressHUD showError:@"请先登录" toView:nil];
        BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    } else if ([IVNetwork savedUserInfo].starLevel == 0 && (![IVNetwork savedUserInfo].realName.length) && (![IVNetwork savedUserInfo].verifyCode.length)) {
        BTTCompleteMeterialController *personInfo = [[BTTCompleteMeterialController alloc] init];
        [self.navigationController pushViewController:personInfo animated:YES];
        return;
    }else if ([model.name isEqualToString:@"充值/购买USDT"]){
        [self jumpToBuyUsdt];
        return;
    }
    NSMutableArray *bigArray = [[NSMutableArray alloc]init];
    bigArray = self.bigDataSoure;
    if (self.bigDataSoure.count>0) {
        BTTMeMainModel *otcmodel = self.bigDataSoure.firstObject;
        if ([otcmodel.name isEqualToString:@"充值/购买USDT"]) {
            [bigArray removeObjectAtIndex:0];
        }
    }
    [[CNTimeLog shareInstance] startRecordTime:CNEventPayLaunch];
    NSMutableArray *channelArray = [NSMutableArray new];
    [channelArray addObjectsFromArray:bigArray];
    [channelArray addObjectsFromArray:self.normalDataSoure];
    [channelArray addObjectsFromArray:self.normalDataTwo];
    
    [self.navigationController pushViewController:[[CNPayVC alloc] initWithChannel:model.paymentType channelArray:channelArray] animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"%@", @(indexPath.row));
    if ((indexPath.row == self.saveMoneyCount + self.mainDataOne.count + 10&&[IVNetwork savedUserInfo].newAccountFlag!=1)||(indexPath.row == self.saveMoneyCount + self.mainDataOne.count + 8&&[IVNetwork savedUserInfo].newAccountFlag==1)) {
        [IVNetwork checkAppUpdate];
        return;
    } else if ((indexPath.row == self.saveMoneyCount + self.mainDataOne.count + 11&&[IVNetwork savedUserInfo].newAccountFlag!=1)||(indexPath.row == self.saveMoneyCount + self.mainDataOne.count + 9&&[IVNetwork savedUserInfo].newAccountFlag==1)) {
        // 网络监测
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
            [self presentViewController:vc animated:YES completion:nil];
        };

        [self.view addSubview:statusView];
        [statusView startCheck];

        return;
    }
    if (![IVNetwork savedUserInfo]) {
        [MBProgressHUD showError:@"请先登录" toView:nil];
        BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.row == self.saveMoneyCount + 3) {
        if (self.isCompletePersonalInfo) {
            if ([IVNetwork savedUserInfo].bankCardNum > 0 || [IVNetwork savedUserInfo].usdtNum > 0||[IVNetwork savedUserInfo].bfbNum>0) {
                NSInteger usdtCount = [IVNetwork savedUserInfo].usdtNum;
                BOOL isBlackNineteen = [[IVNetwork savedUserInfo].depositLevel isEqualToString:@"-19"];
                
                if (isBlackNineteen&&usdtCount==0&&[IVNetwork savedUserInfo].btcNum==0) {
                    [MBProgressHUD showMessagNoActivity:@"请先绑定USDT或BTC钱包" toView:nil];
                    return;
                }
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
    }else if ((indexPath.row == self.saveMoneyCount + 4&&self.isOpenSellUsdt)) {
        
        if (![IVNetwork savedUserInfo]) {
            [MBProgressHUD showError:@"请先登录" toView:nil];
            BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        if (self.sellUsdtLink!=nil&&![self.sellUsdtLink isEqualToString:@""]) {
            BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
            vc.title = @"一键卖币";
            vc.webConfigModel.theme = @"outside";
            vc.webConfigModel.newView = YES;
            vc.webConfigModel.url = self.sellUsdtLink;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if ((indexPath.row == self.saveMoneyCount + 4&&!self.isOpenSellUsdt)||(indexPath.row == self.saveMoneyCount + 5&&self.isOpenSellUsdt)) {
        BTTXimaController *vc = [[BTTXimaController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ((indexPath.row == self.saveMoneyCount + 5&&!self.isOpenSellUsdt)||(indexPath.row == self.saveMoneyCount + 6&&self.isOpenSellUsdt)) {
        if (self.isCompletePersonalInfo) {
            BTTCardInfosController *vc = [[BTTCardInfosController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            BTTNotCompleteInfoController *vc = [[BTTNotCompleteInfoController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if ((indexPath.row == self.saveMoneyCount + 6&&!self.isOpenSellUsdt)||(indexPath.row == self.saveMoneyCount + 7&&self.isOpenSellUsdt)) {
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
    } else if ((indexPath.row == self.saveMoneyCount + 7&&!self.isOpenSellUsdt)||(indexPath.row == self.saveMoneyCount + 8&&self.isOpenSellUsdt)) {
        BTTPersonalInfoController *personInfo = [[BTTPersonalInfoController alloc] init];
        [self.navigationController pushViewController:personInfo animated:YES];
    } else if (indexPath.row == self.saveMoneyCount + self.mainDataOne.count + 4&&[IVNetwork savedUserInfo].newAccountFlag!=1) {
        
        NSMutableArray *names = @[@"首存优惠"].mutableCopy;
        if (self.isFanLi) {
            NSInteger index = [names indexOfObject:@"首存优惠"];
            [names insertObject:@"1%存款返利" atIndex:index + 1];
        }
        if (self.isOpenAccount) {
            NSInteger index = [names indexOfObject:@"首存优惠"];
            [names insertObject:@"开户礼金" atIndex:index + 1];
        }
        BTTActionSheet *actionSheet = [[BTTActionSheet alloc] initWithTitle:@"我的优惠" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:names actionSheetBlock:^(NSInteger buttonIndex) {
            NSLog(@"选择了%@", @(buttonIndex));
            if (buttonIndex == names.count) {
            } else {
                BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
                vc.webConfigModel.theme = @"outside";
                vc.webConfigModel.newView = YES;
                //            vc.webConfigModel.url = [NSString stringWithFormat:@"%@%@",[IVNetwork h5Domain],@"lucky_pot.htm"];
                NSString *title = names[buttonIndex];
                vc.title = title;
                if ([title isEqualToString:@"1%存款返利"]) {
                    vc.webConfigModel.url = [NSString stringWithFormat:@"%@%@", [IVNetwork h5Domain], @"#/activity_pages/deposit_rebate"];
                } else if ([title isEqualToString:@"开户礼金"]) {
                    vc.webConfigModel.url = [NSString stringWithFormat:@"%@%@", [IVNetwork h5Domain], @"#/activity_pages/promo_open_account"];
                } else if ([title isEqualToString:@"首存优惠"]) {
                    vc.webConfigModel.url = [NSString stringWithFormat:@"%@%@", [IVNetwork h5Domain], @"#/first_deposit"];
                }
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
        [actionSheet show];
    } else if (indexPath.row == self.saveMoneyCount + self.mainDataOne.count + 5&&[IVNetwork savedUserInfo].newAccountFlag!=1) {
        BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
        vc.title = @"推荐礼金";
        vc.webConfigModel.theme = @"outside";
        vc.webConfigModel.newView = YES;
        vc.webConfigModel.url = [NSString stringWithFormat:@"%@%@", [IVNetwork h5Domain], @"#/gift/lucky_pot"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ((indexPath.row == self.saveMoneyCount + self.mainDataOne.count + 6&&[IVNetwork savedUserInfo].newAccountFlag!=1)||(indexPath.row == self.saveMoneyCount + self.mainDataOne.count + 4&&[IVNetwork savedUserInfo].newAccountFlag==1)) {
        BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
        vc.webConfigModel.newView = YES;
        vc.webConfigModel.url = @"customer/log.htm";
        vc.webConfigModel.theme = @"inside";
        [self.navigationController pushViewController:vc animated:YES];
    } else if ((indexPath.row == self.saveMoneyCount + self.mainDataOne.count + 7&&[IVNetwork savedUserInfo].newAccountFlag!=1)||(indexPath.row == self.saveMoneyCount + self.mainDataOne.count + 5&&[IVNetwork savedUserInfo].newAccountFlag==1)) {
        BTTAccountSafeController *vc = [[BTTAccountSafeController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ((indexPath.row == self.saveMoneyCount + self.mainDataOne.count + 8&&[IVNetwork savedUserInfo].newAccountFlag!=1)||(indexPath.row == self.saveMoneyCount + self.mainDataOne.count + 6&&[IVNetwork savedUserInfo].newAccountFlag==1)) {
        BTTPTTransferController *vc = [[BTTPTTransferController alloc] init];
        vc.balanceModel = self.balanceModel;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ((indexPath.row == self.saveMoneyCount + self.mainDataOne.count + 9&&[IVNetwork savedUserInfo].newAccountFlag!=1)||(indexPath.row == self.saveMoneyCount + self.mainDataOne.count + 7&&[IVNetwork savedUserInfo].newAccountFlag==1)) {
        BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
        vc.webConfigModel.newView = YES;
        vc.webConfigModel.url = @"customer/letter.htm";
        vc.webConfigModel.theme = @"inside";
        [self.navigationController pushViewController:vc animated:YES];
    } else if ((indexPath.row == self.saveMoneyCount + self.mainDataOne.count + 12&&[IVNetwork savedUserInfo].newAccountFlag!=1)||(indexPath.row == self.saveMoneyCount + self.mainDataOne.count + 10&&[IVNetwork savedUserInfo].newAccountFlag==1)) {
        // 设置
        BTTSettingsController *vc = [[BTTSettingsController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        weakSelf(weakSelf);
        vc.refreshBlock = ^{
            strongSelf(strongSelf);
            [IVNetwork cleanUserInfo];
            [IVHttpManager shareManager].loginName = @"";
            [strongSelf.navigationController popToRootViewControllerAnimated:NO];
            strongSelf.saveMoneyShowType = BTTMeSaveMoneyShowTypeAll;
            strongSelf.saveMoneyTimesType = BTTSaveMoneyTimesTypeLessTen;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:BTTSaveMoneyTimesKey];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:BTTNicknameCache];
            [BTTUserStatusManager logoutSuccess];
            [strongSelf loadPaymentDefaultData];
            [strongSelf setupElements];
            strongSelf.totalAmount = @"-";
            [MBProgressHUD showSuccess:@"退出成功" toView:nil];
        };
    }
}

- (void)requestTakeMoneyTimes{
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTQueryTakeMoneyTimes paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSString *times = [NSString stringWithFormat:@"%@",result.body];
            NSString *message = @"";
            if ([times isEqualToString:@"1"]||[times isEqualToString:@"2"]) {
                message = [NSString stringWithFormat:@"为配合菲新冠疫情防治实施远程办公,日取款上限二次.您今天取款剩余次数为%@次,取款到账时间为2小时",times];
            }else{
                message = @"为配合菲新冠疫情防治实施远程办公,日取款上限二次.您今天取款次数已达2次,请明日再来取款";
            }
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([times isEqualToString:@"1"]||[times isEqualToString:@"2"]) {
                    BTTWithdrawalController *vc = [[BTTWithdrawalController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
                
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:cancel];
            [alertVC addAction:confirm];
            [self presentViewController:alertVC animated:YES completion:nil];
        }else{
            [MBProgressHUD showError:@"接口请求异常,请稍后重试" toView:nil];
        }
    }];
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
    NSInteger total = self.saveMoneyCount + 4 + self.mainDataOne.count + self.mainDataTwo.count;

    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        if (i == 0) {
            if (SCREEN_WIDTH == 414) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 172)]];
            } else if (SCREEN_WIDTH == 320) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 158)]];
            } else {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 158)]];
            }
        } else if (i == 1) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 63)]];
        } else if (i >= 2  && i <= 2 + self.saveMoneyCount - 1) {
            if (self.saveMoneyShowType == BTTMeSaveMoneyShowTypeAll) {
                if (i == 2) {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 180)]];
                } else if (i == 3) {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
                } else if (i == 4) {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 90)]];
                } else {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 105)]];
                }
            } else if (self.saveMoneyShowType == BTTMeSaveMoneyShowTypeBigOneMore) {
                if (i == 2) {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 180)]];
                } else if (i == 3) {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
                } else {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 105)]];
                }
            } else if (self.saveMoneyShowType == BTTMeSaveMoneyShowTypeBig) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 180)]];
            } else if (self.saveMoneyShowType == BTTMeSaveMoneyShowTypeMore) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 105)]];
            } else {
                if (i == 2) {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 90)]];
                } else {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 105)]];
                }
            }
        } else if (i == 1 + self.saveMoneyCount + 1 ||
                   i == self.saveMoneyCount + 9) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 10)]];
        } else {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH / 3, 100)]];
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (BOOL)isCompletePersonalInfo
{
    BOOL isComplete = (![[IVNetwork savedUserInfo].realName isEqualToString:@""]) && (![[IVNetwork savedUserInfo].verifyCode isEqualToString:@""]);
    return isComplete;
}

@end
