//
//  BTTVIPClubPageViewController+LoadData.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/5/4.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTVIPClubPageViewController+LoadData.h"
#import "BTTActivityModel.h"
#import "BTTMakeCallSuccessView.h"

static const char *BTTNextGroupKey = "nextGroup";
@implementation BTTVIPClubPageViewController (LoadData)

- (void)loadDataOfVIPClubPage
{
//    [self loadHeadersData];
//    [self loadGamesData];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("vipclubpage.data", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_group_enter(group);
//    [self loadMainData:group];
//    dispatch_group_enter(group);
//    [self loadScrollText:group];
//    dispatch_group_enter(group);
//    [self loadOtherData:group];

    dispatch_group_enter(group);
    [self loadHightlightsBrand:group];

    dispatch_group_notify(group,queue, ^{
//        [self endRefreshing];
        [self setupElements];
    });
}
- (void)loadHightlightsBrand:(dispatch_group_t)group {
    NSMutableArray *activities = [NSMutableArray array];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"formName"] = @"brandHighlights";
    params[@"dataType"] = @"1";
    [IVNetwork requestPostWithUrl:BTTBrandHighlights paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (result.body) {
                [self.activities removeAllObjects];
                for (NSDictionary *imageDict in result.body) {
                    BTTActivityModel *model = [BTTActivityModel yy_modelWithDictionary:imageDict];
                    [activities addObject:model];
                }
                self.activities = activities.mutableCopy;
            }
        }
        dispatch_group_leave(group);
    }];
}
- (void)makeCallWithPhoneNum:(NSString *)phone captcha:(NSString *)captcha captchaId:(NSString *)captchaId {
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
#pragma mark - 动态添加属性
- (void)setNextGroup:(NSInteger)nextGroup {
    objc_setAssociatedObject(self, &BTTNextGroupKey, @(nextGroup), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)nextGroup {
    return [objc_getAssociatedObject(self, &BTTNextGroupKey) integerValue];
}
- (NSMutableArray *)activities {
    NSMutableArray *activities = objc_getAssociatedObject(self, _cmd);
    if (!activities) {
        activities = [NSMutableArray array];
        [self setActivities:activities];
    }
    return activities;
}

- (void)setActivities:(NSMutableArray *)activities {
    objc_setAssociatedObject(self, @selector(activities), activities, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
