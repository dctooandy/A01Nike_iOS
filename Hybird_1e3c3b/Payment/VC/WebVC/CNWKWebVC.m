//
//  CNWKWebVC.m
//  HybirdApp
//
//  Created by cean.q on 2018/8/22.
//  Copyright © 2018年 AM-DEV. All rights reserved.
//

#import "CNWKWebVC.h"
#import <WebKit/WebKit.h>


@interface CNWKWebVC ()<WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *htmlString;
@property (nonatomic, assign) BOOL isHtml;
@property (nonatomic, copy) NSString *url;
@end

@implementation CNWKWebVC

- (instancetype)initWithHtmlString:(NSString *)htmlString {
    if (self = [super init]) {
        self.htmlString = htmlString;
        self.isHtml = YES;
    }
    return self;
}

- (instancetype)initWithURLString:(NSString *)URLString {
    if (self = [super init]) {
        self.url = URLString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    
    self.title = @"支付中...";
//    self.hideBackItem = NO;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    if (self.isHtml) {
        [_webView loadHTMLString:self.htmlString baseURL:nil];
    } else {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [_webView loadRequest:request];
    }
}



#pragma mark -------------------WKNavigationDelegate------------------------
// 请求开始前，会先调用此代理方法
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *requestString = navigationAction.request.URL.absoluteString;
    NSLog(@"开始请求页面:%@", requestString);
    NSArray *outsideUrls = @[@"itms-apps://", @"alipays://", @"mqqapi://", @"mqq://", @"weixin://"];
    for (NSString *prefixURL in outsideUrls) {
        if ([requestString hasPrefix:prefixURL]) {
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 在响应完成时，会回调此方法
// 如果设置为不允许响应，web内容就不会传过来
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"响应完成，显示界面:%@",navigationResponse.response.URL.absoluteString);
    decisionHandler(WKNavigationResponsePolicyAllow);
    [self startLoadWebView];
}

// 开始导航跳转时会回调
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"开始跳转页面:%@",webView.URL.absoluteString);
}

// 接收到重定向时会回调
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"开始重定向:%@", webView.URL.absoluteString);
}

// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"webView导航失败:%@，错误信息:%@", webView.URL.absoluteString,error);
    [self loadWebViewFailed];
}

// 页面内容到达main frame时回调
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
//    NSLog(@"webView页面内容到达main frame,%@",webView.URL.absoluteString);
}

// 导航完成时，会回调（也就是页面载入完成了）
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"webView页面载入完成,%@",webView.URL.absoluteString);
    [self loadWebViewSuccess];
}
// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"webView导航失败:%@，错误信息:%@", webView.URL.absoluteString,error);
    //在这里隐藏loading框
    [self loadWebViewFailed];
}

// 对于HTTPS的都会触发此代理，如果不要求验证，传默认就行
// 如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
//    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }

}

#ifdef  __IPHONE_9_0
// 9.0才能使用，web内容处理中断时会触发
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"webView内容处理中断:%@", webView.URL.absoluteString);
    [self loadWebViewFailed];
}

#endif
#pragma mark -------------------WKUIDelegate------------------------

/// iOS9.0中新加入的,处理WKWebView关闭的时间
- (void)webViewDidClose:(WKWebView *)webView {
    NSLog(@"%s", __func__);
}

/// 处理网页js中的提示框,若不使用该方法,则提示框无效
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alertC addAction:defaultAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

/// 处理网页js中的确认框,若不使用该方法,则确认框无效
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    [alertC addAction:cancelAction];
    [alertC addAction:defaultAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

/// 处理网页js中的文本输入
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:prompt message:webView.URL.host preferredStyle:UIAlertControllerStyleAlert];
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *text = alertC.textFields.firstObject.text;
        completionHandler(text);
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(nil);
    }];
    [alertC addAction:defaultAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

/**
 打开一个新页面时调用, WKWebView遇到 target='_blank' 的处理方法
 */
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    NSLog(@"打开一个新页面:%@",navigationAction.request.URL.absoluteString);
    [self loadWebViewFailed];
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark -------------------WKScriptMessageHandler---------------------
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@", message);
}

#pragma mark -------------------other-------------------------------------

- (UIColor *)HEX2Color:(NSInteger)hexCode inAlpha:(CGFloat)alpha {
    float red   = ((hexCode >> 16) & 0x000000FF)/255.0f;
    float green = ((hexCode >> 8) & 0x000000FF)/255.0f;
    float blue  = ((hexCode) & 0x000000FF)/255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (CGRectGetHeight(self.view.frame) < CGRectGetWidth(self.view.frame)) {
        self.navigationController.navigationBar.hidden = YES;
    } else {
        self.navigationController.navigationBar.hidden = NO;
    }
}

#pragma mark -------------------界面初始化-------------------------------------
- (void)setupSubViews {
    [self setupWebView];
}

- (void)setupWebView {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize = 10;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        config.websiteDataStore = [WKWebsiteDataStore defaultDataStore];
    }
    config.userContentController = [[WKUserContentController alloc] init];
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    _webView.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0];
    _webView.opaque = NO;
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
}

#pragma mark -------------------界面改变-------------------------------------

- (void)startLoadWebView {
//    [self.view makeToastActivity:CSToastPositionCenter];
}

- (void)loadWebViewFailed {
//    [self.view hideToastActivity];
}

- (void)loadWebViewSuccess {
//    [self.view hideToastActivity];
}

- (void)goToBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
