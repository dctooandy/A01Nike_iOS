//
//  BTTMineViewController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/18.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTMineViewController+LoadData.h"
#import "BTTMeMainModel.h"
#import "CNPayRequestManager.h"
#import "CNPaymentModel.h"
#import "BTTMakeCallSuccessView.h"
#import "CNPayChannelModel.h"
#import "BTTGamesHallModel.h"

@implementation BTTMineViewController (LoadData)

- (void)loadMeAllData {
    [self loadPersonalInfoData];
    [self loadMainDataOne];
    [self loadMainDataTwo];
    [self loadMainDataThree];
    
    [self setupElements];
}


- (void)loadPersonalInfoData {
    if (self.personalInfos.count) {
        [self.personalInfos removeAllObjects];
    }
    NSArray *icons = @[@"me_personalInfo_unband",@"me_mobile_unband",@"me_email_unband",@"me_card_unband"];
    NSArray *names = @[@"个人资料",@"绑定手机",@"绑定邮箱",@"银行卡资料"];
    NSArray *highlights = @[@"me_personalInfo_band",@"me_mobile_band",@"me_email_band",@"me_card_band"];
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = icons[index];
        model.desc = highlights[index];
        [self.personalInfos addObject:model];
    }
}

- (void)loadPaymentDefaultData {
    if (self.bigDataSoure.count) {
        [self.bigDataSoure removeAllObjects];
    }
    if (self.normalDataSoure.count) {
        [self.normalDataSoure removeAllObjects];
    }
    NSArray *icons = @[@"me_alipay",@"me_wechat",@"me_netbank",@"me_hand",@"me_jd",@"me_btc",@"me_bibao",@"me_pointCard"];
    NSArray *names = @[@"支付宝",@"微信",@"银行卡",@"QQ",@"京东",@"比特币",@"钻石币",@"点卡支付"];
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = icons[index];
        model.available = YES;
        if ([model.name isEqualToString:@"支付宝"] || [model.name isEqualToString:@"微信"]) {
            [self.bigDataSoure addObject:model];
        } else {
            [self.normalDataSoure addObject:model];
        }
    }
    [self.collectionView reloadData];
}

- (void)loadPaymentData {
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *icons = @[@"me_netbank",@"me_wechat",@"me_alipay",@"me_hand",@"me_online",@"me_scan",@"me_quick",@"me_alipay",@"me_pointCard",@"me_btc",@"me_jd",@"me_tiaoma",@"me_bibao"];
    NSArray *names = @[@"迅捷网银",@"微信秒存",@"支付宝秒存",@"手工存款",@"在线支付",@"扫码支付",@"银行快捷支付",@"支付宝WAP",@"点卡支付",@"比特币支付",@"京东WAP支付",@"微信条码",@"钻石币支付"];
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = icons[index];
        model.available = YES;
        [arr addObject:model];
    }
    if ([IVNetwork userInfo]) {
        [self loadPersonalPaymentData:arr];
    }
    
}

- (void)loadPersonalPaymentData:(NSMutableArray *)defaultArr {
    [CNPayRequestManager queryAllChannelCompleteHandler:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (self.bigDataSoure.count) {
            [self.bigDataSoure removeAllObjects];
        }
        if (self.normalDataSoure.count) {
            [self.normalDataSoure removeAllObjects];
        }
        NSMutableArray *payments = [NSMutableArray array];
        if (result.data && [result.data isKindOfClass:[NSArray class]]) {
            for (int i = 0; i < [result.data count]; i ++) {
                NSDictionary *dict = result.data[i];
                CNPaymentModel *model = [[CNPaymentModel alloc] initWithDictionary:dict error:nil];
                model.paymentType = i;
                [payments addObject:model];
            }
            
            
            CNPaymentModel *aliFast = payments[CNPaymentBQAli];
            CNPaymentModel *scan3 = payments[CNPaymentAliQR];
            CNPaymentModel *alipay = payments[CNPaymentAliApp];
            BOOL isAli = NO;
            if ((aliFast.isAvailable || scan3.isAvailable || alipay.isAvailable) && !isAli) {
                BTTMeMainModel *mainModel = [BTTMeMainModel new];
                mainModel.name = @"支付宝";
                mainModel.iconName = @"me_alipay";
                mainModel.paymentType = CNPayChannelAli;
                [self.bigDataSoure addObject:mainModel];
                isAli = YES;
            }
            
            CNPaymentModel *WXFast = payments[CNPaymentBQWechat];
            CNPaymentModel *scan1 = payments[CNPaymentWechatQR];
            CNPaymentModel *scan2 = payments[CNPaymentWechatApp];
             CNPaymentModel *tiaoma = payments[CNPaymentWechatBarCode];
            BOOL isWX = NO;
            if ((WXFast.isAvailable || scan1.isAvailable || scan2.isAvailable || tiaoma.isAvailable) && !isWX) {
                BTTMeMainModel *mainModel = [BTTMeMainModel new];
                mainModel.name = @"微信";
                mainModel.iconName = @"me_wechat";
                mainModel.paymentType = CNPayChannelWechat;
                [self.bigDataSoure addObject:mainModel];
                isWX = YES;
            }
            
            CNPaymentModel *BQFast = payments[CNPaymentBQFast];
            CNPaymentModel *hand = payments[CNPaymentDeposit];
            CNPaymentModel *online = payments[CNPaymentOnline];
            CNPaymentModel *scan5 = payments[CNPaymentUnionQR];
            CNPaymentModel *quick = payments[CNPaymentUnionApp];
            BOOL isBank = NO;
            if ((BQFast.isAvailable || hand.isAvailable || online.isAvailable || scan5.isAvailable || quick.isAvailable) && !isBank) {
                BTTMeMainModel *mainModel = [BTTMeMainModel new];
                mainModel.name = @"银行卡";
                mainModel.iconName = @"me_netbank";
                mainModel.paymentType = CNPayChannelBankCard;
                [self.normalDataSoure addObject:mainModel];
                isBank = YES;
            }
            
            
            CNPaymentModel *scan4 = payments[CNPaymentQQApp];
            CNPaymentModel *scan6 = payments[CNPaymentQQQR];
            BOOL isQQ = NO;
            if ((scan3.isAvailable ||
                scan4.isAvailable ||
                scan6.isAvailable ) && !isQQ) {
                BTTMeMainModel *mainModel = [BTTMeMainModel new];
                mainModel.name = @"QQ";
                mainModel.iconName = @"me_scan";
                mainModel.paymentType = CNPayChannelQQ;
                [self.normalDataSoure addObject:mainModel];
                isQQ = YES;
            }
            
            CNPaymentModel *jd = payments[CNPaymentJDApp];
            CNPaymentModel *scan7 = payments[CNPaymentJDQR];
            BOOL isJD = NO;
            if ((jd.isAvailable || scan7.isAvailable) && !isJD) {
                BTTMeMainModel *mainModel = [BTTMeMainModel new];
                mainModel.name = @"京东";
                mainModel.iconName = @"me_jd";
                mainModel.paymentType = CNPayChannelJD;
                [self.normalDataSoure addObject:mainModel];
                isJD = YES;
            }
            
            CNPaymentModel *btc = payments[CNPaymentBTC];
            if (btc.isAvailable) {
                BTTMeMainModel *mainModel = [BTTMeMainModel new];
                mainModel.name = @"比特币";
                mainModel.iconName = @"me_btc";
                mainModel.paymentType = CNPayChannelBTC;
                [self.normalDataSoure addObject:mainModel];
            }
            
            CNPaymentModel *bibao = payments[CNPaymentCoin];
            if (bibao.isAvailable) {
                BTTMeMainModel *mainModel = [BTTMeMainModel new];
                mainModel.name = @"钻石币";
                mainModel.iconName = @"me_bibao";
                mainModel.paymentType = CNPayChannelCoin;
                [self.normalDataSoure addObject:mainModel];
            }

            CNPaymentModel *pointCard = payments[CNPaymentCard];
            if (pointCard.isAvailable) {
                BTTMeMainModel *mainModel = [BTTMeMainModel new];
                mainModel.name = @"点卡";
                mainModel.iconName = @"me_pointCard";
                mainModel.paymentType = CNPayChannelCard;
                [self.normalDataSoure addObject:mainModel];
            }
            
            if (self.bigDataSoure.count && self.normalDataSoure.count) {
                self.saveMoneyShowType = BTTMeSaveMoneyShowTypeAll;
                self.saveMoneyCount = 3;
            } else {
                if (self.bigDataSoure.count) {
                    self.saveMoneyShowType = BTTMeSaveMoneyShowTypeBig;
                }
                if (self.normalDataSoure.count) {
                    self.saveMoneyShowType = BTTMeSaveMoneyShowTypeMore;
                }
                self.saveMoneyCount = 1;
            }
            
            if (!self.bigDataSoure.count && !self.normalDataSoure.count) {
                self.saveMoneyShowType = BTTMeSaveMoneyShowTypeNone;
                self.saveMoneyCount = 0;
            }
        }
        [self setupElements];
    }];
}

- (void)loadMainDataOne {
    if (self.mainDataOne.count) {
        [self.mainDataOne removeAllObjects];
    }
    NSMutableArray *names = @[@"取款",@"结算洗码",@"额度转账",@"我的优惠",@"推荐礼金"].mutableCopy;
    NSMutableArray *icons = @[@"me_withdrawal",@"me_washcode",@"me_transfer",@"me_preferential",@"me_gift"].mutableCopy;
    if (self.isShowHidden) {
        names = [NSMutableArray arrayWithArray:@[@"取款",@"结算洗码",@"额度转账",@"我的优惠",@"首存优惠",@"推荐礼金"]];
        icons = [NSMutableArray arrayWithArray:@[@"me_withdrawal",@"me_washcode",@"me_transfer",@"me_preferential",@"",@"me_gift"]];
        if (self.isFanLi) {
            NSInteger index = [names indexOfObject:@"首存优惠"];
            [names insertObject:@"1%存款返利" atIndex:index + 1];
        }
        if (self.isOpenAccount) {
            NSInteger index = [names indexOfObject:@"首存优惠"];
            [names insertObject:@"开户礼金" atIndex:index + 1];
        }
    }
    
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = icons[index];
        [self.mainDataOne addObject:model];
    }
    [self.collectionView reloadData];
}

- (void)loadMainDataTwo {
    if (self.mainDataTwo.count) {
        [self.mainDataTwo removeAllObjects];
    }
    NSArray *names = @[@"财务报表",@"账号安全",@"设置",@"站内信",@"版本更新",@"网络检测"];
    NSArray *icons = @[@"me_sheet",@"me_amountsafe",@"me_setting",@"me_message",@"me_version",@"me_speed"];
    
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = icons[index];
        [self.mainDataTwo addObject:model];
    }
    [self.collectionView reloadData];
}

- (void)loadMainDataThree {
    if (self.mainDataThree.count) {
        [self.mainDataThree removeAllObjects];
    }
    NSArray *names = @[@"注销登录"];
    NSArray *icons = @[@"me_logout"];
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = icons[index];
        [self.mainDataThree addObject:model];
    }
    [self.collectionView reloadData];
}
- (void)loadUserInfo
{
    [BTTHttpManager fetchUserInfoCompleteBlock:nil];
}
- (void)loadBindStatus {
    weakSelf(weakSelf)
    [BTTHttpManager fetchBindStatusWithUseCache:YES completionBlock:^(IVRequestResultModel *result, id response) {
        [weakSelf.collectionView reloadData];
    }];
}
- (void)loadBankList
{
    [BTTHttpManager fetchBankListWithUseCache:YES completion:nil];
}
- (void)loadBtcRate
{
    if ([IVNetwork userInfo]) {
        [BTTHttpManager fetchBTCRateWithUseCache:YES];
    }
}

- (void)makeCallWithPhoneNum:(NSString *)phone {
    NSString *url = nil;
    NSMutableDictionary *params = @{}.mutableCopy;
    int currentHour = [PublicMethod hour:[NSDate date]];
    if ([IVNetwork userInfo].customerLevel >= 4 && currentHour >= 12) {
        url = BTTCallBackMemberAPI;
        [params setValue:phone forKey:@"phone"];
        [params setValue:@"memberphone" forKey:@"phone_type"];
    } else {
        url = BTTCallBackCustomAPI;
        [params setValue:phone forKey:@"phone_number"];
        
    }
    [IVNetwork sendRequestWithSubURL:url paramters:params.copy completionBlock:^(IVRequestResultModel *result, id response) {
        
        if (result.status) {
            [self showCallBackSuccessView];
        } else {
            NSString *errInfo = [NSString stringWithFormat:@"申请失败,%@",result.message];
            [MBProgressHUD showError:errInfo toView:nil];
        }
    }];
}

- (void)showCallBackSuccessView {
    BTTMakeCallSuccessView *customView = [BTTMakeCallSuccessView viewFromXib];
    customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    customView.dismissBlock = ^{
        [popView dismiss];
    };
    customView.btnBlock = ^(UIButton *btn) {
        [popView dismiss];
    };
}

- (void)loadAccountStatus {
    [BTTHttpManager getOpenAccountStatusCompletion:^(IVRequestResultModel *result, id response) {
        if (result.data && [result.data isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@",response);
            if (result.data[@"depositBonus"] && [result.data[@"depositBonus"] isKindOfClass:[NSDictionary class]]) {
                if ([result.data[@"depositBonus"][@"result_code"] integerValue] == 0) {
                    self.isFanLi = YES;
                }
            }
            
            if (result.data[@"newMemberBonus"] && [result.data[@"newMemberBonus"] isKindOfClass:[NSDictionary class]]) {
                if ([result.data[@"newMemberBonus"][@"result_code"] integerValue] == 203 ||
                    [result.data[@"newMemberBonus"][@"result_code"] integerValue] == 0) {
                    self.isOpenAccount = YES;
                }
            }
        }
    }];
}

- (void)loadGamesListAndGameAmount {
    self.preAmount = @"";
    self.isLoading = YES;
    dispatch_queue_t queue = dispatch_queue_create("mineAmount.data", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self loadLocalAmount:group];
    });
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self loadGameshallList:group];
    });
    dispatch_group_notify(group, queue, ^{
        [self loadEachGameHall];
    });
}

- (void)loadLocalAmount:(dispatch_group_t)group {
    [IVNetwork sendRequestWithSubURL:BTTCreditsLocal paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (result.code_http == 200 && result.status) {
            if (result.data && [result.data isKindOfClass:[NSDictionary class]]) {
                self.preAmount = result.data[@"val"];
                dispatch_group_leave(group);
            }
        }
    }];
}

- (void)loadEachGameHall {
    dispatch_queue_t queue = dispatch_queue_create("mineAmount.eachhall", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    for (BTTGamesHallModel *model in self.games) {
        NSInteger index = [self.games indexOfObject:model];
        dispatch_group_enter(group);
        [self loadGameAmountWithModel:model index:index group:group];
    }
    
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.totalAmount = @"";
            self.isLoading = NO;
            self.totalAmount = [self.preAmount copy];
            [self.collectionView reloadData];
        });
    });
}

- (void)loadGameAmountWithModel:(BTTGamesHallModel *)model index:(NSInteger)index group:(dispatch_group_t)group{
    NSDictionary *params = @{@"game_name":model.gameName};
    [IVNetwork sendRequestWithSubURL:BTTCreditsGame paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (result.code_http == 200 && result.data && [result.data isKindOfClass:[NSDictionary class]]) {
            model.amount = [NSString stringWithFormat:@"%.2f",[result.data[@"val"] floatValue]];
            model.isLoading = NO;
            self.preAmount = [NSString stringWithFormat:@"%.2f",self.preAmount.floatValue + model.amount.floatValue];
        }
        dispatch_group_leave(group);
        if (result.message.length) {
            [MBProgressHUD showError:result.message toView:nil];
        }
    }];
}

- (void)loadGameshallList:(dispatch_group_t)group{
    [BTTHttpManager fetchGamePlatformsWithCompletion:^(IVRequestResultModel *result, id response) {
        if (self.games.count) {
            [self.games removeAllObjects];
        }
        if (result.code_http == 200 && result.status) {
            if (result.data && [result.data isKindOfClass:[NSDictionary class]]) {
                if (result.data[@"platforms"] && [result.data[@"platforms"] isKindOfClass:[NSArray class]] && ![result.data[@"platforms"] isKindOfClass:[NSNull class]]) {
                    for (NSDictionary *dict in result.data[@"platforms"]) {
                        BTTGamesHallModel *model = [BTTGamesHallModel yy_modelWithDictionary:dict];
                        model.isLoading = YES;
                        [self.games addObject:model];
                    }
                }
            }
        }
        [self setupElements];
        dispatch_group_leave(group);
        if (result.message.length) {
            [MBProgressHUD showError:result.message toView:nil];
        }
    }];
}

#pragma mark - 动态添加属性

- (NSMutableArray *)personalInfos {
    NSMutableArray *personalInfos = objc_getAssociatedObject(self, _cmd);
    if (!personalInfos) {
        personalInfos = [NSMutableArray array];
        [self setPersonalInfos:personalInfos];
    }
    return personalInfos;
}

- (void)setPersonalInfos:(NSMutableArray *)personalInfos {
    objc_setAssociatedObject(self, @selector(personalInfos), personalInfos, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)bigDataSoure {
    NSMutableArray *bigDataSoure = objc_getAssociatedObject(self, _cmd);
    if (!bigDataSoure) {
        bigDataSoure = [NSMutableArray array];
        [self setBigDataSoure:bigDataSoure];
    }
    return bigDataSoure;
}

- (void)setBigDataSoure:(NSMutableArray *)bigDataSoure {
    objc_setAssociatedObject(self, @selector(bigDataSoure), bigDataSoure, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSMutableArray *)normalDataSoure {
    NSMutableArray *normalDataSoure = objc_getAssociatedObject(self, _cmd);
    if (!normalDataSoure) {
        normalDataSoure = [NSMutableArray array];
        [self setNormalDataSoure:normalDataSoure];
    }
    return normalDataSoure;
}

- (void)setNormalDataSoure:(NSMutableArray *)normalDataSoure {
    objc_setAssociatedObject(self, @selector(normalDataSoure), normalDataSoure, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)mainDataOne {
    NSMutableArray *mainDataOne = objc_getAssociatedObject(self, _cmd);
    if (!mainDataOne) {
        mainDataOne = [NSMutableArray array];
        [self setMainDataOne:mainDataOne];
    }
    return mainDataOne;
}

- (void)setMainDataOne:(NSMutableArray *)mainDataOne {
    objc_setAssociatedObject(self, @selector(mainDataOne), mainDataOne, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)mainDataTwo {
    NSMutableArray *mainDataTwo = objc_getAssociatedObject(self, _cmd);
    if (!mainDataTwo) {
        mainDataTwo = [NSMutableArray array];
        [self setMainDataTwo:mainDataTwo];
    }
    return mainDataTwo;
}

- (void)setMainDataTwo:(NSMutableArray *)mainDataTwo {
    objc_setAssociatedObject(self, @selector(mainDataTwo), mainDataTwo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)mainDataThree {
    NSMutableArray *mainDataThree = objc_getAssociatedObject(self, _cmd);
    if (!mainDataThree) {
        mainDataThree = [NSMutableArray array];
        [self setMainDataThree:mainDataThree];
    }
    return mainDataThree;
}

- (void)setMainDataThree:(NSMutableArray *)mainDataThree {
    objc_setAssociatedObject(self, @selector(mainDataThree), mainDataThree, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)games {
    NSMutableArray *games = objc_getAssociatedObject(self, _cmd);
    if (!games) {
        games = [NSMutableArray array];
        [self setGames:games];
    }
    return games;
}

- (void)setGames:(NSMutableArray *)games {
    objc_setAssociatedObject(self, @selector(games), games, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
