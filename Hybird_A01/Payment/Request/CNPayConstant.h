//
//  CNPayConstant.h
//  A05_iPhone
//
//  Created by cean.q on 2018/9/29.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 查询存款方式
extern NSString * const kPaymentValidate;
/// 支付接口
extern NSString * const kPaymentOnlinePay;
/// 网银快速充值，线下存款，微信支付生成订单
extern NSString * const kPaymentOfflinePayBill;
/// 创建手工存款提案
extern NSString * const kPaymentDepositPay;
/// 手工存款获取历史存款人姓名
extern NSString * const kPaymentGetDepositName;
/// 删除手工存款历史存款人姓名
extern NSString * const kPaymentDeleteDepositName;
/// BQ存款获取历史存款人姓名
extern NSString * const kPaymentGetBQName;
/// 查询银行信息
extern NSString * const kPaymentQueryBankInfo;
/// 获取手工存款银行卡
extern NSString * const kPaymentGetBankList;
/// 查询提案
extern NSString * const kPaymentQueryDeposit;
/// 完善用户信息
extern NSString * const kPaymentCompleteInfo;
/// 点卡提交订单
extern NSString * const kPaymentCardPay;

#define COLOR_HEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0    \
blue:((float)(rgbValue & 0xFF))/255.0             \
alpha:1.0]

#define kBlackBackgroundColor COLOR_HEX(0x212229)
#define kBlackForgroundColor  COLOR_RGBA(31, 34, 41, 1)
#define kBlackLightColor COLOR_RGBA(41, 45, 54, 1)
#define kTextPlaceHolderColor COLOR_RGBA(129, 135, 145,1)

@interface CNPayConstant : NSObject
@end
