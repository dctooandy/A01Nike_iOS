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
#import "BTTDefaultPopView.h"

@interface BTTActivityManager()
@property(nonatomic,strong)NSString * sevenXiData;
@property(nonatomic,strong)NSString * imageUrlString;
@property(nonatomic,strong)NSString * linkString;
@end
@implementation BTTActivityManager
//SingletonImplementation(BTTActivityManager);
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
        }else
        {
            //测试
            [self showSevenXiPriHotPopView];
        }
    }
    
}
#pragma mark - 检查Default弹窗是否已启用过
-(void)checkDefaultPopViewDate
{
    NSString * showSevenXiDate = [[NSUserDefaults standardUserDefaults] objectForKey:BTTShowDefaultPopDate];
    NSString * realLastLoginDate = [[NSUserDefaults standardUserDefaults] objectForKey:BTTBeforeLoginDate];
    NSString * registDate = [[NSUserDefaults standardUserDefaults] objectForKey:BTTRegistDate];
    if (showSevenXiDate == nil)
    {
        NSString *currentDate = [PublicMethod getCurrentTimesWithFormat:@"yyyy-MM-dd HH:mm:ss" ];
        [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:BTTShowDefaultPopDate];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (realLastLoginDate && ![realLastLoginDate isEqualToString:@"NO"])
        {
            if (![PublicMethod isDateToday:[PublicMethod transferDateStringToDate:realLastLoginDate]]) {
                [self showDefaultPopView];
            }else if ([PublicMethod isDateToday:[PublicMethod transferDateStringToDate:registDate]]) {
                [self showDefaultPopView];
            }
        }else
        {
            [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:BTTBeforeLoginDate];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self showDefaultPopView];
        }
    }else{
        if (![PublicMethod isDateToday:[PublicMethod transferDateStringToDate:showSevenXiDate]])
        {
            NSString *currentDate = [PublicMethod getCurrentTimesWithFormat:@"yyyy-MM-dd HH:mm:ss" ];
            [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:BTTShowDefaultPopDate];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self showDefaultPopView];
        }else
        {
            //测试
//            [self showDefaultPopView];
        }
    }
    
}
- (void)checkPopViewWithCompletionBlock:(PopViewCallBack _Nullable)completionBlock
{
    //等待正确API参数
    NSMutableDictionary *params = @{}.mutableCopy;
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:BTTCheckPopView paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            if (result.body[@"isShow"])//0 不弹窗,1五重礼,2月分红,预计数字会一直增加
            {
                if (result.body[@"image"]){
                    weakSelf.imageUrlString = result.body[@"image"];
                }
                if (result.body[@"link"]){
                    weakSelf.linkString = result.body[@"link"];
                }
                NSNumber *iSshowNumber = [result valueForKey:@"isShow"];
                int isShowType = [iSshowNumber intValue];
                //测试
//                isShowType = 1;
                switch (isShowType) {
                    case 0:
                        
                        break;
                    case 1:
                        [weakSelf checkDefaultPopViewDate];
                        break;
                    case 2:
                    
                        break;
                        
                    default:
                        break;
                }
                if (completionBlock)
                {
                    NSString * isShowString = [NSString stringWithFormat:@"%d",isShowType];
                    completionBlock(isShowString,[error description]);
                }
            }else
            {
                if (completionBlock)
                {
                    completionBlock(nil,[error description]);
                }
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
            if (completionBlock)
            {
                weakSelf.sevenXiData = @"5056";
                completionBlock(response,[error description]);
            }
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
            if (completionBlock)
            {
                weakSelf.sevenXiData = @"";
                completionBlock(nil,result.head.errMsg);
            }
        }
    }];
}
- (void)showSevenXiPriHotPopView
{
    BTTSevenXiPriHotPopView *alertView = [BTTSevenXiPriHotPopView viewFromXib];
    [alertView configForContent:self.sevenXiData];
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
- (void)showDefaultPopView
{
    BTTDefaultPopView *alertView = [BTTDefaultPopView viewFromXib];
    [alertView configForContent:self.imageUrlString];
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
        [popView dismiss];
        BTTBaseWebViewController *vc = [BTTBaseWebViewController new];
        vc.webConfigModel.newView = YES;
        vc.webConfigModel.theme = @"outside";
        vc.webConfigModel.url = self.linkString;
        vc.webConfigModel.title = @"呼朋唤友彩金拿不停";
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
