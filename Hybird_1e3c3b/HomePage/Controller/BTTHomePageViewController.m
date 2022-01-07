//
//  BTTHomePageViewController.m
//  Hybird_1e3c3b
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
#import "DSBRedBagPopView.h"
#import "BTTUserStatusManager.h"
#import "BTTChooseCurrencyPopView.h"
#import "BTTUserGameCurrencyModel.h"
#import "BTTActivityManager.h"
#import "BTTUserForzenManager.h"
#import "AppDelegate.h"
#import "BTTAssistiveButtonModel.h"


@interface BTTHomePageViewController ()<BTTElementsFlowLayoutDelegate>

@property (nonatomic, assign) BOOL adCellShow;
@property (nonatomic, assign) BOOL   isloaded;
@property (nonatomic, strong) NSMutableArray * userCurrencysArr;

@end

@implementation BTTHomePageViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    [BTTUserForzenManager sharedInstance];
    if ([IVNetwork savedUserInfo]) {
        self.isLogin = YES;
        [self checkHasShow];
        [self requestRedbag];
        [BTTActivityManager sharedInstance];
    } else {
        self.isLogin = NO;
        //弹窗
        [self showHomePopView];
    }
    
    [self setupNav];
    [self setupCollectionView];
    [self setupLoginAndRegisterBtnsView];
    [self setupElements];
    [self loadDataOfHomePage];
    [self registerNotification];
//    [IVNetwork registException];
    weakSelf(weakSelf);
    [self pulldownRefreshWithRefreshBlock:^{
        strongSelf(strongSelf);
        NSLog(@"下拉刷新");
        [strongSelf refreshDatasOfHomePage];
    }];
    //悬浮按钮设定
    [self loadAssistiveDataWithBlock:^(BTTAssistiveButtonModel * _Nonnull model) {
        [weakSelf setUpAssistiveButton:model completed:^{
            if (self.assistiveButton != nil) {
                [weakSelf.view addSubview:weakSelf.assistiveButton];
            }
        }];
    }];
    [self setUpCustomAssistiveButtonCompleted:^{
        if (self.redPocketsAssistiveButton != nil) {
            [weakSelf.view addSubview:weakSelf.redPocketsAssistiveButton];
        }
    }];
    [[BTTActivityManager sharedInstance] checkTimeForRedPoickets];
    [self checkLoginVersion];

//    [self setupFloatWindow];
    //监听内部广播
    //状态:已登入过,检查没有Token过期
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeBannerData) name:@"CHANGE_MODE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkHasShow) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestRedbag) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadBanner) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkHasShow) name:LogoutSuccessNotification object:nil];
}

#pragma mark - viewDidAppear
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //第一次登入顯示提示 引導頁
//    BOOL isShowAccountGride = [[[NSUserDefaults standardUserDefaults] objectForKey:BTTShowAccountGride] boolValue];
//    if ([PublicMethod isDateToday:[PublicMethod transferDateStringToDate:[IVNetwork savedUserInfo].lastLoginDate]] && !isShowAccountGride) {
//        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:BTTShowAccountGride];
//        [self showNewAccountGrideView];
//    }
    //第一次出现预加载游戏
    if (!self.isloaded) {
        self.isloaded = YES;
        //AG旗舰预加载
        [BTTAGQJViewController addGameViewToWindow];
        //AG国际预加载
        [BTTAGGJViewController addGameViewToWindow];
//        [[IVGameManager sharedManager] reloadCacheGame];
        [CNTimeLog endRecordTime:CNEventAppLaunch];
        if ([IVNetwork savedUserInfo]) {
            [[BTTUserForzenManager sharedInstance] checkUserForzen];
        } else {
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.idDisable) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UnlockGameBtnPress" object:nil];
    }
}

#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.idDisable = false;
    [self showAssistiveButton];
    [self.collectionView reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self refreshDatasOfHomePage];
}

-(void)showHomePopView {
    //比比存
//    NSDate * saveDate = [PublicMethod transferDateStringToDate:[[NSUserDefaults standardUserDefaults] objectForKey:BTTBiBiCunDate]];
//    if ([IVNetwork savedUserInfo].starLevel >= 2 && (![PublicMethod isDateToday:saveDate] || saveDate == nil)) {
//        [self loadBiBiCun];
//    }
    
    //彈窗集成
    [[BTTActivityManager sharedInstance] checkPopViewWithCompletionBlock:nil];
    
    [BTTHttpManager requestUnReadMessageNum:nil];
    
    //博幣彈窗
//    NSString *timestamp = [[NSUserDefaults standardUserDefaults] objectForKey:BTTCoinTimestamp];
//    if (![NSDate isToday:timestamp]) {
//        [self loadLuckyWheelCoinStatus];
//        NSString *timestamp = [NSString stringWithFormat:@"%@",@([[NSDate date] timeIntervalSince1970] * 1000)];
//        [[NSUserDefaults standardUserDefaults] setObject:timestamp forKey:BTTCoinTimestamp];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
}

-(void)checkLoginVersion {
    if ([IVNetwork savedUserInfo]) {
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        if ([appVersion compare:[IVNetwork savedUserInfo].version options:NSNumericSearch] == NSOrderedDescending) {
            [IVNetwork cleanUserInfo];
            [IVHttpManager shareManager].loginName = @"";
            [IVHttpManager shareManager].userToken = @"";
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:BTTSaveMoneyTimesKey];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:BTTNicknameCache];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:BTTBiBiCunDate];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:BTTBeforeLoginDate];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:BTTShowSevenXi];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:BTTRegistDate];
            [[NSNotificationCenter defaultCenter] postNotificationName:LogoutSuccessNotification object:nil];
            [BTTUserStatusManager logoutSuccess];
        }
    }
}

#pragma mark - 換幣種帳號banner不同所以要刷新
-(void)removeBannerData {
    [self.imageUrls removeAllObjects];
    [self.promotions removeAllObjects];
}

-(void)reloadBanner {
    [self refreshDatasOfHomePage];
}

#pragma mark - 提示
- (void)checkHasShow{
//    [IVNetwork requestPostWithUrl:BTTQueryLoginedShow paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
//        IVJResponseObject *result = response;
//        if ([result.head.errCode isEqualToString:@"0000"]) {
//            if (result.body!=nil) {
//                NSString *code = [NSString stringWithFormat:@"%@",result.body];
//                if ([code isEqualToString:@"1"]) {
//                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"尊敬的博天堂客户:\n \n因网站持菲律宾正规博彩牌照,应菲政府肺炎疫情防控要求,采取局部远程办公等措施,服务效率略降.广受喜爱的AG平台亦响应菲政府决定暂停部分桌台.\n \n对此向各位致以诚挚歉意!我们定会竭力保证游戏顺畅做好服务!\n \n疫情期间,温馨提醒您戴口罩勤洗手,保持良好心态,让我们一起携手战胜病毒!\n \n博天堂全体员工敬上!\n2020年3月18号" preferredStyle:UIAlertControllerStyleAlert];
//
//                    UIAlertAction *unlock = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        [self showInsideMessage];
//                    }];
//                    [alertVC addAction:unlock];
//                    [self presentViewController:alertVC animated:YES completion:nil];
//                }else{
                    [self showInsideMessage];
//                }
//            }
//        }
//    }];
    //弹窗
    [self showHomePopView];
}

- (void)showInsideMessage{
    NSDictionary *params = @{
        @"flag":@"0",
        @"pageSize":@"1",
    };
    
    [IVNetwork requestPostWithUrl:BTTUnreadInsideMessage paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSArray *msgList = [[NSArray alloc]initWithArray:result.body[@"data"]];
            if (msgList.count>0) {
                NSDictionary *json = msgList.firstObject;
                NSString *content = json[@"content"];
                NSString *msgId = json[@"id"];
                BTTConsetiveWinsPopView *alertView = [BTTConsetiveWinsPopView viewFromXib];
                [alertView setContentMessage:content];
                
                BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:alertView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
                
                popView.isClickBGDismiss = YES;
                [popView pop];
                alertView.tapActivity = ^{
                    [self batchNewsWithId:msgId];
                    [popView dismiss];
                    
                };
                alertView.tapConfirm = ^{
                    [self batchNewsWithId:msgId];
                    [popView dismiss];
                };
            }else{
                NSLog(@"没有展示消息");
            }
        }
        
    }];
}

- (void)batchNewsWithId:(NSString *)msgId{
    NSArray *ids = [[NSArray alloc]initWithObjects:msgId, nil];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"ids"] = ids;
    
    [IVNetwork requestPostWithUrl:BTTReadInsideMessage paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",response);
        
    }];
}

#pragma mark - 紅包
- (void)requestRedbag{
    [IVNetwork requestPostWithUrl:DSBHasBouns paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
            IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]){
            NSString *flag = [NSString stringWithFormat:@"%@",result.body];
            if ([flag isEqualToString:@"58"]) {
                [self showDSBRedBagWithFlag:@"58"];
            }else if ([flag isEqualToString:@"108"]){
                [self showDSBRedBagWithFlag:@"108"];
            }
        }
    }];
    
}

- (void)showDSBRedBagWithFlag:(NSString *)flag{
    DSBRedBagPopView *alertView = [DSBRedBagPopView viewFromXib];
    if ([flag isEqualToString:@"108"]) {
        [alertView setContentMessage:@"dsb_content_108"];
    }else{
        [alertView setContentMessage:@"content_58"];
    }
    
    
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:alertView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
    
    popView.isClickBGDismiss = YES;
    [popView pop];
    alertView.tapActivity = ^{
        [popView dismiss];
        
    };
    alertView.tapConfirm = ^{
        [self drawBonus];
        [popView dismiss];
    };
}

- (void)drawBonus{
    if ([IVNetwork savedUserInfo]) {
            [IVNetwork requestPostWithUrl:DSBDrawBouns paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
                IVJResponseObject *result = response;
                if ([result.head.errCode isEqualToString:@"0000"]) {
                    [MBProgressHUD showSuccess:@"领取成功" toView:nil];
                    
                }else{
                    [MBProgressHUD showError:@"领取失败,请稍后重试" toView:nil];
                }
            }];
        }
}

#pragma mark - collectionView
- (void)setupCollectionView {
    [super setupCollectionView];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.collectionView.frame = CGRectMake(0, BTTNavHeightLogin, SCREEN_WIDTH, SCREEN_HEIGHT - BTTNavHeightLogin);
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageADCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageADCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageBannerCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageBannerCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageNoticeCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageNoticeCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTRealPersonGameCell" bundle:nil] forCellWithReuseIdentifier:@"BTTRealPersonGameCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTElectronicGamesCell" bundle:nil] forCellWithReuseIdentifier:@"BTTElectronicGamesCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTOtherGameCell" bundle:nil] forCellWithReuseIdentifier:@"BTTOtherGameCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHotPromotionsCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHotPromotionsCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageAppsCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageAppsCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageActivitiesCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageActivitiesCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageSeparateCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageSeparateCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageFooterCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageFooterCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageGamesCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageGamesCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageDiscountHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageDiscountHeaderCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageAmountsCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageAmountsCell"];
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
            BTTRealPersonGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTRealPersonGameCell" forIndexPath:indexPath];
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                strongSelf.idDisable = true;
                [strongSelf forwardToGameViewWithTag:button.tag];
            };
            return cell;
        } else if (indexPath.row == 4) {
            BTTElectronicGamesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTElectronicGamesCell" forIndexPath:indexPath];
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                strongSelf.idDisable = true;
                [strongSelf forwardToGameViewWithTag:button.tag];
            };
            return cell;

        } else if (indexPath.row == 5) {
            BTTOtherGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTOtherGameCell" forIndexPath:indexPath];
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                strongSelf.idDisable = true;
                [strongSelf forwardToGameViewWithTag:button.tag];
            };
            return cell;
        } else if (indexPath.row == 7) {
            BTTHotPromotionsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHotPromotionsCell" forIndexPath:indexPath];
            cell.promotions = self.promotions;
            weakSelf(weakSelf);
            cell.clickEventBlock = ^(id  _Nonnull value) {
                strongSelf(strongSelf);
                BTTPromotionProcessModel *model = value;
                BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
                vc.title = model.name;
                vc.webConfigModel.url = [model.href stringByReplacingOccurrencesOfString:@" " withString:@""];
                vc.webConfigModel.newView = YES;
                [strongSelf.navigationController pushViewController:vc animated:YES];
            };
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate jumpToTabIndex:BTTPromo];
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
        } else if (indexPath.row == 11) {
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
//        else if (indexPath.row == 13) {
//            BTTHomePageAmountsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageAmountsCell" forIndexPath:indexPath];
//            cell.amounts = self.amounts;
//            return cell;
//        }
        else {
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
            BTTRealPersonGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTRealPersonGameCell" forIndexPath:indexPath];
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                strongSelf.idDisable = true;
                [strongSelf forwardToGameViewWithTag:button.tag];
            };
            return cell;
        } else if (indexPath.row == 3) {
            BTTElectronicGamesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTElectronicGamesCell" forIndexPath:indexPath];
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                strongSelf.idDisable = true;
                [strongSelf forwardToGameViewWithTag:button.tag];
            };
            return cell;
            
        } else if (indexPath.row == 4) {
            BTTOtherGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTOtherGameCell" forIndexPath:indexPath];
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                strongSelf.idDisable = true;
                [strongSelf forwardToGameViewWithTag:button.tag];
            };
            return cell;
        } else if (indexPath.row == 6) {
            BTTHotPromotionsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHotPromotionsCell" forIndexPath:indexPath];
            weakSelf(weakSelf);
            cell.promotions = self.promotions;
            cell.clickEventBlock = ^(id  _Nonnull value) {
                strongSelf(strongSelf);
                BTTPromotionProcessModel *model = value;
                BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
                vc.webConfigModel.url = [model.href stringByReplacingOccurrencesOfString:@" " withString:@""];
                vc.webConfigModel.newView = YES;
                vc.title = model.name;
                [strongSelf.navigationController pushViewController:vc animated:YES];
            };
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate jumpToTabIndex:BTTPromo];
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
//        else if (indexPath.row == 12) {
//            BTTHomePageAmountsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageAmountsCell" forIndexPath:indexPath];
//            cell.amounts = self.amounts;
//            return cell;
//        }
        else {
            BTTHomePageFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageFooterCell" forIndexPath:indexPath];
            cell.model = self.posters.count > 1 ? self.posters[1] : nil;
            return cell;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    BTTPromotionProcessModel * model = nil;
    if (self.adCellShow) {
        if (indexPath.row == 0) {
            model = self.posters.count ? self.posters[0] : nil;
            if (!model || !model.link.length) {
                return;
            }
            BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
            vc.webConfigModel.url = [model.link stringByReplacingOccurrencesOfString:@" " withString:@""];
            vc.webConfigModel.newView = YES;
            vc.webConfigModel.theme = @"outside";
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


#pragma mark - Calculation cell height
- (void)setupElements {
    NSInteger total = 0;
//    if (self.posters.count) {
//        self.adCellShow = YES;
//    } else {
        self.adCellShow = NO;//AV女優活動拿掉
//    }
    if (self.adCellShow) {
        total = 14;
    } else {
        total = 13;
    }
    NSMutableArray *elementsHight = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        if (self.adCellShow) {
            if (i == 0 || i == 2) {
                //AD Notice
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 45)]];
            } else if (i == 1) {
                //Banner
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, BTTBnnnerDefaultHeight * (SCREEN_WIDTH / BTTBannerDefaultWidth))]];
            } else if (i == 3) {
                //RealPerson
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, ((SCREEN_WIDTH - 30) / 2 - 5) / 168.0 * 133 + 60)]];
            } else if (i == 4) {
                //Electronic
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH - 40) / 335.0 * 144 + 60)]];
            } else if (i == 5) {
                //Other
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH - 40) / 335.0 * 227 + 72.5)]];
            } else if (i == 7) {
                //Promotion
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 140)]];
            } else if (i == 9) {
                //Download App
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 180)]];
            } else if (i == 11) {
                //Customer Activity
//                if (self.Activities.count) {
//                    BTTActivityModel *model = self.Activities[self.nextGroup];
//                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, model.cellHeight)]];
//                } else {
//                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 388)]];
//                }
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 0)]];
            } else if (i == 6 || i == 8 || i == 10 || i == 12) {
                //Space
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 15)]];
            }
//            else if (i == 13) {
//                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 300)]];
//            }
            else {
                //Footer Logo
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
//                if (self.Activities.count) {
//                    BTTActivityModel *model = self.Activities[self.nextGroup];
//                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, model.cellHeight)]];
//                } else {
//                    [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 388)]];
//                }
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 0)]];
            } else if (i == 5 || i == 7 || i == 9 || i == 11) {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 15)]];
            }
//            else if (i == 12) {
//                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 300)]];
//            }
            else {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 60)]];
            }
        }
    }
    self.elementsHight = [elementsHight mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)choseGameLineWithTag:(NSInteger)tag {
    if (![IVNetwork savedUserInfo]) {
        [self gotoGameWithTag:tag currency:@"CNY"];
        return;
    }
    if (![[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT" ]) {
        [self checkMultiBetInfo:tag currency:[IVNetwork savedUserInfo].uiMode isShowPop:false];
        return;
    }
    NSString * currencyStr = [IVNetwork savedUserInfo].uiMode.length != 0 ? [IVNetwork savedUserInfo].uiMode:@"CNY";
    NSDictionary *params = @{@"currency": [IVNetwork savedUserInfo] ? currencyStr:@"CNY"};
    NSString *jsonKey = @"";
    switch (tag) {
        case 1000:
            jsonKey = BTTAGQJKEY;
            break;
        case 1001:
            jsonKey = BTTAGGJKEY;
            break;
        case 1003:
            jsonKey = BTTAGGJKEY;
            break;
        case 1006:
            jsonKey = BTTSABAKEY;
            break;
        case 1007:
            jsonKey = BTTYSBKEY;
            break;
        case 1010:
            jsonKey = BTTASKEY;
            break;
        case 1011:
            jsonKey = BTTAGLotteryKEY;
            break;
        default:
            break;
    }
    [self showLoading];
    [IVNetwork requestPostWithUrl:QUERYGames paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        NSArray *lineArray = result.body[jsonKey];
        if (lineArray != nil && lineArray.count >= 2) {
            self.userCurrencysArr = [[NSMutableArray alloc] initWithArray:[NSArray bg_arrayWithName:BTTGameCurrencysWithName]];
            NSString * gameCurrency = @"";
            if (self.userCurrencysArr.count != 0) {
                for (BTTUserGameCurrencyModel * model in self.userCurrencysArr) {
                    if ([jsonKey isEqualToString:model.gameKey]) {
                        gameCurrency = model.currency;
                        break;
                    }
                }
            }
            
            if (gameCurrency.length != 0) {
                [self checkMultiBetInfo:tag currency:gameCurrency isShowPop:false];
            } else {
                [self checkMultiBetInfo:tag currency:@"" isShowPop:true];
            }
        } else {
            if (nil == lineArray) {
                [self checkMultiBetInfo:tag currency:@"CNY" isShowPop:false];
            } else {
                NSDictionary *json = lineArray[0];
                NSString *currency = json[@"platformCurrency"];
                [self checkMultiBetInfo:tag currency:currency isShowPop:false];
            }
        }
    }];
}

-(void)saveCurrencysArrToBGFMDB:(NSString *)currency userCurrencysArr:(NSMutableArray *)userCurrencysArr {
    NSMutableArray * saveArr = [[NSMutableArray alloc] init];
    if (userCurrencysArr.count != 0) {
        for (NSString * str in BTTGameKeysArr) {
            for (BTTUserGameCurrencyModel * model in userCurrencysArr) {
                if ([str isEqualToString:model.gameKey]) {
                    if (model.currency.length == 0) {
                        model.currency = currency;
                    }
                    [saveArr addObject:model];
                    break;
                } else {
                    NSInteger index = [userCurrencysArr indexOfObject:model];
                    if (index == userCurrencysArr.count - 1) {
                        index = [BTTGameKeysArr indexOfObject:str];
                        BTTUserGameCurrencyModel * model = [[BTTUserGameCurrencyModel alloc] init];
                        model.title = BTTGameTitlesArr[index];
                        model.gameKey = str;
                        model.currency = currency;
                        [saveArr addObject:model];
                    }
                }
            }
        }
    } else {
        NSArray *titles = BTTGameTitlesArr;
        NSArray *gameKeys = BTTGameKeysArr;
        for (NSString *gameKey in gameKeys) {
            NSInteger index = [gameKeys indexOfObject:gameKey];
            BTTUserGameCurrencyModel *model = [[BTTUserGameCurrencyModel alloc] init];
            model.title = titles[index];
            model.gameKey = gameKey;
            model.currency = currency;
            [saveArr addObject:model];
        }
    }
    [NSArray bg_clearArrayWithName:BTTGameCurrencysWithName];
    [saveArr bg_saveArrayWithName:BTTGameCurrencysWithName];
}

-(void)checkMultiBetInfo:(NSInteger)tag currency:(NSString *)currency isShowPop:(BOOL)isShowPop {
    [IVNetwork requestPostWithUrl:BTTMultiBetInfo paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSString * gameCode = @"";
            NSString * gameName = @"";
            NSString * rate = @"";
            if (tag==1000) {
                gameCode = BTTAGQJKEY;
            }else if (tag==1001) {
                gameCode = BTTAGGJKEY;
            } else {
                if (tag==1006){
                    gameCode = BTTSABAKEY;
                }else if (tag==1007){
                    gameCode = BTTYSBKEY;
                }else if (tag==1010){
                    gameCode = BTTASKEY;
                } else if (tag==1003) {
                    gameCode = BTTAGGJKEY;
                } else if (tag==1011) {
                    gameCode = BTTAGLotteryKEY;
                }
            }
            
            NSMutableArray * arr = result.body[@"multiBetInfo"];
            for (NSDictionary * dict in arr) {
                rate = dict[@"multiBetRate"];
                if ([dict[@"multiBetGameCode"] isEqualToString:gameCode]) {
                    if ([gameCode isEqualToString:BTTAGQJKEY]) {
                        gameName = @"AG旗舰";
                        break;
                    } else if ([gameCode isEqualToString:BTTAGGJKEY]) {
                        if (tag == 1001) {
                            gameName = @"AG国际";
                        } else {
                            gameName = @"捕鱼王";
                        }
                        break;
                    } else if ([gameCode isEqualToString:BTTSABAKEY]) {
                        gameName = @"沙巴体育";
                        break;
                    } else if ([gameCode isEqualToString:BTTYSBKEY]) {
                        gameName = @"YSB体育";
                        break;
                    } else if ([gameCode isEqualToString:BTTASKEY]) {
                        gameName = @"AS真人棋牌";
                        break;
                    } else if ([gameCode isEqualToString:BTTAGLotteryKEY]) {
                        gameName = @"AG彩票";
                        break;
                    }
                }
            }
            NSString * message = [NSString stringWithFormat:@"您在%@的单笔投注倍数为%@倍", gameName, rate];
            
            if ([[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"]) {
                if (isShowPop) {
                    BTTChooseCurrencyPopView *customView = [BTTChooseCurrencyPopView viewFromXib];
                    customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                    if ([rate integerValue] > 1 && gameName.length > 0) {
                        NSString * rateStr = [NSString stringWithFormat:@"(%@倍投注)", rate];
                        NSString * aStr = [NSString stringWithFormat:@"人民币 CNY 1:7  %@",rateStr];
                        NSRange range = [aStr rangeOfString:rateStr];
                        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:aStr];
                        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
                        [customView.cnyBtn setAttributedTitle:str forState:UIControlStateNormal];
                        
                        aStr = [NSString stringWithFormat:@"数字币 USDT 1:1  %@",rateStr];
                        range = [aStr rangeOfString:rateStr];
                        str = [[NSMutableAttributedString alloc] initWithString:aStr];
                        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
                        [customView.usdtBtn setAttributedTitle:str forState:UIControlStateNormal];
                    }
                    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleScale dismissStyle:BTTAnimationDismissStyleNO];
                    [popView pop];
                    weakSelf(weakSelf);
                    customView.dismissBlock = ^{
                        strongSelf(strongSelf);
                        [popView dismiss];
                        if ([rate integerValue] > 1 && gameName.length > 0) {
                            [MBProgressHUD showSuccessWithTime:message toView:nil duration:3];
                        }
                        [strongSelf gotoGameWithTag:tag currency:@"USDT"];
                    };

                    customView.btnBlock = ^(UIButton *btn) {
                        strongSelf(strongSelf);
                        [popView dismiss];
                        if (btn.tag == 1000) {
                            //cny
                            [strongSelf saveCurrencysArrToBGFMDB:@"CNY" userCurrencysArr:self.userCurrencysArr];
                            [strongSelf gotoGameWithTag:tag currency:@"CNY"];
                        } else {
                            //usdt
                            [strongSelf saveCurrencysArrToBGFMDB:@"USDT" userCurrencysArr:self.userCurrencysArr];
                            [strongSelf gotoGameWithTag:tag currency:@"USDT"];
                        }
                    };
                } else {
                    if ([rate integerValue] > 1 && gameName.length > 0) {
                        [MBProgressHUD showSuccessWithTime:message toView:nil duration:3];
                    }
                    [self gotoGameWithTag:tag currency:currency];
                }
            } else {
                if ([rate integerValue] > 1 && gameName.length > 0) {
                    [MBProgressHUD showSuccessWithTime:message toView:nil duration:3];
                }
                [self gotoGameWithTag:tag currency:@"CNY"];
            }
        } else {
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

- (void)gotoGameWithTag:(NSInteger)tag currency:(NSString *)currency {
    if (tag==1000) {
        BTTAGQJViewController *vc = [BTTAGQJViewController new];
        [CNTimeLog startRecordTime:CNEventAGQJLaunch];
        vc.platformLine = currency;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (tag==1001) {
        BTTAGGJViewController *vc = [BTTAGGJViewController new];
        vc.platformLine = currency;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        IVGameModel *model = [[IVGameModel alloc] init];
        if (tag==1006){
            model.cnName = @"沙巴体育";
            model.enName =  kASBEnName;
            model.gameCode = BTTSABAKEY;
            model.provider =  kShaBaProvider;
            model.platformCurrency = currency;
        }else if (tag==1007){
            model.cnName = @"YSB体育";
            model.enName =  @"YSB";
            model.gameCode = BTTYSBKEY;
            model.provider =  kYSBProvider;
            model.platformCurrency = currency;
        }else if (tag==1010){
            model = [[IVGameModel alloc] init];
            model.cnName = @"AS真人棋牌";
            model.gameCode = BTTASKEY;
            model.enName =  kASSlotEnName;
            model.provider = kASSlotProvider;
            model.platformCurrency = currency;
        } else if (tag==1003) {
            model = [[IVGameModel alloc] init];
            model.cnName =  kFishCnName;
            model.enName =  kFishEnName;
            model.provider = kAGINProvider;
            model.gameCode = BTTAGGJKEY;
            model.gameType = kFishType;
            model.platformCurrency = currency;
        } else if (tag==1011) {
            model = [[IVGameModel alloc] init];
            model.cnName = @"AG彩票";
            model.gameCode = BTTAGLotteryKEY;
            model.enName = @"K8";
            model.provider = @"K8";
            model.platformCurrency = currency;
        }
        [[IVGameManager sharedManager].lastGameVC reloadGame];
        [[IVGameManager sharedManager] forwardToGameWithModel:model controller:self];
    }
}

- (void)forwardToGameViewWithTag:(NSInteger)tag
{
    UIViewController *vc = nil;
    IVGameModel *model = nil;
    BTTVideoGamesListController *videoGamesVC = nil;
    switch (tag) {
        case 1000://AG旗舰
            vc = [BTTAGQJViewController new];
            break;
        case 1001://AG国际
            vc = [BTTAGGJViewController new];
            break;
        case 1002://TTG

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
            model.gameCode = BTTAGGJKEY;
            model.gameType = kFishType;
            break;
            
            case 1004:
        {
            BTTPosterModel * model = self.posters.count ? self.posters[1] : nil;
            videoGamesVC = [BTTVideoGamesListController new];
            videoGamesVC.banners = self.banners;
            videoGamesVC.imageUrls = self.imageUrls;
            videoGamesVC.poster = model;
            videoGamesVC.provider = @"PP";
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
            model.gameCode = BTTSABAKEY;
            model.provider =  kShaBaProvider;
        }
            break;
        case 1007://更改為 YSB体育, 注銷 BTI体育
            model = [[IVGameModel alloc] init];
            model.cnName = @"YSB体育";//@"BTI体育";
            model.enName =  @"YSB";//@"SBT_BTI";
            model.gameCode = BTTYSBKEY;//BTTBTIKEY;
            model.provider = kYSBProvider;//@"SBT";
            break;
        case 1008:{
            model = [[IVGameModel alloc] init];
            model.cnName = @"竞彩";
            model.gameCode = BTTNBKEY;
            model.enName = @"NB";
            model.provider = @"NB";
            model.isSports = YES;
        }
            break;
            
        case 1009: {
            model = [[IVGameModel alloc] init];
            model.cnName = @"体育VIP厅";
            model.enName =  @"CS";
            model.gameCode = BTTCSKEY;
            model.provider =  @"CS";
            model.language = @"zh";
        }
            break;
        case 1010://AS电游
            model = [[IVGameModel alloc] init];
            model.cnName = @"AS真人棋牌";
            model.gameCode = BTTASKEY;
            model.enName =  kASSlotEnName;
            model.provider = kASSlotProvider;
            break;
        case 1011://AG彩票
            model = [[IVGameModel alloc] init];
            model.cnName = @"AG彩票";
            model.gameCode = BTTAGLotteryKEY;
            model.enName = @"K8";
            model.provider = @"K8";
            break;
        default:
            break;
    }
    if ([IVNetwork savedUserInfo]) {
        if (vc || videoGamesVC) {
            if (vc) {
                if (tag==1000||tag==1001) {
                    [self choseGameLineWithTag:tag];
                }else{
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            } else if (videoGamesVC) {
                [self.navigationController pushViewController:videoGamesVC animated:YES];
            }
        }
        if (model) {
            if (tag==1006||tag==1007||tag==1010||tag==1003||tag==1011) {//原先1007 BTI 可試玩,改YSB 不可試玩
                [self choseGameLineWithTag:tag];
            }else{
                [[IVGameManager sharedManager] forwardToGameWithModel:model controller:self];
            }
            
        }
    } else {
        if (tag == 1006 || tag== 1007 || tag == 1011 || tag == 1008) {//原先1007 BTI 可試玩,改YSB 不可試玩
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
                            if (tag==1000||tag==1001) {
                                [self choseGameLineWithTag:tag];
                            }else{
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                        } else if (videoGamesVC) {
                            [self.navigationController pushViewController:videoGamesVC animated:YES];
                        }
                    }
                    if (model) {
                        if (tag==1006||tag==1007||tag==1010||tag==1003) {
                            [self choseGameLineWithTag:tag];
                        }else{
                            [[IVGameManager sharedManager] forwardToGameWithModel:model controller:self];
                        }
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
