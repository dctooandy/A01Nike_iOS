//
//  BTTXmTransferRecordController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 25/09/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTXmTransferRecordController+LoadData.h"
#import "BTTXmTransferRecordModel.h"
@implementation BTTXmTransferRecordController (LoadData)
-(void)loadRecords {
    self.params[@"pageNo"] = @1;
    self.params[@"flags"] = @"";
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTCustomerReportCreditXm paramters:self.params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTXmTransferRecordModel * model = [BTTXmTransferRecordModel yy_modelWithJSON:result.body];
            self.model = model;
            [self setupElements];
        } else {
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}
@end
