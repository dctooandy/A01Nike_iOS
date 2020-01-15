//
//  BTTModifyLimitViewController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 22/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTModifyLimitViewController+LoadData.h"
#import "BTTBetLimitModel.h"

@implementation BTTModifyLimitViewController (LoadData)


- (void)loadMainData {
    self.agin = [[NSArray alloc]initWithObjects:@"20-50000",@"1000-100000",@"2000-200000",@"10000-500000",@"20000-1000000", nil];
    self.bbin = [[NSArray alloc]initWithObjects:@"20-10000",@"200-20000",@"300-30000",@"400-40000",@"500-50000",@"1000-100000",@"2000-200000",@"3000-300000", nil];
    [self showLoading];
    NSDictionary *params = @{
        @"loginName":[IVNetwork savedUserInfo].loginName
    };
    [IVNetwork requestPostWithUrl:BTTBetLimits paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (result.body && [result.body isKindOfClass:[NSDictionary class]]) {
                self.aginStr = result.body[@"agin"];
                self.bbinStr = result.body[@"bbin"];
                [self.collectionView reloadData];
            }
        }
    }];
    
}

- (void)loadSetBetLimitWithAgin:(NSString *)agin bbin:(NSString *)bbin {
    NSString *contentStr = [NSString stringWithFormat:@"AGIN:%@;BBIN:%@",agin,bbin];
    NSDictionary *params = @{
        @"remarks":contentStr,
        @"loginName":[IVNetwork savedUserInfo].loginName
    };
    [self showLoading];
    [IVNetwork requestPostWithUrl:BTTLimitRedModify paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"修改限红成功" toView:nil];
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}



@end
