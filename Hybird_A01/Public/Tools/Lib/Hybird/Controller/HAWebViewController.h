//
//  HAWebViewController.h
//  MainHybird
//
//  Created by Key on 2018/6/7.
//  Copyright © 2018年 Key. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HABaseViewController.h"
#import "WebConfigModel.h"
#import "HAWKWebView.h"
#import "HAWebView.h"

@interface HAWebViewController : HABaseViewController<UIWebViewDelegate, WKUIDelegate, WKNavigationDelegate>
@property(nonatomic, strong, readonly) HAWebView *webView;
@property(nonatomic, strong)WebConfigModel *webConfigModel;
@property (nonatomic, assign, readonly) BOOL loaded;

@property (nonatomic, assign) BOOL isLoaded;

/**
 加载webview
 */
- (void)loadWebView;

/**
 更新UI
 */
- (void)updateUI;
/**
 native调用js方法

 @param functionName 方法名称
 @param arguments 参数
 @return 返回对象
 */
- (id)nativeCallJSFunctionName:(NSString *)functionName arguments:(NSDictionary *)arguments;

/**
 是否开启预加载，开启后不会主动加载页面，必须手动调loadWebView方法
 */
- (BOOL)isPreloading;

/**
 jsContext加载成功后通知js
 */
- (void)loadFinishCallJS;

@end
