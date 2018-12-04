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
    NSArray *icons = @[@"me_netbank",@"me_wechat",@"me_alipay",@"me_hand",@"me_online",@"me_scan",@"me_quick",@"me_alipay",@"me_pointCard",@"me_btc",@"me_jd"];
    NSArray *names = @[@"迅捷网银",@"微信秒存",@"支付宝秒存",@"手工存款",@"在线支付",@"扫码支付",@"银行快捷支付",@"支付宝WAP",@"点卡支付",@"比特币支付",@"京东WAP支付"];
    NSArray *paymentNames = @[@"bqpaytype-0",@"bqpaytype-1",@"bqpaytype-2",@"deposit",@"online-1",@"online-6;online-8;online-5;online-7;online-11;online-15;online-16",@"faster",@"online-9",@"card",@"online-20",@"online-17"];
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = icons[index];
        model.paymentName = paymentNames[index];
        model.available = YES;
        [self.paymentDatas addObject:model];
    }
    [self.collectionView reloadData];
}

- (void)loadPaymentData {
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *icons = @[@"me_netbank",@"me_wechat",@"me_alipay",@"me_hand",@"me_online",@"me_scan",@"me_quick",@"me_alipay",@"me_pointCard",@"me_btc",@"me_jd"];
    NSArray *names = @[@"迅捷网银",@"微信秒存",@"支付宝秒存",@"手工存款",@"在线支付",@"扫码支付",@"银行快捷支付",@"支付宝WAP",@"点卡支付",@"比特币支付",@"京东WAP支付"];
    NSArray *paymentNames = @[@"bqpaytype-0",@"bqpaytype-1",@"bqpaytype-2",@"deposit",@"online-1",@"online-6;online-8;online-5;online-7;online-11;online-15;online-16",@"faster",@"online-9",@"card",@"online-20",@"online-17"];
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = icons[index];
        model.paymentName = paymentNames[index];
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
            for (NSDictionary *dict in result.data) {
                CNPaymentModel *model = [[CNPaymentModel alloc] initWithDictionary:dict error:nil];
                if (model.isAvailable) {
                    [payments addObject:model];
                }
            }
            for (CNPaymentModel *paymentModel in payments) {
                for (BTTMeMainModel *model in defaultArr) {
                    if ([model.name isEqualToString:paymentModel.paymentTitle] && paymentModel.isAvailable) {
                        if ([paymentModel.paymentTitle isEqualToString:@"微信扫码"] ||
                            [paymentModel.paymentTitle isEqualToString:@"微信WAP"] ||
                            [paymentModel.paymentTitle isEqualToString:@"支付宝扫码"] ||
                            [paymentModel.paymentTitle isEqualToString:@"QQ钱包"] ||
                            [paymentModel.paymentTitle isEqualToString:@"QQWAP"] ||
                            [paymentModel.paymentTitle isEqualToString:@"银联扫码"] ||
                            [paymentModel.paymentTitle isEqualToString:@"京东扫码"]) {
                            continue;
                        }
                        
                        [availablePayments addObject:model];
                    }
                }
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
    if ([IVNetwork userInfo]) {
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
- (void)loadTotalAvailableData {
    [IVNetwork sendRequestWithSubURL:BTTCreditsTotalAvailable paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (result.code_http == 200) {
            if (result.data && ![result.data isKindOfClass:[NSNull class]]) {
                self.totalAmount = result.data[@"val"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            }
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

@end
