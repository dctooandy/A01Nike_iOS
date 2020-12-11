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
@property(nonatomic, copy) NSString *billNo;
@property(nonatomic, copy) NSString *payUrl;

@property(nonatomic, strong) NSArray *domainList;
@property(nonatomic, copy) NSString *domainParam;
@property(nonatomic, assign) NSInteger flag;
@property(nonatomic, assign) NSInteger netEarn;

@end

