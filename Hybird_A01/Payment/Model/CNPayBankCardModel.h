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
@property(nonatomic, copy) NSString *bankName;
@property(nonatomic, copy) NSString *bankCode;
@property(nonatomic, copy) NSString *bankIcon;
@property(nonatomic, copy) NSString *city;
@property(nonatomic, copy) NSString *province;
@property (nonatomic, assign) NSInteger showFlag;
@property(nonatomic, copy) NSString *accountId;
@property(nonatomic, copy) NSString *accountName;
@property(nonatomic, copy) NSString *accountNo;
@property(nonatomic, copy) NSString *bankBranchName;
@property(nonatomic, copy) NSString *simpleAccountName;
@property(nonatomic, copy) NSString *amount;
@property(nonatomic, copy) NSString *bankCity;
@property(nonatomic, copy) NSString *bankUrl;
@property(nonatomic, copy) NSString *billNo;
@property(nonatomic, copy) NSString *depositor;
@property(nonatomic, copy) NSString *flag;
@property(nonatomic, copy) NSString *payLimitTime;
@property(nonatomic, copy) NSString *qrCode;

@end



