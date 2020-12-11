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
//    [self setStatusBarBackgroundColor:[UIColor clearColor]];
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
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSMutableArray *loadingImages = [NSMutableArray array];
        for (int i = 0; i < 29; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"frame-%d",i]];
            [loadingImages addObject:image];
        }
        UIImageView *loadingImageView = [[UIImageView alloc] init];
        loadingImageView.animationImages = loadingImages;
        loadingImageView.animationRepeatCount = NSIntegerMax;
        loadingImageView.animationDuration = 1.0;
        [loadingImageView startAnimating];
        
        //设置hud模式
        hud.mode = MBProgressHUDModeCustomView;
        
        //设置在hud影藏时将其从SuperView上移除,自定义情况下默认为NO
        hud.removeFromSuperViewOnHide = YES;
        
        //设置方框view为该模式后修改颜色才有效果
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        
        //设置方框view背景色
        hud.bezelView.backgroundColor = [UIColor blackColor];
        
        //设置总背景view的背景色，并带有透明效果
        hud.backgroundColor = [UIColor clearColor];
        hud.customView = loadingImageView;
        self.hud = hud;
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
