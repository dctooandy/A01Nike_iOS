//
//  BTTBaseWebViewController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/2.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseWebViewController.h"
#import "UIImage+GIF.h"
@interface BTTBaseWebViewController ()<UIWebViewDelegate>

@end

@implementation BTTBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.scrollView.bounces = YES;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showLoading];
    [super webViewDidStartLoad:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [super webViewDidFinishLoad:webView];
    [self hideLoading];
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
        hud.bezelView.backgroundColor = [UIColor clearColor];
        
        //设置总背景view的背景色，并带有透明效果
        hud.backgroundColor = [UIColor clearColor];
        hud.customView = loadingImageView;        
        self.hud = hud;

    }));
    
}

- (void)hideLoading {
    dispatch_main_async_safe((^{
        [self.hud hideAnimated:NO];
    }));
}

@end
