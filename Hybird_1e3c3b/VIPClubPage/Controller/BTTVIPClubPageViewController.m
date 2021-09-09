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
@end
