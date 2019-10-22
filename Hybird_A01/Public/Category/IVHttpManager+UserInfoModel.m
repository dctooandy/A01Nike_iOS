//
//  IVHttpManager+UserInfoModel.m
//  Hybird_A01
//
//  Created by Domino on 17/10/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "IVHttpManager+UserInfoModel.h"

static const char *userInfoModelKey = "userInfoModel";
static const char *appTokenKey = "appTokenKey";



@implementation IVHttpManager (UserInfoModel)


- (NSString *)appToken {
    NSString *appToken = objc_getAssociatedObject(self, _cmd);
    if (!appToken.length) {
        appToken = [IVCacheWrapper readJSONStringForKey:kCacheAppToken requestId:nil];
    }
    return appToken;
}

- (void)setAppToken:(NSString *)appToken {
    
}



- (BTTUserInfoModel *)userInfoModel {
    BTTUserInfoModel *userInfoModel = objc_getAssociatedObject(self, _cmd);
    if (!userInfoModel) {
        userInfoModel = [BTTUserInfoModel yy_modelWithJSON:[IVCacheWrapper readJSONStringForKey:kCacheUserModel requestId:nil]];
        [self setUserInfoModel:userInfoModel];
    }
    return userInfoModel;
}

- (void)setUserInfoModel:(BTTUserInfoModel *)userInfoModel {
    objc_setAssociatedObject(self, &userInfoModelKey, userInfoModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
