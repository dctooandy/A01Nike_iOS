//
//  BTTCustomerInfoModel.h
//  Hybird_A01
//
//  Created by Levy on 1/7/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTCustomerInfoModel : BTTBaseModel

@property (nonatomic, copy  ) NSString  *address;
@property (nonatomic, copy  ) NSString  *avatar;
@property (nonatomic, assign) NSInteger bankCardNum;
@property (nonatomic, copy  ) NSString  *birthday;
@property (nonatomic, assign) NSInteger blackFlag;
@property (nonatomic, assign) NSInteger btcNum;
@property (nonatomic, assign) NSInteger cashCredit;
@property (nonatomic, copy  ) NSString  *clubLevel;
@property (nonatomic, copy  ) NSString  *currency;
@property (nonatomic, copy  ) NSString  *customerId;
@property (nonatomic, assign) NSInteger customerType;
@property (nonatomic, copy  ) NSString  *depositLevel;
@property (nonatomic, copy  ) NSString  *email;
@property (nonatomic, assign) NSInteger emailBind;
@property (nonatomic, assign) NSInteger ethNum;
@property (nonatomic, copy  ) NSString  *firstDepositDate;
@property (nonatomic, assign) NSInteger firstXmFlag;
@property (nonatomic, assign) NSInteger gameCredit;
@property (nonatomic, copy  ) NSString  *gender;
@property (nonatomic, copy  ) NSString  *integral;
@property (nonatomic, copy  ) NSString  *lastLoginDate;
@property (nonatomic, copy  ) NSString  *lastLoginIp;
@property (nonatomic, copy  ) NSString  *loginDate;
@property (nonatomic, copy  ) NSString  *loginName;
@property (nonatomic, assign) NSInteger loginNameFlag;
@property (nonatomic, assign) NSInteger mbtcNum;
@property (nonatomic, copy  ) NSString  *mobileNo;
@property (nonatomic, assign) NSInteger mobileNoBind;
@property (nonatomic, copy  ) NSString  *mobileNoMd5;
@property (nonatomic, assign) NSInteger newWalletFlag;
@property (nonatomic, copy  ) NSString  *nickName;
@property (nonatomic, copy  ) NSString  *onlineMessager2;
@property (nonatomic, assign) NSInteger promoAmountByMonth;
@property (nonatomic, copy  ) NSString  *promotionFlag;
@property (nonatomic, assign) NSInteger pwdExpireDays;
@property (nonatomic, copy  ) NSString  *realName;
@property (nonatomic, assign) NSInteger rebatedAmountByMonth;
@property (nonatomic, copy  ) NSString  *resigtDate;
@property (nonatomic, copy  ) NSString  *remark;
@property (nonatomic, assign) NSInteger starLevel;
@property (nonatomic, copy  ) NSString  *starLevelName;
@property (nonatomic, copy  ) NSString  *token;
@property (nonatomic, copy  ) NSString  *verifyCode;
@property (nonatomic, assign) NSInteger upgradeRequiredBetAmount;
@property (nonatomic, assign) NSInteger usdtNum;
@property (nonatomic, assign) NSInteger voiceVerifyStatus;
@property (nonatomic, assign) NSInteger weeklyBetAmount;
@property (nonatomic, assign) NSInteger xmFlag;

@end

NS_ASSUME_NONNULL_END
