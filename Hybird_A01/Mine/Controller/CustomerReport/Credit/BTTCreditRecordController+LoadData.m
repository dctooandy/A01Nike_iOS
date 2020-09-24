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

-(void)loadAllRecords {
    [self showLoading];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("creditRecords.data", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_enter(group);
    [self loadCreditRecords:group];
    
    dispatch_group_enter(group);
    [self loadXmRecord:group];
    
    dispatch_group_notify(group,queue, ^{
        [self hideLoading];
        [self setupElements];
    });
}

-(void)loadCreditRecords:(dispatch_group_t)group {
    self.params[@"pageNo"] = [NSNumber numberWithInteger:self.pageNo];
    self.params[@"flags"] = [[NSArray alloc] init];
    [IVNetwork requestPostWithUrl:BTTCustomerReportCredit paramters:self.params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTCreditRecordModel * model = [BTTCreditRecordModel yy_modelWithJSON:result.body];
            if (model.data.count) {
                self.model = model;
                [self.modelArr addObjectsFromArray:self.model.data];
            }
        } else {
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
        dispatch_group_leave(group);
    }];
}

-(void)loadXmRecord:(dispatch_group_t)group {
    self.params[@"pageNo"] = @1;
    self.params[@"flags"] = @"";
    [IVNetwork requestPostWithUrl:BTTCustomerReportCreditXm paramters:self.params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTCreditXmRecordModel * model = [BTTCreditXmRecordModel yy_modelWithJSON:result.body];
            if (model.data.count) {
                self.xmModel = model;
                self.xmModelArr = [[NSMutableArray alloc] initWithArray:self.xmModel.data];
            }
        } else {
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
        dispatch_group_leave(group);
    }];
}

-(void)deleteRecords {
    [IVNetwork requestPostWithUrl:BTTDeleteCreditRecord paramters:self.deleteParams completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [self loadAllRecords];
        } else {
            [self hideLoading];
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
    }];
}

@end
