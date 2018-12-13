//
//  BTTWithdrawalController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 25/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTWithdrawalController+LoadData.h"
#import "BTTMeMainModel.h"

@implementation BTTWithdrawalController (LoadData)

- (void)loadMainData {
    [self.sheetDatas removeAllObjects];
    
    NSString *btcrate = [[NSUserDefaults standardUserDefaults] valueForKey:BTTCacheBTCRateKey];
    NSString *rateStr = [NSString stringWithFormat:@"¥%.2lf=1BTC(实时汇率)",[btcrate doubleValue]];
    NSString *depositTotal = self.betInfoModel ? self.betInfoModel.depositTotal : @"";
    NSString *betTotal = self.betInfoModel ? self.betInfoModel.betTotal : @"";
    NSString *currentBet = self.betInfoModel ? self.betInfoModel.currentBet : @"";
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
    NSArray *names3 = @[@"金额(元)",@"比特币",@"取款至",@"登录密码",@""];
    
    NSArray *placeholders1 = @[@"",@""];
    NSArray *placeholders2 = @[@"",@"",@"",@"",@""];
    NSArray *placeholders3 = @[@"最少10元",rateStr,@"***银行-尾号*****",@"请输入游戏账号的登录密码",@""];
    NSArray *heights1 = @[@205.0,@15.0];
    NSArray *heights2 = @[@44.0,@44.0,@44.0,@(notifyHeight),@15.0];
    NSArray *heights3 = @[@44.0,@44.0,@44.0,@44.0,@100.0];
    
    NSArray *canEdits1 = @[@NO,@NO];
    NSArray *canEdits2 = @[@NO,@NO,@NO,@NO,@NO];
    NSArray *canEdits3 = @[@YES,@NO,@NO,@YES,@NO];
    
    NSArray *values1 = @[@"",@""];
    NSArray *values2 = @[depositTotal,betTotal,currentBet,@"",@""];
    NSArray *values3 = @[@"",@"",@"",@"",@""];
 
    NSMutableArray *names = @[].mutableCopy;
    NSMutableArray *placeholders = @[].mutableCopy;
    NSMutableArray *heights = @[].mutableCopy;
    NSMutableArray *canEdits = @[].mutableCopy;
    NSMutableArray *values = @[].mutableCopy;
    NSInteger btcRateIndex = 3;
    if (self.betInfoModel.status) {
        btcRateIndex = 8;
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
    } else {
        btcRateIndex = 3;
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

    if (!self.bankList[self.selectIndex].isBTC) {
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
        [self.sheetDatas addObject:model];
    }
    [self setupElements];
}


- (void)loadCreditsTotalAvailable {
    [self showLoading];
    [IVNetwork sendRequestWithSubURL:BTTCreditsLocal paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        [self hideLoading];
        if (result.code_http == 200 && [result.data isKindOfClass:[NSDictionary class]]) {
            if (result.data) {
                self.totalAvailable = result.data[@"val"];
            }
        } else {
            if (result.message.length) {
                [MBProgressHUD showError:result.message toView:nil];
            }
        }
        [self.collectionView reloadData];
    }];
}
- (void)loadBetInfo
{
    [self showLoading];
    [IVNetwork sendRequestWithSubURL:BTTBetInfo paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        [self hideLoading];
        if (result.code_http == 200 && result.data && [result.data isKindOfClass:[NSDictionary class]]) {
            self.betInfoModel = [[BTTBetInfoModel alloc] initWithDictionary:result.data error:nil];
            self.betInfoModel.status = result.status;
        }
        [self loadMainData];
        [self.collectionView reloadData];
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
