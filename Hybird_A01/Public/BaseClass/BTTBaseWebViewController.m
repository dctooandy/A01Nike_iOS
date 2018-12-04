//
//  BTTBaseWebViewController.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/2.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseWebViewController.h"

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
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];//[MBProgressHUD showCustomView:nil toView:self.view];
        self.hud.bezelView.backgroundColor = [UIColor clearColor];
        self.hud.bezelView.blurEffectStyle = UIBlurEffectStyleLight;
    }));
    
}

- (void)hideLoading {
    dispatch_main_async_safe((^{
        [self.hud hideAnimated:NO];
    }));
}

@end
