//
//  BTTActivityManager.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/7/19.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTActivityManager.h"
#import "BTTSevenXiPriHotPopView.h"
#import "BTTBaseWebViewController.h"
@interface BTTActivityManager()

@end
@implementation BTTActivityManager
//SingletonImplementation(BTTUserForzenManager);
static BTTActivityManager * sharedSingleton;
+ (void)initialize
{
    static BOOL initialized = NO;
    if (!initialized)
    {
        initialized = YES;
        sharedSingleton = [[BTTActivityManager alloc] init];
        [sharedSingleton setNoti];
    }
}
+ (BTTActivityManager *)sharedInstance
{
    return sharedSingleton;
}
- (void)setNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkSevenXiDate) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUserForzenPopViewByNoti) name:@"showUserForzenPopView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkForMobileNumAndCode) name:@"gotoUserForzenVC" object:nil];
    
}
#pragma mark - 检查七夕预热弹窗是否已启用过
-(void)checkSevenXiDate
{
    NSString * showSevenXiDate = [[NSUserDefaults standardUserDefaults] objectForKey:BTTShowSevenXi];
    NSString * realLastLoginDate = [[NSUserDefaults standardUserDefaults] objectForKey:BTTBeforeLoginDate];
    NSString * registDate = [[NSUserDefaults standardUserDefaults] objectForKey:BTTRegistDate];
    if (showSevenXiDate == nil)
    {
        NSString *currentDate = [PublicMethod getCurrentTimesWithFormat:@"yyyy-MM-dd HH:mm:ss" ];
        [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:BTTShowSevenXi];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (realLastLoginDate && ![realLastLoginDate isEqualToString:@"NO"])
        {
            if (![PublicMethod isDateToday:[PublicMethod transferDateStringToDate:realLastLoginDate]]) {
                [self showSevenXiPriHotPopView];
            }else if ([PublicMethod isDateToday:[PublicMethod transferDateStringToDate:registDate]]) 
            {
                [self showSevenXiPriHotPopView];
            }
        }else
        {
            [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:BTTBeforeLoginDate];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self showSevenXiPriHotPopView];
        }
    }else{
        if (![PublicMethod isDateToday:[PublicMethod transferDateStringToDate:showSevenXiDate]])
        {
            NSString *currentDate = [PublicMethod getCurrentTimesWithFormat:@"yyyy-MM-dd HH:mm:ss" ];
            [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:BTTShowSevenXi];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self showSevenXiPriHotPopView];
        }
    }
    
}
-(void)loadSevenXiDatawWithCompletionBlock:(SevenXiCallBack _Nullable)completionBlock
{
    //等待正确API参数
    NSMutableDictionary *params = @{}.mutableCopy;
//    params[@"messageId"] = messageID;
//    params[@"smsCode"] = sCode;
//    params[@"use"] = @22;
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:BTTSevenXiDataBridge paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"取得资料成功!" toView:nil];
            if (completionBlock)
            {
                completionBlock(response,error);
            }
        }else{

            [MBProgressHUD showError:result.head.errMsg toView:nil];
            if (completionBlock)
            {
                completionBlock(nil,result.head.errMsg);
            }
        }
    }];
}
- (void)showSevenXiPriHotPopView
{
    BTTSevenXiPriHotPopView *alertView = [BTTSevenXiPriHotPopView viewFromXib];
    
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:alertView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
    
    popView.isClickBGDismiss = YES;
    [popView pop];
    weakSelf(weakSelf)
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    alertView.dismissBlock = ^{
        [popView dismiss];
        
    };
    alertView.btnBlock = ^(UIButton * _Nullable btn) {
        BTTBaseWebViewController *vc = [BTTBaseWebViewController new];
        vc.webConfigModel.newView = YES;
        vc.webConfigModel.theme = @"outside";
        vc.webConfigModel.url = @"history";
        [[weakSelf currentViewController].navigationController pushViewController:vc animated:YES];
    };

}

- (UIViewController*)topMostWindowController
{
    UIWindow *win = [UIApplication sharedApplication].delegate.window;
    UIViewController *topController = [win rootViewController];
    if ([topController isKindOfClass:[UITabBarController class]]) {
        topController = [(UITabBarController *)topController selectedViewController];
    }
    while ([topController presentedViewController])  topController = [topController presentedViewController];
    return topController;
}

- (UIViewController*)currentViewController;
{
    UIViewController *currentViewController = [self topMostWindowController];
    
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    
    return currentViewController;
}
@end
