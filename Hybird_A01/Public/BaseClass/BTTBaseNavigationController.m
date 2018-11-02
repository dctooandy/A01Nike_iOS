//
//  BTTBaseNavigationController.m
//  A01_Sports
//
//  Created by Domino on 2018/9/21.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseNavigationController.h"

@interface BTTBaseNavigationController ()

@end

@implementation BTTBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.titleTextAttributes = NavigationBarTitleTextAttributes;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 横竖屏

- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

@end
