//
//  HAInitConfig.m
//  Hybird_A03
//
//  Created by Key on 2018/10/8.
//  Copyright © 2018年 Key. All rights reserved.
//

#import "HAInitConfig.h"

@implementation HAInitConfig

+ (NSString *)bundleId {
    return @"ivi.hyxapp.com";
}

+ (NSArray *)gateways {
    switch (EnvirmentType) {
        case 0:
            return @[@"http://www.pt-gateway.com/_glaxy_1e3c3b_/"];
        case 1:
            return @[@"http://fm.918rr.com/_glaxy_1e3c3b_/"];
        default:
            return @[@"https://fen1251.com/_glaxy_1e3c3b_/",@"https://fen1252.com/_glaxy_1e3c3b_/"];
    }
}
//https://a01mobileimage.sm830.com/static/A01M/_default/__static/_wms/_l/_banner/banner-index-186bd16447a23dc145b57aef0989822cf.jpg?v=d5de123c20360742454ddff7a6a0d94b
+ (NSString *)defaultH5Domain {
    switch (EnvirmentType) {
        case 0:
            return @"http://m.a01.com/";
            break;
        case 1:
            return @"http://fm.918rr.com/";
            break;
        case 2:
            return @"https://fen1251.com/";
            break;
        default:
            break;
    }
}

+ (NSString *)defaultCDN {
    switch (EnvirmentType) {
        case 0:
            return @"http://m.a01.com/";
            break;
        case 1:
            return @"http://fm.918rr.com/";
            break;
        case 2:
            return @"https://fen1251.com/";
            break;
        default:
            break;
    }
}

+ (NSString *)appKey {
    return @"";
}

+ (NSString *)appId {
    return @"d9002994416444bbb6d172e65ee4ce6c";
//    return @"aac31aaaa28d4ea89cf2a97ff72bf82d";//vip
}

+ (NSString *)socketIp {
    switch (EnvirmentType) {
        case 0:
            return @"10.71.12.105";
        case 1:
            return @"115.84.241.212";
        default:
            return @"202.83.195.101";
    }
}

+ (NSString *)socketPort {
    switch (EnvirmentType) {
        case 0:
            return @"8090";
        case 1:
            return @"8090";
        default:
            return @"28721";
    }
}

+ (NSString *)productId {
    return @"A01";
}

+ (NSString *)product3SId {
    return @"A01";
}

+ (NSString *)productCodeExt {
    return @"FM";
}

@end
