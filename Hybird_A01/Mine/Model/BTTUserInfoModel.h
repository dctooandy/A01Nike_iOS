//
//  BTTUserInfoModel.h
//  Hybird_A01
//
//  Created by Levy on 12/20/19.
//  Copyright © 2019 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTTUserInfoModel : NSObject

@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *beforeLoginDate;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *mobileNo;
@property (nonatomic, assign) NSInteger walletFlag;
@property (nonatomic, assign) NSInteger starLevel;
@property (nonatomic, copy) NSString *starLevelName;
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) NSInteger noLoginDays;
@property (nonatomic, assign) NSInteger customerType;
@property (nonatomic, copy) NSString *currency;
@end

NS_ASSUME_NONNULL_END
