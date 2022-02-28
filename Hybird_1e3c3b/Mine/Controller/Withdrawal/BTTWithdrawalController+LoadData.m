//
//  BTTWithdrawalController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTWithdrawalController+LoadData.h"
#import "BTTMeMainModel.h"
#import "CNPayRequestManager.h"
#import "CNPayUSDTRateModel.h"
#import "BTTBTCRateModel.h"

@implementation BTTWithdrawalController (LoadData)

- (void)requestUSDTRate{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"amount"] = @1;
    params[@"srcCurrency"] = @"CNY";
    params[@"tgtCurrency"] = @"USDT";
    params[@"used"] = @"2";
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    [IVNetwork requestPostWithUrl:BTTCurrencyExchanged paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
//        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (![result.body isKindOfClass:[NSDictionary class]]) {
                return;
            }
            NSError *error;
            CNPayUSDTRateModel *rateModel = [CNPayUSDTRateModel yy_modelWithJSON:result.body];
            if (error && !rateModel) {
                return;
            }
            self.usdtRate = [rateModel.tgtAmount floatValue];
            [self.collectionView reloadData];
        }
    }];
}

- (void)queryBtcRate{
    NSDictionary *params = @{
        @"amount":@"1"
    };
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTWithDrawBTCRate paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTBTCRateModel *model = [BTTBTCRateModel yy_modelWithJSON:result.body];
            self.btcRate = model.btcRate;
        }else{
            
        }
    }];
}


- (void)requestSellUsdtSwitch{
    self.isSellUsdt = NO;
//    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTOneKeySellUSDT paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
//        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSString *isOpen = [NSString stringWithFormat:@"%@",result.body];
            if ([isOpen isEqualToString:@"1"]) {
                self.isSellUsdt = YES;
                [self requestSellUsdtLink];
                
               
            }
            [self.collectionView reloadData];
        }
    }];
}

- (void)requestSellUsdtLink{
//    [self showLoading];
    NSDictionary *params = @{@"transferType":@"1"};
    [IVNetwork requestPostWithUrl:BTTBuyUSDTLINK paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
//        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSString *link = [NSString stringWithFormat:@"%@",result.body[@"payUrl"]];
            self.sellUsdtLink = link;
        }
    }];
}


- (void)requestCustomerInfoEx{
//    BTTGetLoginInfoByNameEx
//    [self showLoading];
    NSDictionary *params = @{
        @"inclPendingWithdraw":@"0",
        @"loginName":[IVNetwork savedUserInfo].loginName
    };
    [IVNetwork requestPostWithUrl:BTTGetLoginInfoByNameEx paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
//        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            self.canWithdraw = [result.body[@"pendingWithdraw"] integerValue];
        }
    }];
}

-(void)getLimitUSDT {
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTUsdtLimit paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            self.dcboxLimit = result.body[@"DCBox"] != nil ? result.body[@"DCBox"]:@"15";
            self.usdtLimit = result.body[@"USDT"] != nil ? result.body[@"USDT"]:@"15";
            self.iChiPayLimit = result.body[@"IChiPay"] != nil ? result.body[@"IChiPay"]:@"15";
            self.cnyLimit = result.body[@"CNY"] != nil ? result.body[@"CNY"]:@"300";
            [self loadMainData];
        }
    }];
}

- (void)loadMainData {
    [self requestUSDTRate];
    if ([IVNetwork savedUserInfo].btcNum>0) {
        [self queryBtcRate];
    }
    
    [self requestCustomerInfoEx];
    [self.sheetDatas removeAllObjects];
    BOOL isUsdt = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"];
    NSMutableArray *sheetDatas = [NSMutableArray array];
    NSString *btcrate = isNull(self.btcRate) ? @"0" : self.btcRate;
    NSString *rateStr = [NSString stringWithFormat:@"¥%.2lf=1BTC(实时汇率)",[btcrate doubleValue]];
    
    NSArray *names1 = @[@"",@"金额"];
    NSArray *names3 = @[@"",@"比特币",@"取款至",@"资金密码",@""];//@[@"金额(元)",@"比特币",@"取款至",@"登录密码",@""];
    NSArray *names4 = @[@"",@"预估到账",@"取款至",@"资金密码",@"",@"",@""];
    
    NSString *pString = isUsdt ? [NSString stringWithFormat:@"单笔取款限额%@-143万USDT", self.usdtLimit] : [NSString stringWithFormat:@"最少%@元", self.cnyLimit];
    if (!isUsdt && ([self.bankList[self.selectIndex].accountType isEqualToString:@"借记卡"]||[self.bankList[self.selectIndex].accountType isEqualToString:@"信用卡"]||[self.bankList[self.selectIndex].accountType isEqualToString:@"存折"])) {
        pString = [NSString stringWithFormat:@"最少%@元", self.cnyLimit ? self.cnyLimit: @"300"];
    }
    if (isUsdt && [self.bankList[self.selectIndex].accountType isEqualToString:@"DCBOX"]) {
        pString = [NSString stringWithFormat:@"单笔取款限额%@-143万USDT", self.dcboxLimit];
    }
    if (UserForzenStatus)
    {
        pString = @"额度已锁定,无法取款";
    }
    NSString * withdrawPwdP = [IVNetwork savedUserInfo].withdralPwdFlag == 0 ? @"没有资金密码？点击设置资金密码":@"6位数字组合";
    BOOL withdrawPwdCanEdits = [IVNetwork savedUserInfo].withdralPwdFlag == 0 ? false:true;
    
    NSArray *placeholders1 = @[@"",pString];
    NSArray *placeholders3 = @[@"",rateStr,@"***银行-尾号*****",withdrawPwdP,@"",@""];
    NSArray *placeholders4 = @[@"",@"USDT",@"***银行-尾号*****",withdrawPwdP,@"",@"",@"",@""];
    NSArray *heights1 = @[@205.0,@44.0];
    NSArray *heights3 = @[@0.0,@44.0,@44.0,@44.0,@100.0];
    NSArray *heights4 = @[@0.0,@44.0,@44,@44,@44.0,@46.0,@240.0];
    
    NSArray *canEdits1 = @[@NO,@YES];
    NSArray *canEdits3 = @[@NO,@NO,@NO,@(withdrawPwdCanEdits),@NO];
    NSArray *canEdits4 = @[@NO,@NO,@NO,@(withdrawPwdCanEdits),@NO,@NO,@NO];
    
    NSArray *values1 = @[@"",@""];
    NSArray *values3 = @[@"",@"",@"",@"",@""];
    NSArray *values4 = @[@"",@"",@"",@"",@"",@"",@""];
    
    if (self.isMatchWithdrew) {
        //撮合系统金额列表
        
        names3 = @[@"",@"比特币",@"取款至",@"资金密码",@"联系客服",@""];//@[@"金额(元)",@"比特币",@"取款至",@"登录密码",@""];
        names4 = @[@"",@"预估到账",@"取款至",@"资金密码",@"联系客服",@"",@"",@""];
        
        NSUInteger lineCount = self.checkModel.data.amountList.count / 3 > 0 ? self.checkModel.data.amountList.count / 3 : 1;
        CGFloat matchWithdrewAmountH = 32 * lineCount + 16 + 8 * (lineCount - 1);
        heights1 = @[@205.0,@(matchWithdrewAmountH)];
        if (lineCount > 1) {
            heights3 = @[@15.0,@44.0,@44.0,@44.0,@302.0,@100.0];
            heights4 = @[@15.0,@44.0,@44,@44,@302.0,@44.0,@46.0,@240.0];
        } else {
            heights3 = @[@0.0,@44.0,@44.0,@44.0,@302.0,@100.0];
            heights4 = @[@0.0,@44.0,@44,@44,@302.0,@44.0,@46.0,@240.0];
        }
        canEdits3 = @[@NO,@NO,@NO,@(withdrawPwdCanEdits),@NO,@NO];
        canEdits4 = @[@NO,@NO,@NO,@(withdrawPwdCanEdits),@NO,@NO,@NO,@NO];
        
        values3 = @[@"",@"",@"",@"",@"",@""];
        values4 = @[@"",@"",@"",@"",@"",@"",@"",@""];
    }
    
 
    NSMutableArray *names = @[].mutableCopy;
    NSMutableArray *placeholders = @[].mutableCopy;
    NSMutableArray *heights = @[].mutableCopy;
    NSMutableArray *canEdits = @[].mutableCopy;
    NSMutableArray *values = @[].mutableCopy;
    NSInteger btcRateIndex = 3;
    if ([self.bankList[self.selectIndex].accountType isEqualToString:@"借记卡"]||[self.bankList[self.selectIndex].accountType isEqualToString:@"信用卡"]||[self.bankList[self.selectIndex].accountType isEqualToString:@"存折"]||[self.bankList[self.selectIndex].accountType isEqualToString:@"BTC"]) {
        [names addObjectsFromArray:names1];
        [names addObjectsFromArray:names3];
        [placeholders addObjectsFromArray:placeholders1];
        [placeholders addObjectsFromArray:placeholders3];
        [heights addObjectsFromArray:heights1];
        [heights addObjectsFromArray:heights3];
        [canEdits addObjectsFromArray:canEdits1];
        [canEdits addObjectsFromArray:canEdits3];
        [values addObjectsFromArray:values1];
        [values addObjectsFromArray:values3];
    }else{
        [names addObjectsFromArray:names1];
        [names addObjectsFromArray:names4];
        [placeholders addObjectsFromArray:placeholders1];
        [placeholders addObjectsFromArray:placeholders4];
        [heights addObjectsFromArray:heights1];
        [heights addObjectsFromArray:heights4];
        [canEdits addObjectsFromArray:canEdits1];
        [canEdits addObjectsFromArray:canEdits4];
        [values addObjectsFromArray:values1];
        [values addObjectsFromArray:values4];
    }

    if ([self.bankList[self.selectIndex].accountType isEqualToString:@"借记卡"]||[self.bankList[self.selectIndex].accountType isEqualToString:@"信用卡"]||[self.bankList[self.selectIndex].accountType isEqualToString:@"存折"]) {
        [names removeObjectAtIndex:btcRateIndex];
        [placeholders removeObjectAtIndex:btcRateIndex];
        [heights removeObjectAtIndex:btcRateIndex];
        [canEdits removeObjectAtIndex:btcRateIndex];
        [values removeObjectAtIndex:btcRateIndex];
    }
    if (isUsdt) {
        [heights replaceObjectAtIndex:3 withObject:@0];
    }
    if ([self.bankList[self.selectIndex].bankName isEqualToString:@"BITOLL"]||[self.bankList[self.selectIndex].bankName isEqualToString:@"DCBOX"]) {
        [names removeObjectAtIndex:6];
        [placeholders removeObjectAtIndex:6];
        [heights removeObjectAtIndex:6];
        [canEdits removeObjectAtIndex:6];
        [values removeObjectAtIndex:6];
    }
    for (NSInteger index = 0; index < names.count; index++) {
        BTTMeMainModel *model = [[BTTMeMainModel alloc] init];
        model.name = names[index];
        model.iconName = placeholders[index];
        model.cellHeight = [heights[index] doubleValue];
        model.available = [canEdits[index] boolValue];
        model.desc = values[index];
        [sheetDatas addObject:model];
    }
    self.sheetDatas = sheetDatas.mutableCopy;
    [self setupElements];
}


- (void)loadCreditsTotalAvailable {
    [self showLoading];
    NSDictionary *params = @{@"loginName":[IVNetwork savedUserInfo].loginName,@"flag":@1};
    [IVNetwork requestPostWithUrl:BTTCreditsALL paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTCustomerBalanceModel *model = [BTTCustomerBalanceModel yy_modelWithJSON:result.body];
            self.balanceModel = model;
            self.totalAvailable = [PublicMethod stringWithDecimalNumber:model.withdrawBal];
            self.dcboxLimit = model.minWithdrawAmount != nil ? model.minWithdrawAmount:@"15";
            self.usdtLimit = model.minWithdrawAmount != nil ? model.minWithdrawAmount:@"15";
            self.iChiPayLimit = model.minWithdrawAmount != nil ? model.minWithdrawAmount:@"15";
            self.cnyLimit = model.minWithdrawAmount != nil ? model.minWithdrawAmount:@"300";
            dispatch_async(dispatch_get_main_queue(), ^{;
                [self loadMainData];
                [self.collectionView reloadData];
            });
        }
    }];
}

- (NSMutableArray *)sheetDatas {
    NSMutableArray *sheetDatas = objc_getAssociatedObject(self, _cmd);
    if (!sheetDatas) {
        sheetDatas = [NSMutableArray array];
        [self setSheetDatas:sheetDatas];
    }
    return sheetDatas;
}

- (void)setSheetDatas:(NSMutableArray *)sheetDatas {
    objc_setAssociatedObject(self, @selector(sheetDatas), sheetDatas, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



@end
