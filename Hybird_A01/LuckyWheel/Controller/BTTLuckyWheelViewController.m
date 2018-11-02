//
//  BTTLuckyWheelViewController.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/2.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTLuckyWheelViewController.h"
#import "BTTHomePageHeaderView.h"

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
    [super viewWillLayoutSubviews];
    self.webView.frame = CGRectMake(0, KIsiPhoneX ? 88 : 64, SCREEN_WIDTH, SCREEN_HEIGHT - (KIsiPhoneX ? 88 : 64) - (KIsiPhoneX ? 83 : 49));
}
    

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self loadWebView];
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
