//
//  CNPayConstant.m
//  B01_iPhone
//
//  Created by cean.q on 2018/9/29.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayConstant.h"

#pragma mark - 支付

/// 查询存款方式
NSString * const kPaymentValidate       = @"public/payment/isShutdown";
/// 支付接口（app支付...）
NSString * const kPaymentOnlinePay      = @"public/payment/onlinePay";
/// 网银快速充值，线下存款，微信支付生成订单
NSString * const kPaymentOfflinePayBill = @"B01/payment/quickBankPay";
/// 创建手工存款提案
NSString * const kPaymentDepositPay     = @"B01/deposit/createManual";
/// 手工存款获取历史存款人姓名
NSString * const kPaymentGetDepositName = @"B01/deposit/getManualDeposit";
/// BQ存款获取历史存款人姓名
NSString * const kPaymentGetBQName      = @"B01/payment/getQuickBankDeposit";
/// 查询银行信息
NSString * const kPaymentQueryBankInfo  = @"public/payment/quickBankList";
/// 获取手工存款银行卡
NSString * const kPaymentGetBankList    = @"public/deposit/getEnableBank";
/// 完善用户信息
NSString * const kPaymentCompleteInfo   = @"public/users/completeInfo";
/// 点卡提交订单
NSString * const kPaymentCardPay        = @"public/payment/cardPay";
@implementation CNPayConstant

@end
