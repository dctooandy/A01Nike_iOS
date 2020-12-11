//
//  IVNetworkManager.h
//  Hybird_1e3c3b
//
//  Created by Levy on 1/2/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IVNetworkManager : NSObject

/**
 登录用户信息
 */
@property(nonatomic, strong)IVUserInfoModel *userInfoModel;

/**
 单例
 */
+ (IVNetworkManager *)sharedInstance;

@end

NS_ASSUME_NONNULL_END
