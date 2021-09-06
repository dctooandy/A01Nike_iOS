//
//  BTTDiscountsViewController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by Domino on 19/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTDiscountsViewController+LoadData.h"
#import "BTTMakeCallSuccessView.h"

@implementation BTTDiscountsViewController (LoadData)


- (void)makeCallWithPhoneNum:(NSString *)phone captcha:(NSString *)captcha captchaId:(NSString *)captchaId; {
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setValue:captcha forKey:@"captcha"];
    [params setValue:captchaId forKey:@"captchaId"];
    if ([phone containsString:@"*"]) {
        [params setValue:@1 forKey:@"type"];
    } else {
        [params setValue:@0 forKey:@"type"];
    }
    if ([IVNetwork savedUserInfo]) {
            [params setValue:[IVNetwork savedUserInfo].mobileNo forKey:@"mobileNo"];
            [params setValue:[IVNetwork savedUserInfo].loginName forKey:@"loginName"];
        } else {
            [params setValue:phone forKey:@"mobileNo"];
        }
    
        [IVNetwork requestPostWithUrl:BTTCallBackAPI paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
            IVJResponseObject *result = response;
            if ([result.head.errCode isEqualToString:@"0000"]) {
                [self showCallBackSuccessView];
            }else{
                NSString *errInfo = [NSString stringWithFormat:@"申请失败,%@",result.head.errMsg];
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
    [self showLoading];
    NSString *name = [IVNetwork savedUserInfo] ? [IVNetwork savedUserInfo].loginName : @"";
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:name forKey:@"loginName"];
    [params setValue:@"promo" forKey:@"promoName"];
    [IVNetwork requestPostWithUrl:BTTPromotionAndHistoryList paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        [self hideLoading];
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (![result.body isKindOfClass:[NSNull class]]) {
                [self.sheetDatas removeAllObjects];
                [self endRefreshing];
                
                NSMutableArray * arr = [[NSMutableArray alloc] init];
                self.model = [BTTPromotionModel yy_modelWithDictionary:result.body];
                for (BTTPromotionProcessModel *item in self.model.process) {
                    [arr addObject:item];
                }
                
                NSMutableArray * strArr = [[NSMutableArray alloc] init];
                for (NSString * key in self.model.history.allKeys) {
                    [strArr addObject:key];
                }
                NSSortDescriptor * sd = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
                self.yearsBtnTitle = [[NSMutableArray alloc] initWithArray:[strArr sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd, nil]]];
                [self setYearsBtnTitle];
                
                if (!self.inProgressView.isHidden) {
                    [self.sheetDatas addObjectsFromArray:arr];
                    [self setupElements];
                } else {
                    [self changeToHistoryPage:self.btnIndex];
                }
            }
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
