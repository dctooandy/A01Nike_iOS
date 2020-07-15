//
//  BTTBankModel.h
//  Hybird_A01
//
//  Created by Key on 2018/11/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTTBankModel : BTTBaseModel
/** 银行名称 */
@property (copy, nonatomic) NSString *bankName;
/** 支行银行名称 */
@property (copy, nonatomic) NSString *bankBranchName;
/** 银行类型(借记卡/比特币) */
@property (copy, nonatomic) NSString *accountType;
/** 银行账户 */
@property (copy, nonatomic) NSString *accountNo;
/** 账户持卡人名字 */
@property (copy, nonatomic) NSString *bankAccountName;
/** 是否默认银行卡 YES 是 */
@property (assign, nonatomic) BOOL isDefault;
/** 0 银行，1 比特币,3 USDT钱包 */
@property (assign, nonatomic) NSInteger cardType;
/** 9 正在审核 */
@property (assign, nonatomic) NSInteger flag;
/** 省份 */
@property (copy, nonatomic) NSString *province;
/** 城市 */
@property (copy, nonatomic) NSString *city;
/** 银行卡的id */
@property (copy, nonatomic) NSString *accountId;
/** 银行卡logo */
@property (copy, nonatomic) NSString *bankIcon;
/** 背景图 */
@property (copy, nonatomic) NSString *backgroundColor;
/** 比特币汇率 */
@property (copy, nonatomic) NSString *btcrate;
/** 比特币金额 */
@property (copy, nonatomic) NSString *btcamount;
/** 获取比特币汇率返回过来的 */
@property (copy, nonatomic) NSString *uuid;
/** 取款时选取控件显示的文字*/
@property(copy, nonatomic) NSString *withdrawText;

@property(copy, nonatomic) NSString *protocol;

@property(copy, nonatomic) NSString *isOpen;
@end
