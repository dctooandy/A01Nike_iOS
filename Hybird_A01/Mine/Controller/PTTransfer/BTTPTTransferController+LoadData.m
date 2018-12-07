//
//  BTTPTTransferController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 20/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTPTTransferController+LoadData.h"

@implementation BTTPTTransferController (LoadData)

- (void)loadMainData {
    [self showLoading];
    dispatch_queue_t queue = dispatch_queue_create("ptt.data", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self loadTotalAvailableData:group];
    });
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self loadPTGameAmount:group];
    });
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoading];
            [self.collectionView reloadData];
        });
    });
}

- (void)loadTotalAvailableData:(dispatch_group_t)group {
    [IVNetwork sendRequestWithSubURL:BTTCreditsTotalAvailable paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (result.code_http == 200) {
            if (result.data && ![result.data isKindOfClass:[NSNull class]]) {
                self.totalAmount = result.data[@"val"];
                if (self.totalAmount.floatValue) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:BTTPublicBtnEnableNotification object:@"PTTransfer"];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:BTTPublicBtnDisableNotification object:@"PTTransfer"];
                }
                dispatch_group_leave(group);
            }
        }
    }];
}

- (void)loadPTGameAmount:(dispatch_group_t)group {
    NSDictionary *pramas = @{@"game_name": @"PT"};
    [IVNetwork sendRequestWithSubURL:BTTCreditsGame paramters:pramas completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (result.code_http == 200) {
            if (result.data && ![result.data isKindOfClass:[NSNull class]] && [result.data isKindOfClass:[NSDictionary class]]) {
                self.ptAmount = result.data[@"val"];
                dispatch_group_leave(group);
            }
        }
    }];
}

- (void)loadCreditsTransfer:(BOOL)isReverse amount:(NSString *)amount {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"PT" forKey:@"game_name"];
    [params setObject:amount forKey:@"amount"];
    [params setObject:@(isReverse) forKey:@"type"];
    [self showLoading];
    [IVNetwork sendRequestWithSubURL:BTTCreditsTransfer paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        [self hideLoading];
        NSLog(@"%@",response);
        if (result.message.length) {
            [MBProgressHUD showError:result.message toView:nil];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:BTTPublicBtnDisableNotification object:@"PTTransfer"];
        self.transferAmount = @"加载中";
        [self loadMainData];
    }];
    
    
}

@end
