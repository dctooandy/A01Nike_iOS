//
//  BTTRequestPrecache.m
//  Hybird_A01
//
//  Created by Key on 2018/11/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTRequestPrecache.h"
#import "BTTHttpManager.h"
@implementation BTTRequestPrecache
+ (void)startUpdateCache
{
    [self updateCacheNormal];
    [self updateCacheNeedLoginRequest];
}
+ (void)updateCacheNormal
{
    
}
+ (void)updateCacheNeedLoginRequest
{
    if (![IVNetwork userInfo]) {
        return;
    }
    [BTTHttpManager fetchUserInfoCompleteBlock:nil];
    [BTTHttpManager fetchBTCRateWithUseCache:NO];
    [BTTHttpManager fetchBindStatusWithUseCache:NO completionBlock:nil];
    [BTTHttpManager fetchBankListWithUseCache:NO completion:nil];
}
@end
