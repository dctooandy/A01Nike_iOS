//
//  CNPaymentModel.h
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "JSONModel.h"
#import "CNPayBankCardModel.h"
#import "CNPayCardModel.h"

/// 支付方式
typedef NS_ENUM(NSUInteger, CNPaymentType) {
    /// 在线支付
    CNPaymentOnline,
    /// 点卡
    CNPaymentCard,
    /// 手工存款
    CNPaymentDeposit,
    /// 比特币支付
    CNPaymentBTC,
    /// 微信条码
    CNPaymentWechatBarCode,
    /// 钻石币支付
    CNPaymentCoin,
    
    
    /// app
    CNPaymentWechatApp,
    CNPaymentAliApp,
    CNPaymentQQApp,
    CNPaymentYSFQR,
    CNPaymentUnionApp,
    CNPaymentJDApp,
    
    /// 扫码
    CNPaymentAliQR,
    CNPaymentWechatQR,
    CNPaymentQQQR,
    CNPaymentUnionQR,
    CNPaymentJDQR,
    
    /// BQ存款 bypaytype-0,1,2
    CNPaymentBQFast,
    CNPaymentBQWechat,
    CNPaymentBQAli,
    
    CNPaymentBS ///< 币商
};

@interface CNPaymentModel : BTTBaseModel
/// 定义的具体支付方式
@property (nonatomic, assign) NSInteger payType;
/// 支付方式标题
@property (nonatomic, copy) NSString *payTypeName;
/// 支付方式logo
@property (nonatomic, copy) NSString *payTypeIcon;
/// 支付类型
@property (nonatomic, strong) NSDictionary *payTypeTipJson;

@property (nonatomic, strong) NSArray *extras;

@property (nonatomic, assign) NSInteger csr;

@end
