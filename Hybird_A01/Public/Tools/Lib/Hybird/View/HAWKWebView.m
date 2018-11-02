//
//  HAWKWebView.m
//  MainHybird
//
//  Created by Key on 2018/6/9.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "HAWKWebView.h"
@implementation WKCookieSyncManager
SingletonImplementation(WKCookieSyncManager);

- (WKProcessPool *)processPool {
    if (!_processPool) {
        _processPool = [[WKProcessPool alloc] init];
    }
    return _processPool;
}
@end

@interface HAWKWebView()

@end
@implementation HAWKWebView
- (instancetype)initWithFrame:(CGRect)frame {
    self.scrollView.bounces = NO;
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize = 10;
    config.processPool = [WKCookieSyncManager sharedInstance].processPool;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        config.websiteDataStore = [WKWebsiteDataStore defaultDataStore];
    }
    config.userContentController = [[WKUserContentController alloc] init];
    if (self = [super initWithFrame:frame configuration:config]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        }
    }
    return self;
}
@end
