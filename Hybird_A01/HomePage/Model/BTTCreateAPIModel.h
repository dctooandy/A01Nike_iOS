//
//  BTTCreateAPIModel.h
//  Hybird_A01
//
//  Created by Domino on 14/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTCreateAPIModel : BTTBaseModel

@property (nonatomic, copy) NSString *login_name; ///< 会员登录名 (必选)

@property (nonatomic, copy) NSString *password;   ///< 会员登录密码 (必选)

@property (nonatomic, copy) NSString *phone;      ///< 手机号    (必选)

@property (nonatomic, copy) NSString *parent_id;  ///< 渠道号 (必选)

@property (nonatomic, copy) NSString *catpcha;    ///< 验证码 (必选)

@property (nonatomic, copy) NSString *verify_code;///< 手机验证码



@end

NS_ASSUME_NONNULL_END
