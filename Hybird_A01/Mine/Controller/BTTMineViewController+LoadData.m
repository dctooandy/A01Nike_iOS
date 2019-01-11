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
    if (self.paymentDatas.count) {
        [self.paymentDatas removeAllObjects];
    }
    NSArray *icons = @[@"me_netbank",@"me_wechat",@"me_alipay",@"me_hand",@"me_online",@"me_scan",@"me_quick",@"me_alipay",@"me_pointCard",@"me_btc",@"me_jd",@"me_tiaoma",@"me_bibao"];
    NSArray *names = @[@"迅捷网银",@"微信秒存",@"支付宝秒存",@"手工存款",@"在线支付",@"扫码支付",@"银行快捷支付",@"支付宝WAP",@"点卡支付",@"比特币支付",@"京东WAP支付",@"微信条码",@"钻石币支付"];
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = icons[index];
        model.available = YES;
        [self.paymentDatas addObject:model];
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
//    [self showLoading];
    [CNPayRequestManager queryAllChannelCompleteHandler:^(IVRequestResultModel *result, id response) {
//        [self hideLoading];
        NSLog(@"%@",response);
        NSMutableArray *payments = [NSMutableArray array];
        NSMutableArray *availablePayments = [NSMutableArray array];
        if (result.data && [result.data isKindOfClass:[NSArray class]]) {
            for (int i = 0; i < [result.data count]; i ++) {
                NSDictionary *dict = result.data[i];
                CNPaymentModel *model = [[CNPaymentModel alloc] initWithDictionary:dict error:nil];
                model.paymentType = i;
                [payments addObject:model];
            }
            if (!payments.count) {
                self.paymentDatas = [NSMutableArray array];
                [self setupElements];
                return;
            }
            CNPaymentModel *BQFast = payments[CNPaymentBQFast];
            if (BQFast.isAvailable) {
                BTTMeMainModel *mainModel = [BTTMeMainModel new];
                mainModel.name = @"迅捷网银";
                mainModel.iconName = @"me_netbank";
                mainModel.paymentType = CNPayChannelBQFast;
                [availablePayments addObject:mainModel];
            }
            
            CNPaymentModel *WXFast = payments[CNPaymentBQWechat];
            if (WXFast.isAvailable) {
                BTTMeMainModel *mainModel = [BTTMeMainModel new];
                mainModel.name = @"微信秒存";
                mainModel.iconName = @"me_wechat";
                mainModel.paymentType = CNPayChannelBQWechat;
                [availablePayments addObject:mainModel];
            }
            
            CNPaymentModel *aliFast = payments[CNPaymentBQAli];
            if (aliFast.isAvailable) {
                BTTMeMainModel *mainModel = [BTTMeMainModel new];
                mainModel.name = @"支付宝秒存";
                mainModel.iconName = @"me_alipay";
                mainModel.paymentType = CNPayChannelBQAli;
                [availablePayments addObject:mainModel];
            }
            
            CNPaymentModel *hand = payments[CNPaymentDeposit];
            if (hand.isAvailable) {
                BTTMeMainModel *mainModel = [BTTMeMainModel new];
                mainModel.name = @"手工存款";
                mainModel.iconName = @"me_hand";
                mainModel.paymentType = CNPayChannelDeposit;
                [availablePayments addObject:mainModel];
            }
            
            CNPaymentModel *online = payments[CNPaymentOnline];
            if (online.isAvailable) {
                BTTMeMainModel *mainModel = [BTTMeMainModel new];
                mainModel.name = @"在线支付";
                mainModel.iconName = @"me_online";
                mainModel.paymentType = CNPayChannelOnline;
                [availablePayments addObject:mainModel];
            }
            
            CNPaymentModel *scan1 = payments[CNPaymentWechatQR];
            CNPaymentModel *scan2 = payments[CNPaymentWechatApp];
            CNPaymentModel *scan3 = payments[CNPaymentAliQR];
            CNPaymentModel *scan4 = payments[CNPaymentQQApp];
            CNPaymentModel *scan5 = payments[CNPaymentUnionQR];
            CNPaymentModel *scan6 = payments[CNPaymentQQQR];
            CNPaymentModel *scan7 = payments[CNPaymentJDQR];
            BOOL isHave = NO;
            if ((scan1.isAvailable ||
                scan2.isAvailable ||
                scan3.isAvailable ||
                scan4.isAvailable ||
                scan5.isAvailable ||
                scan6.isAvailable ||
                scan7.isAvailable) && !isHave) {
                BTTMeMainModel *mainModel = [BTTMeMainModel new];
                mainModel.name = @"扫码支付";
                mainModel.iconName = @"me_scan";
                mainModel.paymentType = CNPayChannelQR;
                [availablePayments addObject:mainModel];
                isHave = YES;
            }
            
            CNPaymentModel *quick = payments[CNPaymentUnionApp];
            if (quick.isAvailable) {
                BTTMeMainModel *mainModel = [BTTMeMainModel new];
                mainModel.name = @"银行快捷支付";
                mainModel.iconName = @"me_quick";
                mainModel.paymentType = CNPayChannelUnionApp;
                [availablePayments addObject:mainModel];
            }
            
            CNPaymentModel *alipay = payments[CNPaymentAliApp];
            if (alipay.isAvailable) {
                BTTMeMainModel *mainModel = [BTTMeMainModel new];
                mainModel.name = @"支付宝WAP";
                mainModel.iconName = @"me_alipay";
                mainModel.paymentType = CNPayChannelAliApp;
                [availablePayments addObject:mainModel];
            }
            
            CNPaymentModel *pointCard = payments[CNPaymentCard];
            if (pointCard.isAvailable) {
                BTTMeMainModel *mainModel = [BTTMeMainModel new];
                mainModel.name = @"点卡支付";
                mainModel.iconName = @"me_pointCard";
                mainModel.paymentType = CNPayChannelCard;
                [availablePayments addObject:mainModel];
            }
            
            CNPaymentModel *btc = payments[CNPaymentBTC];
            if (btc.isAvailable) {
                BTTMeMainModel *mainModel = [BTTMeMainModel new];
                mainModel.name = @"比特币支付";
                mainModel.iconName = @"me_btc";
                mainModel.paymentType = CNPayChannelBTC;
                [availablePayments addObject:mainModel];
            }
            
            CNPaymentModel *jd = payments[CNPaymentJDApp];
            if (jd.isAvailable) {
                BTTMeMainModel *mainModel = [BTTMeMainModel new];
                mainModel.name = @"京东WAP支付";
                mainModel.iconName = @"me_jd";
                mainModel.paymentType = CNPayChannelJDApp;
                [availablePayments addObject:mainModel];
            }
            
            CNPaymentModel *tiaoma = payments[CNPaymentWechatBarCode];
            if (tiaoma.isAvailable) {
                BTTMeMainModel *mainModel = [BTTMeMainModel new];
                mainModel.name = @"微信条码";
                mainModel.iconName = @"me_tiaoma";
                mainModel.paymentType = CNPayChannelWechatBarCode;
                [availablePayments addObject:mainModel];
            }
            
            CNPaymentModel *bibao = payments[CNPaymentCoin];
            if (bibao.isAvailable) {
                BTTMeMainModel *mainModel = [BTTMeMainModel new];
                mainModel.name = @"钻石币支付";
                mainModel.iconName = @"me_bibao";
                mainModel.paymentType = CNPayChannelCoin;
                [availablePayments addObject:mainModel];
            }

            self.paymentDatas = [availablePayments mutableCopy];
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
    NSArray *names = @[@"客户报表",@"账号安全",@"设置",@"站内信",@"版本更新",@"网络检测"];
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
                self.totalAmount = result.data[@"val"];
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
            self.totalAmount = [NSString stringWithFormat:@"%.2f",self.totalAmount.floatValue + model.amount.floatValue];
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


- (NSMutableArray *)paymentDatas {
    NSMutableArray *paymentDatas = objc_getAssociatedObject(self, _cmd);
    if (!paymentDatas) {
        paymentDatas = [NSMutableArray array];
        [self setPaymentDatas:paymentDatas];
    }
    return paymentDatas;
}

- (void)setPaymentDatas:(NSMutableArray *)paymentDatas {
     objc_setAssociatedObject(self, @selector(paymentDatas), paymentDatas, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
