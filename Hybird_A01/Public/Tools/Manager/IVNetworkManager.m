//
//  IVNetworkManager.m
//  Hybird_A01
//
//  Created by Levy on 1/2/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "IVNetworkManager.h"

@implementation IVNetworkManager

+ (IVNetworkManager *)sharedInstance
{
    static IVNetworkManager *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[super allocWithZone:NULL] init];
    });
    return shareManager;
}

- (IVUserInfoModel *)userInfoModel
{
    //从内存中取
    NSDictionary *json = [IVCacheWrapper objectForKey:@"customer"];
    if (json==nil) {
        return nil;
    }
    _userInfoModel = [[IVUserInfoModel alloc]initWithDictionary:json error:nil];
    return _userInfoModel;
}

@end
