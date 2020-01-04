//
//  BTTDiscountsViewController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 19/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTDiscountsViewController+LoadData.h"
#import "BTTPromotionModel.h"
#import "BTTMakeCallSuccessView.h"

@implementation BTTDiscountsViewController (LoadData)


- (void)makeCallWithPhoneNum:(NSString *)phone {
    NSString *url = nil;
    NSMutableDictionary *params = @{}.mutableCopy;
    int currentHour = [PublicMethod hour:[NSDate date]];
    if ([IVNetwork savedUserInfo]) {
        if ([phone containsString:@"*"]) {
            url = BTTCallBackMemberAPI;
            [params setValue:phone forKey:@"phone"];
            [params setValue:@"memberphone" forKey:@"phone_type"];
        } else {
            if ([IVNetwork savedUserInfo].starLevel > 4 && currentHour >= 12) {
                url = BTTCallBackMemberAPI;
                [params setValue:phone forKey:@"phone"];
                [params setValue:@"memberphone" forKey:@"phone_type"];
            } else {
                url = BTTCallBackCustomAPI;
                [params setValue:phone forKey:@"phone_number"];
                
            }
        }
    } else {
        url = BTTCallBackCustomAPI;
        [params setValue:phone forKey:@"phone_number"];
    }
    
    [IVNetwork sendRequestWithSubURL:url paramters:params.copy completionBlock:^(IVRequestResultModel *result, id response) {
        
        if (result.status) {
            [self showCallBackSuccessView];
        } else {
            NSString *errInfo = [NSString stringWithFormat:@"申请失败,%@",result.message];
            [MBProgressHUD showError:errInfo toView:nil];
        }
    }];
}

- (void)showCallBackSuccessView {
    BTTMakeCallSuccessView *customView = [BTTMakeCallSuccessView viewFromXib];
    customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    customView.dismissBlock = ^{
        [popView dismiss];
    };
    customView.btnBlock = ^(UIButton *btn) {
        [popView dismiss];
    };
}


- (void)loadMainData {
    if (self.discountsVCType == BTTDiscountsVCTypeDetail) {
        [self showLoading];
    }
    NSString *name = [IVNetwork savedUserInfo] ? [IVNetwork savedUserInfo].loginName : @"";
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:name forKey:@"loginName"];
    [params setValue:@"promo" forKey:@"promoName"];
    [IVNetwork requestPostWithUrl:BTTPromotionList paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (![result.body isKindOfClass:[NSNull class]]) {
                [self.sheetDatas removeAllObjects];
                NSLog(@"%@",response);
                [self endRefreshing];
                for (NSDictionary *dict in result.body) {
                    BTTPromotionModel *model = [BTTPromotionModel yy_modelWithDictionary:dict];
                    [self.sheetDatas addObject:model];
                }
                [self setupElements];
            }
        }
    }];
   
}

- (void)getLive800InfoDataWithResponse:(BTTLive800ResponseBlock)responseBlock {
    [IVNetwork sendRequestWithSubURL:@"users/getLiveUrl" paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        if (result.status) {
            responseBlock(result.data[@"info"]);
        }
    }];
}


- (NSMutableArray *)sheetDatas {
    NSMutableArray *sheetDatas = objc_getAssociatedObject(self, _cmd);
    if (!sheetDatas) {
        sheetDatas = [NSMutableArray array];
        [self setSheetDatas:sheetDatas];
    }
    return sheetDatas;
}

- (void)setSheetDatas:(NSMutableArray *)sheetDatas {
    objc_setAssociatedObject(self, @selector(sheetDatas), sheetDatas, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
