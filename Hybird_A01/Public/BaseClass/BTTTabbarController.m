//
//  BTTTabbarController.m
//  A01_Sports
//
//  Created by Domino on 2018/9/21.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTTabbarController.h"
#import "BTTTabBar.h"
#import "BTTHomePageViewController.h"
#import "BTTDiscountsViewController.h"
#import "BTTMineViewController.h"
#import "BTTLuckyWheelViewController.h"
#import "BTTActionSheet.h"
#import "BTTTabbarController+VoiceCall.h"
#import "JXRegisterManager.h"
#import "BTTVoiceCallViewController.h"
#import "BTTLoginOrRegisterViewController.h"
#import <IVCacheLibrary/IVCacheWrapper.h>


@interface BTTTabbarController ()<BTTTabBarDelegate, UINavigationControllerDelegate,JXRegisterManagerDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) BTTBaseViewController *selectVC;

@property (nonatomic, strong) BTTHomePageViewController *homePageVC;

@property (nonatomic, strong) BTTBaseViewController *voiceCall;

@property (nonatomic, strong) BTTLuckyWheelViewController *lucky;

@property (nonatomic, strong) BTTDiscountsViewController *discountsVC;

@property (nonatomic, strong) BTTMineViewController *mineVC;

@property (nonatomic, assign) NSInteger preSelectIndex;


@end

@implementation BTTTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewControllers];
    [self customTabbar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userTokenExpired) name:IVNUserTokenExpiredNotification object:nil];
    [self registerLoginOrOutNotification];
    [self registerNotification];
    [self requestCustomerVipLine];
}


- (void)registerLoginOrOutNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess:) name:LogoutSuccessNotification object:nil];
}

- (void)loginSuccess:(NSNotification *)notifi {
    NSDictionary * dic = notifi.object;
    if ([[dic objectForKey:@"isBackHome"] boolValue]) {
        [self resetTabar];
    }
}

- (void)logoutSuccess:(NSNotification *)notifi {
    [self.myTabbar setSeletedIndex:0];
    [self resetTabar];
}


- (void)resetTabar {
    
    if ([IVNetwork savedUserInfo]) {
        for (UITabBarItem *item in self.items) {
            NSInteger index = [self.items indexOfObject:item];
            if (index == 3) {
                item.title = @"优惠";
                item.image = ImageNamed(@"preferential_normal");
                item.selectedImage = ImageNamed(@"preferential_pressed");
                break;
            }
        }
    } else {
        for (UITabBarItem *item in self.items) {
            NSInteger index = [self.items indexOfObject:item];
            if (index == 3) {
                item.title = @"登录/开户";
                item.image = ImageNamed(@"login_normal");
                item.selectedImage = ImageNamed(@"login_pressed");
                break;
            }
        }
    }
    [self customTabbar];
}

//登录状态失效
- (void)userTokenExpired
{
    //清空用户信息
    if ([IVNetwork savedUserInfo].loginName!=nil&&![[IVNetwork savedUserInfo].loginName isEqualToString:@""]) {
        [MBProgressHUD showError:@"登录超时，请重新登录" toView:nil];
        [IVNetwork cleanUserInfo];
        [IVHttpManager shareManager].loginName = @"";
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:BTTSaveMoneyTimesKey];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:BTTNicknameCache];
        [[NSNotificationCenter defaultCenter] postNotificationName:LogoutSuccessNotification object:nil];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:BTTNicknameCache];
    }
    
}
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSuccessGotoHomePageNotification) name:BTTRegisterSuccessGotoHomePageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSuccessGotoMineNotification) name:BTTRegisterSuccessGotoMineNotification object:nil];
}

- (void)registerSuccessGotoHomePageNotification {
    [self.myTabbar setSeletedIndex:0];
}

- (void)registerSuccessGotoMineNotification {
    [self.myTabbar setSeletedIndex:4];
}

- (void)requestCustomerVipLine{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if ([IVNetwork savedUserInfo]) {
        [params setValue:[IVNetwork savedUserInfo].loginName forKey:@"loginName"];
    }
    [IVNetwork requestPostWithUrl:BTT400Line paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [IVCacheWrapper setObject:result.body[@"value"] forKey:@"APP_400_HOTLINE"];
        }
    }];
}

/**
 自定义tabbar
 */
- (void)customTabbar {
    self.tabBar.hidden = YES;
    if (!_myTabbar) {
        _myTabbar = [[BTTTabBar alloc] init];
        _myTabbar.delegate = self;
        _myTabbar.backgroundColor = [UIColor colorWithPatternImage:ImageNamed(@"TabBar_bg")];
        _myTabbar.frame = self.tabBar.frame;
        [self.view addSubview:_myTabbar];
    }
    // 存储UITabBarItem
    _myTabbar.items = self.items;
}

- (void)setupViewControllers {
    [self addOneChildVC:self.homePageVC title:@"首页" imageName:@"home_normal" selectedImageName:@"home_pressed"];
    [self addOneChildVC:self.voiceCall title:@"APP语音" imageName:@"tab_voiceCall" selectedImageName:@"tab_voiceCall"];
    [self addOneChildVC:self.lucky title:@"抽奖" imageName:@"lottery_pressed" selectedImageName:@"lottery_pressed"];
    if ([IVNetwork savedUserInfo]) {
        [self addOneChildVC:self.discountsVC title:@"优惠" imageName:@"preferential_normal" selectedImageName:@"preferential_pressed"];
    } else {
        [self addOneChildVC:self.discountsVC title:@"登录/开户" imageName:@"login_normal" selectedImageName:@"login_pressed"];
    }
    [self addOneChildVC:self.mineVC title:@"会员中心" imageName:@"member_normal" selectedImageName:@"member_pressed"];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.myTabbar.frame = self.tabBar.frame;
    NSLog(@"%@",NSStringFromCGRect(self.tabBar.frame));
}


/**
 *  添加一个自控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中时的图标
 */

- (void)addOneChildVC:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    // 设置标题
    childVc.tabBarItem.title = title;
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    // 不要渲染
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = selectedImage;
    // 记录所有控制器对应按钮的内容
    [self.items addObject:childVc.tabBarItem];
    // 添加为tabbar控制器的子控制器
    BTTBaseNavigationController *nav = [[BTTBaseNavigationController alloc] initWithRootViewController:childVc];
    nav.delegate = self;
    [self addChildViewController:nav];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
    [self.myTabbar setSeletedIndex:selectedIndex];
}


#pragma mark - BTTTabBarDelegate

- (void)tabBar:(BTTTabBar *)tabBar didClickBtn:(NSInteger)index {
    [super setSelectedIndex:index];
    if (index == 2) {
        self.selectVC = (BTTBaseViewController *)self.lucky;
        NSString *domain = [IVNetwork h5Domain];
        self.lucky.webConfigModel.theme = @"inside";
        self.lucky.webConfigModel.url = [NSString stringWithFormat:@"%@%@",domain,@"#/activity_pages/lucky_wheel_2020"]; //@"customer/lucky_wheel.htm";
        self.preSelectIndex = index;
        [self.selectVC.navigationController popToRootViewControllerAnimated:NO];
    } else if (index == 1) {
        self.selectVC = self.voiceCall;
        BTTActionSheet *actionSheet = [[BTTActionSheet alloc] initWithTitle:@"欢迎使用免费语音通话" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"APP语音"] actionSheetBlock:^(NSInteger buttonIndex) {
            NSLog(@"选择了%@",@(buttonIndex));
            weakSelf(weakSelf);
            if (buttonIndex == 0) {
                if ([IVNetwork savedUserInfo]) {
                    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
                    [self loadVoiceCallNumWithIsLogin:YES makeCall:^(NSString *uid) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        if (uid == nil || uid.length == 0) {
                            [MBProgressHUD showError:@"拨号失败请重试" toView:nil];
                        } else {
                            strongSelf(strongSelf);
                            [strongSelf registerUID:uid];
                        }
                        
                    }];
                } else {
                    [MBProgressHUD showLoadingSingleInView:self.view animated:YES];
                    [self loadVoiceCallNumWithIsLogin:NO makeCall:^(NSString *uid) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        if (uid == nil || uid.length == 0) {
                            [MBProgressHUD showError:@"拨号失败请重试" toView:nil];
                        } else {
                            strongSelf(strongSelf);
                            [strongSelf registerUID:uid];
                        }
                    }];
                }
            }
        }];
        [actionSheet show];
        self.myTabbar.seletedIndex = self.preSelectIndex;
    } else if (index == 0) {
        self.selectVC = self.homePageVC;
        self.preSelectIndex = index;
    } else if (index == 3) {
        self.selectVC = self.discountsVC;
        if ([IVNetwork savedUserInfo]) {
            self.preSelectIndex = index;
        } else {
            BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
            [self.selectVC.navigationController pushViewController:vc animated:YES];
        }
        
    } else {
        self.selectVC = self.mineVC;
        self.preSelectIndex = index;
    }
}

#pragma mark - JXRegisterManagerDelegate

- (void)registerUID:(NSString *)uid {
    JXRegisterManager *registerManager = [JXRegisterManager sharedInstance];
    registerManager.delegate = self;
    [registerManager registerWithUID:uid];
}

- (void)didRegisterResponse:(NSDictionary *)response {
    NSInteger statusCode = [response[@"code"] integerValue];
     if (statusCode == 200 || statusCode == 409) {//当注册成功或者这个号码在别的手机上注册过
        BTTVoiceCallViewController *vc = (BTTVoiceCallViewController *)[BTTVoiceCallViewController getVCFromStoryboard];
        [self.selectVC.navigationController pushViewController:vc animated:NO];
    } else {
        NSLog(@"VOIP注册失败");
        [MBProgressHUD showError:@"拨号失败请重试" toView:nil];
    }
}

#pragma mark - 横竖屏

- (BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
}

#pragma mark - UINavigationControllerDelegate

#pragma mark navVC代理
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    UIViewController *root = navigationController.viewControllers.firstObject;
    self.tabBar.hidden = YES;
    if (viewController != root) {
        //从HomeViewController移除
        [self.myTabbar removeFromSuperview];
        // 调整tabbar的Y值
        CGRect dockFrame = self.myTabbar.frame;
        NSLog(@"%@",@(SCREEN_HEIGHT));
        dockFrame.origin.y = root.view.frame.size.height - kTabbarHeight;
        if ([root.view isKindOfClass:[UIScrollView class]]) { // 根控制器的view是能滚动
            UIScrollView *scrollview = (UIScrollView *)root.view;
            dockFrame.origin.y += scrollview.contentOffset.y;
        }
        self.myTabbar.frame = dockFrame;
        // 添加dock到根控制器界面
        [root.view addSubview:self.myTabbar];
    }
}

// 完全展示完调用
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    UIViewController *root = navigationController.viewControllers.firstObject;
    BTTBaseNavigationController *nav = (BTTBaseNavigationController *)navigationController;
    if (viewController == root) {
        navigationController.interactivePopGestureRecognizer.delegate = nav.popDelegate;
        // 让Dock从root上移除
        [_myTabbar removeFromSuperview];
        _myTabbar.frame = CGRectMake(0, SCREEN_HEIGHT - kTabbarHeight, SCREEN_WIDTH, kTabbarHeight);
        [self.view addSubview:_myTabbar];
    }
}


#pragma mark - getter

- (BTTHomePageViewController *)homePageVC {
    if (!_homePageVC) {
        _homePageVC = [[BTTHomePageViewController alloc] init];
        
        AGQJController *AGQJvc = [IVGameManager sharedManager].agqjVC;
        [self.homePageVC.view addSubview:AGQJvc.view];
        AGQJvc.view.top = -SCREEN_HEIGHT;

        AGINController *aginVC = [IVGameManager sharedManager].aginVC;
        //AG国际预加载
        [self.homePageVC.view addSubview:aginVC.view];
        aginVC.view.top = -SCREEN_HEIGHT;
    }
    return _homePageVC;
}

- (BTTBaseViewController *)voiceCall {
    if (!_voiceCall) {
        _voiceCall = [[BTTBaseViewController alloc] init];
    }
    return _voiceCall;
}

- (BTTLuckyWheelViewController *)lucky {
    if (!_lucky) {
        _lucky = [[BTTLuckyWheelViewController alloc] init];
    }
    return _lucky;
}

- (BTTDiscountsViewController *)discountsVC {
    if (!_discountsVC) {
        _discountsVC = [[BTTDiscountsViewController alloc] init];;
    }
    return _discountsVC;
}

- (BTTMineViewController *)mineVC {
    if (!_mineVC) {
        _mineVC = [[BTTMineViewController alloc] init];
    }
    return _mineVC;
}

- (NSMutableArray *)items {
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}


@end
