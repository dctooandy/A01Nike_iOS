//
//  BTTHomePageViewController.m
//  Hybird_A01
//
//  Created by Domino on 2018/9/29.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTHomePageViewController.h"
#import "BTTHomePageViewController+LoadData.h"
#import "BTTHomePageBannerCell.h"
#import "BTTHomePageADCell.h"
#import "BTTHomePageNoticeCell.h"
#import "BTTHomePageGamesCell.h"
#import "BTTHomePageAppsCell.h"
#import "BTTHomePageSeparateCell.h"
#import "BTTHomePageDiscountHeaderCell.h"
#import "BTTHomePageDiscountCell.h"
#import "BTTActivityModel.h"
#import "BTTHomePageActivitiesCell.h"
#import "BTTHomePageAmountsCell.h"
#import "BTTHomePageViewController+Nav.h"
#import "BTTPromotionModel.h"
#import "BTTPosterModel.h"
#import "BTTPromotionDetailController.h"
#import "BTTBannerModel.h"
#import "BTTDownloadModel.h"
#import "BTTAGGJViewController.h"
#import "BTTAGQJViewController.h"
#import "BTTDiscountsViewController.h"
#import "BTTVideoGamesListController.h"
#import "BTTGamesTryAlertView.h"
#import "BTTLoginOrRegisterViewController.h"
#import "BTTHomePageFooterCell.h"
#import "BTTHomePageHeaderModel.h"
#import "BTTLuckyWheelCoinView.h"
#import "BTTAndroid88PopView.h"
#import "BTTRealPersonGameCell.h"
#import "BTTElectronicGamesCell.h"
#import "BTTOtherGameCell.h"
#import "BTTHotPromotionsCell.h"
#import "BTTConsetiveWinsPopView.h"

@interface BTTHomePageViewController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, assign) BOOL adCellShow;
@property (nonatomic, assign) BOOL   isloaded;

@end

@implementation BTTHomePageViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    if ([IVNetwork savedUserInfo]) {
        self.isLogin = YES;
    } else {
        self.isLogin = NO;
    }
    
    [self setupNav];
    [self setupCollectionView];
    [self setupLoginAndRegisterBtnsView];
    [self setupElements];
    weakSelf(weakSelf);
    [self pulldownRefreshWithRefreshBlock:^{
        strongSelf(strongSelf);
        NSLog(@"下拉刷新");
        [strongSelf refreshDatasOfHomePage];
    }];
    [self loadDataOfHomePage];
    [self registerNotification];
//    [IVNetwork registException];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSTimeInterval interval = [[userDefault objectForKey:@"jayTimeStamp"] doubleValue] / 1000.0;
        NSInteger today = [PublicMethod timeIntervalSince1970].integerValue;
        NSInteger endTime = [PublicMethod timeSwitchTimestamp:@"2019-11-17 23:59:59" andFormatter:@"yyyy-MM-dd HH:mm:ss"];
        if (today <= endTime) {
            if (![PublicMethod isDateToday:[NSDate dateWithTimeIntervalSince1970:interval]]) {
                [userDefault setObject:[PublicMethod timeIntervalSince1970] forKey:@"jayTimeStamp"];
                [self showJay];
            }
        }
    });
    [self setupFloatWindow];
    
}

- (void)showConsetivePopView{
    NSString *timeStamp = [[NSUserDefaults standardUserDefaults]objectForKey:BTTConsetiveWinsToday];
    if (timeStamp==nil) {
        [self showCWpopView];
        NSString *timeStamp1 = [PublicMethod getCurrentTimesWithFormat:@"yyyy-MM-dd hh:mm:ss"];
        [[NSUserDefaults standardUserDefaults]setObject:timeStamp1 forKey:BTTConsetiveWinsToday];
    }else{
        BOOL isSameDay = [PublicMethod isDateToday:[PublicMethod transferDateStringToDate:timeStamp]];
        
        if (!isSameDay) {
            NSString *timeStamp1 = [PublicMethod getCurrentTimesWithFormat:@"yyyy-MM-dd hh:mm:ss"];
            [[NSUserDefaults standardUserDefaults]setObject:timeStamp1 forKey:BTTConsetiveWinsToday];
            NSDate *startDate = [PublicMethod transferDateStringToDate:@"2020-01-18 00:00:00"];
            NSDate *endDate = [PublicMethod transferDateStringToDate:@"2020-02-09 23:59:59"];
            if ([PublicMethod date:[NSDate date] isBetweenDate:startDate andDate:endDate]) {
                [self showCWpopView];
            }
        }
    }
}

- (void)showCWpopView{
    BTTConsetiveWinsPopView *alertView = [BTTConsetiveWinsPopView viewFromXib];
    
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:alertView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = NO;
    [popView pop];
    alertView.tapActivity = ^{
        [popView dismiss];
        BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
        vc.webConfigModel.url = [@"win_champions.htm" stringByReplacingOccurrencesOfString:@" " withString:@""];
        vc.webConfigModel.newView = YES;
        vc.webConfigModel.theme = @"outside";
        [self.navigationController pushViewController:vc animated:YES];
    };
    alertView.dismissBlock = ^{
        [popView dismiss];
    };
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    BOOL isShowAccountGride = [[[NSUserDefaults standardUserDefaults] objectForKey:BTTShowAccountGride] boolValue];
    if ([PublicMethod isDateToday:[PublicMethod transferDateStringToDate:[IVNetwork savedUserInfo].lastLoginDate]] && !isShowAccountGride) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:BTTShowAccountGride];
        [self showNewAccountGrideView];
    }
    //第一次出现预加载游戏
    if (!self.isloaded) {
        self.isloaded = YES;
        //AG旗舰预加载
        [BTTAGQJViewController addGameViewToWindow];
        
        //AG国际预加载
        [BTTAGGJViewController addGameViewToWindow];
        [[IVGameManager sharedManager] reloadCacheGame];
        [IN3SAnalytics launchFinished];
    }
    [self showConsetivePopView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if ([IVNetwork savedUserInfo]) {
        [BTTHttpManager requestUnReadMessageNum:nil];
        NSString *timestamp = [[NSUserDefaults standardUserDefaults] objectForKey:BTTCoinTimestamp];
        if (![NSDate isToday:timestamp]) {
            [self loadLuckyWheelCoinStatus];
            NSString *timestamp = [NSString stringWithFormat:@"%@",@([[NSDate date] timeIntervalSince1970] * 1000)];
            [[NSUserDefaults standardUserDefaults] setObject:timestamp forKey:BTTCoinTimestamp];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.collectionView.frame = CGRectMake(0, BTTNavHeightLogin, SCREEN_WIDTH, SCREEN_HEIGHT - BTTNavHeightLogin);
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageBannerCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageBannerCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageADCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageADCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageNoticeCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageNoticeCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageGamesCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageGamesCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageAppsCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageAppsCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageSeparateCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageSeparateCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageDiscountHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageDiscountHeaderCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageDiscountCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageDiscountCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageActivitiesCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageActivitiesCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageAmountsCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageAmountsCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageFooterCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageFooterCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTRealPersonGameCell" bundle:nil] forCellWithReuseIdentifier:@"BTTRealPersonGameCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTElectronicGamesCell" bundle:nil] forCellWithReuseIdentifier:@"BTTElectronicGamesCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTOtherGameCell" bundle:nil] forCellWithReuseIdentifier:@"BTTOtherGameCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHotPromotionsCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHotPromotionsCell"];
//    BTTElectronicGamesCell BTTOtherGameCell BTTHotPromotionsCell
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.adCellShow) {
        if (indexPath.row == 0) {
            BTTHomePageADCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageADCell" forIndexPath:indexPath];
            cell.model = self.posters.count ? self.posters[0] : nil;
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                [strongSelf.posters removeAllObjects];
                [strongSelf setupElements];
            };
            return cell;
        } else if (indexPath.row == 1) {
            BTTHomePageBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageBannerCell" forIndexPath:indexPath];
            weakSelf(weakSelf);
            cell.clickEventBlock = ^(id  _Nonnull value) {
                strongSelf(strongSelf);
                BTTBannerModel *model = strongSelf.banners[[value integerValue]];
                if ([model.action.type isEqualToString:@"1"]) {
                    BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
                    vc.webConfigModel.url = [model.action.detail stringByReplacingOccurrencesOfString:@" " withString:@""];
                    vc.webConfigModel.newView = YES;
                    vc.webConfigModel.browser = NO;
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }else{
                    [strongSelf bannerToGame:model];
                }
                
            };
            cell.imageUrls = self.imageUrls;
            return cell;
        } else if (indexPath.row == 2) {
            BTTHomePageNoticeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageNoticeCell" forIndexPath:indexPath];
            cell.noticeStr = self.noticeStr;
            weakSelf(weakSelf); 
            cell.clickEventBlock = ^(id  _Nonnull value) {
                strongSelf(strongSelf);
                BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
                vc.webConfigModel.url = @"common/ancement.htm";
                vc.webConfigModel.newView = YES;
                vc.webConfigModel.theme = @"inside";
                [strongSelf.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        } else if (indexPath.row == 3) {
            BTTRealPersonGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTRealPersonGameCell" forIndexPath:indexPath];
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                [strongSelf forwardToGameViewWithTag:button.tag];
            };
            return cell;
        } else if (indexPath.row == 4) {
            BTTElectronicGamesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTElectronicGamesCell" forIndexPath:indexPath];
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                [strongSelf forwardToGameViewWithTag:button.tag];
            };
            return cell;

        } else if (indexPath.row == 5) {
            BTTOtherGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTOtherGameCell" forIndexPath:indexPath];
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                [strongSelf forwardToGameViewWithTag:button.tag];
            };
            return cell;
        } else if (indexPath.row == 7) {
            BTTHotPromotionsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHotPromotionsCell" forIndexPath:indexPath];
            cell.promotions = self.promotions;
            weakSelf(weakSelf);
            cell.clickEventBlock = ^(id  _Nonnull value) {
                strongSelf(strongSelf);
                BTTPromotionModel *model = value;
                BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
                vc.webConfigModel.url = [model.href stringByReplacingOccurrencesOfString:@" " withString:@""];
                vc.webConfigModel.newView = YES;
                [strongSelf.navigationController pushViewController:vc animated:YES];
            };
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                BTTDiscountsViewController *vc = [BTTDiscountsViewController new];
                vc.discountsVCType = BTTDiscountsVCTypeDetail;
                [strongSelf.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        } else if (indexPath.row == 9) {
            BTTHomePageAppsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageAppsCell" forIndexPath:indexPath];
            cell.downloads = self.downloads;
            cell.clickEventBlock = ^(id  _Nonnull value) {
                BTTDownloadModel *model = value;
                if (!model.iosLink.length) {
                    [MBProgressHUD showError:@"抱歉, 该游戏不支持苹果手机, 请使用安卓系统手机下载就可以了" toView:nil];
                    return;
                }

                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.iosLink]];
            };
            return cell;
        }
        else if (indexPath.row == 11) {
            BTTHomePageActivitiesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageActivitiesCell" forIndexPath:indexPath];
            BTTActivityModel *model = self.Activities.count ? self.Activities[self.nextGroup] : nil;
            cell.activityModel = model;
            weakSelf(weakSelf);
            cell.reloadBlock = ^{
                strongSelf(strongSelf);
                strongSelf.nextGroup += 1;
                if (strongSelf.nextGroup == self.Activities.count) {
                    self.nextGroup = 0;
                }
                [strongSelf setupElements];
            };
            return cell;
        }else if (indexPath.row == 6 || indexPath.row == 8 || indexPath.row == 10 || indexPath.row == 12) {
            BTTHomePageSeparateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageSeparateCell" forIndexPath:indexPath];
            return cell;
        }
        else if (indexPath.row == 13) {
            BTTHomePageAmountsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageAmountsCell" forIndexPath:indexPath];
            cell.amounts = self.amounts;
            return cell;
        } else {
            BTTHomePageFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageFooterCell" forIndexPath:indexPath];
            cell.model = self.posters.count > 1 ? self.posters[1] : nil;
            return cell;
        }
    } else  {
        if (indexPath.row == 0) {
            BTTHomePageBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageBannerCell" forIndexPath:indexPath];
            cell.imageUrls = self.imageUrls;
            weakSelf(weakSelf);
            cell.clickEventBlock = ^(id  _Nonnull value) {
                strongSelf(strongSelf);
                BTTBannerModel *model = strongSelf.banners[[value integerValue]];
                if ([model.action.type isEqualToString:@"1"]) {
                    BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
                    vc.webConfigModel.url = [model.action.detail stringByReplacingOccurrencesOfString:@" " withString:@""];
                    vc.webConfigModel.newView = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [strongSelf bannerToGame:model];
                }
            };
            return cell;
        } else if (indexPath.row == 1) {
            BTTHomePageNoticeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageNoticeCell" forIndexPath:indexPath];
            cell.noticeStr = self.noticeStr;
            weakSelf(weakSelf);
            cell.clickEventBlock = ^(id  _Nonnull value) {
                strongSelf(strongSelf);
                BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
                vc.webConfigModel.url = @"common/ancement.htm";
                vc.webConfigModel.newView = YES;
                vc.webConfigModel.theme = @"inside";
                [strongSelf.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        } else if (indexPath.row == 2) {
            BTTRealPersonGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTRealPersonGameCell" forIndexPath:indexPath];
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                [strongSelf forwardToGameViewWithTag:button.tag];
            };
            return cell;
        } else if (indexPath.row == 3) {
            BTTElectronicGamesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTElectronicGamesCell" forIndexPath:indexPath];
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                [strongSelf forwardToGameViewWithTag:button.tag];
            };
            return cell;
            
        } else if (indexPath.row == 4) {
            BTTOtherGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTOtherGameCell" forIndexPath:indexPath];
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                [strongSelf forwardToGameViewWithTag:button.tag];
            };
            return cell;
        } else if (indexPath.row == 6) {
            BTTHotPromotionsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHotPromotionsCell" forIndexPath:indexPath];
            weakSelf(weakSelf);
            cell.clickEventBlock = ^(id  _Nonnull value) {
                strongSelf(strongSelf);
                BTTPromotionModel *model = value;
                BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
                vc.webConfigModel.url = [model.href stringByReplacingOccurrencesOfString:@" " withString:@""];
                vc.webConfigModel.newView = YES;
                [strongSelf.navigationController pushViewController:vc animated:YES];
            };
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                BTTDiscountsViewController *vc = [BTTDiscountsViewController new];
                vc.discountsVCType = BTTDiscountsVCTypeDetail;
                [strongSelf.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        } else if (indexPath.row == 8) {
            BTTHomePageAppsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageAppsCell" forIndexPath:indexPath];
            cell.downloads = self.downloads;
            cell.clickEventBlock = ^(id  _Nonnull value) {
                BTTDownloadModel *model = value;
                if (!model.iosLink.length) {
                    [MBProgressHUD showError:@"抱歉, 该游戏不支持苹果手机, 请使用安卓系统手机下载就可以了" toView:nil];
                    return;
                }
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.iosLink]];
            };
            return cell;
        } else if (indexPath.row == 10) {
            BTTHomePageActivitiesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageActivitiesCell" forIndexPath:indexPath];
            BTTActivityModel *model = self.Activities.count ? self.Activities[self.nextGroup] : nil;
            cell.activityModel = model;
            weakSelf(weakSelf);
            cell.reloadBlock = ^{
                strongSelf(strongSelf);
                strongSelf.nextGroup += 1;
                if (strongSelf.nextGroup == self.Activities.count) {
                    self.nextGroup = 0;
                }
                [strongSelf setupElements];
            };
            return cell;
        } else if (indexPath.row == 5 || indexPath.row == 7 || indexPath.row == 9 || indexPath.row == 11) {
            BTTHomePageSeparateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageSeparateCell" forIndexPath:indexPath];
            return cell;
        }
        else if (indexPath.row == 12) {
            BTTHomePageAmountsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageAmountsCell" forIndexPath:indexPath];
            cell.amounts = self.amounts;
            return cell;
        } else {
            BTTHomePageFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageFooterCell" forIndexPath:indexPath];
            cell.model = self.posters.count > 1 ? self.posters[1] : nil;
            return cell;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    BTTPosterModel * model = nil;
    if (self.adCellShow) {
        if (indexPath.row == 0) {
            model = self.posters.count ? self.posters[0] : nil;
            if (!model || !model.link.length) {
                return;
            }
            BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
            vc.webConfigModel.url = [model.link stringByReplacingOccurrencesOfString:@" " withString:@""];
            vc.webConfigModel.newView = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 14) {
            model = self.posters.count ? self.posters[1] : nil;
            if (!model || !model.link.length) {
                return;
            }
            BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
            vc.webConfigModel.url = [model.link stringByReplacingOccurrencesOfString:@" " withString:@""];
            vc.webConfigModel.newView = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        if (indexPath.row == 13) {
            model = self.posters.count ? self.posters[1] : nil;
            if (!model || !model.link.length) {
                return;
            }
            BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
            vc.webConfigModel.url = [model.link stringByReplacingOccurrencesOfString:@" " withString:@""];
            vc.webConfigModel.newView = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

}

- (void)refreshDataOfActivities {
    self.nextGroup += 1;
    if (self.nextGroup == self.Activities.count) {
        self.nextGroup = 0;
    }
    [self setupElements];
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
    return UIEdgeInsetsMake(0, 0, KIsiPhoneX ? 63 : 59, 0);
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
    if (self.posters.count) {
        self.adCellShow = YES;
    } else {
        self.adCellShow = NO;
    }
    if (self.adCellShow) {
        total = 15;
    } else {
        total = 14;
    }
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        if (self.adCellShow) {
            if (i == 0 || i == 2) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 45)]];
            } else if (i == 1) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, BTTBnnnerDefaultHeight * (SCREEN_WIDTH / BTTBannerDefaultWidth))]];
            } else if (i == 3) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, ((SCREEN_WIDTH - 30) / 2 - 5) / 168.0 * 133 + 60)]];
            } else if (i == 4) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH - 40) / 335.0 * 144 + 60)]];
            } else if (i == 5) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH - 40) / 335.0 * 227 + 72.5)]];
            } else if (i == 7) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 140)]];
            } else if (i == 9) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 180)]];
            } else if (i == 11) {
                if (self.Activities.count) {
                    BTTActivityModel *model = self.Activities[self.nextGroup];
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, model.cellHeight)]];
                } else {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 388)]];
                }
            } else if (i == 6 || i == 8 || i == 10 || i == 12) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 15)]];
            }
            else if (i == 13) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 300)]];
            } else {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 60)]];
            }
        } else {
            if (i == 0) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, BTTBnnnerDefaultHeight * (SCREEN_WIDTH / BTTBannerDefaultWidth))]];
            } else if (i == 1) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 45)]];
            } else if (i == 2) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, ((SCREEN_WIDTH - 30) / 2 - 5) / 168.0 * 133 + 60)]];
            } else if (i == 3) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH - 40) / 335.0 * 144 + 60)]];
            } else if (i == 4) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH - 40) / 335.0 * 227 + 72.5)]];
            } else if (i == 6) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 140)]];
            } else if (i == 8) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 180)]];
            } else if (i == 10) {
                if (self.Activities.count) {
                    BTTActivityModel *model = self.Activities[self.nextGroup];
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, model.cellHeight)]];
                } else {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 388)]];
                }
            } else if (i == 5 || i == 7 || i == 9 || i == 11) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 15)]];
            }
            else if (i == 12) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 300)]];
            } else {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 60)]];
            }
        }
    }
    self.elementsHight = [elementsHight mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}
- (void)forwardToGameViewWithTag:(NSInteger)tag
{
    UIViewController *vc = nil;
    IVGameModel *model = nil;
    BTTVideoGamesListController *videoGamesVC = nil;
    switch (tag) {
        case 1000://AG旗舰
            vc = [BTTAGQJViewController new];
            [[CNTimeLog shareInstance] startRecordTime:CNEventAGQJLaunch];
            break;
        case 1001://AG国际
            vc = [BTTAGGJViewController new];
            break;
        case 1002://沙巴体育

        {
            BTTPosterModel * model = self.posters.count ? self.posters[1] : nil;
            videoGamesVC = [BTTVideoGamesListController new];
            videoGamesVC.banners = self.banners;
            videoGamesVC.imageUrls = self.imageUrls;
            videoGamesVC.poster = model;
            videoGamesVC.provider = @"TTG";
        }
            
            break;
        case 1003://捕鱼王
            model = [[IVGameModel alloc] init];
            model.cnName =  kFishCnName;
            model.enName =  kFishEnName;
            model.provider = kAGINProvider;
            model.gameId = model.gameCode;
            model.gameType = kFishType;
            break;
            
            case 1004:
        {
            BTTPosterModel * model = self.posters.count ? self.posters[1] : nil;
            videoGamesVC = [BTTVideoGamesListController new];
            videoGamesVC.banners = self.banners;
            videoGamesVC.imageUrls = self.imageUrls;
            videoGamesVC.poster = model;
            videoGamesVC.provider = @"MG";
        }
            break;
        case 1005:
            //跳电子游戏大厅
        {
            BTTPosterModel * model = self.posters.count ? self.posters[1] : nil;
            videoGamesVC = [[BTTVideoGamesListController alloc] init];
            videoGamesVC.banners = self.banners;
            videoGamesVC.imageUrls = self.imageUrls;
            videoGamesVC.poster = model;
        }
            break;
        
        case 1006: {
            model = [[IVGameModel alloc] init];
            model.cnName = @"沙巴体育";
            model.enName =  kASBEnName;
            model.provider =  kShaBaProvider;
        }
            break;
        case 1007://BTI体育
            model = [[IVGameModel alloc] init];
            model.cnName = @"BTI体育";
            model.enName =  @"SBT_BTI";
            model.provider =  @"SBT";
            break;
        case 1008:{
            model = [[IVGameModel alloc] init];
            model.cnName = @"竞彩";
            model.enName = @"NB";
            model.provider = @"NB";
            model.isSports = YES;
        }
            break;
            
        case 1009: {
            model = [[IVGameModel alloc] init];
            model.cnName = @"体育VIP厅";
            model.enName =  @"CS";
            model.provider =  @"CS";
            model.language = @"zh";
        }
            break;
        case 1010://AS电游
            model = [[IVGameModel alloc] init];
            model.cnName = @"AS真人棋牌";
            model.enName =  kASSlotEnName;
            model.provider = kASSlotProvider;
            break;
        case 1011://AG彩票
            model = [[IVGameModel alloc] init];
            model.cnName = @"AG彩票";
            model.enName = @"K8";
            model.provider = @"K8";
            break;
        default:
            break;
    }
    if ([IVNetwork savedUserInfo]) {
        if (vc || videoGamesVC) {
            if (vc) {
                [self.navigationController pushViewController:vc animated:YES];
            } else if (videoGamesVC) {
                [self.navigationController pushViewController:videoGamesVC animated:YES];
            }
        }
        if (model) {
            [[IVGameManager sharedManager] forwardToGameWithModel:model controller:self];
        }
    } else {
        if (tag == 1006 || tag == 1011 || tag == 1008) {
            [MBProgressHUD showError:@"请先登录" toView:nil];
            BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (tag == 3) {
            
        } else {
            weakSelf(weakSelf);
            [self showTryAlertViewWithBlock:^(UIButton *btn) {
                strongSelf(strongSelf);
                NSLog(@"%@",@(btn.tag));
                if (btn.tag == 1090) {
                    if (vc || videoGamesVC) {
                        if (vc) {
                            [self.navigationController pushViewController:vc animated:YES];
                        } else if (videoGamesVC) {
                            [self.navigationController pushViewController:videoGamesVC animated:YES];
                        }
                    }
                    if (model) {
                        [[IVGameManager sharedManager] forwardToGameWithModel:model controller:strongSelf];
                    }
                } else {
                    [MBProgressHUD showError:@"请先登录" toView:nil];
                    BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
    }
    
}




@end
