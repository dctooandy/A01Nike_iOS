//
//  BTTLiCaiViewController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by JerryHU on 2021/4/29.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTLiCaiViewController+LoadData.h"

@implementation BTTLiCaiViewController (LoadData)
-(void)LoadLiCaiConfig {
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTLiCaiConfig paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if (![self.accountBalance isEqualToString:@"加载中"]) {
            [self hideLoading];
        }
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTLiCaiConfigModel * model = [BTTLiCaiConfigModel yy_modelWithJSON:result.body];
            CGFloat rate = [model.rate floatValue] * 1000000 * 365 /10000;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.interestRate = [PublicMethod stringWithDecimalNumber:rate];
                [self.collectionView reloadData];
            });
        } else {
            [self hideLoading];
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

-(void)loadLocalAmount {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"flag"] = @1;
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTCreditsALL paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if (![self.interestRate isEqualToString:@"加载中"]) {
            [self hideLoading];
        }
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTCustomerBalanceModel *model = [BTTCustomerBalanceModel yy_modelWithJSON:result.body];
            NSString * accountBalance = [PublicMethod stringWithDecimalNumber:model.balance];
            self.accountBalance = accountBalance;
            self.inDetailPopView.accountBalance = accountBalance;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.walletAmount = [PublicMethod stringWithDecimalNumber:model.yebAmount+model.yebInterest];
                [self.collectionView reloadData];
            });
        } else {
            [self hideLoading];
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

-(void)loadTransferInRecords:(ShowOutPopViewCompleteBlock)completeBlock {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"transferType"] = @1;
    params[@"lastDays"] = @365;
    params[@"pageNo"] = @1;
    params[@"pageSize"] = @15;
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTLiCaiTransferRecords paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSMutableArray * arr = [[NSMutableArray alloc] init];
            BTTLiCaiTransferRecordModel * transferModel = [BTTLiCaiTransferRecordModel yy_modelWithJSON:result.body];
            if (transferModel.data.count > 0) {
                for (BTTLiCaiTransferRecordItemModel * model in transferModel.data) {
                    if (model.transferOutTime.length == 0) {
                        arr = [[NSMutableArray alloc] initWithObjects:model, nil];
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completeBlock(arr);
            });
        } else {
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

-(void)transferOut:(TransferCompleteBlock)completeBlock {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"clientType"] = @"4";
    [self showLoading];
    [IVNetwork requestPostWithUrl:@"yeb/transferOut" paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [self loadLocalAmount];
            completeBlock();
        } else {
            [self hideLoading];
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

-(void)transferIn:(NSString *)amount completeBlock:(TransferCompleteBlock)completeBlock {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"clientType"] = @"4";
    params[@"amount"] = amount;
    [self showLoading];
    [IVNetwork requestPostWithUrl:@"yeb/transferIn" paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [self loadLocalAmount];
            completeBlock();
        } else {
            [self hideLoading];
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

@end
