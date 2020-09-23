//
//  BTTWithdrawRecordController+LoadData.m
//  Hybird_A01
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
            if (model.data.count) {
                self.model = model;
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
            [self loadRecords];
        } else {
            [self hideLoading];
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

@end
