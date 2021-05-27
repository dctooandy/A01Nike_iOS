//
//  CNPayWriteModel.h
//  A05_iPhone
//
//  Created by cean.q on 2018/10/4.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNPayBankCardModel.h"
#import "CNPayOrderModel.h"
#import "CNPayCardModel.h"
#import "CNPayOrderModelV2.h"

/// BQ转账支付类型，用于差异化UI
typedef NS_ENUM(NSUInteger, CNPayBQType) {
    /// 网银转账
    CNPayBQTypeBankUnion = 0,
    /// 微信转账
    CNPayBQTypeWechat,
    /// 支付宝转账
    CNPayBQTypeAli,
    /// 手机银行
    CNPayBQTypeWap,
    /// 其它方式转账
    CNPayBQTypeOther,
};


///存款填写的信息
@interface CNPayWriteModel : NSObject
/// 存款人
@property (nonatomic, copy) NSString *depositBy;
/// 存款金额
@property (nonatomic, copy) NSString *amount;
/// 汇款方式
@property (nonatomic, copy) NSString *depositType;
/// 汇款省份
@property (nonatomic, copy) NSString *provience;
/// 汇款城市
@property (nonatomic, copy) NSString *city;
/// 汇款时间
@property (nonatomic, copy) NSString *date;
/// 汇款收费
@property (nonatomic, copy) NSString *charge;
/// 备注
@property (nonatomic, copy) NSString *remarks;
/// 订单ID
@property (nonatomic, assign) NSInteger payId;
/// 从isShutdown获取
@property (nonatomic, copy) NSString *referenceId;
/// 要存入银行卡信息
@property (nonatomic, strong) CNPayBankCardModel *chooseBank;
/// 银行卡数组
@property (nonatomic, strong) NSArray <CNPayBankCardModel *> *bankList;

/// BQ支付方式
@property (nonatomic, assign) CNPayBQType BQType;

/// 订单信息
@property (nonatomic, strong) CNPayOrderModel *orderModel;

/// 订单信息
@property (nonatomic, strong) CNPayOrderModelV2 *orderModelV2;

/// 点卡信息
@property (nonatomic, strong) CNPayCardModel *cardModel;
@end
