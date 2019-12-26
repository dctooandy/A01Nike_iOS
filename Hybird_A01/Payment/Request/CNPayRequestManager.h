//
//  CNPayRequestManager.h
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNPayWriteModel.h"


@class CNPayOrderModel;

/// 预设支付方式总个数
extern NSInteger const kPayTypeTotalCount;

@interface CNPayRequestManager : NSObject

/**
 总接口，查询支付方式是否可用及支付数据
 
 @param completeHandler 访问回调
 */
+ (void)queryAllChannelCompleteHandler:(IVRequestCallBack)completeHandler;


/**
 在线支付接口: app 支付，快速支付, 扫码支付，条码支付，在线支付
 
 @param type        支付类型
 @param payId       接口返回
 @param amout       支付金额
 @param bankCode    支付银行卡的bankCode，只有网银在线支付 online-1 需要传
 @param completeHandler 接口回调
 */

+ (void)paymentWithPayType:(NSString *)type payId:(NSInteger)payId amount:(NSString *)amout bankCode:(NSString *)bankCode completeHandler:(IVRequestCallBack)completeHandler;


/**
 手工存款 获取历史存款人姓名
 
 @param isDeposit       手工存款或BQ存款
 @param completeHandler 接口回调
 */
+ (void)paymentGetDepositNameWithType:(BOOL)isDeposit CompleteHandler:(IVRequestCallBack)completeHandler;

/**
 手工存款 删除历史存款人姓名
 
 @param requestId       编号
 @param completeHandler 接口回调
 */
+ (void)paymentDeleteDepositNameWithId:(NSString *)requestId  CompleteHandler:(IVRequestCallBack)completeHandler;

/**
 手工存款第一步 和 BQ存款第一步 获取银行卡列表
 
 @param isDeposit       手工存款或BQ存款
 @param depositor       存款人
 @param referenceId     获取存款人姓名接口返回
 @param completeHandler 接口回调
 */
//+ (void)paymentGetBankListWithType:(BOOL)isDeposit depositor:(NSString *)depositor referenceId:(NSString *)referenceId completeHandler:(IVRequestCallBack)completeHandler;
+ (void)paymentGetBankListWithType:(BOOL)isDeposit
                         depositor:(NSString *)depositor
                       referenceId:(NSString *)referenceId
                         BQPayType:(NSInteger)bqPayType
                   completeHandler:(IVRequestCallBack)completeHandler;

/**
 手工存款查询未处理提案
 
 @param completeHandler 接口回调
 */
+ (void)paymentQueryBillCompleteHandler:(IVRequestCallBack)completeHandler;

/**
 手工存款第三步 创建手工存款提案
 
 @param infoModel   用户填写的信息
 @param completeHandler 接口回调
 */
+ (void)paymentCreateManualWithWriteInfo:(CNPayWriteModel *)infoModel completeHandler:(IVRequestCallBack)completeHandler;



/**
 BQ提交订单后获取收款银行卡详细信息
 
 @param infoModel    用户第一步填写的信息
 @param completeHandler 接口回调
 */
+ (void)paymentSubmitBill:(CNPayWriteModel *)infoModel completeHandler:(IVRequestCallBack)completeHandler;


/**
 点卡递交订单

 @param cardModel      点卡相关信息模型
 @param completeHandler 接口回调
 */
+ (void)paymentCardPay:(CNPayCardModel *)cardModel completeHandler:(IVRequestCallBack)completeHandler;


/**
 支付form表单提交
 
 @param model      订单支付模型
 */
+ (NSString *)submitPayFormWithOrderModel:(CNPayOrderModel *)model;


/**
 完善用户信息
 
 @param name    真实姓名
 @param message  预留信息
 @param completeHandler 接口回调
 */
+ (void)paymentCompleteUserName:(NSString *)name preSet:(NSString *)message completeHandler:(IVRequestCallBack)completeHandler;

/// 获取USDT汇率
/// @param completeHandler 接口回调
+ (void)getUSDTRateWithAmount:(NSString *)amount tradeType:(NSString *)tradeType target:(NSString *)target completeHandler:(IVRequestCallBack)completeHandler;


/// 获取USDT支付方式
/// @param completeHandler 接口回调
+ (void)getUsdtPayTypeWithCompleteHandler:(IVRequestCallBack)completeHandler;


/// usdt线上银行普通支付
/// @param type 类型 31-MOBI 其他25
/// @param amount 金额
/// @param completeHandler 接口回调
+ (void)usdtPayOnlineHandleWithType:(NSString *)type amount:(NSString *)amount completeHandler:(IVRequestCallBack)completeHandler;

/// usdt手工银行普通支付
/// @param bankAccountNo 银行账号
/// @param amount 金额
/// @param remark 备注
/// @param completeHandler 接口回调
+ (void)usdtManualPayHandleWithBankAccountNo:(NSString *)bankAccountNo amount:(NSString *)amount remark:(NSString *)remark completeHandler:(IVRequestCallBack)completeHandler;

@end

