//
//  CNPayChannelModel.h
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNPaymentModel.h"

/// 支付渠道
typedef NS_ENUM(NSUInteger, CNPayChannel) {
    /// 在线支付
    CNPayChannelOnline,
    /// 点卡
    CNPayChannelCard,
    /// 手工存款
    CNPayChannelDeposit,
    /// 比特币支付
    CNPayChannelBTC,
    /// 微信条码
    CNPayChannelWechatBarCode,
    /// 钻石币支付
    CNPayChannelCoin,
    
    /// app
//    CNPayChannelWechatApp,
//    CNPayChannelQQApp,
    CNPayChannelUnionApp,
    CNPayChannelWechatQQJDAPP,  ///< WechatQQJD 三种支付合用
    CNPayChannelAliApp,

//    CNPayChannelJDApp,
    
    /// 扫码
    CNPayChannelQR,
    CNPayChannelWechatQR,
    CNPayChannelAliQR,
    CNPayChannelQQQR,
    CNPayChannelUnionQR,
    CNPayChannelJDQR,
    CNPayChannelYSFQR,
    
    /// BQ存款
    CNPayChannelBQFast,
    CNPayChannelBQWechat,
    CNPayChannelBQAli,
//    CNPayChannelAli, ///< 支付宝
//    CNPayChannelWechat, ///< 微信
//    CNPayChannelBankCard, ///< 银行卡
//    CNPayChannelQQ,     ///< QQ
//    CNPayChannelJD      ///< 京东
    CNPayChannelBS,   ///< 币商
    
    ///USDT
    CNPayChannelUSDT,
    
};

@interface CNPayChannelModel : NSObject

/** 渠道类型 */
@property (nonatomic, assign) CNPayChannel payChannel;

/** 渠道名称 */
@property (nonatomic, copy, readonly) NSString *channelName;

/** 渠道选中图标名称  */
@property (nonatomic, copy, readonly) NSString *selectedIcon;

/** Channel 是否可用 */
@property (nonatomic, assign, readonly) BOOL isAvailable;

/** 渠道下面的支付方式 */
@property (nonatomic, copy) NSArray<CNPaymentModel *> *payments;

@end
