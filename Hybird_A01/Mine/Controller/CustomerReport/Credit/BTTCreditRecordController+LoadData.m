//
//  BTTCreditRecordController+LoadData.m
//  Hybird_A01
//
//  Created by Jairo on 22/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTCreditRecordController+LoadData.h"
#import "BTTCreditRecordModel.h"

@implementation BTTCreditRecordController (LoadData)

-(void)loadRecords {
    self.params[@"pageNo"] = [NSNumber numberWithInteger:self.pageNo];
    self.params[@"flags"] = [[NSArray alloc] init];
    [IVNetwork requestPostWithUrl:BTTCustomerReportCredit paramters:self.params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTCreditRecordModel * model = [BTTCreditRecordModel yy_modelWithJSON:result.body];
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
    [IVNetwork requestPostWithUrl:BTTDeleteCreditRecord paramters:self.deleteParams completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
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
