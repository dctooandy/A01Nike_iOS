//
//  AppdelegateManager.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/12/2.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "AppdelegateManager.h"
#import "AppInitializeConfig.h"

@implementation AppdelegateManager
@synthesize gateways = _gateways;
@synthesize websides = _websides;
+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static AppdelegateManager *_manager = nil;
    dispatch_once(&onceToken, ^{
        _manager = [[AppdelegateManager alloc] init];
    });
    return _manager;
}
- (void)setGateways:(NSArray *)gateways
{
    _gateways = gateways;
}
- (NSArray *)gateways
{
    if (!_gateways) {
        switch (EnvirmentType) {
            case 0:
                return @[@"http://www.pt-gateway.com/_glaxy_1e3c3b_/"];
                break;
            case 1:
                return @[@"http://fm.918rr.com/_glaxy_1e3c3b_/"];
                break;
            case 2:
                return @[@"https://m.c349b2.com:9188/_glaxy_1e3c3b_/", @"https://918xxs.com/_glaxy_1e3c3b_/", @"https://918ykk.com/_glaxy_1e3c3b_/", @"https://918ygg.com/_glaxy_1e3c3b_/", @"https://918yjj.com/_glaxy_1e3c3b_/", @"https://918yvv.com/_glaxy_1e3c3b_/", @"https://918yuu.com/_glaxy_1e3c3b_/"];
                break;
            default:
                return @[@"http://www.pt-gateway.com/_glaxy_1e3c3b_/"];
                break;
        }
    }
    return _gateways;
}
- (void)setWebsides:(NSArray *)websides
{
    _websides = websides;
}
- (NSArray *)websides
{
    if (!_websides)
    {
        switch (EnvirmentType) {
            case 0:
                return @[@"http://m.a01.com/"];
                break;
            case 1:
                return @[@"http://fm.918rr.com/"];
                break;
            case 2:
                return @[@"https://918yuu.com/"];
                break;
            default:
                return @[@"http://m.a01.com/"];
                break;
        }
    }
    return _websides;
}
@end
