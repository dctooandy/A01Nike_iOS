//
//  NSString+Expand.h
//  C01
//
//  Created by harden-imac on 2017/5/25.
//  Copyright © 2017年 harden-imac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Expand)

/**
 *  判断字符串是否为空
 *
 *  @param string 原字符串
 *
 *  @return BOOL 返回真字符串为空，否不为空
 */
+ (BOOL)isBlankString:(NSString *)string;

+ (NSString *)getURL:(NSString *)baseUrl queryParameters:(NSDictionary*)params;
+ (NSString *)handleRequestPostParams:(NSDictionary*)params;
+ (NSString *)wkWebViewPostjsWithURLString:(NSString *)url;

#pragma mark Base64
- (NSString *)base64;

/**
 URL Decode
 
 @return URL Decode String
 */
- (NSString *)URLDecodedString;

/**
 URL DEncode
 
 @return URL Decode String
 */
- (NSString *)URLEncodeString;

/**
 处理URLPath路径后缀的/
 
 @param URLPath URLPath路径
 @return 处理后的URLPath路径
 */
+ (NSString *)handleURLPathSuffire:(NSString *)URLPath;

- (NSString *)handleNativeDomain;
@end
