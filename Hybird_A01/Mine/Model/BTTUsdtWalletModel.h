//
//  BTTUsdtWalletModel.h
//  Hybird_A01
//
//  Created by Levy on 1/9/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTUsdtWalletModel : BTTBaseModel
//{
//    "provinces" : "海南",
//    "cuslevel" : "-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51",
//    "isshow" : "1",
//    "bankaccountname" : "Coincola",
//    "payType" : "25",
//    "currency" : "USDT",
//    "bankprovince" : "海南",
//    "retelling" : "37887",
//    "flag" : "1",
//    "bankIcon" : "/cdn/A01FM/externals/_wms/img/bank_icons/coincola.png",
//    "bankcity" : "海口",
//    "id" : "2806501759",
//    "token" : "",
//    "grade" : "-20,-19,-18,-17,-16,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21",
//    "payCategory" : "3",
//    "bankaccountno" : "",
//    "limitamount" : "999999999999",
//    "bankcode" : "coincola",
//    "product" : "A01",
//    "depositamount" : "0",
//    "timestamp" : "1578547089024",
//    "isRecommendWallet" : 0,
//    "bankname" : "coincola",
//    "rate" : "5.6456",
//    "bqpaytype" : "2",
//    "pxh" : 0,
//    "bankaddress" : "海南0001"
//},
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *cuslevel;
@property (nonatomic, copy) NSString *isShow;
@property (nonatomic, copy) NSString *bankaccountname;
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *bankprovince;
@property (nonatomic, copy) NSString *retelling;
@property (nonatomic, copy) NSString *flag;
@property (nonatomic, copy) NSString *bankIcon;
@property (nonatomic, copy) NSString *bankcity;
@property (nonatomic, copy) NSString *wid;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *payCategory;
@property (nonatomic, copy) NSString *bankaccountno;
@property (nonatomic, copy) NSString *limitamount;
@property (nonatomic, copy) NSString *bankcode;
@property (nonatomic, copy) NSString *product;
@property (nonatomic, copy) NSString *depositamount;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, assign) NSInteger isRecommendWallet;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *bqpaytype;
@property (nonatomic, assign) NSInteger pxh;
@property (nonatomic, copy) NSString *bankaddress;
@property (nonatomic, copy) NSString *minAmount;
@property (nonatomic, copy) NSString *maxAmount;
@property (nonatomic, copy) NSString *usdtProtocol;
@end

NS_ASSUME_NONNULL_END
