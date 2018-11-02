//
//  HAWKWebView.h
//  MainHybird
//
//  Created by Key on 2018/6/9.
//  Copyright © 2018年 Key. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKCookieSyncManager : NSObject
@property (nonatomic, strong) WKProcessPool *processPool;
SingletonInterface(WKCookieSyncManager);

@end
@interface HAWKWebView : WKWebView

@end
