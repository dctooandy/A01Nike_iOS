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
    [BTTAGQJViewController addGameViewToWindow];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)addGameViewToSelf
{
    [self addChildViewController:[IVGameManager sharedManager].agqjVC];
    [self.view addSubview:[IVGameManager sharedManager].agqjVC.view];
    [IVGameManager sharedManager].agqjVC.view.frame = self.view.frame;
    [IVGameManager sharedManager].agqjVC.view.hidden = NO;
}
+ (void)addGameViewToWindow
{
    [[IVGameManager sharedManager].agqjVC removeFromParentViewController];
    UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
    [IVGameManager sharedManager].agqjVC.view.hidden = YES;
    [keyWin addSubview:[IVGameManager sharedManager].agqjVC.view];
    [IVGameManager sharedManager].agqjVC.view.frame = keyWin.frame;
}
@end
