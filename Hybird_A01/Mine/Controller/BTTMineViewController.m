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
    self.saveMoneyCount = 4;
    self.saveMoneyShowType = BTTMeSaveMoneyShowTypeAll;
    self.saveMoneyTimesType = BTTSaveMoneyTimesTypeLessTen;
    self.title = @"会员中心";
    self.totalAmount = @"加载中";
    self.collectionView.bounces = NO;
    [self setupNav];
    self.isCompletePersonalInfo = NO;
    self.isChangeMobile = NO;
    [self setupCollectionView];
    [self loadPaymentDefaultData];
    [self loadMeAllData];
    [self registerNotification];
    _webViewVC = [[BTTBaseWebViewController alloc] init];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if ([IVNetwork userInfo]) {
        [self loadUserInfo];
        [self loadBindStatus];
        [self loadBankList];
        if (!self.isLoading) {
            [self loadGamesListAndGameAmount];
        }
        [self loadPaymentData];
        [self loadAccountStatus];
        [self loadSaveMoneyTimes];
//        if (![[[NSUserDefaults standardUserDefaults] objectForKey:BTTNicknameCache] length]) {
            [self loadNickName];
//        }
    } else {
        self.saveMoneyShowType = BTTMeSaveMoneyShowTypeAll;
        self.saveMoneyTimesType = BTTSaveMoneyTimesTypeLessTen;
        self.saveMoneyCount = 4;
        [self loadPaymentDefaultData];
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
        if ([IVNetwork userInfo]) {
            NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:BTTNicknameCache];
            if (!nickName.length) {
                BTTMeHeaderLoginCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeHeaderLoginCell" forIndexPath:indexPath];
                cell.noticeStr = homeVC.noticeStr.length ? homeVC.noticeStr : @"";
                if ([self.totalAmount isEqualToString:@"加载中"]) {
                    cell.totalAmount = self.totalAmount;
                } else {
                    cell.totalAmount = [PublicMethod transferNumToThousandFormat:[self.totalAmount floatValue]];
                }
                
                cell.nameLabel.text = [IVNetwork userInfo].loginName;
                cell.vipLevelLabel.text = ([IVNetwork userInfo].customerLevel == 7) ? @" 准VIP5 " : [NSString stringWithFormat:@" VIP%@ ",@([IVNetwork userInfo].customerLevel)];
                weakSelf(weakSelf);
                cell.accountBlanceBlock = ^{
                    strongSelf(strongSelf);
                    BTTAccountBalanceController *accountBalance = [[BTTAccountBalanceController alloc] init];
                    [strongSelf.navigationController pushViewController:accountBalance animated:YES];
                };
                cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                    strongSelf(strongSelf);
                    BTTNicknameSetController *vc = (BTTNicknameSetController *)[BTTNicknameSetController getVCFromStoryboard];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                };
                cell.clickEventBlock = ^(id  _Nonnull value) {
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
                
                cell.nameLabel.text = [IVNetwork userInfo].loginName;
                cell.vipLevelLabel.text = ([IVNetwork userInfo].customerLevel == 7) ? @" 准VIP5 " : [NSString stringWithFormat:@" VIP%@ ",@([IVNetwork userInfo].customerLevel)];
                weakSelf(weakSelf);
                cell.accountBlanceBlock = ^{
                    strongSelf(strongSelf);
                    BTTAccountBalanceController *accountBalance = [[BTTAccountBalanceController alloc] init];
                    [strongSelf.navigationController pushViewController:accountBalance animated:YES];
                };
                cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                    strongSelf(strongSelf);
                    BTTNicknameSetController *vc = (BTTNicknameSetController *)[BTTNicknameSetController getVCFromStoryboard];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                };
                cell.clickEventBlock = ^(id  _Nonnull value) {
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
            cell.clickEventBlock = ^(id  _Nonnull value) {
                strongSelf(strongSelf);
                BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
                vc.webConfigModel.url = @"common/ancement.htm";
                vc.webConfigModel.newView = YES;
                vc.webConfigModel.theme = @"inside";
                [strongSelf.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        }
    } else if (indexPath.row >= 1 && indexPath.row <= 1 + self.personalInfos.count - 1) {
        BTTMeMainModel *model = self.personalInfos[indexPath.row - 1];
        BTTMeInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeInfoCell" forIndexPath:indexPath];
        cell.model = model;
        return cell;
    } else if (indexPath.row == 1 + self.personalInfos.count ||
               indexPath.row == 3 + self.personalInfos.count + self.saveMoneyCount ||
               indexPath.row == 4 + self.mainDataOne.count + self.personalInfos.count + self.saveMoneyCount ||
               indexPath.row == 5 + self.mainDataTwo.count + self.mainDataOne.count + self.personalInfos.count + self.saveMoneyCount ||
               indexPath.row == 6 + self.mainDataTwo.count + self.mainDataOne.count + self.personalInfos.count + self.saveMoneyCount + self.mainDataThree.count) {
        BTTHomePageSeparateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageSeparateCell" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 2 + self.personalInfos.count) {
        BTTMeMoneyHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMoneyHeaderCell" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row >= 3 + self.personalInfos.count && indexPath.row <= 3 + self.personalInfos.count + self.saveMoneyCount - 1) {
        if (self.saveMoneyShowType == BTTMeSaveMoneyShowTypeAll) {
            if (indexPath.row == 3 + self.personalInfos.count) {
                BTTMeBigSaveMoneyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeBigSaveMoneyCell" forIndexPath:indexPath];
                cell.dataSource = self.bigDataSoure;
                weakSelf(weakSelf);
                cell.clickEventBlock = ^(id  _Nonnull value) {
                    strongSelf(strongSelf);
                    BTTMeMainModel *model = value;
                    [strongSelf goSaveMoneyWithModel:model];
                };
                return cell;
            } else if (indexPath.row == 4 + self.personalInfos.count) {
                BTTMeMoreSaveMoneyHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMoreSaveMoneyHeaderCell" forIndexPath:indexPath];
                return cell;
            } else {
                BTTMeMoreSaveMoneyCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMoreSaveMoneyCell" forIndexPath:indexPath];
                if (indexPath.row == 5 + self.personalInfos.count) {
                    cell.dataSource = self.normalDataSoure;
                } else {
                    cell.dataSource = self.normalDataTwo;
                }
                weakSelf(weakSelf);
                cell.clickEventBlock = ^(id  _Nonnull value) {
                    strongSelf(strongSelf);
                    BTTMeMainModel *model = value;
                    [strongSelf goSaveMoneyWithModel:model];
                };
                return cell;
            }
        } else if (self.saveMoneyShowType == BTTMeSaveMoneyShowTypeBig) {
            BTTMeBigSaveMoneyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeBigSaveMoneyCell" forIndexPath:indexPath];
            cell.dataSource = self.bigDataSoure;
            weakSelf(weakSelf);
            cell.clickEventBlock = ^(id  _Nonnull value) {
                strongSelf(strongSelf);
                BTTMeMainModel *model = value;
                [strongSelf goSaveMoneyWithModel:model];
            };
            return cell;
        } else if (self.saveMoneyShowType == BTTMeSaveMoneyShowTypeMore) {
            BTTMeMoreSaveMoneyCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMoreSaveMoneyCell" forIndexPath:indexPath];
            cell.dataSource = self.normalDataSoure.count ? self.normalDataSoure : self.normalDataTwo;
            weakSelf(weakSelf);
            cell.clickEventBlock = ^(id  _Nonnull value) {
                strongSelf(strongSelf);
                BTTMeMainModel *model = value;
                [strongSelf goSaveMoneyWithModel:model];
            };
            return cell;
        } else if (self.saveMoneyShowType == BTTMeSaveMoneyShowTypeTwoMore) {
            BTTMeMoreSaveMoneyCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMoreSaveMoneyCell" forIndexPath:indexPath];
            if (indexPath.row == 3 + self.personalInfos.count) {
                cell.dataSource = self.normalDataSoure;
            } else {
                cell.dataSource = self.normalDataTwo;
            }
            weakSelf(weakSelf);
            cell.clickEventBlock = ^(id  _Nonnull value) {
                strongSelf(strongSelf);
                BTTMeMainModel *model = value;
                [strongSelf goSaveMoneyWithModel:model];
            };
            return cell;
        } else if (self.saveMoneyShowType == BTTMeSaveMoneyShowTypeBigOneMore) {
            if (indexPath.row == 3 + self.personalInfos.count) {
                BTTMeBigSaveMoneyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeBigSaveMoneyCell" forIndexPath:indexPath];
                cell.dataSource = self.bigDataSoure;
                weakSelf(weakSelf);
                cell.clickEventBlock = ^(id  _Nonnull value) {
                    strongSelf(strongSelf);
                    BTTMeMainModel *model = value;
                    [strongSelf goSaveMoneyWithModel:model];
                };
                return cell;
            } else if (indexPath.row == 4 + self.personalInfos.count) {
                BTTMeMoreSaveMoneyHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMoreSaveMoneyHeaderCell" forIndexPath:indexPath];
                return cell;
            } else {
                BTTMeMoreSaveMoneyCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMoreSaveMoneyCell" forIndexPath:indexPath];
                
                cell.dataSource = self.normalDataSoure.count ? self.normalDataSoure : self.normalDataTwo;
                
                weakSelf(weakSelf);
                cell.clickEventBlock = ^(id  _Nonnull value) {
                    strongSelf(strongSelf);
                    BTTMeMainModel *model = value;
                    [strongSelf goSaveMoneyWithModel:model];
                };
                return cell;
            }
        }
        else {
            return [UICollectionViewCell new];
        }
    } else if (indexPath.row >= 4 + self.personalInfos.count + self.saveMoneyCount && indexPath.row <= 4 + self.mainDataOne.count + self.personalInfos.count + self.saveMoneyCount) {
        BTTMeMainModel *model = self.mainDataOne[indexPath.row - ( 4 + self.personalInfos.count + self.saveMoneyCount)];
        if (self.isShowHidden) {
            NSInteger maxRow = 8 + self.personalInfos.count + self.saveMoneyCount;
            if (self.isFanLi) {
                maxRow += 1;
            }
            if (self.isOpenAccount) {
                maxRow += 1;
            }
            if (indexPath.row >= 8 + self.personalInfos.count + self.saveMoneyCount && indexPath.row <= maxRow) {
                BTTMeInfoHiddenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeInfoHiddenCell" forIndexPath:indexPath];
                cell.mineArrowsDirectionType = BTTMineArrowsDirectionTypeRight;
                cell.model = model;
                return cell;
            } else {
                BTTMeMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMainCell" forIndexPath:indexPath];
                if (indexPath.row == 4 + self.mainDataOne.count + self.personalInfos.count + self.saveMoneyCount) {
                    cell.mineSparaterType = BTTMineSparaterTypeNone;
                } else {
                    cell.mineSparaterType = BTTMineSparaterTypeSingleLine;
                }
                if (indexPath.row == 7 + self.personalInfos.count + self.saveMoneyCount && self.isShowHidden) {
                    cell.mineArrowsDirectionType = BTTMineArrowsDirectionTypeUp;
                } else {
                    cell.mineArrowsDirectionType = BTTMineArrowsDirectionTypeRight;
                }
                cell.model = model;
                return cell;
            }
        } else {
            BTTMeMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMainCell" forIndexPath:indexPath];
            if (indexPath.row == 4 + self.mainDataOne.count + self.personalInfos.count + self.saveMoneyCount) {
                cell.mineSparaterType = BTTMineSparaterTypeNone;
            } else {
                cell.mineSparaterType = BTTMineSparaterTypeSingleLine;
            }
            if (indexPath.row == 7 + self.personalInfos.count + self.saveMoneyCount && self.isShowHidden) {
                cell.mineArrowsDirectionType = BTTMineArrowsDirectionTypeUp;
            } else {
                cell.mineArrowsDirectionType = BTTMineArrowsDirectionTypeRight;
            }
            cell.model = model;
            return cell;
        }
    } else if (indexPath.row >= 5 + self.mainDataOne.count + self.personalInfos.count + self.saveMoneyCount && indexPath.row <= 5 + self.mainDataOne.count + self.personalInfos.count + self.saveMoneyCount + self.mainDataTwo.count) {
        BTTMeMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMainCell" forIndexPath:indexPath];
        BTTMeMainModel *model = self.mainDataTwo[indexPath.row - (5 + self.mainDataOne.count + self.personalInfos.count + self.saveMoneyCount)];
        cell.mineArrowsDirectionType = BTTMineArrowsDirectionTypeRight;
        if (indexPath.row == 5 + self.mainDataOne.count + self.personalInfos.count + self.saveMoneyCount + self.mainDataTwo.count) {
            cell.mineSparaterType = BTTMineSparaterTypeNone;
        } else {
            cell.mineSparaterType = BTTMineSparaterTypeSingleLine;
        }
        cell.model = model;
        return cell;
    } else  {
        BTTMeMainModel *model = self.mainDataThree[indexPath.row - (6 + self.mainDataOne.count + self.personalInfos.count + self.saveMoneyCount + self.mainDataTwo.count)];
        BTTMeMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTMeMainCell" forIndexPath:indexPath];
        cell.model = model;
        cell.mineArrowsDirectionType = BTTMineArrowsDirectionTypeRight;
        cell.mineSparaterType = BTTMineSparaterTypeNone;
        return cell;
    }
}

- (void)goSaveMoneyWithModel:(BTTMeMainModel *)model {
    if (![IVNetwork userInfo]) {
        [MBProgressHUD showError:@"请先登录" toView:nil];
        BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    } else if ([IVNetwork userInfo].customerLevel == 0 && (![IVNetwork userInfo].verify_code.length || ![IVNetwork userInfo].real_name.length)) {
        if (model.paymentType == 15 || model.paymentType == 17 || model.paymentType == 16 || model.paymentType == 2) {
            BTTCompleteMeterialController *personInfo = [[BTTCompleteMeterialController alloc] init];
            [self.navigationController pushViewController:personInfo animated:YES];
            return;
        }
    }
    [[CNTimeLog shareInstance] startRecordTime:CNEventPayLaunch];
    [self.navigationController pushViewController:[[CNPayVC alloc] initWithChannel:model.paymentType] animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"%@",@(indexPath.row));
    if (![IVNetwork userInfo]) {
//        [MBProgressHUD showError:@"请先登录" toView:nil];
//        BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
//        BTTSaveMoneyModifyViewController *vc = [BTTSaveMoneyModifyViewController new];
//        BTTSaveMoneySuccessController *vc = [BTTSaveMoneySuccessController new];
        if (indexPath.row == self.personalInfos.count + self.saveMoneyCount + self.mainDataOne.count + self.mainDataTwo.count + 4) {
            // 网络监测
            [IVNetwork startCheckWithType:IVCheckNetworkTypeAll appWindow:[UIApplication sharedApplication].keyWindow detailBtnClickedBlock:^{
                [self.navigationController pushViewController:[IVNetworkStatusDetailViewController new] animated:YES];
            }];
            return;
        } else if (indexPath.row == self.personalInfos.count + self.saveMoneyCount + self.mainDataOne.count + self.mainDataTwo.count + 3) {
            [IVNetwork checkAppUpdate];
            return;
        }
        [MBProgressHUD showError:@"请先登录" toView:nil];
        BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    NSInteger total = 0;
    if ([IVNetwork userInfo]) {
        total = self.personalInfos.count + 7 + self.saveMoneyCount + self.mainDataOne.count + self.mainDataTwo.count + self.mainDataThree.count;
        
    } else {
        total = self.personalInfos.count + 6 + self.saveMoneyCount + self.mainDataOne.count + self.mainDataTwo.count;
    }
    if (indexPath.row >= total) {
        [self loadPaymentData];
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
    } else if (indexPath.row == 7 + self.personalInfos.count + self.saveMoneyCount) {
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
    } else if (indexPath.row == 4 + self.personalInfos.count + self.saveMoneyCount) {
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
        
    } else if (indexPath.row == 6 + self.personalInfos.count + self.saveMoneyCount) {
        BTTPTTransferController *vc = [[BTTPTTransferController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == self.personalInfos.count + self.saveMoneyCount + self.mainDataOne.count + self.mainDataTwo.count) {
        BTTAccountSafeController *vc = [[BTTAccountSafeController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == self.personalInfos.count + self.saveMoneyCount + self.mainDataOne.count + self.mainDataTwo.count - 1) {
        BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
        vc.webConfigModel.newView = YES;
        vc.webConfigModel.url = @"customer/log.htm";
        vc.webConfigModel.theme = @"inside";
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == self.personalInfos.count + self.saveMoneyCount + self.mainDataOne.count + self.mainDataTwo.count + self.mainDataThree.count  + 5) {
        // 退出登录
        [MBProgressHUD showSuccess:@"退出成功" toView:nil];
        self.saveMoneyShowType = BTTMeSaveMoneyShowTypeAll;
        self.saveMoneyTimesType = BTTSaveMoneyTimesTypeLessTen;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:BTTSaveMoneyTimesKey];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:BTTNicknameCache];
        [BTTUserStatusManager logoutSuccess];
        [self loadPaymentDefaultData];
        [self setupElements];
        self.totalAmount = @"-";
    } else if (indexPath.row == self.personalInfos.count + self.saveMoneyCount + self.mainDataOne.count + self.mainDataTwo.count + 1) {
        // 设置
        BTTSettingsController *vc = [[BTTSettingsController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 5 + self.personalInfos.count + self.saveMoneyCount) {
        BTTXimaController *vc = [[BTTXimaController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == self.personalInfos.count + self.saveMoneyCount + self.mainDataOne.count + self.mainDataTwo.count + 2) {
        BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
        vc.webConfigModel.newView = YES;
        vc.webConfigModel.url = @"customer/letter.htm";
        vc.webConfigModel.theme = @"inside";
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == self.personalInfos.count + self.saveMoneyCount + self.mainDataOne.count + self.mainDataTwo.count + 3) {
        [IVNetwork checkAppUpdate];
    } else if (indexPath.row == self.personalInfos.count + self.saveMoneyCount + self.mainDataOne.count + self.mainDataTwo.count + 4) {
        // 网络监测
        [IVNetwork startCheckWithType:IVCheckNetworkTypeAll appWindow:[UIApplication sharedApplication].keyWindow detailBtnClickedBlock:^{
            [self.navigationController pushViewController:[IVNetworkStatusDetailViewController new] animated:YES];
        }];
    }  else if (indexPath.row >= 3 + self.personalInfos.count && indexPath.row <= 3 + self.personalInfos.count + self.saveMoneyCount - 1) {
        //支付方式点击事件
//        BTTMeMainModel *model = self.paymentDatas[indexPath.row - (3 + self.personalInfos.count)];
//        [self.navigationController pushViewController:[[CNPayVC alloc] initWithChannel:model.paymentType] animated:YES];
    } else if (indexPath.row >= 4 + self.personalInfos.count + self.saveMoneyCount && indexPath.row <= 4 + self.mainDataOne.count + self.personalInfos.count + self.saveMoneyCount) {
        BTTMeMainModel *model = self.mainDataOne[indexPath.row - ( 4 + self.personalInfos.count + self.saveMoneyCount)];
        BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
        vc.webConfigModel.theme = @"outside";
        vc.webConfigModel.newView = YES;
        if ([model.name isEqualToString:@"首存优惠"]) {
            vc.webConfigModel.url = [NSString stringWithFormat:@"%@%@",[IVNetwork h5Domain],@"mypromotion.htm"];
        } else if ([model.name isEqualToString:@"开户礼金"]) {
            vc.webConfigModel.url = [NSString stringWithFormat:@"%@%@",[IVNetwork h5Domain],@"promo_open_account.htm"];
        } else if ([model.name isEqualToString:@"1%存款返利"]) {
            vc.webConfigModel.url = [NSString stringWithFormat:@"%@%@",[IVNetwork h5Domain],@"deposit_rebate.htm"];
        } else {
            vc.webConfigModel.url = [NSString stringWithFormat:@"%@%@",[IVNetwork h5Domain],@"lucky_pot.htm"];
        }
        [self.navigationController pushViewController:vc animated:YES];
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
    NSInteger total = 0;
    if ([IVNetwork userInfo]) {
        total = self.personalInfos.count + 7 + self.saveMoneyCount + self.mainDataOne.count + self.mainDataTwo.count + self.mainDataThree.count;
        
    } else {
        total = self.personalInfos.count + 6 + self.saveMoneyCount + self.mainDataOne.count + self.mainDataTwo.count;
    }
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
        } else if (i >= 1 && i <= 1 + self.personalInfos.count - 1) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH / 4, 98)]];
        } else if (i == 1 + self.personalInfos.count ||
                   i == 3 + self.personalInfos.count + self.saveMoneyCount ||
                   i == 4 + self.mainDataOne.count + self.personalInfos.count + self.saveMoneyCount ||
                   i == 5 + self.mainDataTwo.count + self.mainDataOne.count + self.personalInfos.count + self.saveMoneyCount ||
                   i == 6 + self.mainDataTwo.count + self.mainDataOne.count + self.personalInfos.count + self.saveMoneyCount + self.mainDataThree.count) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 15)]];
        } else if (i == 2 + self.personalInfos.count) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 63)]];
        } else if (i >= 3 + self.personalInfos.count && i <= 3 + self.personalInfos.count + self.saveMoneyCount - 1) {
            if (self.saveMoneyShowType == BTTMeSaveMoneyShowTypeAll) {
                if (i == 3 + self.personalInfos.count) {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 180)]];
                } else if (i == 4 + self.personalInfos.count) {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
                } else if (i == 5 + self.personalInfos.count) {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 90)]];
                }
                else {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 105)]];
                }
            } else if (self.saveMoneyShowType == BTTMeSaveMoneyShowTypeBigOneMore) {
                if (i == 3 + self.personalInfos.count) {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 180)]];
                } else if (i == 4 + self.personalInfos.count) {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
                } else {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 105)]];
                }
            }
            else if (self.saveMoneyShowType == BTTMeSaveMoneyShowTypeBig) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 180)]];
            } else if (self.saveMoneyShowType == BTTMeSaveMoneyShowTypeMore) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 105)]];
            } else {
                if (i == 3 + self.personalInfos.count) {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 90)]];
                } else {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 105)]];
                }
            }
        } else if ((i >= 4 + self.personalInfos.count + self.saveMoneyCount && i <= 4 + self.mainDataOne.count + self.personalInfos.count + self.saveMoneyCount) ||
                   (i >= 5 + self.mainDataOne.count + self.personalInfos.count + self.saveMoneyCount && i <= 5 + self.mainDataOne.count + self.personalInfos.count + self.saveMoneyCount + self.mainDataTwo.count)) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
        } else {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 44)]];
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (BOOL)isCompletePersonalInfo
{
    return [IVNetwork userInfo].real_name && [IVNetwork userInfo].verify_code;
}
@end
