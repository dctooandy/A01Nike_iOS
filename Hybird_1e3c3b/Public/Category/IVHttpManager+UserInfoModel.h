//
//  IVHttpManager+UserInfoModel.h
//  Hybird_A01
//
//  Created by Domino on 17/10/2019.
//  Copyright © 2019 BTT. All rights reserved.
//


#import "IVHttpManager.h"
#import "BTTUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IVHttpManager (UserInfoModel)

@property (nonatomic, strong) BTTUserInfoModel *userInfoModel;

@property (nonatomic, copy) NSString *appToken;

@end

NS_ASSUME_NONNULL_END
