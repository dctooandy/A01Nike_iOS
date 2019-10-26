//
//  NSString+Expand.m
//  C01
//
//  Created by harden-imac on 2017/5/25.
//  Copyright © 2017年 harden-imac. All rights reserved.
//

#import "NSString+Expand.h"
#import "BTTUserInfoModel.h"

#define kWKWebViewPostJS @"function wkWebViewPostJS(path, params) {\
var method = \"POST\";\
var form = document.createElement(\"form\");\
form.setAttribute(\"method\", method);\
form.setAttribute(\"action\", path);\
for(var key in params){\
if (params.hasOwnProperty(key)) {\
var hiddenFild = document.createElement(\"input\");\
hiddenFild.setAttribute(\"type\", \"hidden\");\
hiddenFild.setAttribute(\"name\", key);\
hiddenFild.setAttribute(\"value\", params[key]);\
}\
form.appendChild(hiddenFild);\
}\
document.body.appendChild(form);\
form.submit();\
}"

@implementation NSString (Expand)


/**
 *  判断字符串是否为空
 *
 *  @param string 原字符串
 *
 *  @return BOOL 返回真字符串为空，否不为空
 */
+ (BOOL)isBlankString:(NSString *)string{
    if (string == nil || string == NULL){
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]){
        return YES;
    }
    
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    
    if ([string isEqualToString:@"null"]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0){
        return YES;
    }
    return NO;
}


+ (NSString *)_encodeString:(NSString *)string{
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)string,
                                                                                 NULL,
                                                                                 (CFStringRef)@";/?:@&=$+{}<>,",
                                                                                 kCFStringEncodingUTF8));
    return result;
}


+ (NSString *)_queryStringWithBase:(NSString *)base parameters:(NSDictionary *)params prefixed:(BOOL)prefixed{
    // Append base if specified.
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    if (base) {
        [str appendString:base];
    }
    // Append each name-value pair.
    if (params) {
        int i;
        NSArray *names = [params allKeys];
        for (i = 0; i < [names count]; i++) {
            if (i == 0 && prefixed && [str rangeOfString:@"?"].location == NSNotFound) {
                [str appendString:@"?"];
            } else {
                [str appendString:@"&"];
            }
            NSString *name = [names objectAtIndex:i];
            [str appendString:[NSString stringWithFormat:@"%@=%@",
                               name, [self _encodeString:[NSString stringWithFormat:@"%@",[params objectForKey:name]]]]];
        }
    }
    
    return str;
}


+ (NSString *)getURL:(NSString *)baseUrl queryParameters:(NSDictionary*)params{
    NSString* fullPath = [baseUrl copy];
    if (params) {
        fullPath = [self _queryStringWithBase:fullPath parameters:params prefixed:YES];
    }
    return fullPath;
}

+ (NSString *)handleRequestPostParams:(NSDictionary*)params {
    NSMutableString *str = [NSMutableString string];
    if (params && params.count > 0) {
        NSArray *names = [params allKeys];
        for (NSUInteger i = 0; i < [names count]; i++) {
            
            if (i != 0) {
                [str appendString:@"&"];
            }
            
            NSString *name = [names objectAtIndex:i];
            [str appendString:[NSString stringWithFormat:@"%@=%@", name, [params objectForKey:name]]];
        }
    }
    
    return str;
}

+ (NSString *)wkWebViewPostjsWithURLString:(NSString *)url {
    NSString *parameterStr  = @"";
    NSString *localDomain = [IVHttpManager shareManager].gateway;
    if ([url containsString:localDomain]) {
        
        NSString *appToken =  [IVCacheWrapper readJSONStringForKey:kCacheAppToken requestId:nil];//[[IVCacheManager sharedInstance] nativeReadDictionaryForKey:kCacheAppToken];
        BTTUserInfoModel *userModel = [IVHttpManager shareManager].userInfoModel;//[IVNetwork userInfo];
        
        if (userModel != nil) {
            parameterStr = [NSString stringWithFormat:@"{\"accountName\":\"%@\",\"appToken\":\"%@\",\"userToken\":\"%@\"}",userModel.loginName, appToken, [IVHttpManager shareManager].userToken];
        }
        else {
            parameterStr = [NSString stringWithFormat:@"{\"appToken\":\"%@\",}", appToken];
        }
    }
    NSString * postjs = [NSString stringWithFormat:@"%@wkWebViewPostJS(\"%@\", %@)",kWKWebViewPostJS, url,parameterStr];
    return postjs;
}

#pragma mark Base64
- (NSString *)base64{
    if ([NSString isBlankString:self]) {
        return @"";
    }
    NSData *encodeData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [encodeData base64EncodedStringWithOptions:0];
    return base64String;
}

/**
 URL Decode
 
 @return URL Decode String
 */
- (NSString *)URLDecodedString {
    if ([NSString isBlankString:self]) {
        return self;
    }
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

/**
 URL DEncode
 
 @return URL Decode String
 */
- (NSString *)URLEncodeString {
    if ([NSString isBlankString:self]) {
        return self;
    }
    NSString *outputStr =
    (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes( NULL, /* allocator */  (__bridge CFStringRef)self,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
    return outputStr;
}

/**
 处理URLPath路径后缀的/
 
 @param URLPath URLPath路径
 @return 处理后的URLPath路径
 */
+ (NSString *)handleURLPathSuffire:(NSString *)URLPath {
    if ([NSString isBlankString:URLPath]) {
        return @"";
    }
    NSString *last = [URLPath substringFromIndex:URLPath.length - 1];
    if ([last isEqualToString:@"/"]) {
        URLPath =[URLPath substringWithRange:NSMakeRange(0, [URLPath length] - 1)];
        return [self handleURLPathSuffire:URLPath];
    }
    return URLPath;
}


- (NSString *)handleNativeDomain {
    if ([NSString isBlankString:self]) {
        return @"";
    }
    NSString *httpHeader = @"";
    if ([self hasPrefix:@"http://"]) {
        httpHeader = @"http://";
    }
    else if ([self hasPrefix:@"https://"]) {
        httpHeader = @"https://";
    }
    NSString *handleURL = [[NSString handleURLPathSuffire:self] substringFromIndex:httpHeader.length];
    return handleURL;
}
@end
