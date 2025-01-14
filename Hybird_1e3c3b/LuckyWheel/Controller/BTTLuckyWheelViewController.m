//
//  BTTLuckyWheelViewController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/2.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTLuckyWheelViewController.h"
#import "BTTHomePageHeaderView.h"
#import "WebViewUserAgaent.h"

@interface BTTLuckyWheelViewController ()

@end

@implementation BTTLuckyWheelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupNav];
}
- (void)setupNav {
    [self.navigationController setNavigationBarHidden:YES];
    BTTHomePageHeaderView *nav = [[BTTHomePageHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KIsiPhoneX ? 88 : 64) withNavType:BTTNavTypeOnlyTitle];
    nav.titleLabel.text = @"幸运大转盘";
    [self.view addSubview:nav];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webView.frame = CGRectMake(0, KIsiPhoneX ? 88 : 64, SCREEN_WIDTH, SCREEN_HEIGHT - (KIsiPhoneX ? 88 : 64) - (KIsiPhoneX ? 83 : 49));
    self.statusView.frame = CGRectMake(0, 0, CGRectGetWidth(self.webView.frame), CGRectGetHeight(self.webView.frame));
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}   

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![IVNetwork savedUserInfo]) {
        [WebViewUserAgaent clearCookie];
    }
    [self loadWebView];
    [self.webView reload];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error.code != NSURLErrorCancelled) {
        [super webView:webView didFailLoadWithError:error];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
    [self loadFinishCallJS];
}

- (BOOL)isPreloading
{
    return YES;
}

@end
