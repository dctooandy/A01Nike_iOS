//
//  BTTWithdrawRecordController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 05/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTWithdrawRecordController+LoadData.h"
#import "BTTWithdrawRecordModel.h"

@implementation BTTWithdrawRecordController (LoadData)

-(void)loadRecords {
    self.params[@"pageNo"] = [NSNumber numberWithInteger:self.pageNo];
    [IVNetwork requestPostWithUrl:BTTCustomerReportWithdraw paramters:self.params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTWithdrawRecordModel * model = [BTTWithdrawRecordModel yy_modelWithJSON:result.body];
            self.model = model;
            if (model.data.count) {
                [self.modelArr addObjectsFromArray:self.model.data];
            }
            [self setupElements];
        } else {
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

-(void)deleteRecords {
    [IVNetwork requestPostWithUrl:BTTDeleteWithdrawRecord paramters:self.deleteParams completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            self.pageNo = 1;
            [self.modelArr removeAllObjects];
            [self loadRecords];
        } else {
            [self hideLoading];
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

-(void)cancelRequest:(NSString *)referenceId {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    dict[@"referenceId"] = referenceId;
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTCancelWithdrawRequest paramters:dict completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            self.pageNo = 1;
            [self.modelArr removeAllObjects];
            [self loadRecords];
        } else {
            [self hideLoading];
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

@end
