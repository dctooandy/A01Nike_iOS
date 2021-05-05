//
//  BTTLiCaiTransRecordController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 4/28/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTLiCaiTransRecordController+LoadData.h"

@implementation BTTLiCaiTransRecordController (LoadData)

-(void)loadRecords {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"transferType"] = @(self.transferType);
    params[@"lastDays"] = @(self.lastDays);
    params[@"pageNo"] = @(self.page);
    params[@"pageSize"] = @15;
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTLiCaiTransferRecords paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTLiCaiTransferRecordModel * transferModel = [BTTLiCaiTransferRecordModel yy_modelWithJSON:result.body];
            if (transferModel.data.count > 0) {
                [self.modelArr addObjectsFromArray:transferModel.data];
            }
            [self setupElements];
        } else {
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

-(void)loadInterestRecords {
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"lastDays"] = @(self.lastDays);
    params[@"pageNo"] = @(self.page);
    params[@"pageSize"] = @15;
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTLiCaiInterestRecords paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTInterestRecordsModel * model = [BTTInterestRecordsModel yy_modelWithJSON:result.body];
            if (model.data.count > 0) {
                [self.interestModelArr addObjectsFromArray:model.data];
            }
            [self setupElements];
        } else {
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

@end
