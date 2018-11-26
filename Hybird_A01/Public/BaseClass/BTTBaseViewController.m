//
//  SPBaseViewController.m
//  A01_Sports
//
//  Created by Domino on 2018/9/21.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseViewController.h"

@interface BTTBaseViewController ()

@property (nonatomic, strong) id<UIGestureRecognizerDelegate> weakself;

@end

@implementation BTTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = _weakself;
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    self.view.backgroundColor = COLOR_RGBA(42, 45, 53, 1);
}

+ (BTTBaseViewController *)getVCFromStoryboard {
    UIStoryboard *stroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BTTBaseViewController *vc = [stroyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    NSLog(@"%@",NSStringFromClass([self class]));
    return vc;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

#pragma mark --------------------加载框-----------------------------------------
- (void)showLoading {
    dispatch_main_async_safe((^{
        if (self.hud) {
            [self hideLoading];
        }
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];//[MBProgressHUD showCustomView:nil toView:self.view];
        self.hud.bezelView.backgroundColor = [UIColor clearColor];
        self.hud.bezelView.blurEffectStyle = UIBlurEffectStyleLight;
    }));
    
}

- (void)hideLoading {
    dispatch_main_async_safe(^{
        [self.hud hideAnimated:YES];
    });
    
}

- (void)goToBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
