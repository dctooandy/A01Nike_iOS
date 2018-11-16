//
//  BTTMineViewController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/18.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTMineViewController+LoadData.h"
#import "BTTMeMainModel.h"

@implementation BTTMineViewController (LoadData)

- (void)loadMeAllData {
    [self loadPersonalInfoData];
    [self loadPaymentData];
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
    NSArray *names = @[@"个人资料",@"更换手机",@"绑定邮箱",@"银行卡资料"];
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = icons[index];
        [self.personalInfos addObject:model];
    }
    [self.collectionView reloadData];
}

- (void)loadPaymentData {
    if (self.paymentDatas.count) {
        [self.paymentDatas removeAllObjects];
    }
    NSArray *icons = @[@"me_netbank",@"me_wechat",@"me_alipay",@"me_hand",@"me_online",@"me_scan",@"me_quick",@"me_alipay",@"me_pointCard",@"me_btc",@"me_jd"];
    NSArray *names = @[@"迅捷网银",@"微信秒存",@"支付宝秒存",@"手工存款",@"在线支付",@"扫码支付",@"银行快捷支付",@"支付宝wap",@"点卡支付",@"比特币支付",@"京东wap支付"];
    for (NSString *name in names) {
        NSInteger index = [names indexOfObject:name];
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = name;
        model.iconName = icons[index];
        [self.paymentDatas addObject:model];
    }
    [self.collectionView reloadData];
}

- (void)loadMainDataOne {
    if (self.mainDataOne.count) {
        [self.mainDataOne removeAllObjects];
    }
    NSArray *names = @[@"取款",@"结算洗码",@"额度转账",@"我的优惠",@"推荐礼金"];
    NSArray *icons = @[@"me_withdrawal",@"me_washcode",@"me_transfer",@"me_preferential",@"me_gift"];
    if (self.isShowHidden) {
        names = @[@"取款",@"结算洗码",@"额度转账",@"我的优惠",@"开户礼金",@"开户礼金",@"开户礼金",@"推荐礼金"];
        icons = @[@"me_withdrawal",@"me_washcode",@"me_transfer",@"me_preferential",@"",@"",@"",@"me_gift"];
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
    NSArray *names = @[@"财务报表",@"账号安全",@"设置",@"站内信",@"版本更新"];
    NSArray *icons = @[@"me_sheet",@"me_amountsafe",@"me_setting",@"me_message",@"me_version"];
    
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
    NSArray *names = @[@"退出登录"];
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

- (void)loadBindStatus {
    NSString *typeList = @"phone;email;bank;btc";
    NSDictionary *pramas = @{@"typeList":typeList};
    [IVNetwork sendRequestWithSubURL:BTTIsBindStatusAPI paramters:pramas completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (result.code_http == 200) {
            if (result.data) {
                BTTBindStatusModel *model = [[BTTBindStatusModel alloc] initWithDictionary:result.data error:nil];
                self.statusModel = model;
                [self.collectionView reloadData];
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
