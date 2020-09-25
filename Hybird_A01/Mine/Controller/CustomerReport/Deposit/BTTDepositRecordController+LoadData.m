//
//  BTTDepositRecordController+LoadData.m
//  Hybird_A01
//
//  Created by Jairo on 25/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTDepositRecordController+LoadData.h"
#import "BTTDepositRecordModel.h"

@implementation BTTDepositRecordController (LoadData)
-(void)loadRecords {
    self.params[@"pageNo"] = [NSNumber numberWithInteger:self.pageNo];
    [IVNetwork requestPostWithUrl:BTTCustomerReportDeposit paramters:self.params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            
            BTTDepositRecordModel * model = [BTTDepositRecordModel yy_modelWithJSON:result.body];
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
    [IVNetwork requestPostWithUrl:BTTDeleteDepositRecord paramters:self.deleteParams completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
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
