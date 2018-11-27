//
//  HDAGGJViewController.m
//  A04_iPhone
//
//  Created by Key on 2018/11/23.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "BTTAGGJViewController.h"

@interface BTTAGGJViewController ()

@end

@implementation BTTAGGJViewController
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
    [self addChildViewController:[IVGameManager sharedManager].aginVC];
    [self.view addSubview:[IVGameManager sharedManager].aginVC.view];
    [IVGameManager sharedManager].aginVC.view.frame = self.view.frame;
    [IVGameManager sharedManager].aginVC.view.hidden = NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [BTTAGGJViewController addGameViewToWindow];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
+ (void)addGameViewToWindow
{
    [[IVGameManager sharedManager].aginVC removeFromParentViewController];
    UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
    [IVGameManager sharedManager].aginVC.view.hidden = YES;
    [keyWin addSubview:[IVGameManager sharedManager].aginVC.view];
    [IVGameManager sharedManager].aginVC.view.frame = keyWin.frame;
}
@end