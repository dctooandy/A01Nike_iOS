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
    CNPaymentOnline=1,
    /// 点卡
    CNPaymentCard=2,
    /// 手工存款
    CNPaymentDeposit=0,
    /// 比特币支付
    CNPaymentBTC=20,
    /// 微信条码
    CNPaymentWechatBarCode=23,
    /// 钻石币支付
    CNPaymentCoin=41,
    
    
    /// app
    CNPaymentWechatApp=8,//微信wap
    CNPaymentAliApp=9,//支付宝wap
    CNPaymentQQApp=11,//qqwap
    CNPaymentYSFQR=27,//云闪付扫码,
    CNPaymentUnionApp,//银联wap
    CNPaymentJDApp=17,//京东wap
    
    /// 扫码
    CNPaymentAliQR=5,//支付宝扫码
    CNPaymentWechatQR=6,//微信扫码
    CNPaymentQQQR=7,//qq扫码
    CNPaymentUnionQR=15,//银联扫码
    CNPaymentJDQR=16,//京东扫码
    CNPaymentBQFast=90,//迅捷网银
    CNPaymentBQWechat=91,//微信秒存
    CNPaymentBQAli=92,//支付宝秒存
    CNPaymentBS=25, ///< 币商
    CNPaymentUSDT=99//USDT
};

@interface CNPaymentModel : BTTBaseModel
/// 定义的具体支付方式 0:手工存款 99:USDT存款 100:币商 9:支付宝wap 5:支付宝扫码 92:支付宝秒存 91:微信秒存 6：微信扫码 23:微信条码  90：迅捷网银 19:银行快捷网银 15:银联扫码 25:虚拟币支付 16:京东扫码 27：云闪付 
@property (nonatomic, assign) NSInteger payType;
/// 支付方式标题
@property (nonatomic, copy) NSString *payTypeName;
/// 支付方式logo
@property (nonatomic, copy) NSString *payTypeIcon;
/// 支付类型
@property (nonatomic, strong) NSDictionary *payTypeTipJson;

@property (nonatomic, strong) NSArray *extras;

@property (nonatomic, assign) NSInteger csr;

@property (nonatomic, assign) NSInteger minAmount;

@property (nonatomic, assign) NSInteger maxAmount;

@end
