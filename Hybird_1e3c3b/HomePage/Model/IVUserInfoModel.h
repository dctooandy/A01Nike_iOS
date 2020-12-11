//
//  IVUserInfoModel.h
//  Hybird_1e3c3b
//
//  Created by Levy on 12/20/19.
//  Copyright © 2019 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface IVUserInfoModel : JSONModel
/**usertoken*/
@property (nonatomic, strong) NSString  *userToken;
/**用户名*/
@property (nonatomic, strong) NSString  *loginName;
/** userid */
@property (nonatomic, assign) NSInteger customerId;
/** vip等级 */
@property (nonatomic, assign) NSInteger starLevel;
/** 绑定的手机号 */
@property (nonatomic, strong) NSString  *phone;
/** 绑定手机的地区号 */
@property (nonatomic, strong) NSString  *phone_prefix;
/** 登录后返回的pwd */
@property (copy, nonatomic) NSString *pwd;
/** 预留信息 */
@property (nonatomic, copy) NSString *verify_code;
/** 真实姓名 */
@property (copy, nonatomic) NSString *real_name;
/** 性别 */
@property (copy, nonatomic) NSString *sex;
/** 出生日期(没有时分秒) */
@property (copy, nonatomic) NSString *birthday;
/** 邮箱 */
@property (copy, nonatomic) NSString *email;
/** 备注 */
@property (copy, nonatomic) NSString *remarks;
/** 地址 */
@property (copy, nonatomic) NSString *address;
/** 最后登录时间 */
@property (copy, nonatomic) NSString *last_login_date;
/** 创建时间 */
@property (copy, nonatomic) NSString *created_date;
/**  */
@property (copy, nonatomic) NSString *before_login_date;
/** 首次存款时间 */
@property (copy, nonatomic) NSString *first_deposit_date;
/** 最后一次存款时间 */
@property (copy, nonatomic) NSString *last_deposit_date;
/** 存款等级 */
@property (assign, nonatomic) NSInteger deposit_level;
/** 首次投注时间 */
@property (copy, nonatomic) NSString *first_bet_time;
/** 最后一次投注时间 */
@property (copy, nonatomic) NSString *last_bet_date;
/** */
@property (copy, nonatomic) NSString *channel;
/** 是否已绑定手机 */
@property (assign, nonatomic) BOOL isPhoneBinded;
/** 是否已绑定邮箱 */
@property (assign, nonatomic) BOOL isEmailBinded;
/** 是否已绑定银行卡 */
@property (assign, nonatomic) BOOL isBankBinded;
/** 是否已绑定比特比钱包 */
@property (assign, nonatomic) BOOL isBtcBinded;
/** 最大优惠id */
@property (copy, nonatomic) NSString *max_promo_id;
/** md5值 校验发现有无更新 */
@property (copy, nonatomic) NSString *max_discover_id;
/** 扩展信息1 */
@property (copy, nonatomic) NSString *exteranl1;
/** 扩展信息2 */
@property (copy, nonatomic) NSString *exteranl2;
/** 扩展信息3 */
@property (copy, nonatomic) NSString *exteranl3;
/** A01增加的字段 */
@property (copy, nonatomic) NSString *domain_name;
@end


NS_ASSUME_NONNULL_END
