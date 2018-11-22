//
//  BTTBookMessageController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 22/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBookMessageController+LoadData.h"
#import "BTTSMSEmailModifyModel.h"

@implementation BTTBookMessageController (LoadData)

- (void)loadMainData {
    [self showLoading];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self loadSmsListStatus:group];
    });
    dispatch_group_notify(group, queue, ^{
        [self loadEmailListStatus];
    });
}

- (void)loadSmsListStatus:(dispatch_group_t)group {
    [IVNetwork sendRequestWithSubURL:BTTSmsList paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (result.code_http == 200) {
            if (result.data && [result.data isKindOfClass:[NSDictionary class]]) {
                BTTSMSEmailModifyModel *model = [BTTSMSEmailModifyModel yy_modelWithDictionary:result.data];
                self.smsStatus = model;
            }
        }
        dispatch_group_leave(group);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
}


- (void)loadEmailListStatus{
    [IVNetwork sendRequestWithSubURL:BTTEmailList paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        [self hideLoading];
        NSLog(@"%@",response);
        if (result.code_http == 200) {
            if (result.data && [result.data isKindOfClass:[NSDictionary class]]) {
                BTTSMSEmailModifyModel *model = [BTTSMSEmailModifyModel yy_modelWithDictionary:result.data];
                self.emailStatus = model;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
    }];
}

@end
