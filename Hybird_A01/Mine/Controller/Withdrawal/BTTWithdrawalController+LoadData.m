//
//  BTTWithdrawalController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTWithdrawalController+LoadData.h"
#import "BTTMeMainModel.h"
#import "CNPayRequestManager.h"
#import "CNPayUSDTRateModel.h"

@implementation BTTWithdrawalController (LoadData)

- (void)requestUSDTRate{
    [CNPayRequestManager getUSDTRateWithAmount:@"1" tradeType:@"02" target:@"cny" completeHandler:^(IVRequestResultModel *result, id response) {
        [self hideLoading];
        if (![result.data isKindOfClass:[NSDictionary class]]) {
            // 后台返回类型不一，全部转成字符串
            return;
        }
        
        NSError *error;
        CNPayUSDTRateModel *rateModel = [CNPayUSDTRateModel yy_modelWithJSON:result.data];
        if (error && !rateModel) {
            return;
        }
        self.usdtRate = [rateModel.tgtAmount floatValue];
        [self.collectionView reloadData];
    }];
}

- (void)loadMainData {
    [self requestUSDTRate];
    [self.sheetDatas removeAllObjects];
    NSMutableArray *sheetDatas = [NSMutableArray array];
    NSString *btcrate = [[NSUserDefaults standardUserDefaults] valueForKey:BTTCacheBTCRateKey];
    NSString *rateStr = [NSString stringWithFormat:@"¥%.2lf=1BTC(实时汇率)",[btcrate doubleValue]];
    NSString *depositTotal = self.betInfoModel.depositTotal.length ? self.betInfoModel.depositTotal : @"";
    NSString *betTotal = self.betInfoModel.betTotal.length ? self.betInfoModel.betTotal : @"";
    NSString *currentBet = self.betInfoModel.betTotal.length ? self.betInfoModel.currentBet : @"";
    CGFloat differenceBet = [self.betInfoModel.differenceBet doubleValue];
    NSString *canWithdrawTitle = @"尚不可取款";
    CGFloat notifyHeight = 44.0;
    if (differenceBet > 0.0) {
        canWithdrawTitle = @"尚不可取款";
        notifyHeight = [self.betInfoModel.notiyStr boundingRectWithSize:CGSizeMake(180, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 30;
    } else {
        canWithdrawTitle = @"可取款";
    }
    
    NSArray *names1 = @[@"",@""];
    NSArray *names2 = @[@"本次存款金额",@"需要达到的投注额",@"已经达成的投注额",canWithdrawTitle,@""];
    NSArray *names3 = @[@"金额(元)",@"比特币",@"取款至",@""];//@[@"金额(元)",@"比特币",@"取款至",@"登录密码",@""];
    NSArray *names4 = @[@"金额(元)",@"预估到账",@"取款至",@"",@""];
    
    NSArray *placeholders1 = @[@"",@""];
    NSArray *placeholders2 = @[@"",@"",@"",@"",@""];
    NSArray *placeholders3 = @[@"最少10元",rateStr,@"***银行-尾号*****",@""];
    NSArray *placeholders4 = @[@"最少10元",@"USDT",@"***银行-尾号*****",@"",@""];
    NSArray *heights1 = @[@205.0,@15.0];
    NSArray *heights2 = @[@44.0,@44.0,@80.0,@(notifyHeight),@15.0];
    NSArray *heights3 = @[@44.0,@44.0,@80.0,@100.0];
    NSArray *heights4 = @[@44.0,@44.0,@80,@27,@100.0];
    
    NSArray *canEdits1 = @[@NO,@NO];
    NSArray *canEdits2 = @[@NO,@NO,@NO,@NO,@NO];
    NSArray *canEdits3 = @[@YES,@NO,@NO,@NO];
    NSArray *canEdits4 = @[@YES,@NO,@NO,@NO,@NO];
    
    NSArray *values1 = @[@"",@""];
    NSArray *values2 = @[depositTotal,betTotal,currentBet,@"",@""];
    NSArray *values3 = @[@"",@"",@"",@""];
    NSArray *values4 = @[@"",@"",@"",@"",@""];
 
    NSMutableArray *names = @[].mutableCopy;
    NSMutableArray *placeholders = @[].mutableCopy;
    NSMutableArray *heights = @[].mutableCopy;
    NSMutableArray *canEdits = @[].mutableCopy;
    NSMutableArray *values = @[].mutableCopy;
    NSInteger btcRateIndex = 3;
    if (self.betInfoModel.status) {
        btcRateIndex = 8;
        
        if (self.bankList[self.selectIndex].cardType==3) {
            [names addObjectsFromArray:names1];
            [names addObjectsFromArray:names2];
            [names addObjectsFromArray:names4];
            [placeholders addObjectsFromArray:placeholders1];
            [placeholders addObjectsFromArray:placeholders2];
            [placeholders addObjectsFromArray:placeholders4];
            [heights addObjectsFromArray:heights1];
            [heights addObjectsFromArray:heights2];
            [heights addObjectsFromArray:heights4];
            [canEdits addObjectsFromArray:canEdits1];
            [canEdits addObjectsFromArray:canEdits2];
            [canEdits addObjectsFromArray:canEdits4];
            [values addObjectsFromArray:values1];
            [values addObjectsFromArray:values2];
            [values addObjectsFromArray:values4];
        }else{
            [names addObjectsFromArray:names1];
            [names addObjectsFromArray:names2];
            [names addObjectsFromArray:names3];
            [placeholders addObjectsFromArray:placeholders1];
            [placeholders addObjectsFromArray:placeholders2];
            [placeholders addObjectsFromArray:placeholders3];
            [heights addObjectsFromArray:heights1];
            [heights addObjectsFromArray:heights2];
            [heights addObjectsFromArray:heights3];
            [canEdits addObjectsFromArray:canEdits1];
            [canEdits addObjectsFromArray:canEdits2];
            [canEdits addObjectsFromArray:canEdits3];
            [values addObjectsFromArray:values1];
            [values addObjectsFromArray:values2];
            [values addObjectsFromArray:values3];
        }
        
    } else {
        btcRateIndex = 3;
        if (self.bankList[self.selectIndex].cardType==3) {
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
        }else{
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
        }
        
    }

    if (self.bankList[self.selectIndex].cardType==0) {
        [names removeObjectAtIndex:btcRateIndex];
        [placeholders removeObjectAtIndex:btcRateIndex];
        [heights removeObjectAtIndex:btcRateIndex];
        [canEdits removeObjectAtIndex:btcRateIndex];
        [values removeObjectAtIndex:btcRateIndex];
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
//    [self showLoading];
    //TODO:
//    [IVNetwork sendRequestWithSubURL:BTTCreditsTotalAvailable paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
////        [self hideLoading];
//        if (result.status && [result.data isKindOfClass:[NSDictionary class]]) {
//            if (result.data) {
//                self.totalAvailable = result.data[@"val"];
//            }
//        } else {
//            if (result.message.length) {
//                [MBProgressHUD showError:result.message toView:nil];
//            }
//        }
//        [self.collectionView reloadData];
//    }];
}
- (void)loadBetInfo
{
//    [self showLoading];
    //TODO:
//    [IVNetwork sendRequestWithSubURL:BTTBetInfo paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
////        [self hideLoading];
//        if (result.status && result.data && [result.data isKindOfClass:[NSDictionary class]]) {
//            self.betInfoModel = [[BTTBetInfoModel alloc] initWithDictionary:result.data error:nil];
//            self.betInfoModel.status = result.status;
//        }
//        [self loadMainData];
//        [self.collectionView reloadData];
//    }];
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
