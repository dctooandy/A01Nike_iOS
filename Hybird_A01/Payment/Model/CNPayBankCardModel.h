//
//  CNPayBankCardModel.h
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "JSONModel.h"

@protocol CNPayBankCardModel
@end

@interface CNPayBankCardModel : JSONModel
@property(nonatomic, copy) NSString *bankname;
@property(nonatomic, copy) NSString *bankcode;
@property(nonatomic, copy) NSString *banklogo;
@property(nonatomic, copy) NSString *bankimage;
@property(nonatomic, copy) NSString *url;



/*
 "id" : "239957",
 "cus_level" : "111111110000000000000000000",
 "last_depost_flag" : "0",
 "bank_name" : "交通银行",
 "bank_account_code" : "BCM",
 "bank_account_no" : "987632254122",
 "province" : "甘肃省",
 "trust_level" : "00001110111100000000000",
 "bank_city" : "白银市",
 "bank_account_name" : "()",
 "bank_show" : "",
 "is_show" : "0",
 "branch_name" : "白银测试分行",
 "limit_amount" : "10000000",
 "deposit_amount" : "107300",
 "currency" : "CNY"
 */

// 获取银行卡列表
@property(nonatomic, copy) NSString *bank_account_code;
@property(nonatomic, copy) NSString *bank_name;
@property(nonatomic, copy) NSString *bankId;
@property(nonatomic, copy) NSString *cus_level;
@property(nonatomic, copy) NSString *last_depost_flag;
@property(nonatomic, copy) NSString *bank_account_no;
@property(nonatomic, copy) NSString *province;
@property(nonatomic, copy) NSString *trust_level;
@property(nonatomic, copy) NSString *bank_city;
@property(nonatomic, copy) NSString *bank_account_name;
@property(nonatomic, copy) NSString *bank_show;
@property(nonatomic, assign) BOOL is_show;
@property(nonatomic, copy) NSString *branch_name;
@property(nonatomic, copy) NSString *limit_amount;
@property(nonatomic, copy) NSString *deposit_amount;
@property(nonatomic, copy) NSString *currency;
/*
 {
 "postscript" : "4224",
 "bankprovince" : "北京",
 "amount" : "5000",
 "bankname" : "交通银行",
 "bankimage" : "static/A05M/_default/__static/_wms/bankcards/6c196ecbe7899a15320fd6c3ab48b64b.png",
 "billno" : "A05EP18100417130914",
 "bankcity" : "北京市",
 "bankurl" : "https://pbank.95559.com.cn/personbank/logon.jsp",
 "bankcode" : "BCM",
 "bankaddress" : "测试分行",
 "accountname" : "交通银行",
 "accountnumber" : "784512545656",
 "alipay" : "https://auth.alipay.com/login/index.htm",
 "banklogo" : "static/A05M/_default/__static/_wms/bankcards/ab562bdd60ddabdcc8885d093fbebb27.png"
 },
 */

// 订单返回的银行卡信息
@property(nonatomic, copy) NSString *postscript;
@property(nonatomic, copy) NSString *bankprovince;
@property(nonatomic, copy) NSString *amount;
@property(nonatomic, copy) NSString *billno;
@property(nonatomic, copy) NSString *bankcity;
@property(nonatomic, copy) NSString *bankurl;
@property(nonatomic, copy) NSString *bankaddress;
@property(nonatomic, copy) NSString *accountname;
@property(nonatomic, copy) NSString *accountnumber;
@property(nonatomic, copy) NSString *alipay;
@property(nonatomic, copy) NSString *wechat;
@property (nonatomic, copy) NSString *qrcode;
@end



