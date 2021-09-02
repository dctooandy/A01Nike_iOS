//
//  BTTVIPClubWebViewController.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/5/10.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTVIPClubWebViewController.h"

@interface BTTVIPClubWebViewController ()

@end

@implementation BTTVIPClubWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadWebView];
}
- (void)goToBack {
//    if ([self.webView.request.URL.description isEqual:@""])
//    {
//        if (self.clickEventBlock) {
//            [self.navigationController popViewControllerAnimated:YES];
//            self.clickEventBlock(@"");
//        }
//    }
    if ([self.webView.request.URL.description isEqual:@""]
        || ([self.webConfigModel.url isEqual: @"history"]
        && [[self.webView.request.URL absoluteString] containsString:@"history"]
        && [[self.webView.request.URL absoluteString] containsString:@"?"] == true
        ))
    {
        if (self.clickEventBlock) {
            [self.navigationController popViewControllerAnimated:YES];
            self.clickEventBlock(@"");
        }
    }else
    {
        [self loadWebView];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *absoluteString = request.URL.absoluteString;
    NSLog(@"UIWebView将要打开：%@",absoluteString);
    // 跳转原生界面
    if (![absoluteString containsString:@"history"] && ([absoluteString hasPrefix:@"http"]) ) {
        NSString *hostString = request.URL.host;
        NSRange hostStringRange = [absoluteString rangeOfString:hostString];
        NSString *currentString = [absoluteString substringFromIndex:hostStringRange.location + hostStringRange.length + 1];
        UIViewController *topVC = [self currentViewController];
        BTTBaseWebViewController  *webController = [[BTTBaseWebViewController alloc] init];
        webController.webConfigModel.url = currentString;
        webController.webConfigModel.newView = YES;
        [webController loadWebView];
        [topVC.navigationController pushViewController:webController animated:YES];
        return NO;
    }
    return  YES;
}
- (UIViewController*)topMostWindowController
{
    UIWindow *win = [UIApplication sharedApplication].delegate.window;
    UIViewController *topController = [win rootViewController];
    if ([topController isKindOfClass:[UITabBarController class]]) {
        topController = [(UITabBarController *)topController selectedViewController];
    }
    while ([topController presentedViewController])  topController = [topController presentedViewController];
    return topController;
}
- (UIViewController*)currentViewController;
{
    UIViewController *currentViewController = [self topMostWindowController];
    
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    
    return currentViewController;
}
@end
