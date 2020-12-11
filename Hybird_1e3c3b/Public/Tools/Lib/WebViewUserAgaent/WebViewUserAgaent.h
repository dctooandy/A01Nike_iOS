//
//  WebViewUserAgaent.h
//  A02_iPhone
//
//  Created by Robert on 06/03/2017.
//  Copyright © 2017 toby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebViewUserAgaent : NSObject

/**
 写入IOS的UserAgaent
 
 */
+ (void)writeIOSUserAgent;


+ (void)writePTIOSUserAgent;

/**
 写入Android的UserAgaent
 
 */
+ (void)writeAndroidUserAgent;

/**
 清除cookie
 */
+ (void)clearCookie;

/**
 获取应用的名称
 
 @return 应用程序名称
 */
+ (NSString *)getAppName;


/**
 获取需要返回WebView的上一层界面的地址

 @return 返回WebView的上一层界面的地址
 */
+ (NSArray *)webViewBackURL;
@end
