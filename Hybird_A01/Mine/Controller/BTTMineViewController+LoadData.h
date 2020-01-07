//
//  BTTMineViewController+LoadData.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/18.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTMineViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTMineViewController (LoadData)

@property (nonatomic, strong) NSMutableArray *personalInfos;

@property (nonatomic, strong) NSMutableArray *mainDataOne;

@property (nonatomic, strong) NSMutableArray *mainDataTwo;

@property (nonatomic, strong) NSMutableArray *mainDataThree;

@property (nonatomic, strong) NSMutableArray *games;

@property (nonatomic, strong) NSMutableArray *bigDataSoure;

@property (nonatomic, strong) NSMutableArray *normalDataSoure;

@property (nonatomic, strong) NSMutableArray *normalDataTwo;





- (void)loadMeAllData;

- (void)loadUserInfo;

- (void)loadBankList;

- (void)loadBtcRate;

- (void)loadGamesListAndGameAmount;

- (void)loadPaymentData;

- (void)loadPaymentDefaultData;

- (void)makeCallWithPhoneNum:(NSString *)phone captcha:(NSString *)captcha captchaId:(NSString *)captchaId;

- (void)loadAccountStatus;

- (void)loadSaveMoneyTimes;

- (void)getLive800InfoDataWithResponse:(BTTLive800ResponseBlock)responseBlock;

/// 获取微信分享链接
- (void)loadWeiXinRediect;


@end

NS_ASSUME_NONNULL_END
