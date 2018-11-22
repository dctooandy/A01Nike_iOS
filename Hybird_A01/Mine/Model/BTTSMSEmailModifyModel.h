//
//  BTTSMSEmailModifyModel.h
//  Hybird_A01
//
//  Created by Domino on 22/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTSMSEmailModifyModel : BTTBaseModel

@property (nonatomic, assign) BOOL modify_account_name; ///< 资料变更

@property (nonatomic, assign) BOOL modify_banking_data; ///< 银行卡变更

@property (nonatomic, assign) BOOL modify_password;     ///< 密码变更

@property (nonatomic, assign) BOOL modify_phone;        ///< 手机号变更

@property (nonatomic, assign) BOOL new_payment_account; ///< 收款账号变更

@property (nonatomic, assign) BOOL new_website;         ///< 网站域名变更

@property (nonatomic, assign) BOOL noble_metal;         ///<

@property (nonatomic, assign) BOOL notify_promotions;   ///< 优惠活动通知

@property (nonatomic, assign) BOOL promotions;          ///<

@property (nonatomic, assign) BOOL regards;             ///<

@property (nonatomic, assign) BOOL specific_msg;        ///<

@property (nonatomic, assign) BOOL withdrawal;          ///<

@property (nonatomic, assign) BOOL login;               ///<

@property (nonatomic, assign) BOOL deposit;             ///<

@property (nonatomic, assign) BOOL forex;               ///<

@end

NS_ASSUME_NONNULL_END
