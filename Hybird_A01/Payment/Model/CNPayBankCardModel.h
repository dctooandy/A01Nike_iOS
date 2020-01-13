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

@end



