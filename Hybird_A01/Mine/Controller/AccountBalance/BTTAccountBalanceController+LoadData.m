//
//  BTTAccountBalanceController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 19/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTAccountBalanceController+LoadData.h"

@implementation BTTAccountBalanceController (LoadData)

- (void)loadLocalAmount {
    [self showLoading];
    [IVNetwork sendRequestWithSubURL:BTTCreditsLocal paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        [self hideLoading];
        NSLog(@"%@",response);
        if (result.code_http == 200) {
            if (result.data && ![result.data isKindOfClass:[NSNull class]]) {
                self.amount = result.data[@"val"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            }
        }
    }];
}

- (void)loadGamesListAndGameAmount {
    dispatch_queue_t queue = dispatch_queue_create("gamesListAndGameAmount.queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        // 追加任务1
        [self loadGameshallList];
    });
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
}

- (void)loadGameshallList {
    [IVNetwork sendRequestWithSubURL:BTTGamePlatforms paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
    }];
}

@end
