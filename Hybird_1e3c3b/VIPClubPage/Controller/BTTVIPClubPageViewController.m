//
//  BTTVIPClubPageViewController.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/4/16.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTVIPClubPageViewController.h"
#import "BTTVIPClubPageViewController+Nav.h"
#import "BTTVIPClubPageViewController+LoadData.h"
#import "BTTActivityModel.h"

#import "BTTVIPChangeBtnsCell.h"
#import "BTTVIPClubPageActivitiesCell.h"
#import "BTTVIPClubHistoryCell.h"
#import "BTTVIPClubWebViewController.h"
#import "BTTVIPClubUserRightCell.h"
#import "BTTVIPChangeBtnsView.h"
#import "BTTLoginOrRegisterViewController.h"
#import "BTTVIPDiscriptionPopView.h"
#import "BTTVIPActivitiesPopView.h"
#import "VIPHistoryModel.h"

@interface BTTVIPClubPageViewController ()<  UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *sheetDatas;
@property (nonatomic,copy)BTTVIPChangeBtnsCell *buttonCell;
@property (nonatomic,copy)BTTVIPClubWebViewController *vipWebViewController;
@property (nonatomic, strong) UICollectionView *vipClubCollectionView;
@property (nonatomic, strong) NSMutableArray<NSValue *> *elementsHight;
@property (nonatomic, strong) BTTVIPChangeBtnsView *buttonsView;
@property (nonatomic, assign) BOOL directToHistoryWebview;
@property (nonatomic, strong) VIPHistoryModel *tempModel;

@end
@implementation BTTVIPClubPageViewController
@synthesize buttonCell ,vipWebViewController;
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNav];
    [self changeSheetDatas:self.selectedType];
    [self.vipClubCollectionView reloadData];
    self.directToHistoryWebview = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"VIPClub";
    _tempModel = [self createVIPHistoryData];
    if ([IVNetwork savedUserInfo]) {
        self.isLogin = YES;
    } else {
        self.isLogin = NO;
    }
    [self setupCollectionView];
    [self setButtonsView];
//    [self setupLoginAndRegisterBtnsView];
    [self setupElements];
    [self loadDataOfVIPClubPage];
//    [self registerNotification];
//    [IVNetwork registException];
//    weakSelf(weakSelf);
//    [self pulldownRefreshWithRefreshBlock:^{
//        strongSelf(strongSelf);
//        NSLog(@"下拉刷新");
//        [strongSelf refreshDatasOfHomePage];
//    }];
    
    //jay AD
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//        NSTimeInterval interval = [[userDefault objectForKey:@"jayTimeStamp"] doubleValue] / 1000.0;
//        NSInteger today = [PublicMethod timeIntervalSince1970].integerValue;
//        NSInteger endTime = [PublicMethod timeSwitchTimestamp:@"2019-11-17 23:59:59" andFormatter:@"yyyy-MM-dd HH:mm:ss"];
//        if (today <= endTime) {
//            if (![PublicMethod isDateToday:[NSDate dateWithTimeIntervalSince1970:interval]]) {
//                [userDefault setObject:[PublicMethod timeIntervalSince1970] forKey:@"jayTimeStamp"];
//                [self showJay];
//            }
//        }
//    });
//    [self setUpAssistiveButton];
//    if (self.assistiveButton != nil) {
//        [self.view addSubview:self.assistiveButton];
//    }
    [self checkLoginVersion];
//    [self setupFloatWindow];

}
- (void)refreshDatasOfHomePage
{
    NSLog(@"下拉刷新 拉了");
//    [self endRefreshing];
    [self setupElements];
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
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:BTTShowYuFenHong];
            [[NSNotificationCenter defaultCenter] postNotificationName:LogoutSuccessNotification object:nil];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (CGSize)waterflowLayout:(nonnull BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(nonnull UICollectionView *)collectionView sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    return  (self.elementsHight.count && indexPath.row <= self.elementsHight.count - 1) ? self.elementsHight[indexPath.item].CGSizeValue : CGSizeZero;
//}

-(void)changeSheetDatas:(NSInteger)tag {
//    if ([[self getNewPwdCell] isKindOfClass:[BTTPasswordCell class]] && [[self getLoginPwdCell] isKindOfClass:[BTTPasswordCell class]]) {
//        [self getLoginPwdCell].textField.text = @"";
//        [self getNewPwdCell].textField.text = @"";
//    }
    self.sheetDatas = [[NSMutableArray alloc] init];
//    NSArray *titles = @[];
//    NSArray *placeholders = @[];
    switch (self.selectedType) {
        case BTTVIPRight:
        {
            
        }
            break;
        case BTTVIPHistory:
        {

            
        }
            break;
        case BTTVIPActivity:
        {
            
        }
            break;
    }
    
    [self setupElements];
}
-(void)setupElements {
    NSMutableArray *elementsHight = [NSMutableArray array];
//    NSInteger count = 1;

//    for (int i = 0; i < count; i++) {
//        if (i == 0) {
//            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 48)]];
//        } else if (i == 1) {
//        }
//    }
    switch (self.selectedType) {
        case BTTVIPRight:
        {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - BTTNavHeightLogin - kTabbarHeight)]];
        }
            break;
        case BTTVIPHistory:
        {
//            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 150 + 48)]];
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - BTTNavHeightLogin - kTabbarHeight)]];
        }
            break;
        case BTTVIPActivity:
        {
            if (self.activities.count) {
                for (int i = 0; i<self.activities.count; i++) {
                    BTTActivityModel *model = self.activities[i];
                    if (i == 0)
                    {
                        [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, model.cellHeight + 48)]];
                    }else
                    {
                        [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, model.cellHeight )]];
                    }
                }
//                BTTActivityModel *model = self.activities[self.nextGroup];
//                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, model.cellHeight * self.activities.count + 48)]];
            } else {
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 388)]];
            }
        }
            break;
            
        default:
            break;
    }
    
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.vipClubCollectionView reloadData];
    });
}
- (BTTVIPClubWebViewController *)vipWebViewController
{
    if (!vipWebViewController)
    {
        vipWebViewController = [[BTTVIPClubWebViewController alloc] init];
        vipWebViewController.webConfigModel.newView = YES;
        vipWebViewController.webConfigModel.url = @"history";
        vipWebViewController.webConfigModel.theme = @"inside";
    }
    return vipWebViewController;
}
- (void)setVipWebViewController:(BTTVIPClubWebViewController *)vipWebViewController
{
    self.vipWebViewController = vipWebViewController;
}

#pragma mark - collectionView
- (UICollectionView *)vipClubCollectionView
{
    if (!_vipClubCollectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];

        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - BTTNavHeightLogin - kTabbarHeight); //固定的itemsize
//        flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 43);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //初始化 UICollectionView
        _vipClubCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _vipClubCollectionView.delegate = self; //设置代理
        _vipClubCollectionView.dataSource = self;   //设置数据来源
        
        _vipClubCollectionView.bounces = NO;   //设置弹跳
        
        self.vipClubCollectionView.backgroundColor = [UIColor colorWithHexString:@"212229"];
        [self.vipClubCollectionView registerNib:[UINib nibWithNibName:@"BTTVIPChangeBtnsCell" bundle:nil] forCellWithReuseIdentifier:@"BTTVIPChangeBtnsCell"];
        [self.vipClubCollectionView registerNib:[UINib nibWithNibName:@"BTTVIPClubPageActivitiesCell" bundle:nil] forCellWithReuseIdentifier:@"BTTVIPClubPageActivitiesCell"];
        [self.vipClubCollectionView registerNib:[UINib nibWithNibName:@"BTTVIPClubHistoryCell" bundle:nil] forCellWithReuseIdentifier:@"BTTVIPClubHistoryCell"];
        [self.vipClubCollectionView registerNib:[UINib nibWithNibName:@"BTTVIPClubUserRightCell" bundle:nil] forCellWithReuseIdentifier:@"BTTVIPClubUserRightCell"];
    }
    return _vipClubCollectionView;
}
- (void)setupCollectionView {
//    [super setupCollectionView];
    self.vipClubCollectionView.frame = CGRectMake(0, BTTNavHeightLogin, SCREEN_WIDTH, SCREEN_HEIGHT - BTTNavHeightLogin - kTabbarHeight);
    [self.view addSubview:self.vipClubCollectionView];
}
- (void)setButtonsView
{
    if (!_buttonsView)
    {
        weakSelf(weakSelf);
        BTTVIPChangeBtnsView *btnsView = [[[NSBundle mainBundle]loadNibNamed:@"BTTVIPChangeBtnsView" owner:self options:nil]lastObject];
        [btnsView setFrame:CGRectMake(0, BTTNavHeightLogin, SCREEN_WIDTH, 48)];
        btnsView.buttonClickBlock = ^(UIButton * _Nonnull button) {
            weakSelf.selectedType = button.tag;
            [weakSelf changeSheetDatas:button.tag];
        };
        btnsView.vipRightBtn.selected = true;
        [btnsView setupArrow];
        _buttonsView = btnsView;
        [self.view addSubview:_buttonsView];
    }
}
- (void)showVIPDiscription:(BTTVIPDiscriptionViewType) type
{
    BTTVIPDiscriptionPopView * customView = [BTTVIPDiscriptionPopView viewFromXib];
    customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    customView.model = model;
    customView.discriptionViewType = type;
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    customView.dismissBlock = ^{
        [popView dismiss];
    };
    
    customView.btnBlock = ^(UIButton * _Nullable btn) {
        [popView dismiss];
//        BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
//        vc.title = @"博天堂股东 分红月月领～第二季";
//        vc.webConfigModel.url = @"/activity_pages/withdraw_gift";
//        vc.webConfigModel.newView = YES;
//        [self.navigationController pushViewController:vc animated:YES];
    };
}
- (void)showVIPActivitiesImagesViewWithCorrentModel:(BTTActivityModel*)model WithCurrentIndex:(NSInteger) currentIndex
{
    BTTVIPActivitiesPopView * customView = [BTTVIPActivitiesPopView viewFromXib];
    customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    customView.model = model;
//    customView.discriptionViewType = type;
    [customView configWithImageUrls:[model.imageUrls copy] currentImageIndex:currentIndex];
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    customView.dismissBlock = ^{
        [popView dismiss];
    };
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.elementsHight[indexPath.item].CGSizeValue;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.selectedType) {
        case BTTVIPRight:
        {
            BTTVIPClubUserRightCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVIPClubUserRightCell" forIndexPath:indexPath];
            weakSelf(weakSelf);
            cell.buttonClickBlock = ^(UIButton * _Nonnull button) {
                strongSelf(strongSelf);
                if (button.tag == 1000) {
                    BTTLoginOrRegisterViewController *loginAndRegister = [[BTTLoginOrRegisterViewController alloc] init];
                    loginAndRegister.registerOrLoginType = BTTRegisterOrLoginTypeLogin;
                    [strongSelf.navigationController pushViewController:loginAndRegister animated:YES];
                }
                else if (button.tag == 1001){
                    BTTLoginOrRegisterViewController *loginAndRegister = [[BTTLoginOrRegisterViewController alloc] init];
                    loginAndRegister.registerOrLoginType = BTTRegisterOrLoginTypeRegisterNormal;
                    [strongSelf.navigationController pushViewController:loginAndRegister animated:YES];
                }
                else if (button.tag == 2000){
                    [strongSelf showVIPDiscription:VIPSmall];
                }
                else if (button.tag == 2001){
                    [strongSelf showVIPDiscription:VIPMiddle];
                }
                else if (button.tag == 2002){
                    [strongSelf showVIPDiscription:VIPLarge];
                }
                else if (button.tag == 3000){
//                    strongSelf.directToHistoryWebview = YES;
                    [strongSelf.buttonsView.vipHistoryBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    strongSelf.selectedType = BTTVIPHistory;
                    [strongSelf changeSheetDatas:BTTVIPHistory];
                    
//                    [strongSelf showVIPDiscription:VIPLarge];
                }
            };
            return cell;
        }
            break;
        case BTTVIPHistory:
        {
            BTTVIPClubHistoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVIPClubHistoryCell" forIndexPath:indexPath];
            [cell configForCellWithhHistoryDatas:self.tempModel];
            
            weakSelf(weakSelf);
            cell.moreBlock = ^{ //打開Webview
                weakSelf.vipWebViewController.clickEventBlock = ^(id  _Nonnull value){ // 接收gotoBack事件
                    //                        strongSelf(strongSelf)
                    //                        [weakSelf.buttonCell vipRightBtnClick:weakSelf.buttonCell.vipRightBtn]; // 返回之後去選擇左邊第一個頁籤
                };
                if ([weakSelf.vipWebViewController isMovingFromParentViewController] == NO)
                {
                    [weakSelf.navigationController pushViewController:weakSelf.vipWebViewController animated:YES];
                }
            };
            //                [cell moreBtnClick]; //  直接進入更多的Webview
            if (self.directToHistoryWebview == YES)
            {
                self.directToHistoryWebview = NO;
                [cell moreBtnClick];
            }
            return cell;
            
        }
            break;
        case BTTVIPActivity:
        {
            BTTVIPClubPageActivitiesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTVIPClubPageActivitiesCell" forIndexPath:indexPath];
//            BTTActivityModel *model = self.activities.count ? self.activities[self.nextGroup] : nil;
            __block BTTActivityModel *model = self.activities.count ? self.activities[indexPath.item] : nil;
            cell.activityModel = model;
            if (indexPath.item == 0)
            {
                [cell setConfigForFirstCell:YES];
            }else
            {
                [cell setConfigForFirstCell:NO];
            }
            
            weakSelf(weakSelf);
//            cell.reloadBlock = ^{
//                strongSelf(strongSelf);
//                strongSelf.nextGroup += 1;
//                if (strongSelf.nextGroup == self.activities.count) {
//                    self.nextGroup = 0;
//                }
//                [strongSelf setupElements];
//            };
            cell.selectBlock = ^(NSInteger index) {

                [weakSelf showVIPActivitiesImagesViewWithCorrentModel:model WithCurrentIndex:index];
            };
            return cell;
        }
            break;
    }
}
- (VIPHistoryModel *)createVIPHistoryData
{
    VIPHistorySideBarModel *sData1 = [[VIPHistorySideBarModel alloc] initWithYearString:@"2019" withImageName:@"logo" withIsSelected:YES withIsFirstData:YES];
    VIPHistorySideBarModel *sData2 = [[VIPHistorySideBarModel alloc] initWithYearString:@"2018" withImageName:@"logo" withIsSelected:NO withIsFirstData:NO];
    VIPHistorySideBarModel *sData3 = [[VIPHistorySideBarModel alloc] initWithYearString:@"2017" withImageName:@"logo" withIsSelected:NO withIsFirstData:NO];
    VIPHistorySideBarModel *sData4 = [[VIPHistorySideBarModel alloc] initWithYearString:@"2016" withImageName:@"logo" withIsSelected:NO withIsFirstData:NO];
    VIPHistorySideBarModel *sData5 = [[VIPHistorySideBarModel alloc] initWithYearString:@"2015" withImageName:@"logo" withIsSelected:NO withIsFirstData:NO];
    VIPHistorySideBarModel *sData6 = [[VIPHistorySideBarModel alloc] initWithYearString:@"2014" withImageName:@"logo" withIsSelected:NO withIsFirstData:NO];
    VIPHistorySideBarModel *sData7 = [[VIPHistorySideBarModel alloc] initWithYearString:@"2013" withImageName:@"logo" withIsSelected:NO withIsFirstData:NO];


    VIPHistoryImageModel *iData1 = [[VIPHistoryImageModel alloc] initWithYearString:@"2019" WithMonthString:@"10" withImageName:@"cdn/1e3c3bFM/static/img/img44.258ddc53.jpg" withUrl:@"www/promo_av_201910" withTopTitleString:@"我和三上悠亚有个约会" withSubTitleString:@"与三上悠亚的浪漫邂逅圆满结束" withIsFirstData:YES withIsDetails:YES];
    VIPHistoryImageModel *iData11 = [[VIPHistoryImageModel alloc] initWithYearString:@"2019" WithMonthString:@"02" withImageName:@"cdn/1e3c3bFM/static/img/img43.e4a7c16a.jpg" withUrl:@"www/yacht_tour_201902" withTopTitleString:@"四天三夜浪漫游艇邂逅之旅" withSubTitleString:@"浪漫游艇邂逅之旅圆满结束" withIsFirstData:NO withIsDetails:YES];
    
    VIPHistoryImageModel *iData2 = [[VIPHistoryImageModel alloc] initWithYearString:@"2018" WithMonthString:@"10" withImageName:@"cdn/1e3c3bFM/static/img/img42.ea77e007.jpg" withUrl:@"www/f1_race_2018_3" withTopTitleString:@"五天四夜F1日本之旅" withSubTitleString:@"观战F1&日本关西韵味之旅活动圆满收官" withIsFirstData:YES withIsDetails:YES];
    VIPHistoryImageModel *iData21 = [[VIPHistoryImageModel alloc] initWithYearString:@"2018" WithMonthString:@"09" withImageName:@"cdn/1e3c3bFM/static/img/img41.205503c9.jpg" withUrl:@"www/yacht_bunny2" withTopTitleString:@"三天两夜兔女郎豪华游艇游" withSubTitleString:@"豪华游艇邂逅兔女郎主题旅游活动圆满结束" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData22 = [[VIPHistoryImageModel alloc] initWithYearString:@"2018" WithMonthString:@"06" withImageName:@"cdn/1e3c3bFM/static/img/img40.3f962838.png" withUrl:@"www/dream_island_trip2" withTopTitleString:@"“菲”去不可  科隆岛浪漫之旅" withSubTitleString:@"阳光、沙滩、海岛、比基尼美女，好玩到不想走！" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData23 = [[VIPHistoryImageModel alloc] initWithYearString:@"2018" WithMonthString:@"04" withImageName:@"cdn/1e3c3bFM/static/img/img39.de303dfc.jpg" withUrl:@"www/bayer_travel_4thquarter2" withTopTitleString:@"激情观战勒沃库森旅游" withSubTitleString:@"2018年4月勒沃库森旅游季，德法浪漫游再次让博天堂客户欢聚" withIsFirstData:NO withIsDetails:YES];
    
    VIPHistoryImageModel *iData3 = [[VIPHistoryImageModel alloc] initWithYearString:@"2017" WithMonthString:@"12" withImageName:@"cdn/1e3c3bFM/static/img/img_38.72c607b4.jpg" withUrl:@"www/ph_tour" withTopTitleString:@"“飞”律宾第四季" withSubTitleString:@"长滩岛遇见博天堂 完美收官" withIsFirstData:YES withIsDetails:YES];
    VIPHistoryImageModel *iData31 = [[VIPHistoryImageModel alloc] initWithYearString:@"2017" WithMonthString:@"8" withImageName:@"cdn/1e3c3bFM/static/img/img37.d8733923.jpg" withUrl:@"www/dream_island_trip" withTopTitleString:@"“飞”律宾第三季" withSubTitleString:@"梦幻海岛之旅" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData32 = [[VIPHistoryImageModel alloc] initWithYearString:@"2017" WithMonthString:@"06" withImageName:@"cdn/1e3c3bFM/static/img/img_as.0016dca6.jpg" withUrl:@"" withTopTitleString:@"新增AS电玩城" withSubTitleString:@"AS厅首创实时实体赌场数据开牌，社交化在线博彩。" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData33 = [[VIPHistoryImageModel alloc] initWithYearString:@"2017" WithMonthString:@"05" withImageName:@"cdn/1e3c3bFM/static/img/img38.5927338e.jpg" withUrl:@"www/yacht_tour2" withTopTitleString:@"“飞”律宾第二季" withSubTitleString:@"欢乐翱翔之旅" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData34 = [[VIPHistoryImageModel alloc] initWithYearString:@"2017" WithMonthString:@"02" withImageName:@"cdn/1e3c3bFM/static/img/img39.de303dfc.jpg" withUrl:@"www/yacht_tour" withTopTitleString:@"“飞”律宾第一季" withSubTitleString:@"惊喜游艇之旅" withIsFirstData:NO withIsDetails:YES];
    
    VIPHistoryImageModel *iData4 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"10" withImageName:@"cdn/1e3c3bFM/static/img/img1.e15119f4.jpg" withUrl:@"" withTopTitleString:@"AG旗舰厅新增贵宾百万投注桌台" withSubTitleString:@"～百万单注想投就投 盈利机会不容错过～" withIsFirstData:YES withIsDetails:NO];
    VIPHistoryImageModel *iData41 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"09" withImageName:@"cdn/1e3c3bFM/static/img/img2.d4bf9528.jpg" withUrl:@"www/bayer_tab4" withTopTitleString:@"德荷两国欢乐游 现场观战勒 | 沃库森" withSubTitleString:@"观看精彩刺激球赛 尊享贵宾奢华待遇" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData42 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"09" withImageName:@"cdn/1e3c3bFM/static/img/img34.ba4025ae.png" withUrl:@"" withTopTitleString:@"AG旗舰厅新增30万盘口" withSubTitleString:@"AG旗舰厅真人单注30万盘口火热开启" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData43 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"09" withImageName:@"cdn/1e3c3bFM/static/img/img3.9866a554.jpg" withUrl:@"" withTopTitleString:@"真人娱乐开设50、100万盘口，单日提款限额提升至1000万" withSubTitleString:@"50万盘口开设无任何要求,1000万提款工作日1小时到账" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData44 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"09" withImageName:@"cdn/1e3c3bFM/static/img/img4.50d7a166.jpg" withUrl:@""
                                                                  withTopTitleString:@"AG旗舰豪华厅正式上线"
                                                                  withSubTitleString:@"亚洲新坐标 全球首推" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData45 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"08" withImageName:@"cdn/1e3c3bFM/static/img/img5.63481c19.jpg" withUrl:@""
                                                                  withTopTitleString:@"与尼尔·罗伯逊相约菲律宾活动"
                                                                  withSubTitleString:@"博天堂客户欢聚菲律宾，参加豪华游艇party" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData46 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"07" withImageName:@"cdn/1e3c3bFM/static/img/img6.9a9ad3d4.jpg" withUrl:@""
                                                                  withTopTitleString:@"博天堂专属手机APP"
                                                                  withSubTitleString:@"畅享极速体验" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData47 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"07" withImageName:@"cdn/1e3c3bFM/static/img/img7.5f793691.jpg" withUrl:@""
                                                                  withTopTitleString:@"博天堂签约赞助"
                                                                  withSubTitleString:@"德甲知名球队勒沃库森" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData48 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"07" withImageName:@"cdn/1e3c3bFM/static/img/img8.0ac1e348.jpg" withUrl:@""
                                                                  withTopTitleString:@"BSG火热上线"
                                                                  withSubTitleString:@"无限惊喜  尽在3D视频老虎机" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData49 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"05" withImageName:@"cdn/1e3c3bFM/static/img/img9.d35d348d.jpg" withUrl:@""
                                                                  withTopTitleString:@"博天堂鼎力赞助"
                                                                  withSubTitleString:@"萧敬腾＆范玮琪澳门演唱会" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData410 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"02" withImageName:@"cdn/1e3c3bFM/static/img/img10.a1129942.jpg" withUrl:@""
                                                                  withTopTitleString:@"斯诺克知名选手"
                                                                  withSubTitleString:@"尼尔‧罗伯逊代言博天堂" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData411 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"02" withImageName:@"cdn/1e3c3bFM/static/img/img11.a60a833a.jpg" withUrl:@""
                                                                  withTopTitleString:@"博天堂冠名世界经典赛事"
                                                                  withSubTitleString:@"博天堂独家冠名赞助2016斯诺克德国大师赛" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData412 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"01" withImageName:@"cdn/1e3c3bFM/static/img/img12.37adbc59.jpg" withUrl:@""
                                                                  withTopTitleString:@"博天堂雀神麻将正式上线"
                                                                  withSubTitleString:@"特色广东麻将 玩家对战 血战到底更有趣" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData413 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"01" withImageName:@"cdn/1e3c3bFM/static/img/img13.99343411.jpg" withUrl:@""
                                                                  withTopTitleString:@"博天堂助力西甲"
                                                                  withSubTitleString:@"巴萨成功卫冕西甲冠军 博天堂倾情同贺再创辉煌" withIsFirstData:NO withIsDetails:NO];
    
    VIPHistoryImageModel *iData5 = [[VIPHistoryImageModel alloc] initWithYearString:@"2015" WithMonthString:@"07" withImageName:@"cdn/1e3c3bFM/static/img/img14.1ddac8a9.jpg" withUrl:@""
                                                                  withTopTitleString:@"博天堂全新推出GPI彩票游戏"
                                                                  withSubTitleString:@"世界首创60秒极速开奖超级快乐彩" withIsFirstData:YES withIsDetails:NO];
    VIPHistoryImageModel *iData51 = [[VIPHistoryImageModel alloc] initWithYearString:@"2015" WithMonthString:@"07" withImageName:@"cdn/1e3c3bFM/static/img/img15.d854d88d.jpg" withUrl:@""
                                                                  withTopTitleString:@"博天堂棋牌室隆重登场"
                                                                  withSubTitleString:@"24小时在线 真人对战 其乐无穷" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData52 = [[VIPHistoryImageModel alloc] initWithYearString:@"2015" WithMonthString:@"07" withImageName:@"cdn/1e3c3bFM/static/img/img16.8faaa5f2.jpg" withUrl:@""
                                                                  withTopTitleString:@"日提款限额人民币800万"
                                                                  withSubTitleString:@"网站单日提款金额上限从600万调升至800万" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData53 = [[VIPHistoryImageModel alloc] initWithYearString:@"2015" WithMonthString:@"07" withImageName:@"cdn/1e3c3bFM/static/img/img17.e3d66b49.jpg" withUrl:@""
                                                                  withTopTitleString:@"博天堂全新呈现HG真人游戏"
                                                                  withSubTitleString:@"HG平台闪亮登场 美女荷官现场互动" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData54 = [[VIPHistoryImageModel alloc] initWithYearString:@"2015" WithMonthString:@"04" withImageName:@"cdn/1e3c3bFM/static/img/img18.046692ad.jpg" withUrl:@"www/h_helpspanish"
                                                                  withTopTitleString:@"博天堂助力西甲"
                                                                  withSubTitleString:@"博天堂力捧巴萨卫冕西甲冠军，再创辉煌" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData55 = [[VIPHistoryImageModel alloc] initWithYearString:@"2015" WithMonthString:@"03" withImageName:@"cdn/1e3c3bFM/static/img/img19.bfc6a5f2.jpg" withUrl:@"www/h_polygramconcert"
                                                                  withTopTitleString:@"博天堂集团独家冠名赞助"
                                                                  withSubTitleString:@"宝丽金永恒金曲澳门演唱会，博天堂上百名客户聚首澳门" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData56 = [[VIPHistoryImageModel alloc] initWithYearString:@"2015" WithMonthString:@"03" withImageName:@"cdn/1e3c3bFM/static/img/img20.a35ebcd8.jpg" withUrl:@"www/h_thankyou"
                                                                  withTopTitleString:@"“一路相伴 感谢有您”"
                                                                  withSubTitleString:@"博天堂澳门春茗答谢晚宴 派送百万豪礼" withIsFirstData:NO withIsDetails:YES];
    
    VIPHistoryImageModel *iData6 = [[VIPHistoryImageModel alloc] initWithYearString:@"2014" WithMonthString:@"11" withImageName:@"cdn/1e3c3bFM/static/img/img21.f7f119c3.jpg" withUrl:@"www/h_golfpackage"
                                                                  withTopTitleString:@"918.com高尔夫亚巡赛完美收官"
                                                                  withSubTitleString:@"新加坡老将马玛（Mardan Mamat）喜获冠军" withIsFirstData:YES withIsDetails:YES];
    VIPHistoryImageModel *iData61 = [[VIPHistoryImageModel alloc] initWithYearString:@"2014" WithMonthString:@"10" withImageName:@"cdn/1e3c3bFM/static/img/img22.732edff1.jpg" withUrl:@""
                                                                  withTopTitleString:@"互动咪牌百家乐正式上线"
                                                                  withSubTitleString:@"互动咪牌百家乐正式上线，LED超清视觉效果 游戏进程尽在掌控" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData62 = [[VIPHistoryImageModel alloc] initWithYearString:@"2014" WithMonthString:@"10" withImageName:@"cdn/1e3c3bFM/static/img/img23.9e74feb6.jpg" withUrl:@"www/h_golftour"
                                                                  withTopTitleString:@"博天堂冠名2014高尔夫亚巡赛"
                                                                  withSubTitleString:@"10月10日举办南木球场高球友谊赛及马尼拉站媒体见面会" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData63 = [[VIPHistoryImageModel alloc] initWithYearString:@"2014" WithMonthString:@"7" withImageName:@"cdn/1e3c3bFM/static/img/img24.56aac11b.jpg" withUrl:@"www/h_golfconference"
                                                                  withTopTitleString:@"“918.com亚巡大师杯”高尔夫赛新闻发布会"
                                                                  withSubTitleString:@"在菲律宾最知名赌场“resorts world”召开新闻发布会" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData64 = [[VIPHistoryImageModel alloc] initWithYearString:@"2014" WithMonthString:@"7" withImageName:@"cdn/1e3c3bFM/static/img/img25.2ab4cb56.jpg" withUrl:@""
                                                                  withTopTitleString:@"手机投注全面上线"
                                                                  withSubTitleString:@"随时随地畅享投注赢利爆棚" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData65 = [[VIPHistoryImageModel alloc] initWithYearString:@"2014" WithMonthString:@"5" withImageName:@"cdn/1e3c3bFM/static/img/img26.c5c36c82.jpg" withUrl:@""
                                                                  withTopTitleString:@"博天堂正式更换LOGO"
                                                                  withSubTitleString:@"918博天堂 博彩天堂" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData66 = [[VIPHistoryImageModel alloc] initWithYearString:@"2014" WithMonthString:@"1" withImageName:@"cdn/1e3c3bFM/static/img/img27.b1037f51.jpg" withUrl:@"www/h_lotusofficer"
                                                                  withTopTitleString:@"博天堂AV女优荷官周"
                                                                  withSubTitleString:@"一睹波多野结衣等著名AV女优荷官发牌风采" withIsFirstData:NO withIsDetails:YES];
    
    VIPHistoryImageModel *iData7 = [[VIPHistoryImageModel alloc] initWithYearString:@"2013" WithMonthString:@"12" withImageName:@"cdn/1e3c3bFM/static/img/img28.e42cc206.jpg" withUrl:@""
                                                                  withTopTitleString:@"博天堂引领博彩业潮流"
                                                                  withSubTitleString:@"正式开通比特币充值游戏" withIsFirstData:YES withIsDetails:NO];
    VIPHistoryImageModel *iData71 = [[VIPHistoryImageModel alloc] initWithYearString:@"2013" WithMonthString:@"11" withImageName:@"cdn/1e3c3bFM/static/img/img29.e1db268c.jpg" withUrl:@"www/h_industrytrend"
                                                                  withTopTitleString:@"博天堂爱心捐赠"
                                                                  withSubTitleString:@"博天堂全体爱心捐赠100万peso" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData72 = [[VIPHistoryImageModel alloc] initWithYearString:@"2013" WithMonthString:@"11" withImageName:@"cdn/1e3c3bFM/static/img/img29.e1db268c.jpg" withUrl:@""
                                                                  withTopTitleString:@"博天堂通过博彩监管机构 “FCLRC”"
                                                                  withSubTitleString:@"正式开通比特币充值游戏" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData73 = [[VIPHistoryImageModel alloc] initWithYearString:@"2013" WithMonthString:@"11" withImageName:@"cdn/1e3c3bFM/static/img/img31.bf484a2e.jpg" withUrl:@""
                                                                  withTopTitleString:@"博天堂单日提款限额升至600万"
                                                                  withSubTitleString:@"网站开通各澳门知名赌场赌厅最高单日提款2000万" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData74 = [[VIPHistoryImageModel alloc] initWithYearString:@"2013" WithMonthString:@"2" withImageName:@"cdn/1e3c3bFM/static/img/img32.9a9ff037.jpg" withUrl:@""
                                                                  withTopTitleString:@"包桌咪牌百家乐正式上线"
                                                                  withSubTitleString:@"打造线上赌场贵宾厅" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData75 = [[VIPHistoryImageModel alloc] initWithYearString:@"2013" WithMonthString:@"2" withImageName:@"cdn/1e3c3bFM/static/img/img33.d27b2152.jpg" withUrl:@""
                                                                  withTopTitleString:@"首创六张牌先发"
                                                                  withSubTitleString:@"将在线博彩的公平性展现到极致" withIsFirstData:NO withIsDetails:NO];
    
    
    
    NSMutableArray *dArray = [NSMutableArray arrayWithObjects:sData1,sData2,sData3,sData4,sData5,sData6,sData7, nil];
    NSMutableArray *iArray = [NSMutableArray arrayWithObjects:iData1,iData11,iData2,iData21,iData22,iData23,iData3,iData31,iData32,iData33,iData34,iData4,iData41,iData42,iData43,iData44,iData45,iData46,iData47,iData48,iData49,iData410,iData411,iData412,iData413,iData5,iData51,iData52,iData53,iData54,iData55,iData56,iData6,iData61,iData62,iData63,iData64,iData65,iData66,iData7,iData71,iData72,iData73,iData74,iData75, nil];
    VIPHistoryModel * tempModel = [[VIPHistoryModel alloc] initWithSideBarData:dArray withImageModel:iArray];
    return tempModel;
}
@end
