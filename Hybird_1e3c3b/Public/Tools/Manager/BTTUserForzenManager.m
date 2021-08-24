//
//  BTTUserForzenManager.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/7/1.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTUserForzenManager.h"
#import "BTTUserForzenPopView.h"
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
    
}
#pragma mark - 检查用户资金冻结
- (void)checkUserForzen{
    ///檢查是否凍結用戶
    ///lockBalanceStatus=1 就是被锁了
    if (UserForzenStatus)
    {
        [self showUserForzenPopView];        
    }
}
- (void)showUserForzenPopViewByNoti
{
    [self checkUserForzen];
}
- (void)showUserForzenPopView
{
    BTTUserForzenPopView *alertView = [BTTUserForzenPopView viewFromXib];
    NSNumber * days = [NSNumber numberWithInteger:[[IVNetwork savedUserInfo] lockBalanceDays]];
    [alertView setuUserForzenContentMessage:days];
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
        [CSVisitChatmanager startWithSuperVC:[self currentViewController] finish:^(CSServiceCode errCode) {
            if (errCode != CSServiceCode_Request_Suc) {
                [MBProgressHUD showErrorWithTime:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持" toView:nil duration:3];
            } else {

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
        vc.mobileCodeType = BTTSafeVerifyTypeUserForzenBindMobile;
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

-(void)unBindUserForzenAccount:(NSString *)wPassword
                     withMessageID:(NSString *)messageID
                     withSCode:(NSString *)sCode
               completionBlock:(UserForzenCallBack)completionBlock
{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"messageId"] = messageID;
    params[@"smsCode"] = sCode;
    params[@"use"] = @22;
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:BTTVerifySmsCode paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            [MBProgressHUD showSuccess:@"验证成功!" toView:nil];
            NSString * messageId = result.body[@"messageId"];
            NSString * validateId = result.body[@"validateId"];
            [weakSelf turenUBindUserForzenAccount:wPassword
                                    withMessageID:messageId
                                        withSCode:sCode
                                   withValidateId:validateId
                                  completionBlock:^(NSString * _Nullable response, NSString * _Nullable error) {
                completionBlock(response,error);
            }];

        }else{

            [MBProgressHUD showError:result.head.errMsg toView:nil];
            completionBlock(nil,result.head.errMsg);
        }
    }];

}
-(void)turenUBindUserForzenAccount:(NSString *)wPassword
                     withMessageID:(NSString *)messageID
                         withSCode:(NSString *)sCode
                    withValidateId:(NSString *)validateId
                   completionBlock:(UserForzenCallBack)completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"password"] = wPassword;//资金密码
    params[@"smsCode"] = sCode;///短信验证码
    params[@"messageId"] = messageID;
    params[@"validateId"] = validateId;
    
    [IVNetwork requestPostWithUrl:BTTUnlockBalance paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        
        if ([result.head.errCode isEqualToString:@"0000"] || [result.head.errCode isEqualToString:@"GW_200001"]) {
            
//            [[self currentViewController].navigationController popToRootViewControllerAnimated:true];
            
            completionBlock(result.head.errMsg,nil);
        }else
        {
            [MBProgressHUD showError:result.head.errMsg toView:nil];
            completionBlock(nil,result.head.errMsg);
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
