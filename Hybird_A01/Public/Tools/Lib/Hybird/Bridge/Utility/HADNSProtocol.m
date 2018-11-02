//
//  HDDNSProtocol.m
//  A04_iPhone
//
//  Created by harden-imac on 2017/7/5.
//  Copyright © 2017年 alibaba. All rights reserved.
//

#import "HADNSProtocol.h"

static NSString *protocolKey = @"protocolKey";

@interface HADNSProtocol() <NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSessionTask *task;

@end



@implementation HADNSProtocol

+ (BOOL)isValidIP:(NSString *)ip {
    NSString *regex = [NSString stringWithFormat:@"^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL rc = [pre evaluateWithObject:ip];
    
    if (rc) {
        NSArray *componds = [ip componentsSeparatedByString:@","];
        
        BOOL v = YES;
        for (NSString *s in componds) {
            if (s.integerValue > 255) {
                v = NO;
                break;
            }
        }
        
        return v;
    }
    
    return NO;
}

+ (BOOL)isIpV4Address:(NSString *) url {
    NSString *regex = @"^(2[0-4][0-9]|25[0-5]|1[0-9][0-9]|[1-9]?[0-9])(\\.(2[0-4][0-9]|25[0-5]|1[0-9][0-9]|[1-9]?[0-9])){3}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:url];
}

+ (NSString *)getHostNameOfUrl:(NSString *)urlString
{
    NSURL* url = [NSURL URLWithString:urlString];
    if (url == nil) {
        NSLog(@"ERROR:%s:%d failed reason: %@ is invaild url.",__FUNCTION__,__LINE__, urlString);
    }
    
    return url.host;
}

/**
 *  是否拦截处理指定的请求
 *
 *  @param request 指定的请求
 *
 *  @return 返回YES表示要拦截处理，返回NO表示不拦截处理
 */
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    if ([NSURLProtocol propertyForKey:protocolKey inRequest:request]) {
        return NO;
    }
    
    NSString *netHost = request.URL.host;
    if (netHost == nil && netHost.length <= 0) {
        return NO;
    }
    
    if ([request.URL.absoluteString containsString:@"gameCode=A01039"] ||
        [request.URL.absoluteString containsString:@"game_pt"]) {
        return NO;
    }
    
    NSString *localDomain = [HADNSProtocol nativeReadDictionaryDomain];
    if ([netHost isEqualToString:localDomain]) {
        return YES;
    }
    
    NSString *localIp = [HADNSProtocol nativeReadDictionaryIP];
    if ([netHost isEqualToString:localIp]) {
        return YES;
    }
    
    NSString *headerHost = [request valueForHTTPHeaderField:@"Host"];
    if ([netHost isEqualToString:headerHost]) {
        return YES;
    }
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

+ (NSString *)nativeReadDictionaryDomain {
    NSString *localDomain = [IVNetwork h5Domain];
    if ([localDomain hasPrefix:@"http"]) {
        NSURL *localHost = [NSURL URLWithString:localDomain];
        return localHost.host;
    }
    
    return localDomain;
}

+ (NSString *)nativeReadDictionaryIP {
    NSString *localIp = [[IVCacheManager sharedInstance] nativeReadDictionaryForKey:kCacheDnsIp];
    if ([localIp hasPrefix:@"http"]) {
        NSURL *localHost = [NSURL URLWithString:localIp];
        return localHost.host;
    }
    
    return localIp;
}

- (void)startLoading {
    NSMutableURLRequest *mutableReq = [self.request mutableCopy];
    // 表示该请求已经被处理，防止无限循环
    [NSURLProtocol setProperty:@(YES) forKey:protocolKey inRequest:mutableReq];
    
    NSString *localHost = [HADNSProtocol nativeReadDictionaryDomain];
    NSString *localIp = [HADNSProtocol nativeReadDictionaryIP];
    if ([mutableReq.URL.host isEqualToString:localIp]) {
        [mutableReq setValue:localHost forHTTPHeaderField:@"Host"];
    }
    
    else {
        NSString *ip = nil;
        if ([mutableReq.URL.host isEqualToString:localHost]) {
            ip = localIp;
        }
        
        if (ip != nil && ip.length > 0 && [HADNSProtocol isValidIP:ip]) {
            NSString *domainstring = mutableReq.URL.absoluteString;
            NSURL *url = mutableReq.URL;
            NSRange domainRange = [domainstring rangeOfString:url.host];
            if (NSNotFound != domainRange.location) {
                NSString *temp = [domainstring stringByReplacingCharactersInRange:domainRange withString:ip];
                NSString *host = url.host;
                mutableReq.URL = [NSURL URLWithString:temp];
                [mutableReq setValue:host forHTTPHeaderField:@"Host"];
            }
        }
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.protocolClasses = @[[HADNSProtocol class]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
    self.task = [session dataTaskWithRequest:mutableReq completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        }
        
        else {
            [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
            [[self client] URLProtocol:self didLoadData:data];
            [[self client] URLProtocolDidFinishLoading:self];
        }
    }];
    
    [self.task resume];
}

- (void)stopLoading {
    [self.task cancel];
    [self setTask:nil];
}

-(void)URLSession:(NSURLSession*)session task:(NSURLSessionTask*)task willPerformHTTPRedirection:(NSHTTPURLResponse*)response newRequest:(NSURLRequest*)newRequest completionHandler:(void (^)(NSURLRequest*))completionHandler
{
    NSMutableURLRequest *request = newRequest.mutableCopy;
    [NSURLProtocol removePropertyForKey:protocolKey inRequest:request];
    
    NSString *localDomain = [IVNetwork h5Domain];
    NSString *localIp = [[IVCacheManager sharedInstance] nativeReadDictionaryForKey:kCacheDnsIp];
    if (![request.URL.host isEqualToString:localDomain] &&
        ![request.URL.host isEqualToString:localIp]) {
        [request setValue:nil forHTTPHeaderField:@"Host"];
    }
    
    else {
        [request setValue:localDomain forHTTPHeaderField:@"Host"];
    }
    
    [self.client URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    [task cancel];
    [self.client URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
}

@end

