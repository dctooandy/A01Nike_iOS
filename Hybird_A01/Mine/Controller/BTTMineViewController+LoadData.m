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
#import "BTTCustomerBalanceModel.h"
#import "HAInitConfig.h"

@implementation BTTMineViewController (LoadData)

- (void)loadMeAllData {
    [self loadMainDataOne];
    [self loadMainDataTwo];
    [self loadMainDataThree];
    [self setupElements];
}

- (void)loadPaymentDefaultData {
    if (self.bigDataSoure.count) {
        [self.bigDataSoure removeAllObjects];
    }
    if (self.normalDataSoure.count) {
        [self.normalDataSoure removeAllObjects];
    }
    if (self.normalDataTwo.count) {
        [self.normalDataTwo removeAllObjects];
    }
    
    NSArray *icons =  @[@"me_bankscan",@"me_jdscan",@"me_aliwap",@"me_bank",@"me_wechatsecond",@"me_alipaySecond",@"me_online",@"me_aliSacn",@"me_wechatscan",@"me_qqScan",@"me_hand",@"me_wap",@"me_YSF",@"me_quick",@"me_bibao",@"me_pointCard",@"me_btc",@"me_tiaoma",@"me_bishang"];
    NSArray *names = @[@"银联扫码",@"京东扫码",@"支付宝wap",@"迅捷网银",@"微信秒存",@"支付宝秒存",@"在线支付",@"支付宝扫码",@"微信扫码",@"QQ扫码",@"手工存款",@"微信/QQ/京东wap",@"云闪付扫码",@"银行快捷网银",@"点卡",@"钻石币",@"比特币",@"微信条码支付",@"币商充值"];
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = icons[index];
        model.available = YES;
        if ([model.name isEqualToString:@"币商充值"] || [model.name isEqualToString:@"银联扫码"] || [model.name isEqualToString:@"京东扫码"] || [model.name isEqualToString:@"支付宝wap"]) {
            [self.bigDataSoure addObject:model];
        } else if ([model.name isEqualToString:@"迅捷网银"] ||
                   [model.name isEqualToString:@"微信秒存"] ||
                   [model.name isEqualToString:@"支付宝秒存"] ||
                   [model.name isEqualToString:@"在线支付"] ||
                   [model.name isEqualToString:@"支付宝扫码"] ||
                   [model.name isEqualToString:@"微信扫码"] ||
                   [model.name isEqualToString:@"QQ扫码"]) {
            [self.normalDataSoure addObject:model];
        } else {
            [self.normalDataTwo addObject:model];
        }
    }
    [self setupElements];
}

- (void)loadWeiXinRediect {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if ([IVNetwork savedUserInfo]) {
        params[@"loginName"]=[IVNetwork savedUserInfo].loginName;
    }else{
        params[@"loginName"]=@"";
    }
    [IVNetwork requestPostWithUrl:BTTGetWeiXinRediect paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTShareRedirectModel *model = [BTTShareRedirectModel yy_modelWithDictionary:result.body];
            self.redirectModel = model;
        }
    }];
    
}

- (void)queryBiShangStatus{
    [IVNetwork requestPostWithUrl:BTTQueryBiShangOpen paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [[NSUserDefaults standardUserDefaults]setObject:result.body forKey:BTTBMerchantStatus];
        }
    }];
}

- (void)loadPaymentData {
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *icons = nil;
    NSArray *names = nil;
    if (self.saveMoneyTimesType == BTTSaveMoneyTimesTypeLessTen) {
        icons =  @[@"me_bishang",@"me_bankscan",@"me_jdscan",@"me_aliwap",@"me_bank",@"me_wechatsecond",@"me_alipaySecond",@"me_online",@"me_aliSacn",@"me_wechatscan",@"me_qqScan",@"me_hand",@"me_wap",@"me_YSF",@"me_quick",@"me_bibao",@"me_pointCard",@"me_btc",@"me_tiaoma"];
        names = @[@"币商充值",@"银联扫码",@"京东扫码",@"支付宝wap",@"迅捷网银",@"微信秒存",@"支付宝秒存",@"在线支付",@"支付宝扫码",@"微信扫码",@"QQ扫码",@"手工存款",@"微信/QQ/京东wap",@"云闪付扫码",@"银行快捷网银",@"点卡",@"钻石币",@"比特币",@"微信条码支付"];
    } else {
        icons =  @[@"me_bank",@"me_alipaySecond",@"me_wechatsecond",@"me_hand",@"me_bankscan",@"me_online",@"me_wechatscan",@"me_aliSacn",@"me_wechatscan",@"me_jdscan",@"me_qqScan",@"me_wap",@"me_YSF",@"me_quick",@"me_bibao",@"me_pointCard",@"me_btc",@"me_tiaoma"];
        names = @[@"迅捷网银",@"支付宝秒存",@"微信秒存",@"手工存款",@"银联扫码",@"支付宝扫码",@"在线支付",@"微信扫码",@"京东扫码",@"QQ扫码",@"支付宝/微信/QQ/京东wap",@"云闪付扫码",@"银行快捷网银",@"钻石币",@"点卡",@"比特币",@"微信条码支付"];
    }
    
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = icons[index];
        model.available = YES;
        [arr addObject:model];
    }
    if ([IVNetwork savedUserInfo]) {
        [self loadPersonalPaymentData:arr];
    }
    
}

- (void)loadPersonalPaymentData:(NSMutableArray *)defaultArr {
    [CNPayRequestManager queryAllChannelCompleteHandler:^(id response,NSError * _Nullable error) {
        NSLog(@"%@",response);
        IVJResponseObject *result = response;
        if (self.bigDataSoure.count) {
            [self.bigDataSoure removeAllObjects];
        }
        if (self.normalDataSoure.count) {
            [self.normalDataSoure removeAllObjects];
        }
        if (self.normalDataTwo.count) {
            [self.normalDataTwo removeAllObjects];
        }
        NSMutableArray *payments = [NSMutableArray array];
        BOOL haveUSDT = NO;
        CNPaymentModel *usdtModel = [[CNPaymentModel alloc]init];
        
        NSMutableArray *wapPayments = [NSMutableArray array];
        BOOL haveWap = NO;
        
        NSString *bsStatus = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:BTTBMerchantStatus]];
        
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if ([result.body[@"payTypeList"] isKindOfClass:[NSArray class]]) {
                NSArray *payTypeArray = result.body[@"payTypeList"];
                for (int i = 0; i < payTypeArray.count; i ++) {
                    NSDictionary *dict = payTypeArray[i];
                    CNPaymentModel *model = [CNPaymentModel yy_modelWithJSON:dict];
                    [payments addObject:model];
                    if ([model.payTypeName isEqualToString:@"银联扫码"]&&![[IVNetwork savedUserInfo].depositLevel isEqualToString:@"-19"]) {
                        BTTMeMainModel *mainModel = [BTTMeMainModel new];
                        mainModel.name = @"银联扫码";
                        mainModel.iconName = @"me_bankscan";
                        mainModel.paymentType = model.payType;
                        mainModel.payModel = model;
                        if (self.saveMoneyTimesType == BTTSaveMoneyTimesTypeLessTen) {
                            [self.bigDataSoure addObject:mainModel];
                        }else{
                            [self.normalDataSoure addObject:mainModel];
                        }
                    }
                    if ([model.payTypeName isEqualToString:@"USDT支付"]) {
                        haveUSDT = YES;
                        usdtModel = model;
                    }
                    if ([model.payTypeName isEqualToString:@"京东扫码"]&&![[IVNetwork savedUserInfo].depositLevel isEqualToString:@"-19"]) {
                        BTTMeMainModel *mainModel = [BTTMeMainModel new];
                        mainModel.name = @"京东扫码";
                        mainModel.iconName = @"me_jdscan";
                        mainModel.paymentType = model.payType;
                        mainModel.payModel = model;
                        if (self.saveMoneyTimesType == BTTSaveMoneyTimesTypeLessTen) {
                            [self.bigDataSoure addObject:mainModel];
                        }else{
                            [self.normalDataSoure addObject:mainModel];
                        }
                    }

                    if ([model.payTypeName isEqualToString:@"快速支付"]&&![[IVNetwork savedUserInfo].depositLevel isEqualToString:@"-19"]) {
                        BTTMeMainModel *mainModel = [BTTMeMainModel new];
                        mainModel.name = @"迅捷网银";
                        mainModel.iconName = @"me_bank";
                        mainModel.paymentType = model.payType;
                        mainModel.payModel = model;
                        if (self.saveMoneyTimesType == BTTSaveMoneyTimesTypeLessTen) {
                            [self.normalDataSoure addObject:mainModel];
                        }else{
                            [self.bigDataSoure addObject:mainModel];
                        }
                    }
                    if ([model.payTypeName isEqualToString:@"微信转账银行卡"]&&![[IVNetwork savedUserInfo].depositLevel isEqualToString:@"-19"]) {
                        BTTMeMainModel *mainModel = [BTTMeMainModel new];
                        mainModel.name = @"微信秒存";
                        mainModel.iconName = @"me_wechatsecond";
                        mainModel.paymentType = model.payType;
                        mainModel.payModel = model;
                        if (self.saveMoneyTimesType == BTTSaveMoneyTimesTypeLessTen) {
                            [self.normalDataSoure addObject:mainModel];
                        }else{
                            [self.bigDataSoure addObject:mainModel];
                        }
                    }
                    if ([model.payTypeName isEqualToString:@"支付宝转账银行卡"]&&![[IVNetwork savedUserInfo].depositLevel isEqualToString:@"-19"]) {
                        BTTMeMainModel *mainModel = [BTTMeMainModel new];
                        mainModel.name = @"支付宝秒存";
                        mainModel.iconName = @"me_alipaySecond";
                        mainModel.paymentType = model.payType;
                        mainModel.payModel = model;
                        if (self.saveMoneyTimesType == BTTSaveMoneyTimesTypeLessTen) {
                            [self.normalDataSoure addObject:mainModel];
                        }else{
                            [self.bigDataSoure addObject:mainModel];
                        }
                    }
                    if ([model.payTypeName isEqualToString:@"支付宝扫码"]&&![[IVNetwork savedUserInfo].depositLevel isEqualToString:@"-19"]) {
                        BTTMeMainModel *mainModel = [BTTMeMainModel new];
                        mainModel.name = @"支付宝扫码";
                        mainModel.iconName = @"me_aliSacn";
                        mainModel.paymentType = model.payType;
                        mainModel.payModel = model;
                        [self.normalDataSoure addObject:mainModel];
                    }
                    if ([model.payTypeName isEqualToString:@"微信扫码"]&&![[IVNetwork savedUserInfo].depositLevel isEqualToString:@"-19"]) {
                        BTTMeMainModel *mainModel = [BTTMeMainModel new];
                        mainModel.name = @"微信扫码";
                        mainModel.iconName = @"me_wechatscan";
                        mainModel.paymentType = model.payType;
                        mainModel.payModel = model;
                        [self.normalDataSoure addObject:mainModel];
                    }
                    if ([model.payTypeName isEqualToString:@"QQ扫码"]&&![[IVNetwork savedUserInfo].depositLevel isEqualToString:@"-19"]) {
                        BTTMeMainModel *mainModel = [BTTMeMainModel new];
                        mainModel.name = @"QQ扫码";
                        mainModel.iconName = @"me_qqScan";
                        mainModel.paymentType = model.payType;
                        mainModel.payModel = model;
                        [self.normalDataSoure addObject:mainModel];
                    }
                    if ([model.payTypeName isEqualToString:@"手工存款"]&&![[IVNetwork savedUserInfo].depositLevel isEqualToString:@"-19"]) {
                        BTTMeMainModel *mainModel = [BTTMeMainModel new];
                        mainModel.name = @"手工存款";
                        mainModel.iconName = @"me_hand";
                        mainModel.paymentType = model.payType;
                        mainModel.payModel = model;
                        [self.normalDataTwo addObject:mainModel];
                    }
                    if ([model.payTypeName isEqualToString:@"在线支付"]&&![[IVNetwork savedUserInfo].depositLevel isEqualToString:@"-19"]) {
                        BTTMeMainModel *mainModel = [BTTMeMainModel new];
                        mainModel.name = @"在线支付";
                        mainModel.iconName = @"me_online";
                        mainModel.paymentType = model.payType;
                        mainModel.payModel = model;
                        [self.normalDataTwo addObject:mainModel];
                    }
                    if ([model.payTypeName isEqualToString:@"云闪付"]&&![[IVNetwork savedUserInfo].depositLevel isEqualToString:@"-19"]) {
                        BTTMeMainModel *mainModel = [BTTMeMainModel new];
                        mainModel.name = @"云闪付扫码";
                        mainModel.iconName = @"me_YSF";
                        mainModel.paymentType = model.payType;
                        mainModel.payModel = model;
                        [self.normalDataSoure addObject:mainModel];
                    }
                    if ([model.payTypeName isEqualToString:@"网银快捷支付MOB"]&&![[IVNetwork savedUserInfo].depositLevel isEqualToString:@"-19"]) {
                        BTTMeMainModel *mainModel = [BTTMeMainModel new];
                        mainModel.name = @"银行快捷网银";
                        mainModel.iconName = @"me_quick";
                        mainModel.paymentType = model.payType;
                        mainModel.payModel = model;
                        [self.normalDataTwo addObject:mainModel];
                    }
                    if ([model.payTypeName isEqualToString:@"币商"]&&[bsStatus isEqualToString:@"1"]&&![[IVNetwork savedUserInfo].depositLevel isEqualToString:@"-19"]) {
                        BTTMeMainModel *mainModel = [BTTMeMainModel new];
                        mainModel.name = @"币商充值";
                        mainModel.iconName = @"me_bishang";
                        mainModel.paymentType = model.payType;
                        mainModel.payModel = model;
                        [self.bigDataSoure addObject:mainModel];
                    }
                    if ([model.payTypeName isEqualToString:@"钻石币支付"]&&![[IVNetwork savedUserInfo].depositLevel isEqualToString:@"-19"]) {
                        BTTMeMainModel *mainModel = [BTTMeMainModel new];
                        mainModel.name = @"钻石币";
                        mainModel.iconName = @"me_bibao";
                        mainModel.paymentType = model.payType;
                        mainModel.payModel = model;
                        [self.normalDataTwo addObject:mainModel];
                    }
                    if ([model.payTypeName isEqualToString:@"点卡"]&&![[IVNetwork savedUserInfo].depositLevel isEqualToString:@"-19"]) {
                        BTTMeMainModel *mainModel = [BTTMeMainModel new];
                        mainModel.name = @"点卡";
                        mainModel.iconName = @"me_pointCard";
                        mainModel.paymentType = model.payType;
                        mainModel.payModel = model;
                        [self.normalDataTwo addObject:mainModel];
                    }
                    if ([model.payTypeName isEqualToString:@"比特币"]) {
                        BTTMeMainModel *mainModel = [BTTMeMainModel new];
                        mainModel.name = @"比特币";
                        mainModel.iconName = @"me_btc";
                        mainModel.paymentType = model.payType;
                        mainModel.payModel = model;
                        [self.normalDataTwo addObject:mainModel];
                    }
                    if ([model.payTypeName isEqualToString:@"微信条码"]&&![[IVNetwork savedUserInfo].depositLevel isEqualToString:@"-19"]) {
                        BTTMeMainModel *mainModel = [BTTMeMainModel new];
                        mainModel.name = @"微信条码支付";
                        mainModel.iconName = @"me_tiaoma";
                        mainModel.paymentType = model.payType;
                        mainModel.payModel = model;
                        [self.normalDataTwo addObject:mainModel];
                    }
                    if ([model.payTypeName isEqualToString:@"支付宝WAP"] || [model.payTypeName isEqualToString:@"微信WAP"] ||[model.payTypeName isEqualToString:@"QQWAP"]|| [model.payTypeName isEqualToString:@"京东WAP"]) {
                        [wapPayments addObject:model];
                        haveWap = YES;
                    }
                }
                if (haveWap&&![[IVNetwork savedUserInfo].depositLevel isEqualToString:@"-19"]) {
                    BTTMeMainModel *mainModel = [BTTMeMainModel new];
                    mainModel.name            = @"支付宝/微信/QQ/京东";
                    mainModel.iconName        = @"me_wap";
                    mainModel.paymentType     = 6789;
                    mainModel.payModels = wapPayments;
                    mainModel.payModel = wapPayments.firstObject;
                    [self.normalDataTwo addObject:mainModel];
                }
                
                if (haveUSDT) {
                    BTTMeMainModel *mainModel = [BTTMeMainModel new];
                    mainModel.name = @"泰达币-USDT";
                    mainModel.iconName = @"me_usdt";
                    mainModel.paymentType = 99;
                    if (usdtModel!=nil) {
                        mainModel.payModel = usdtModel;
                    }
                    [self.bigDataSoure addObject:mainModel];
                }
                
                if (self.bigDataSoure.count && self.normalDataSoure.count && self.normalDataTwo.count) {
                    self.saveMoneyShowType = BTTMeSaveMoneyShowTypeAll;
                    self.saveMoneyCount = 4;
                } else {
                    if (self.bigDataSoure.count && (self.normalDataSoure.count || self.normalDataTwo.count)) {
                        self.saveMoneyShowType = BTTMeSaveMoneyShowTypeBigOneMore;
                        self.saveMoneyCount = 3;
                    }

                    if (!self.bigDataSoure.count && (self.normalDataSoure.count && self.normalDataTwo.count)) {
                        self.saveMoneyShowType = BTTMeSaveMoneyShowTypeTwoMore;
                        self.saveMoneyCount = 2;
                    } else {
                        if ((self.normalDataSoure.count || self.normalDataTwo.count) && !self.bigDataSoure.count) {
                            self.saveMoneyShowType = BTTMeSaveMoneyShowTypeMore;
                            self.saveMoneyCount = 1;
                        } else if (self.bigDataSoure.count && (!self.normalDataSoure.count && !self.normalDataTwo.count)) {
                            self.saveMoneyShowType = BTTMeSaveMoneyShowTypeBig;
                            self.saveMoneyCount = 1;
                        }
                    }

                    if (!self.bigDataSoure.count && !self.normalDataSoure.count && !self.normalDataTwo.count) {
                        self.saveMoneyShowType = BTTMeSaveMoneyShowTypeNone;
                        self.saveMoneyCount = 0;
                    }

                }
                
            }else{
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
    NSMutableArray *names = @[@"取款",@"洗码",@"银行卡资料",@"绑定手机",@"个人资料",@""].mutableCopy;
    NSMutableArray *icons = @[@"me_withdrawal",@"me_washcode",@"me_card_band",@"me_mobile_band",@"me_personalInfo_band",@""].mutableCopy;
    
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
    NSArray *names = @[@"我的优惠",@"推荐礼金",@"客户报表",@"账号安全",@"额度转账",@"站内信",@"版本更新",@"网站检测",@"设置"];
    NSArray *icons = @[@"me_preferential",@"me_gift",@"me_sheet",@"me_amountsafe",@"me_transfer",@"me_message",@"me_version",@"me_speed",@"me_setting"];
    
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

- (void)loadBankList
{
    [BTTHttpManager fetchBankListWithUseCache:YES completion:nil];
}
- (void)loadBtcRate
{

}

- (void)makeCallWithPhoneNum:(NSString *)phone captcha:(NSString *)captcha captchaId:(NSString *)captchaId; {
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setValue:captcha forKey:@"captcha"];
    [params setValue:captchaId forKey:@"captchaId"];
    if ([phone containsString:@"*"]) {
        [params setValue:@1 forKey:@"type"];
    } else {
        [params setValue:@0 forKey:@"type"];
    }
    if ([IVNetwork savedUserInfo]) {
            [params setValue:[IVNetwork savedUserInfo].mobileNo forKey:@"mobileNo"];
            [params setValue:[IVNetwork savedUserInfo].loginName forKey:@"loginName"];
        } else {
            [params setValue:phone forKey:@"mobileNo"];
        }
    
        [IVNetwork requestPostWithUrl:BTTCallBackAPI paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
            IVJResponseObject *result = response;
            if ([result.head.errCode isEqualToString:@"0000"]) {
                [self showCallBackSuccessView];
            }else{
                NSString *errInfo = [NSString stringWithFormat:@"申请失败,%@",result.head.errMsg];
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

- (void)loadRebateStatus {
    [IVNetwork requestWithUseCache:YES url:BTTGiftRebateStatus paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSString *code = [NSString stringWithFormat:@"%@",result.body[@"newMemberBonus"][@"result_code"]];
            self.isOpenAccount = [code isEqualToString:@"203"]||[code isEqualToString:@"0"];
        }
    }];
}

- (void)loadGamesListAndGameAmount {
    self.preAmount = @"";
    if (![IVNetwork savedUserInfo]) {
        return;
    }
    [self loadLocalAmount:nil];
}

- (void)loadLocalAmount:(dispatch_group_t)group {
    NSDictionary *params = @{@"loginName":[IVNetwork savedUserInfo].loginName,@"flag":@1};
    [IVNetwork requestPostWithUrl:BTTCreditsALL paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTCustomerBalanceModel *model = [BTTCustomerBalanceModel yy_modelWithJSON:result.body];
            self.balanceModel = model;
            self.preAmount = [PublicMethod stringWithDecimalNumber:model.balance];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.totalAmount = [PublicMethod stringWithDecimalNumber:model.balance];
                self.isLoading = NO;
                [self.collectionView reloadData];
            });
        }
    }];
}

- (void)loadSaveMoneyTimes {
    NSDictionary *params = @{@"loginName":[IVNetwork savedUserInfo].loginName};
    [IVNetwork requestPostWithUrl:BTTSaveMoneyTimesAPI paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [[NSUserDefaults standardUserDefaults] setObject:result.body[@"data"] forKey:BTTSaveMoneyTimesKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [result.body[@"data"] integerValue] >= 10 ? (self.saveMoneyTimesType = BTTSaveMoneyTimesTypeMoreTen) : (self.saveMoneyTimesType = BTTSaveMoneyTimesTypeLessTen);
            [[NSNotificationCenter defaultCenter] postNotificationName:BTTSaveMoneyTimesNotification object:result.body];
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

- (NSMutableArray *)normalDataTwo {
    NSMutableArray *normalDataTwo = objc_getAssociatedObject(self, _cmd);
    if (!normalDataTwo) {
        normalDataTwo = [NSMutableArray array];
        [self setNormalDataTwo:normalDataTwo];
    }
    return normalDataTwo;
}

- (void)setNormalDataTwo:(NSMutableArray *)normalDataTwo {
    objc_setAssociatedObject(self, @selector(normalDataTwo), normalDataTwo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
