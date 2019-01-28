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
    [self showLoading];
    [IVNetwork sendRequestWithSubURL:BTTBetLimits paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        [self hideLoading];
        if (result.status) {
            if (result.data && [result.data isKindOfClass:[NSDictionary class]]) {
                for (NSDictionary *dict in result.data[@"agin"]) {
                    BTTBetLimitModel *model = [BTTBetLimitModel yy_modelWithDictionary:dict];
                    NSString *aginLimit = [NSString stringWithFormat:@"%@~%@",model.min,model.max];
                    [self.agin addObject:aginLimit];
                }
                
                for (NSDictionary *dict in result.data[@"bbin"]) {
                    BTTBetLimitModel *model = [BTTBetLimitModel yy_modelWithDictionary:dict];
                    NSString *bbinLimit = [NSString stringWithFormat:@"%@~%@",model.min,model.max];
                    [self.bbin addObject:bbinLimit];
                }
            }
        }
    }];
    
}

- (void)loadSetBetLimitWithAgin:(NSString *)agin bbin:(NSString *)bbin {
    NSString *contentStr = [NSString stringWithFormat:@"AGIN:%@;BBIN:%@",agin,bbin];
    NSDictionary *params = @{@"content":contentStr};
    [self showLoading];
    [IVNetwork sendRequestWithSubURL:BTTApplyBetLimit paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        [self hideLoading];
        NSLog(@"%@",result);
        if (result.status) {
            if (!result.code_system) {
                [MBProgressHUD showSuccess:@"修改限红成功" toView:nil];
            }
        }
        if (result.message.length) {
            [MBProgressHUD showError:result.message toView:nil];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (NSMutableArray *)agin {
    NSMutableArray *agin = objc_getAssociatedObject(self, _cmd);
    if (!agin) {
        agin = [NSMutableArray array];
        [self setAgin:agin];
    }
    return agin;
}

- (void)setAgin:(NSMutableArray *)agin {
    objc_setAssociatedObject(self, @selector(agin), agin, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)bbin {
    NSMutableArray *bbin = objc_getAssociatedObject(self, _cmd);
    if (!bbin) {
        bbin = [NSMutableArray array];
        [self setBbin:bbin];
    }
    return bbin;
}

- (void)setBbin:(NSMutableArray *)bbin {
    objc_setAssociatedObject(self, @selector(bbin), bbin, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
