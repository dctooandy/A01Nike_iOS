//
//  HDAGQJViewController.m
//  A04_iPhone
//
//  Created by Key on 2018/11/23.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "BTTAGQJViewController.h"

@interface BTTAGQJViewController ()
@end

@implementation BTTAGQJViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [[IVGameManager sharedManager].agqjVC willMoveToParentViewController:nil];
    [[IVGameManager sharedManager].agqjVC.view removeFromSuperview];
    [[IVGameManager sharedManager].agqjVC removeFromParentViewController];
}

- (void)addGameViewToSelf
{
    IVGameManager *manager = [IVGameManager sharedManager];
    IVGameModel *gameModel = manager.agqjVC.gameModel;
    gameModel.platformCurrency = self.platformLine;
    gameModel.gameCode = BTTAGQJKEY;
    manager.agqjVC.gameModel = gameModel;
    [self addChildViewController:[IVGameManager sharedManager].agqjVC];
    [self.view addSubview:[IVGameManager sharedManager].agqjVC.view];
    [IVGameManager sharedManager].agqjVC.view.frame = self.view.frame;
    [IVGameManager sharedManager].agqjVC.view.hidden = NO;
    [[IVGameManager sharedManager].agqjVC didMoveToParentViewController:self];
    [[IVGameManager sharedManager].agqjVC reloadGame];
    [[IVGameManager sharedManager].agqjVC.backBtn addTarget:self action:@selector(overrideBackAction)];
}

-(void)overrideBackAction
{
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

+ (void)addGameViewToWindow
{
    [CNTimeLog AGQJFirstLoad];
    [[IVGameManager sharedManager].agqjVC removeFromParentViewController];
    UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
    [IVGameManager sharedManager].agqjVC.view.hidden = YES;
    [keyWin addSubview:[IVGameManager sharedManager].agqjVC.view];
    [IVGameManager sharedManager].agqjVC.view.frame = keyWin.frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
