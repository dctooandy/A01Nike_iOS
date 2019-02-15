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
    if ([IVNetwork userInfo]) {
        self.isLogin = YES;
    } else {
        self.isLogin = NO;
    }
    [self setupNav];
    [self setupCollectionView];
    [self setupElements];
    weakSelf(weakSelf);
    [self pulldownRefreshWithRefreshBlock:^{
        strongSelf(strongSelf);
        NSLog(@"下拉刷新");
        [strongSelf loadDataOfHomePage];
    }];
    [self loadDataOfHomePage];
    [self registerNotification];
    [IVNetwork registException];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //第一次出现预加载游戏
    if (!self.isloaded) {
        self.isloaded = YES;
        //AG旗舰预加载
        [BTTAGQJViewController addGameViewToWindow];
        //AG国际预加载
        [BTTAGGJViewController addGameViewToWindow];
        [[IVGameManager sharedManager] reloadCacheGame];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if ([IVNetwork userInfo]) {
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
    self.collectionView.frame = CGRectMake(0,  self.isLogin ? BTTNavHeightLogin : BTTNavHeightNotLogin, SCREEN_WIDTH, SCREEN_HEIGHT - (self.isLogin ? BTTNavHeightLogin : BTTNavHeightNotLogin));
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
                [strongSelf bannerToGame:model];
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
            BTTHomePageGamesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageGamesCell" forIndexPath:indexPath];
            cell.games = self.games;
            weakSelf(weakSelf);
            cell.clickEventBlock = ^(id  _Nonnull value) {
                strongSelf(strongSelf);
                [strongSelf forwardToGameView:value];
            };
            return cell;
        } else if (indexPath.row == 4) {
            BTTHomePageAppsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageAppsCell" forIndexPath:indexPath];
            cell.downloads = self.downloads;
            weakSelf(weakSelf);
            cell.clickEventBlock = ^(id  _Nonnull value) {
                BTTDownloadModel *model = value;
                if (!model.iosLink.length) {
                    [MBProgressHUD showError:@"抱歉, 该游戏不支持苹果手机, 请使用安卓系统手机下载就可以了" toView:nil];
                    return;
                }
                strongSelf(strongSelf);
                BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
                vc.webConfigModel.url = model.iosLink;
                vc.webConfigModel.newView = YES;
                vc.webConfigModel.theme = @"outside";
                [strongSelf.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        } else if (indexPath.row == 5 || indexPath.row == 7 + (self.promotions.count ? self.promotions.count : 3) || indexPath.row == 10 + (self.promotions.count ? self.promotions.count : 3)) {
            BTTHomePageSeparateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageSeparateCell" forIndexPath:indexPath];
            return cell;
        } else if (indexPath.row == 6 || indexPath.row == 8 + (self.promotions.count ? self.promotions.count : 3) || indexPath.row == 11 + (self.promotions.count ? self.promotions.count : 3)) {
            BTTHomePageDiscountHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageDiscountHeaderCell" forIndexPath:indexPath];
            BTTHomePageHeaderModel *headerModel = nil;
            if (indexPath.row == 6) {
                headerModel = self.headers[0];
            } else if (indexPath.row == 8 + (self.promotions.count ? self.promotions.count : 3)) {
                headerModel = self.headers[1];
                if (self.Activities.count > 1) {
                    headerModel.detailBtnStr = @"查看下一组";
                } else {
                    headerModel.detailBtnStr = @"";
                }
            } else {
                headerModel = self.headers[2];
            }
            cell.headerModel = headerModel;
            return cell;
        } else if (indexPath.row >= 7 && indexPath.row < 7 + (self.promotions.count ? self.promotions.count : 3)) {
            BTTHomePageDiscountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageDiscountCell" forIndexPath:indexPath];
            BTTPromotionModel *model = self.promotions.count ? self.promotions[indexPath.row - 7] : nil;
            if (indexPath.row == 6 + (self.promotions.count ? self.promotions.count : 3)) {
                cell.mineSparaterType = BTTMineSparaterTypeNone;
            } else {
                cell.mineSparaterType = BTTMineSparaterTypeSingleLine;
            }
            cell.model = model;
            return cell;
        } else if (indexPath.row == 9 + (self.promotions.count ? self.promotions.count : 3)) {
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
        } else if (indexPath.row == 13 + (self.promotions.count ? self.promotions.count : 3)) {
            BTTHomePageFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageFooterCell" forIndexPath:indexPath];
            return cell;
        } else  {
            BTTHomePageAmountsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageAmountsCell" forIndexPath:indexPath];
            cell.amounts = self.amounts;
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
                [strongSelf bannerToGame:model];
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
            BTTHomePageGamesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageGamesCell" forIndexPath:indexPath];
            cell.games = self.games;
            weakSelf(weakSelf);
            cell.clickEventBlock = ^(id  _Nonnull value) {
                strongSelf(strongSelf);
                [strongSelf forwardToGameView:value];
            };
            return cell;
        } else if (indexPath.row == 3) {
            BTTHomePageAppsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageAppsCell" forIndexPath:indexPath];
            cell.downloads = self.downloads;
            weakSelf(weakSelf);
            cell.clickEventBlock = ^(id  _Nonnull value) {
                BTTDownloadModel *model = value;
                if (!model.iosLink.length) {
                    [MBProgressHUD showError:@"抱歉, 该游戏不支持苹果手机, 请使用安卓系统手机下载就可以了" toView:nil];
                    return;
                }
                strongSelf(strongSelf);
                BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
                vc.webConfigModel.url = model.iosLink.length ? model.iosLink : model.androidLink;
                vc.webConfigModel.newView = YES;
                vc.webConfigModel.theme = @"outside";
                [strongSelf.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        } else if (indexPath.row == 4 || indexPath.row == 6 + (self.promotions.count ? self.promotions.count : 3) || indexPath.row == 9 + (self.promotions.count ? self.promotions.count : 3)) {
            BTTHomePageSeparateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageSeparateCell" forIndexPath:indexPath];
            return cell;
        } else if (indexPath.row == 5 || indexPath.row == 7 + (self.promotions.count ? self.promotions.count : 3) || indexPath.row == 10 + (self.promotions.count ? self.promotions.count : 3)) {
            BTTHomePageDiscountHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageDiscountHeaderCell" forIndexPath:indexPath];
            BTTHomePageHeaderModel *model = nil;
            if (indexPath.row == 5) {
                model = self.headers[0];
            } else if (indexPath.row == 7 + (self.promotions.count ? self.promotions.count : 3)) {
                model = self.headers[1];
                if (self.Activities.count > 1) {
                    model.detailBtnStr = @"查看下一组";
                } else {
                    model.detailBtnStr = @"";
                }
            } else {
                model = self.headers[2];
            }
            cell.headerModel = model;
            return cell;
        } else if (indexPath.row >= 6 && indexPath.row < 6 + (self.promotions.count ? self.promotions.count : 3)) {
            BTTPromotionModel *model = self.promotions.count ? self.promotions[indexPath.row - 6] : nil;
            BTTHomePageDiscountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageDiscountCell" forIndexPath:indexPath];
            if (indexPath.row == 5 + (self.promotions.count ? self.promotions.count : 3)) {
                cell.mineSparaterType = BTTMineSparaterTypeNone;
            } else {
                cell.mineSparaterType = BTTMineSparaterTypeSingleLine;
            }
            cell.model = model;
            return cell;
        } else if (indexPath.row == 8 + (self.promotions.count ? self.promotions.count : 3)) {
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
        } else if (indexPath.row == 12 + (self.promotions.count ? self.promotions.count : 3)) {
            BTTHomePageFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageFooterCell" forIndexPath:indexPath];
            return cell;
        }
        else {
            BTTHomePageAmountsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageAmountsCell" forIndexPath:indexPath];
            cell.amounts = self.amounts;
            return cell;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSInteger total = 0;
    if (self.posters.count) {
        self.adCellShow = YES;
    } else {
        self.adCellShow = NO;
    }
    NSInteger promotionCount = self.promotions.count ? self.promotions.count : 3;
    if (self.adCellShow) {
        total = 14 + promotionCount;
    } else {
        total = 13 + promotionCount;
    }
    if (self.elementsHight.count != total) {
        return;
    }
    if (self.adCellShow) {
        if (indexPath.row == 8 + (self.promotions.count ? self.promotions.count : 3)) {
            [self refreshDataOfActivities];
        } else if (indexPath.row >= 7 && indexPath.row < 7 + (self.promotions.count ? self.promotions.count : 3)) {
            BTTPromotionModel *model = self.promotions.count ? self.promotions[indexPath.row - 7] : nil;
            if (!model) {
                return;
            }
            if ([model.href hasPrefix:@"http"]) {
                BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
                vc.webConfigModel.url = [model.href stringByReplacingOccurrencesOfString:@" " withString:@""];
                vc.webConfigModel.newView = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                NSRange gameIdRange = [model.href rangeOfString:@"gameId"];
                if (gameIdRange.location != NSNotFound) {
                    NSArray *arr = [model.href componentsSeparatedByString:@":"];
                    NSString *gameid = arr[1];
                    UIViewController *vc = nil;
                    if ([gameid isEqualToString:@"A01003"]) {
                        vc = [BTTAGQJViewController new];
                        [self.navigationController pushViewController:vc animated:YES];
                    } else if ([gameid isEqualToString:@"A01026"]) {
                        vc = [BTTAGGJViewController new];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
                NSRange andRange = [model.href rangeOfString:@"&"];
                if (andRange.location != NSNotFound) {
                    NSArray *andArr = [model.href componentsSeparatedByString:@"&"];
                    NSArray *providerArr = [andArr[0] componentsSeparatedByString:@":"];
                    NSString *provider = providerArr[1];
                    NSArray *gameKindArr = [andArr[1] componentsSeparatedByString:@":"];
                    NSString *gameKind = gameKindArr[1];
                    IVGameModel *model = [[IVGameModel alloc] init];
                    if ([provider isEqualToString:@"AGIN"] && [gameKind isEqualToString:@"8"]) { // 捕鱼王
                        model = [[IVGameModel alloc] init];
                        model.cnName =  kFishCnName;
                        model.enName =  kFishEnName;
                        model.provider = kAGINProvider;
                        model.gameId = model.gameCode;
                        model.gameType = kFishType;
                        [[IVGameManager sharedManager] forwardToGameWithModel:model controller:self];
                    } else if ([provider isEqualToString:@"SHAB"] && [gameKind isEqualToString:@"1"]) { // 沙巴体育
                        model = [[IVGameModel alloc] init];
                        model.cnName = @"沙巴体育";
                        model.enName =  kASBEnName;
                        model.provider =  kShaBaProvider;
                    } else if ([provider isEqualToString:@"BTI"] && [gameKind isEqualToString:@"1"]) {  // BTIi体育
                        model = [[IVGameModel alloc] init];
                        model.cnName = @"BTI体育";
                        model.enName =  @"SBT_BTI";
                        model.provider =  @"SBT";
                    } else if ([provider isEqualToString:@"MG"] ||
                               [provider isEqualToString:@"AGIN"] ||
                               [provider isEqualToString:@"PT"] ||
                               [provider isEqualToString:@"TTG"] ||
                               [provider isEqualToString:@"PP"]) {
                        BTTVideoGamesListController *videoGamesVC = [BTTVideoGamesListController new];
                        NSString *subProvider = nil;
                        if ([provider isEqualToString:@"AGIN"]) {
                            subProvider = @"AG";
                        } else {
                            subProvider = provider;
                        }
                        videoGamesVC.provider = subProvider;
                        [self.navigationController pushViewController:videoGamesVC animated:YES];
                    }
                } else {
                    NSRange providerRange = [model.href rangeOfString:@"provider"];
                    if (providerRange.location != NSNotFound) {
                        NSArray *arr = [model.href componentsSeparatedByString:@":"];
                        NSString *provider = arr[1];
                        UIViewController *vc = nil;
                        if ([provider isEqualToString:@"AGQJ"]) {
                            vc = [BTTAGQJViewController new];
                            [self.navigationController pushViewController:vc animated:YES];
                        } else if ([provider isEqualToString:@"AGIN"]) {
                            vc = [BTTAGGJViewController new];
                            [self.navigationController pushViewController:vc animated:YES];
                        } else if ([provider isEqualToString:@"AS"]) {
                            IVGameModel *model = [[IVGameModel alloc] init];
                            model.cnName = @"AS电游";
                            model.enName =  kASSlotEnName;
                            model.provider = kASSlotProvider;
                        }
                    }
                }
            }
        } else if (indexPath.row == 2) {
            BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
            vc.webConfigModel.url = @"common/ancement.htm";
            vc.webConfigModel.newView = YES;
            vc.webConfigModel.theme = @"inside";
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 0 || indexPath.row == 13 + (self.promotions.count ? self.promotions.count : 3)) {
            BTTPosterModel * model = self.posters.count ? self.posters[0] : nil;
            if (!model) {
                return;
            }
            BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
            vc.webConfigModel.url = [model.link stringByReplacingOccurrencesOfString:@" " withString:@""];
            vc.webConfigModel.newView = YES;
            vc.webConfigModel.theme = @"outside";
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 6 || indexPath.row == 8 + (self.promotions.count ? self.promotions.count : 3) || indexPath.row == 11 + (self.promotions.count ? self.promotions.count : 3)) {
            if (indexPath.row == 6) {
                BTTDiscountsViewController *vc = [[BTTDiscountsViewController alloc] init];
                vc.discountsVCType = BTTDiscountsVCTypeDetail;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } else {
        if (indexPath.row == 7 + (self.promotions.count ? self.promotions.count : 3)) {
            [self refreshDataOfActivities];
        } else if (indexPath.row >= 6 && indexPath.row < 6 + (self.promotions.count ? self.promotions.count : 3)) {
            BTTPromotionModel *model = self.promotions.count ? self.promotions[indexPath.row - 6] : nil;
            if (!model) {
                return;
            }
            BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
            vc.webConfigModel.url = [model.href stringByReplacingOccurrencesOfString:@" " withString:@""];
            vc.webConfigModel.newView = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
            vc.webConfigModel.url = @"common/ancement.htm";
            vc.webConfigModel.newView = YES;
            vc.webConfigModel.theme = @"inside";
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 5 || indexPath.row == 7 + (self.promotions.count ? self.promotions.count : 3) || indexPath.row == 10 + (self.promotions.count ? self.promotions.count : 3)) {
            if (indexPath.row == 5) {
                BTTDiscountsViewController *vc = [[BTTDiscountsViewController alloc] init];
                vc.discountsVCType = BTTDiscountsVCTypeDetail;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else if (indexPath.row == 12 + (self.promotions.count ? self.promotions.count : 3)) {
            BTTPosterModel * model = self.posters.count ? self.posters[0] : nil;
            if (!model) {
                return;
            }
            BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
            vc.webConfigModel.url = [model.link stringByReplacingOccurrencesOfString:@" " withString:@""];
            vc.webConfigModel.newView = YES;
            vc.webConfigModel.theme = @"outside";
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
    NSInteger promotionCount = self.promotions.count ? self.promotions.count : 3;
    if (self.adCellShow) {
        total = 14 + promotionCount;
    } else {
        total = 13 + promotionCount;
    }
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        if (self.adCellShow) {
            if (i == 0 || i == 2) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 45)]];
            } else if (i == 1) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, BTTBnnnerDefaultHeight * (SCREEN_WIDTH / BTTBannerDefaultWidth))]];
            } else if (i == 3) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 174)]];
            } else if (i == 4) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 166)]];
            } else if (i == 5 || i == 7 + promotionCount || i == 10 + promotionCount) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 15)]];
            } else if (i == 6 || i == 8 + promotionCount || i == 11 + promotionCount) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 45)]];
            } else if (i >= 7 && i < 7 + promotionCount) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 130)]];
            } else if (i == 9 + promotionCount) {
                if (self.Activities.count) {
                    BTTActivityModel *model = self.Activities[self.nextGroup];
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, model.cellHeight)]];
                } else {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 228)]];
                }
            } else if (i == 12 + promotionCount) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 295)]];
            } else if (i == 13 + promotionCount) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 60)]];
            }
            else {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
            }
        } else {
            if (i == 0) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, BTTBnnnerDefaultHeight * (SCREEN_WIDTH / BTTBannerDefaultWidth))]];
            } else if (i == 1) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 45)]];
            } else if (i == 2) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 174)]];
            } else if (i == 3) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 166)]];
            } else if (i == 4 || i == 6 + promotionCount || i == 9 + promotionCount) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 15)]];
            } else if (i == 5 || i == 7 + promotionCount || i == 10 + promotionCount) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 45)]];
            } else if (i >= 6 && i < 6 + promotionCount) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 130)]];
            } else if (i == 8 + promotionCount) {
                if (self.Activities.count) {
                    BTTActivityModel *model = self.Activities[self.nextGroup];
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, model.cellHeight)]];
                } else {
                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 228)]];
                }
            } else if (i == 11 + promotionCount) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 295)]];
            } else if (i == 12 + promotionCount) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 60)]];
            }
            else {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 100)]];
            }
        }
    }
    self.elementsHight = [elementsHight mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}
- (void)forwardToGameView:(BTTGameModel *)gameModel
{
    UIViewController *vc = nil;
    IVGameModel *model = nil;
    switch (gameModel.index) {
        case 0://AG旗舰
            vc = [BTTAGQJViewController new];
            break;
        case 1://AG国际
            vc = [BTTAGGJViewController new];
            break;
        case 2://捕鱼王
            model = [[IVGameModel alloc] init];
            model.cnName =  kFishCnName;
            model.enName =  kFishEnName;
            model.provider = kAGINProvider;
            model.gameId = model.gameCode;
            model.gameType = kFishType;
            break;
        case 3:
            //跳电子游戏大厅
        {
            BTTPosterModel * model = self.posters.count ? self.posters[0] : nil;
            BTTVideoGamesListController *videoGame = [[BTTVideoGamesListController alloc] init];
            videoGame.banners = self.banners;
            videoGame.imageUrls = self.imageUrls;
            videoGame.poster = model;
            [self.navigationController pushViewController:videoGame animated:YES];
        }
            break;
        case 4://沙巴体育
            model = [[IVGameModel alloc] init];
            model.cnName = @"沙巴体育";
            model.enName =  kASBEnName;
            model.provider =  kShaBaProvider;
            break;
        case 5://BTI体育
            model = [[IVGameModel alloc] init];
            model.cnName = @"BTI体育";
            model.enName =  @"SBT_BTI";
            model.provider =  @"SBT";
            break;
        case 6://AS电游
            model = [[IVGameModel alloc] init];
            model.cnName = @"AS电游";
            model.enName =  kASSlotEnName;
            model.provider = kASSlotProvider;
            break;
        default:
            break;
    }
    if ([IVNetwork userInfo]) {
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (model) {
            [[IVGameManager sharedManager] forwardToGameWithModel:model controller:self];
        }
    } else {
        if (gameModel.index == 4) {
            [MBProgressHUD showError:@"请先登录" toView:nil];
            BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (gameModel.index == 3) {
            
        } else {
            weakSelf(weakSelf);
            [self showTryAlertViewWithBlock:^(UIButton *btn) {
                strongSelf(strongSelf);
                NSLog(@"%@",@(btn.tag));
                if (btn.tag == 1090) {
                    if (vc) {
                        [strongSelf.navigationController pushViewController:vc animated:YES];
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
