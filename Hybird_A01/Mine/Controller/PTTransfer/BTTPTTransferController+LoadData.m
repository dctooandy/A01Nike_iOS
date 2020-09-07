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
            self.submitBtnEnable = YES;
            [self.collectionView reloadData];
        });
    });
}

- (void)loadTotalAvailableData:(dispatch_group_t)group {
    CGFloat totalAmount = self.balanceModel.balance - [self.balanceModel.platformTotalBalance floatValue];
    self.totalAmount = [PublicMethod stringWithDecimalNumber:totalAmount];
    if (self.totalAmount.floatValue) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BTTPublicBtnEnableNotification object:@"PTTransfer"];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:BTTPublicBtnDisableNotification object:@"PTTransfer"];
    }
    dispatch_group_leave(group);
}

- (void)loadPTGameAmount:(dispatch_group_t)group {
    NSArray *array = self.balanceModel.platformBalances;
    for (NSDictionary *json in array) {
        platformBanlaceModel *model = [platformBanlaceModel yy_modelWithJSON:json];
        if ([model.platformCode isEqualToString:@"039"]) {
            self.ptAmount = model.balance;
            self.gameKind = model.gameKind;
            dispatch_group_leave(group);
            break;
        }
    }
}

- (void)loadCreditsTransfer:(BOOL)isReverse amount:(NSString *)amount transferType:(NSInteger)transferType {
    NSString * urlStr = transferType == 0 ?  BTTTransferAllMoneyToLocal:BTTTransferToGame;
    if ([amount doubleValue]<[self.balanceModel.minWithdrawAmount doubleValue]) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"转账最小金额为%@",self.balanceModel.minWithdrawAmount] toView:nil];
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:@"A01039" forKey:@"gameCode"];
        [params setValue:self.gameKind forKey:@"gameKind"];
        [params setValue:@1 forKey:@"isQueryBalanceBeforeTransfer"];
        [params setValue:[IVNetwork savedUserInfo].loginName forKey:@"loginName"];
        [self showLoading];
        [IVNetwork requestPostWithUrl:urlStr paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
            [self hideLoading];
            IVJResponseObject *result = response;
            if ([result.head.errCode isEqualToString:@"0000"]) {
                [MBProgressHUD showSuccess:@"转账成功" toView:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showError:result.head.errMsg toView:nil];
            }
        }];
    }
}

@end
