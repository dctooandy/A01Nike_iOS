//
//  BTTBookMessageController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by Domino on 22/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTBookMessageController+LoadData.h"
#import "BTTSMSEmailModifyModel.h"
#import "BTTSubcribModel.h"

@implementation BTTBookMessageController (LoadData)

- (void)loadMainData {
    [self showLoading];
    dispatch_queue_t queue = dispatch_queue_create("bookmessage.data", DISPATCH_QUEUE_CONCURRENT);
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
    self.smsArray = [NSMutableArray new];
    NSDictionary *params = @{
        @"type":@1,
        @"loginName":[IVNetwork savedUserInfo].loginName
    };
    [IVNetwork requestPostWithUrl:BTTSubscriptionQuery paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSArray *array = result.body;
            BOOL balanceStatus = NO;
            BOOL infoStatus = NO;
            NSMutableArray *elseArray = [[NSMutableArray alloc]initWithObjects:@NO,@NO,@NO,@NO, nil];
            for (NSDictionary *json in array) {
                BTTSubcribModel *model = [BTTSubcribModel yy_modelWithJSON:json];
                if ([model.code isEqualToString:@"DEPOSIT"]) {
                    balanceStatus = model.subscribed==1;
                }else if ([model.code isEqualToString:@"MODIFY_PWD"]){
                    infoStatus = model.subscribed==1;
                }else if ([model.code isEqualToString:@"NEW_WEBSITE"]){
                    [elseArray replaceObjectAtIndex:0 withObject:@(model.subscribed==1)];
                }else if ([model.code isEqualToString:@"PAYMENT_ACCOUNT"]){
                    [elseArray replaceObjectAtIndex:1 withObject:@(model.subscribed==1)];
                }else if ([model.code isEqualToString:@"LOGIN"]){
                    [elseArray replaceObjectAtIndex:2 withObject:@(model.subscribed==1)];
                }else if ([model.code isEqualToString:@"PROMO_ACTIVITY"]){
                    [elseArray replaceObjectAtIndex:3 withObject:@(model.subscribed==1)];
                }
            }
            dispatch_group_leave(group);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.smsArray addObject:@(balanceStatus)];
                [self.smsArray addObject:@(infoStatus)];
                [self.smsArray addObject:elseArray];
//                [self.collectionView reloadData];
            });
        }
    }];
}


- (void)loadEmailListStatus{
    self.emailArray = [NSMutableArray new];
    NSDictionary *params = @{
        @"type":@2,
        @"loginName":[IVNetwork savedUserInfo].loginName
    };
    
    [IVNetwork requestPostWithUrl:BTTSubscriptionQuery paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        [self hideLoading];
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSArray *array = result.body;
            BOOL balanceStatus = NO;
            BOOL infoStatus = NO;
            NSMutableArray *elseArray = [[NSMutableArray alloc]initWithObjects:@NO,@NO,@NO,@NO, nil];
            for (NSDictionary *json in array) {
                BTTSubcribModel *model = [BTTSubcribModel yy_modelWithJSON:json];
                if ([model.code isEqualToString:@"DEPOSIT"]) {
                    balanceStatus = model.subscribed==1;
                }else if ([model.code isEqualToString:@"MODIFY_PWD"]){
                    infoStatus = model.subscribed==1;
                }else if ([model.code isEqualToString:@"NEW_WEBSITE"]){
                    [elseArray replaceObjectAtIndex:0 withObject:@(model.subscribed==1)];
                }else if ([model.code isEqualToString:@"PAYMENT_ACCOUNT"]){
                    [elseArray replaceObjectAtIndex:1 withObject:@(model.subscribed==1)];
                }else if ([model.code isEqualToString:@"LOGIN"]){
                    [elseArray replaceObjectAtIndex:2 withObject:@(model.subscribed==1)];
                }else if ([model.code isEqualToString:@"PROMO_ACTIVITY"]){
                    [elseArray replaceObjectAtIndex:3 withObject:@(model.subscribed==1)];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.emailArray addObject:@(balanceStatus)];
                [self.emailArray addObject:@(infoStatus)];
                [self.emailArray addObject:elseArray];
                [self.collectionView reloadData];
            });
        }
    }];
}

- (void)updateBookStatus {
    [self showLoading];
    dispatch_queue_t queue = dispatch_queue_create("bookmessage.data", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self updateSmsStatus:group];
    });
    dispatch_group_notify(group, queue, ^{
        [self updateEmailStatus];
    });
}

- (void)updateSmsStatus:(dispatch_group_t)group {
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    parmas[@"type"] = @1;
    parmas[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    NSDictionary *json1 = @{@"code":@"DEPOSIT",@"subscribed":@([self.smsArray.firstObject boolValue])};
    NSDictionary *json2 = @{@"code":@"WITHDRAW",@"subscribed":@([self.smsArray.firstObject boolValue])};
    NSDictionary *json3 = @{@"code":@"PROMOTION",@"subscribed":@([self.smsArray.firstObject boolValue])};
    NSDictionary *json4 = @{@"code":@"MODIFY_PWD",@"subscribed":@([self.smsArray[1] boolValue])};
    NSDictionary *json5 = @{@"code":@"MODIFY_BANKCARD",@"subscribed":@([self.smsArray[1] boolValue])};
    NSDictionary *json6 = @{@"code":@"MODIFY_ACCOUNT_NAME",@"subscribed":@([self.smsArray[1] boolValue])};
    NSDictionary *json7 = @{@"code":@"MODIFY_PHONE",@"subscribed":@([self.smsArray[1] boolValue])};
    NSArray *array = self.smsArray.lastObject;
    NSDictionary *json8 = @{@"code":@"NEW_WEBSITE",@"subscribed":@([array[0] boolValue])};
    NSDictionary *json9 = @{@"code":@"PAYMENT_ACCOUNT",@"subscribed":@([array[1] boolValue])};
    NSDictionary *json10 = @{@"code":@"LOGIN",@"subscribed":@([array[2] boolValue])};
    NSDictionary *json11 = @{@"code":@"PROMO_ACTIVITY",@"subscribed":@([array[3] boolValue])};
    NSArray *paramsArray = @[json1,json2,json3,json4,json5,json6,json7,json8,json9,json10,json11];
    parmas[@"subscribes"] = paramsArray;
    [IVNetwork requestPostWithUrl:BTTSubscriptionModify paramters:parmas completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"订阅成功" toView:nil];
        }else{
            [MBProgressHUD showSuccess:result.head.errMsg toView:nil];
        }
        dispatch_group_leave(group);
    }];
}

- (void)updateEmailStatus {
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    parmas[@"type"] = @2;
    parmas[@"loginName"] = [IVNetwork savedUserInfo].loginName;
    NSDictionary *json1 = @{@"code":@"DEPOSIT",@"subscribed":@([self.emailArray.firstObject boolValue])};
    NSDictionary *json2 = @{@"code":@"WITHDRAW",@"subscribed":@([self.emailArray.firstObject boolValue])};
    NSDictionary *json3 = @{@"code":@"PROMOTION",@"subscribed":@([self.emailArray.firstObject boolValue])};
    NSDictionary *json4 = @{@"code":@"MODIFY_PWD",@"subscribed":@([self.emailArray[1] boolValue])};
    NSDictionary *json5 = @{@"code":@"MODIFY_BANKCARD",@"subscribed":@([self.emailArray[1] boolValue])};
    NSDictionary *json6 = @{@"code":@"MODIFY_ACCOUNT_NAME",@"subscribed":@([self.emailArray[1] boolValue])};
    NSDictionary *json7 = @{@"code":@"MODIFY_PHONE",@"subscribed":@([self.emailArray[1] boolValue])};
    NSArray *array = self.emailArray.lastObject;
    NSDictionary *json8 = @{@"code":@"NEW_WEBSITE",@"subscribed":@([array[0] boolValue])};
    NSDictionary *json9 = @{@"code":@"PAYMENT_ACCOUNT",@"subscribed":@([array[1] boolValue])};
    NSDictionary *json10 = @{@"code":@"LOGIN",@"subscribed":@([array[2] boolValue])};
    NSDictionary *json11 = @{@"code":@"PROMO_ACTIVITY",@"subscribed":@([array[3] boolValue])};
    NSArray *paramsArray = @[json1,json2,json3,json4,json5,json6,json7,json8,json9,json10,json11];
    parmas[@"subscribes"] = paramsArray;
    [IVNetwork requestPostWithUrl:BTTSubscriptionModify paramters:parmas completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"订阅成功" toView:nil];
        }else{
            [MBProgressHUD showSuccess:result.head.errMsg toView:nil];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)updateSmsStatusModelWithStats:(BOOL)isON indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.smsArray replaceObjectAtIndex:0 withObject:@(isON)];
    } else if (indexPath.row == 2) {
        [self.smsArray replaceObjectAtIndex:1 withObject:@(isON)];
    } else if (indexPath.row == 4) {
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.smsArray.lastObject];
        [array replaceObjectAtIndex:0 withObject:@(isON)];
        [self.smsArray replaceObjectAtIndex:2 withObject:array];
    } else if (indexPath.row == 5) {
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.smsArray.lastObject];
        [array replaceObjectAtIndex:1 withObject:@(isON)];
        [self.smsArray replaceObjectAtIndex:2 withObject:array];
    } else if (indexPath.row == 6) {
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.smsArray.lastObject];
        [array replaceObjectAtIndex:2 withObject:@(isON)];
        [self.smsArray replaceObjectAtIndex:2 withObject:array];
    } else if (indexPath.row == 7) {
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.smsArray.lastObject];
        [array replaceObjectAtIndex:3 withObject:@(isON)];
        [self.smsArray replaceObjectAtIndex:2 withObject:array];
    } else if (indexPath.row == 8) {
        self.smsArray = [[NSMutableArray alloc]init];
        [self.smsArray addObject:@(isON)];
        [self.smsArray addObject:@(isON)];
        NSArray *array = @[@(isON),@(isON),@(isON),@(isON)];
        [self.smsArray addObject:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }
    
}

- (void)updateEmailStatusModelWithStats:(BOOL)isON indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.emailArray replaceObjectAtIndex:0 withObject:@(isON)];
    } else if (indexPath.row == 2) {
        [self.emailArray replaceObjectAtIndex:1 withObject:@(isON)];
    } else if (indexPath.row == 4) {
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.emailArray.lastObject];
        [array replaceObjectAtIndex:0 withObject:@(isON)];
        [self.emailArray replaceObjectAtIndex:2 withObject:array];
    } else if (indexPath.row == 5) {
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.emailArray.lastObject];
        [array replaceObjectAtIndex:1 withObject:@(isON)];
        [self.emailArray replaceObjectAtIndex:2 withObject:array];
    } else if (indexPath.row == 6) {
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.emailArray.lastObject];
        [array replaceObjectAtIndex:2 withObject:@(isON)];
        [self.emailArray replaceObjectAtIndex:2 withObject:array];
    } else if (indexPath.row == 7) {
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.emailArray.lastObject];
        [array replaceObjectAtIndex:3 withObject:@(isON)];
        [self.emailArray replaceObjectAtIndex:2 withObject:array];
    } else if (indexPath.row == 8) {
        self.emailArray = [[NSMutableArray alloc]init];
        [self.emailArray addObject:@(isON)];
        [self.emailArray addObject:@(isON)];
        NSArray *array = @[@(isON),@(isON),@(isON),@(isON)];
        [self.emailArray addObject:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }
    
}


@end
