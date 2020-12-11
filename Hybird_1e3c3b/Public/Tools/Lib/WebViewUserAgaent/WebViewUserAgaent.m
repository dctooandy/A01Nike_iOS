//
//  WebViewUserAgaent.m
//  A02_iPhone
//
//  Created by Robert on 06/03/2017.
//  Copyright © 2017 toby. All rights reserved.
//

#import "WebViewUserAgaent.h"
#import <UIKit/UIKit.h>
#import <WebKit/WKWebsiteDataStore.h>
// app_version版本号
#define app_version   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]


@implementation WebViewUserAgaent

#pragma mark UserAgaent方法
+ (void)writeIOSUserAgent {
    NSString *userAgaent = [NSString stringWithFormat: @"Mozilla/5.0 (iPhone; CPU iPhone OS 10_1_1 like Mac OS X) AppleWebKit/602.2.14 (KHTML, like Gecko) Version/10.0 Mobile/14B100 Safari/602.1 app_version=%@ great-winner",app_version];
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:userAgaent,@"UserAgent",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)writeAndroidUserAgent {
    NSString *userAgaent = [NSString stringWithFormat: @"Mozilla/5.0 (Linux; Android 6.0.1; SM-G920F Build/SM-G920F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.89 Mobile Safari/537.36 app_version=%@ great-winner,Mobile",app_version];
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:userAgaent,@"UserAgent",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)writePTIOSUserAgent {
    NSString *newUserAgaent =[NSString stringWithFormat: @"Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1 great-winner"];
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newUserAgaent,@"UserAgent",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)writeOtherIOSUserAgent {
    NSMutableString *userAgent = [NSMutableString stringWithString:[[UIWebView new] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"]];
    NSString *newUserAgaent =[NSString stringWithFormat: @"%@ app_version=%@ great-winner",userAgent,app_version];
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newUserAgaent,@"UserAgent",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearCookie {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    // verge 增加 2017-07-20
    // 修改AG国际厅缓存导致串号问题
    if ([UIDevice currentDevice].systemVersion.floatValue < 9.0f) {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/WebKit"];
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&error];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
            NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
            NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
            [dateStore removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{}];
        });
    }
}

/**
 获取应用的名称

 @return 应用程序名称
 */
+ (NSString *)getAppName {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return app_Name;
}

/**
 获取需要返回WebView的上一层界面的地址
 
 @return 返回WebView的上一层界面的地址
 */
+ (NSArray *)webViewBackURL {
    return @[@"recommended.htm"];
}

@end
