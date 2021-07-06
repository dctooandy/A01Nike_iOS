//
//  BTTUserForzenManager.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/7/1.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTUserForzenManager.h"
#import "BTTUserForzenPopView.h"
#import "CLive800Manager.h"
#import "BTTBindingMobileController.h"
#import "BTTUserForzenVerityViewController.h"
#import "BTTPasswordChangeController.h"
@interface BTTUserForzenManager()

@end
@implementation BTTUserForzenManager
//SingletonImplementation(BTTUserForzenManager);
static BTTUserForzenManager * sharedSingleton;
+ (void)initialize
{
    static BOOL initialized = NO;
    if (!initialized)
    {
        initialized = YES;
        sharedSingleton = [[BTTUserForzenManager alloc] init];
        [sharedSingleton setNoti];
    }
}
+ (BTTUserForzenManager *)sharedInstance
{
    return sharedSingleton;
}
- (void)setNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkUserForzen) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUserForzenPopViewByNoti) name:@"showUserForzenPopView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkForMobileNumAndCode) name:@"gotoUserForzenVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unbindUserAccountByNotifi:) name:@"gotoUnBindUser" object:nil];
}
#pragma mark - 检查用户资金冻结
- (void)checkUserForzen{
    ///檢查是否凍結用戶
    ///lockBalanceStatus=1 就是被锁了
    if ([IVNetwork savedUserInfo] && [IVNetwork savedUserInfo].lockBalanceStatus == 1)
    {
        [self showUserForzenPopView];        
    }
}
- (void)showUserForzenPopViewByNoti
{
    [self showUserForzenPopView];
}
- (void)showUserForzenPopView
{
    BTTUserForzenPopView *alertView = [BTTUserForzenPopView viewFromXib];
    NSNumber * days = [NSNumber numberWithInteger:[[IVNetwork savedUserInfo] lockBalanceDays]];
    [alertView setContentMessage:[NSString stringWithFormat:@"%@",days]];
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:alertView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
    
    popView.isClickBGDismiss = YES;
    [popView pop];
    weakSelf(weakSelf)
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    alertView.tapActivity = ^{
        [popView dismiss];
        [weakSelf checkForMobileNumAndCode];
    };
    alertView.tapDismiss = ^{
        [popView dismiss];
    };
    alertView.tapService = ^{
        [popView dismiss];
        [LiveChat startKeFu:[self currentViewController] csServicecompleteBlock:^(CSServiceCode errCode) {
            if (errCode != CSServiceCode_Request_Suc) {//异常处理
                BTTActionSheet *actionSheet = [[BTTActionSheet alloc] initWithTitle:@"请选择问题类型" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"存款问题",@"其他问题"] actionSheetBlock:^(NSInteger buttonIndex) {
                    if (buttonIndex == 0) {
                        [[CLive800Manager sharedInstance] startLive800ChatSaveMoney:[self currentViewController]];
                    }else if (buttonIndex == 1){
                        [[CLive800Manager sharedInstance] startLive800Chat:[self currentViewController]];
                    }
                }];
                [actionSheet show];
            }
        }];
    };
}

- (void)checkForMobileNumAndCode
{
    if ([IVNetwork savedUserInfo].mobileNoBind != 1) {
        ///没有绑定手机
        BOOL isUSDTAcc = [[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"];
        BTTBindingMobileController *vc = [[BTTBindingMobileController alloc] init];
        vc.mobileCodeType = BTTUserForzenTypeBindMobile;
        vc.showNotice = isUSDTAcc;
        [MBProgressHUD showMessagNoActivity:@"请先绑定手机号!" toView:nil];
        [[self currentViewController].navigationController pushViewController:vc animated:YES];
    }else {
        if ([IVNetwork savedUserInfo].withdralPwdFlag == 1) {
            /// 已设置资金密码
            /// 出现验证资金密码VC
            BTTUserForzenVerityViewController *vc = [BTTUserForzenVerityViewController new];
            [[self currentViewController].navigationController pushViewController:vc animated:YES];
            /// 打解锁API
//            [self unbindUserAccount];
        } else {
            /// 未设置资金密码
            BTTPasswordChangeController *vc = [[BTTPasswordChangeController alloc] init];
            vc.selectedType = BTTChangeWithdrawPwd;
            vc.isGoToMinePage = false;
            vc.isGoToUserForzenVC = true;
            [[self currentViewController].navigationController pushViewController:vc animated:YES];
        }
    }
}
- (void)unbindUserAccountByNotifi:(NSNotification *)notifi
{
    NSDictionary * dic = notifi.object;
    if (dic[@"wPassword"])
    {
        weakSelf(weakSelf)
        [self unBindUserForzenAccount:dic[@"wPassword"] completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
            [MBProgressHUD showMessagNoActivity:@"解锁成功!!!" toView:nil];
            [[weakSelf currentViewController].navigationController popToRootViewControllerAnimated:true];
        }];
    }
}
-(void)unBindUserForzenAccount:(NSString *)wPassword completionBlock:(UserForzenCallBack)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"password"] = wPassword;//资金密码
    
    //        params[@"smsCode"] = [HAInitConfig appId];///短信验证码
    
    [IVNetwork requestPostWithUrl:BTTUnlockBalance paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        
        if ([result.head.errCode isEqualToString:@"0000"]) {
            
//            [[self currentViewController].navigationController popToRootViewControllerAnimated:true];
            
            completionBlock(nil,nil);
        }else
        {
            [MBProgressHUD showError:result.head.errMsg toView:nil];
        }
        
    }];
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
