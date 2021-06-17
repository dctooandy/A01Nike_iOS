//
//  BTTLiCaiViewController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by JerryHU on 2021/4/29.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTLiCaiViewController+LoadData.h"

@implementation BTTLiCaiViewController (LoadData)

-(void)loadYebConfig {
    [IVNetwork requestPostWithUrl:BTTLiCaiConfig paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTLiCaiConfigModel * model = [BTTLiCaiConfigModel yy_modelWithJSON:result.body];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.interestRate = model.yearRate;
                [self.collectionView reloadData];
            });
        } else {
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

-(void)loadInterestSum {
    [self loadServerTime:^(NSString * _Nonnull timeStr) {
        NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
        params[@"beginTime"] = @"2021-04-01 00:00:00";
        params[@"endTime"] = timeStr;

        [IVNetwork requestPostWithUrl:BTTLiCaiInterestSum paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
            IVJResponseObject *result = response;
            if ([result.head.errCode isEqualToString:@"0000"]) {
                NSArray * arr = result.body;
                CGFloat num = arr.count > 0 ? [arr[0][@"sumInterest"] floatValue]: 0.00;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.earn = [PublicMethod stringWithDecimalNumber:[PublicMethod calculateTwoDecimals:num]];
                    [self.collectionView reloadData];
                });
            } else {
                [MBProgressHUD showError:result.head.errMsg toView:nil];
            }
        }];
    }];
}

-(void)loadServerTime:(ServerTimeCompleteBlock)completeBlock {
    [IVNetwork requestPostWithUrl:BTTServerTime paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSDate *timeDate = [[NSDate alloc]initWithTimeIntervalSince1970:[result.body longLongValue]];
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            completeBlock([dateFormatter stringFromDate:timeDate]);
        } else {
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

-(void)loadLocalAmount {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"flag"] = @1;
    params[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    [IVNetwork requestPostWithUrl:BTTCreditsALL paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTCustomerBalanceModel *model = [BTTCustomerBalanceModel yy_modelWithJSON:result.body];
            NSString * accountBalance = [PublicMethod stringWithDecimalNumber:model.localBalance];
            self.accountBalance = accountBalance;
            self.inDetailPopView.accountBalance = accountBalance;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.walletAmount = [PublicMethod stringWithDecimalNumber:[PublicMethod calculateTwoDecimals:(model.yebAmount+model.yebInterest)]];
                [self.collectionView reloadData];
            });
        } else {
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
    [IVNetwork requestPostWithUrl:BTTLiCaiTransferOut paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [self loadLocalAmount];
            [self loadInterestSum];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.walletAmount = @"加载中";
                self.earn = @"加载中";
                [self.collectionView reloadData];
                completeBlock();
            });
        } else {
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

-(void)transferIn:(NSString *)amount completeBlock:(TransferCompleteBlock)completeBlock {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"clientType"] = @"4";
    params[@"amount"] = amount;
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTLiCaiTransferIn paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [self loadLocalAmount];
            completeBlock();
        } else {
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

@end
