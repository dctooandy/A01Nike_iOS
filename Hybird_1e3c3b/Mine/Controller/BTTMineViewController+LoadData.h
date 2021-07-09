//
//  BTTMineViewController+LoadData.h
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/18.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTMineViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^CompleteRealNameBlock)(IVJResponseHead * errHead);

@interface BTTMineViewController (LoadData)

@property (nonatomic, strong) NSMutableArray *personalInfos;

@property (nonatomic, strong) NSMutableArray *mainDataOne;

@property (nonatomic, strong) NSMutableArray *mainDataTwo;

@property (nonatomic, strong) NSMutableArray *mainDataThree;

@property (nonatomic, strong) NSMutableArray *games;

@property (nonatomic, strong) NSMutableArray *bigDataSoure;

@property (nonatomic, strong) NSMutableArray *normalDataSoure;

@property (nonatomic, strong) NSMutableArray *normalDataTwo;



- (void)completeRealName:(NSString *)nameStr completeRealNameBlock:(CompleteRealNameBlock)completeRealNameBlock;

- (void)loadMeAllData;

- (void)loadMainDataTwo;

- (void)loadUserInfo;

- (void)requestBuyUsdtLink;

- (void)loadBankList;

- (void)loadBtcRate;

- (void)loadGamesListAndGameAmount;

- (void)loadPaymentData;

- (void)loadPaymentDefaultData;

- (void)makeCallWithPhoneNum:(NSString *)phone captcha:(NSString *)captcha captchaId:(NSString *)captchaId;

- (void)loadRebateStatus;

- (void)loadSaveMoneyTimes;

/// 获取微信分享链接
- (void)loadWeiXinRediect;

- (void)queryBiShangStatus;

-(void)changeMode:(NSString *)modeStr isInGame:(BOOL)isInGame;

-(void)loadGetPopWithDraw;

@end

NS_ASSUME_NONNULL_END
