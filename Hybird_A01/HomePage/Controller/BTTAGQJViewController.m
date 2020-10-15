//
//  HDAGQJViewController.m
//  A04_iPhone
//
//  Created by Key on 2018/11/23.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "BTTAGQJViewController.h"
#import "BTTBJLPopView.h"

@interface BTTAGQJViewController ()
@property (nonatomic, strong) BTTBJLPopView *customView;
@property (nonatomic, assign) BOOL isRemoved;
@end

@implementation BTTAGQJViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (!self.isRemoved) {
        self.isRemoved = true;
        [[IVGameManager sharedManager].agqjVC removeObserver:self forKeyPath:@"loadStatus" context:nil];
    }
}
- (BOOL)shouldAutorotate
{
    return [[IVGameManager sharedManager].agqjVC shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [[IVGameManager sharedManager].agqjVC supportedInterfaceOrientations];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return StatusBarStyle;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addGameViewToSelf];
    [self registerNotifiction];
    [[IVGameManager sharedManager].agqjVC addObserver:self forKeyPath:@"loadStatus" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    self.isRemoved = false;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"loadStatus"]) {
        if ([IVGameManager sharedManager].agqjVC.loadStatus == IVGameLoadStatusSuccess) {
            if (self.customView == nil) {
                [self showBjlPopView];
            }
        }
    }
}
- (void)registerNotifiction {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLoginGame) name:@"FinishLoginGame" object:nil];
}

- (void)finishLoginGame {
    if ([IVGameManager sharedManager].agqjVC.loadStatus == IVGameLoadStatusSuccess) {
        [[CNTimeLog shareInstance] endRecordTime:CNEventAGQJLaunch];
        if (self.customView == nil) {
            [self showBjlPopView];
        }
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([IVGameManager sharedManager].agqjVC.parentViewController != self) {
        [self addGameViewToSelf];
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [BTTAGQJViewController addGameViewToWindow];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)addGameViewToSelf
{
    IVGameManager *manager = [IVGameManager sharedManager];
    IVGameModel *gameModel = manager.agqjVC.gameModel;
    gameModel.platformCurrency = self.platformLine;
    manager.agqjVC.gameModel = gameModel;
    [self addChildViewController:[IVGameManager sharedManager].agqjVC];
    [self.view addSubview:[IVGameManager sharedManager].agqjVC.view];
    [IVGameManager sharedManager].agqjVC.view.frame = self.view.frame;
    [IVGameManager sharedManager].agqjVC.view.hidden = NO;
}
+ (void)addGameViewToWindow
{
    [[CNTimeLog shareInstance] AGQJFirstLoad];
    [[IVGameManager sharedManager].agqjVC removeFromParentViewController];
    UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
    [IVGameManager sharedManager].agqjVC.view.hidden = YES;
    [keyWin addSubview:[IVGameManager sharedManager].agqjVC.view];
    [IVGameManager sharedManager].agqjVC.view.frame = keyWin.frame;
}

-(void)showBjlPopView {
    self.customView = [BTTBJLPopView viewFromXib];
    self.customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:self.customView popStyle:BTTAnimationPopStyleScale dismissStyle:BTTAnimationDismissStyleNO];
    [popView pop];
    weakSelf(weakSelf);
    self.customView.dismissBlock = ^{
        strongSelf(strongSelf);
        [popView dismiss];
        if (!strongSelf.isRemoved) {
            strongSelf.isRemoved = true;
            [[IVGameManager sharedManager].agqjVC removeObserver:strongSelf forKeyPath:@"loadStatus" context:nil];
        }
    };
}
@end
