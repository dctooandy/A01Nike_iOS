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
            return @[@"http://a01nike.gateway.com"];
//            return @[@"http://10.71.12.105:81"];
        case 1:
            return @[@"http://a01gatewaynew.bawinx.com/",@"http://a01gatewayfresh.bawinx.com/"];
        default:
            return @[@"https://a01.gatewayphp.net:9443/",@"https://a01.gatewayphp.com:9443/",@"https://a01.gateway-api.net/"];
    }
}

+ (NSString *)defaultH5Domain {
    switch (EnvirmentType) {
        case 0:
            return @"http://m.a01.com";
            break;
        case 1:
            return @"https://m.918rr.com";
            break;
        case 2:
            return @"https://m.918bs.com";
            break;
        default:
            break;
    }
}

+ (NSString *)defaultCDN {
    switch (EnvirmentType) {
        case 0:
            return @"http://m.a01.com";
            break;
        case 1:
            return @"https://m.918rr.com";
            break;
        case 2:
            return @"https://m.918bs.com";
            break;
        default:
            break;
    }
}

+ (NSString *)appKey {
    switch (EnvirmentType) {
        case 0:
            return @"2ohcxmpyamvnid01au4vfvnf6tnubuar";
        default:
            return @"dxobhchquwgoatvqn96l2mimq2nemjug";
    }
}

+ (NSString *)appId {
    return @"fby8beji7lesmooeh54m28l1u09ymmkb";
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
