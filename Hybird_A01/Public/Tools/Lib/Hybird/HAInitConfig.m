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
            return @[@"http://www.pt-gateway.com/_glaxy_a01_/"];
        case 1:
            return @[@"http://fm.918rr.com/_glaxy_a01_/"];
        default:
            return @[@"https://m.918nee.com/_glaxy_a01_/"];
    }
}
//https://a01mobileimage.sm830.com/static/A01M/_default/__static/_wms/_l/_banner/banner-index-186bd16447a23dc145b57aef0989822cf.jpg?v=d5de123c20360742454ddff7a6a0d94b
+ (NSString *)defaultH5Domain {
    switch (EnvirmentType) {
        case 0:
            return @"http://m.a01f.com/";
            break;
        case 1:
            return @"https://fm.918rr.com/";
            break;
        case 2:
            return @"https://m.918bs.com/";
            break;
        default:
            break;
    }
}

+ (NSString *)defaultCDN {
    switch (EnvirmentType) {
        case 0:
            return @"http://m.a01f.com/";
            break;
        case 1:
            return @"https://fm.918rr.com/";
            break;
        case 2:
            return @"https://a01mobileimage.sm830.com/";
            break;
        default:
            break;
    }
}

+ (NSString *)appKey {
    return @"A01FM";
}

+ (NSString *)appId {
    return @"A01APP02";
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

@end
