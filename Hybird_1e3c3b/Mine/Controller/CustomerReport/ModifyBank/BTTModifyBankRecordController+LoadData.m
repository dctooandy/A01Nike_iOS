//
//  BTTModifyBankRecordController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 22/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTModifyBankRecordController+LoadData.h"
#import "BTTModifyBankRecordModel.h"

@implementation BTTModifyBankRecordController (LoadData)

-(void)loadRecords {
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTCustomerReportBank paramters:self.params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTModifyBankRecordModel * model = [BTTModifyBankRecordModel yy_modelWithJSON:result.body];
            self.model = model;
            [self setupElements];
        } else {
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

@end
