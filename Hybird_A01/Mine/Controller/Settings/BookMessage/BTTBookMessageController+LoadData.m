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
    [parmas setObject:@(self.smsStatus.deposit) forKey:@"deposit"];
    [parmas setObject:@(self.smsStatus.withdrawal) forKey:@"withdrawal"];
    [parmas setObject:@(self.smsStatus.promotions) forKey:@"promotions"];
    [parmas setObject:@(self.smsStatus.modify_password) forKey:@"modify_password"];
    [parmas setObject:@(self.smsStatus.modify_banking_data) forKey:@"modify_banking_data"];
    [parmas setObject:@(self.smsStatus.new_website) forKey:@"new_website"];
    [parmas setObject:@(self.smsStatus.modify_account_name) forKey:@"modify_account_name"];
    [parmas setObject:@(self.smsStatus.new_payment_account) forKey:@"new_payment_account"];
    [parmas setObject:@(self.smsStatus.modify_phone) forKey:@"modify_phone"];
    [parmas setObject:@(self.smsStatus.notify_promotions) forKey:@"notify_promotions"];
    [parmas setObject:@(self.smsStatus.regards) forKey:@"regards"];
    [parmas setObject:@(self.smsStatus.login) forKey:@"login"];
    [parmas setObject:@(self.smsStatus.specific_msg) forKey:@"specific_msg"];
    [parmas setObject:@(self.smsStatus.noble_metal) forKey:@"noble_metal"];
    [parmas setObject:@(self.smsStatus.forex) forKey:@"forex"];
    [IVNetwork sendRequestWithSubURL:BTTSmsOrder paramters:parmas completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (result.code_http == 200 && !result.code_system) {
            [MBProgressHUD showSuccess:@"订阅成功" toView:nil];
        } else {
            if (result.message.length) {
                [MBProgressHUD showSuccess:result.message toView:nil];
            }
        }
        dispatch_group_leave(group);
        
    }];
}

- (void)updateEmailStatus {
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    [parmas setObject:@(self.emailStatus.deposit) forKey:@"deposit"];
    [parmas setObject:@(self.emailStatus.withdrawal) forKey:@"withdrawal"];
    [parmas setObject:@(self.emailStatus.promotions) forKey:@"promotions"];
    [parmas setObject:@(self.emailStatus.modify_password) forKey:@"modify_password"];
    [parmas setObject:@(self.emailStatus.modify_banking_data) forKey:@"modify_banking_data"];
    [parmas setObject:@(self.emailStatus.new_website) forKey:@"new_website"];
    [parmas setObject:@(self.emailStatus.modify_account_name) forKey:@"modify_account_name"];
    [parmas setObject:@(self.emailStatus.new_payment_account) forKey:@"new_payment_account"];
    [parmas setObject:@(self.emailStatus.modify_phone) forKey:@"modify_phone"];
    [parmas setObject:@(self.emailStatus.notify_promotions) forKey:@"notify_promotions"];
    [parmas setObject:@(self.emailStatus.regards) forKey:@"regards"];
    [parmas setObject:@(self.emailStatus.login) forKey:@"login"];
    [parmas setObject:@(self.emailStatus.specific_msg) forKey:@"specific_msg"];
    [parmas setObject:@(self.emailStatus.noble_metal) forKey:@"noble_metal"];
    [parmas setObject:@(self.emailStatus.forex) forKey:@"forex"];
    [IVNetwork sendRequestWithSubURL:BTTEmailOrder paramters:parmas completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        [self hideLoading];
        if (result.code_http == 200 && !result.code_system) {
            [MBProgressHUD showSuccess:@"订阅成功" toView:nil];
        } else {
            if (result.message.length) {
                [MBProgressHUD showSuccess:result.message toView:nil];
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)updateSmsStatusModelWithStats:(BOOL)isON indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.smsStatus.deposit = isON;
        self.smsStatus.withdrawal = isON;
        self.smsStatus.promotions = isON;
    } else if (indexPath.row == 2) {
        self.smsStatus.modify_password = isON;
        self.smsStatus.modify_phone = isON;
        self.smsStatus.modify_banking_data = isON;
        self.smsStatus.modify_account_name = isON;
    } else if (indexPath.row == 4) {
        self.smsStatus.new_website = isON;
    } else if (indexPath.row == 5) {
        self.smsStatus.new_payment_account = isON;
    } else if (indexPath.row == 6) {
        self.smsStatus.login = isON;
        self.smsStatus.specific_msg = isON;
        self.smsStatus.regards = isON;
    } else if (indexPath.row == 7) {
        self.smsStatus.notify_promotions = isON;
    } else if (indexPath.row == 8) {
        self.smsStatus.notify_promotions = isON;
        self.smsStatus.login = isON;
        self.smsStatus.specific_msg = isON;
        self.smsStatus.regards = isON;
        self.smsStatus.new_payment_account = isON;
        self.smsStatus.new_website = isON;
        self.smsStatus.modify_password = isON;
        self.smsStatus.modify_phone = isON;
        self.smsStatus.modify_banking_data = isON;
        self.smsStatus.modify_account_name = isON;
        self.smsStatus.deposit = isON;
        self.smsStatus.withdrawal = isON;
        self.smsStatus.promotions = isON;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }
    
}

- (void)updateEmailStatusModelWithStats:(BOOL)isON indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.emailStatus.deposit = isON;
        self.emailStatus.withdrawal = isON;
        self.emailStatus.promotions = isON;
    } else if (indexPath.row == 2) {
        self.emailStatus.modify_password = isON;
        self.emailStatus.modify_phone = isON;
        self.emailStatus.modify_banking_data = isON;
        self.emailStatus.modify_account_name = isON;
    } else if (indexPath.row == 4) {
        self.emailStatus.new_website = isON;
    } else if (indexPath.row == 5) {
        self.emailStatus.new_payment_account = isON;
    } else if (indexPath.row == 6) {
        self.emailStatus.login = isON;
        self.emailStatus.specific_msg = isON;
        self.emailStatus.regards = isON;
    } else if (indexPath.row == 7) {
        self.emailStatus.notify_promotions = isON;
    } else if (indexPath.row == 8) {
        self.emailStatus.notify_promotions = isON;
        self.emailStatus.login = isON;
        self.emailStatus.specific_msg = isON;
        self.emailStatus.regards = isON;
        self.emailStatus.new_payment_account = isON;
        self.emailStatus.new_website = isON;
        self.emailStatus.modify_password = isON;
        self.emailStatus.modify_phone = isON;
        self.emailStatus.modify_banking_data = isON;
        self.emailStatus.modify_account_name = isON;
        self.emailStatus.deposit = isON;
        self.emailStatus.withdrawal = isON;
        self.emailStatus.promotions = isON;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }
    
}


@end
