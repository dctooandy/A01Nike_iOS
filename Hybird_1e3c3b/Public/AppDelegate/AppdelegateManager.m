//
//  AppdelegateManager.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/12/2.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "AppdelegateManager.h"
#import "AppInitializeConfig.h"
#import "IVCheckNetworkWrapper.h"
#import "HAInitConfig.h"
#import "BTTCheckDomainModel.h"

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
                return @[@"https://wrd.58baili.com/pro/_glaxy_1e3c3b_/", @"https://m.jkfjdfe.com:9188/_glaxy_1e3c3b_/", @"https://m.zncjdhvs.com:9188/_glaxy_1e3c3b_/", @"https://m.pkyorjhn.com:9188/_glaxy_1e3c3b_/"];
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
                return @[@"https://wrd.58baili.com/pro/"];
                break;
            default:
                return @[@"http://m.a01.com/"];
                break;
        }
    }
    return _websides;
}
- (void)checkDomainHandler:(void (^)(void))handler
{
    // 启动时先去访问接口
    [self recheckDomain:handler];
    //获取最优的网关
//    self.getSpeedestDomain = NO;
//    [self testSpeed:[IVHttpManager shareManager].gateways Handler:handler];
//    handler();
}
- (void)testSpeed:(NSArray*)domailArr Handler:(void (^)(void))handler
{
//    [IVCheckNetworkWrapper initSDK];
    //app有域名测速功能就使用，没有直接注释domainBakList赋值即可
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    for (NSString * str in domailArr) {
        if ([[str substringFromIndex:str.length-1] isEqualToString:@"/"]) {
            [arr addObject:str];
        } else {
            [arr addObject:[NSString stringWithFormat:@"%@/", str]];
        }
    }
    //...测速代码，速度从快到慢
    weakSelf(weakSelf)
    [IVCheckNetworkWrapper getOptimizeUrlWithArray:[IVHttpManager shareManager].gateways
                                            isAuto:YES
                                              type:IVKCheckNetworkTypeGateway
                                          progress:^(IVCheckDetailModel * _Nonnull respone) {
        [weakSelf checkProgressWithTableViewWithRespone:respone Handler:handler];
    }
                                        completion:^(IVCheckDetailModel * _Nonnull model) {

    }];
}
- (void)checkProgressWithTableViewWithRespone:(IVCheckDetailModel *)respone Handler:(void (^)(void))handler
{
    NSInteger index = 0;
    BOOL exit = NO;
    weakSelf(weakSelf)
    for (NSString *domainString in [IVHttpManager shareManager].gateways) {
        NSInteger i = [[IVHttpManager shareManager].gateways indexOfObject:domainString];
        NSURL *url = [NSURL URLWithString:domainString];
        NSURL *url1 = [NSURL URLWithString:respone.url];
        if ([url.host isEqualToString:url1.host] ) {
            if (weakSelf.getSpeedestDomain == NO)
            {
                weakSelf.getSpeedestDomain = YES;
                index = i;
                exit = YES;
            }
        }
    }
    if (exit) {
        [[IVHttpManager shareManager] setGateway:[IVHttpManager shareManager].gateways[index]];
        handler();
    }else
    {
        if (self.getSpeedestDomain == NO)
        {
            [[AppdelegateManager shareManager] setGateways:nil];
            [[AppdelegateManager shareManager] setWebsides:nil];
            [IVCacheWrapper setObject:nil forKey:IVCacheAllGatewayKey];
            [IVCacheWrapper setObject:nil forKey:IVCacheAllH5DomainsKey];
            [self recheckDomain:handler];
        }
    }
}
- (void)recheckDomain:(void (^)(void))handler  {
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [IVHttpManager shareManager].appId = [HAInitConfig appId];     // 应用ID
    [IVHttpManager shareManager].productId = [HAInitConfig productId]; // 产品标识
    [IVHttpManager shareManager].isSensitive = YES;
    [IVHttpManager shareManager].gateways = [HAInitConfig gateways];  // 网关列表
    params[@"productId"] = [IVHttpManager shareManager].productId;
    params[@"productCodeExt"] = @"FM";
    params[@"productCode"] = @"";
    [IVNetwork requestPostWithUrl:BTTAppSetting paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTCheckDomainModel *model = [BTTCheckDomainModel yy_modelWithDictionary:result.body];
            NSMutableArray * tempGetArr = [NSMutableArray new];
            NSMutableArray * tempWebArr = [NSMutableArray new];
            for (NSString *getway in model.getways) {
                if ([[getway substringFromIndex:getway.length-1] isEqualToString:@"/"]) {
                    [tempGetArr addObject:[NSString stringWithFormat:@"%@_glaxy_1e3c3b_/", getway]];
                } else {
                    [tempGetArr addObject:[NSString stringWithFormat:@"%@/_glaxy_1e3c3b_/", getway]];
                }
            }
           
            for (NSString *websit in model.websides) {
                if ([[websit substringFromIndex:websit.length-1] isEqualToString:@"/"]) {
                    [tempWebArr addObject:websit];
                } else {
                    [tempWebArr addObject:[NSString stringWithFormat:@"%@/", websit]];
                }
            }
            [[AppdelegateManager shareManager] setGateways:tempGetArr];
            [[AppdelegateManager shareManager] setWebsides:tempWebArr];
        }else
        {
            [[AppdelegateManager shareManager] setGateways:nil];
            [[AppdelegateManager shareManager] setWebsides:nil];
        }
        [IVHttpManager shareManager].gateways = [HAInitConfig gateways];  // 网关列表
        [IVHttpManager shareManager].domains = [HAInitConfig websides];
        handler();
    }];
}
- (void)recheckDomainWithTestSpeed
{
    NSMutableDictionary *params = @{}.mutableCopy;
    [IVHttpManager shareManager].appId = [HAInitConfig appId];     // 应用ID
    [IVHttpManager shareManager].productId = [HAInitConfig productId]; // 产品标识
    [IVHttpManager shareManager].isSensitive = YES;
    [IVHttpManager shareManager].gateways = [HAInitConfig gateways];  // 网关列表
    params[@"productId"] = [IVHttpManager shareManager].productId;
    params[@"productCodeExt"] = @"FM";
    params[@"productCode"] = @"";
    [IVNetwork requestPostWithUrl:BTTAppSetting paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTCheckDomainModel *model = [BTTCheckDomainModel yy_modelWithDictionary:result.body];
            NSMutableArray * tempGetArr = [NSMutableArray new];
            NSMutableArray * tempWebArr = [NSMutableArray new];
            for (NSString *getway in model.getways) {
                if ([[getway substringFromIndex:getway.length-1] isEqualToString:@"/"]) {
                    [tempGetArr addObject:[NSString stringWithFormat:@"%@_glaxy_1e3c3b_/", getway]];
                } else {
                    [tempGetArr addObject:[NSString stringWithFormat:@"%@/_glaxy_1e3c3b_/", getway]];
                }
            }
           
            for (NSString *websit in model.websides) {
                if ([[websit substringFromIndex:websit.length-1] isEqualToString:@"/"]) {
                    [tempWebArr addObject:websit];
                } else {
                    [tempWebArr addObject:[NSString stringWithFormat:@"%@/", websit]];
                }
            }
            [[AppdelegateManager shareManager] setGateways:tempGetArr];
            [[AppdelegateManager shareManager] setWebsides:tempWebArr];
        }else
        {
            [[AppdelegateManager shareManager] setGateways:nil];
            [[AppdelegateManager shareManager] setWebsides:nil];
        }
        [IVHttpManager shareManager].gateways = [HAInitConfig gateways];  // 网关列表
        [IVHttpManager shareManager].domains = [HAInitConfig websides];
        [IVCheckNetworkWrapper getOptimizeUrlWithArray:[IVHttpManager shareManager].gateways
                                                isAuto:YES
                                                  type:IVKCheckNetworkTypeGateway
                                              progress:nil completion:nil];
    }];
}
@end
