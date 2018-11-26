//
//  CNPayOrderModel.h
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "JSONModel.h"

@interface CNPayOrderModel : JSONModel
@property(nonatomic, copy) NSString *amount;
@property(nonatomic, copy) NSString *billno;
@property(nonatomic, copy) NSString *url;

@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *product;
@property(nonatomic, copy) NSString *billdate;
@property(nonatomic, copy) NSString *paycode;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, copy) NSString *keycode;
@property(nonatomic, copy) NSString *des_url;
@property(nonatomic, copy) NSString *currency;
@property(nonatomic, copy) NSArray  *urlList;
@property(nonatomic, copy) NSString *memo;

/// 点卡
@property(nonatomic, copy) NSString *method;
@property(nonatomic, copy) NSString *newaccount;
@end
/**
 {
 amount = 19;
 billdate = 20181031;
 billno = B0118103116163811;
 "des_url" = "http://pay.xyuju569.com/CardPaymentThird.do";
 keycode = c72b1d17f907962e75db83b86c5ef040;
 memo = null;
 message = "";
 method = 0;
 newaccount = 0;
 product = B01;
 status = 0;
 }
 */
