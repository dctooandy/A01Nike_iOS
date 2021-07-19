//
//  BTTHomePageViewController+LoadData.h
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/11.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTHomePageViewController.h"
#import "BTTGameModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BTTHomePageViewController (LoadData)


@property (nonatomic, copy) NSString *noticeStr;

@property (nonatomic, strong) NSMutableArray *headers;

@property (nonatomic, strong) NSMutableArray *Activities;

@property (nonatomic, strong) NSMutableArray *amounts;

@property (nonatomic, strong) NSMutableArray *posters;

@property (nonatomic, strong) NSMutableArray *promotions;

@property (nonatomic, strong) NSMutableArray *banners;

@property (nonatomic, strong) NSMutableArray *downloads;

@property (nonatomic, strong) NSMutableArray *games;

@property (nonatomic, strong) NSMutableArray *imageUrls;

@property (nonatomic, assign) NSInteger nextGroup;
//
@property (nonatomic, assign) NSInteger chanceCount;
@property (nonatomic, strong) NSMutableArray *lotteryNumList;


#pragma mark 加载所有数据
- (void)loadDataOfHomePage;

- (void)makeCallWithPhoneNum:(NSString *)phone captcha:(NSString *)captcha captchaId:(NSString *)captchaId;

- (void)refreshDatasOfHomePage;

- (void)showTryAlertViewWithBlock:(BTTBtnBlock)btnClickBlock;

// 查新博币数量
- (void)loadLuckyWheelCoinStatus;

// 博币兑换
- (void)loadLuckyWheelCoinChangeWithAmount:(NSString *)amount;

- (void)showMidAutumnPopView;

-(void)loadBiBiCun;

-(void)loadYenFenHong;

-(void)loadSevenXiData;
@end

NS_ASSUME_NONNULL_END
