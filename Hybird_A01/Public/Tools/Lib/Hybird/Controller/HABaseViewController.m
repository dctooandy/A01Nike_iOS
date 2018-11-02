//
//  HABaseViewController.m
//  MainHybird
//
//  Created by Key on 2018/7/6.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "HABaseViewController.h"
#import "Constants.h"
@interface HABaseViewController ()

@end

@implementation HABaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    weakSelf(weakSelf)
    self.navigationController.interactivePopGestureRecognizer.delegate =
    weakSelf;
    [self setLeftItems];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark ------------------UIGestureRecognizerDelegate----------------------------------------------
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return StatusBarStyle;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --------------------加载框-----------------------------------------
- (void)showLoading {
}

- (void)hideLoading {
}

- (void)setLeftItems {
    if (self.hideBackItem) {
         self.navigationItem.hidesBackButton = YES;
        return;
    }
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 54, 54);
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(navigationBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:backItem];
    if (items.count > 0) {
        self.navigationItem.leftBarButtonItems = items.copy;
    }
}

- (void)navigationBackButtonAction:(UIButton *)sender {
    [self goToBack];
}

- (void)goToBack {
    
}

@end
