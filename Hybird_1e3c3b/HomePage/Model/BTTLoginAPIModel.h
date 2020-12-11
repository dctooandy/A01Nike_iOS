//
//  BTTLoginAPIModel.h
//  Hybird_1e3c3b
//
//  Created by Domino on 14/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTLoginAPIModel : BTTBaseModel

@property (nonatomic, copy) NSString *login_name; ///< 会员登录名 (必选)

@property (nonatomic, copy) NSString *password;   ///< 会员登录密码 (必选)

@property (nonatomic, copy) NSString *app_token;  ///< 会话token (必选)

@property (nonatomic, copy) NSString *signature;  ///< 签名 通过获取userToken签名接口返回的签名 (必选)

@property (nonatomic, copy) NSString *timestamp;  ///< 时间戳 (必选)

@property (nonatomic, copy) NSString *device_id;  ///< json格式 (必选) {"device_id":"wasfsfsfdsfsdgsdgdsgsdgsdfsf"}

@property (nonatomic, copy) NSString *code;       ///< 验证码 (选填)

@property (nonatomic, copy) NSString *sms_code;   ///< 手机验证码
@end

NS_ASSUME_NONNULL_END
