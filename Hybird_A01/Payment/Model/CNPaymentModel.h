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
    /// 币宝支付
    CNPaymentCoin,
    
    
    /// app
    CNPaymentWechatApp,
    CNPaymentAliApp,
    CNPaymentQQApp,
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
};

@interface CNPaymentModel : JSONModel
/// 定义的具体支付方式
@property (nonatomic, assign) CNPaymentType paymentType;
/// 支付方式标题
@property (nonatomic, copy, readonly) NSString<Ignore> *paymentTitle;
/// 支付方式logo
@property (nonatomic, copy, readonly) NSString<Ignore> *paymentLogo;

/// 支付方式是否可用
@property (nonatomic, assign) BOOL isAvailable;
@property (nonatomic, copy)  NSArray <NSString *> *amountList;
@property (nonatomic, assign) double maxamount;
@property (nonatomic, assign) double minamount;
@property (nonatomic, assign) NSInteger payid;
@property (nonatomic, copy) NSArray <CNPayBankCardModel> *bankList;

#pragma mark - 点卡
@property (nonatomic, copy) NSArray <CNPayCardModel> *cardList;
@property (nonatomic, copy) NSString *postUrl;

/// 推荐金额
- (NSArray<NSNumber *> *)prePayAmountArray;
/// 支付方式
- (NSArray<NSString *> *)payTypeArray;
@end
