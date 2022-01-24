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
#import "BTTYueFenHongPopView.h"
#import "BTTYenFenHongModel.h"
#import "BTTPopViewModel.h"
#import "RedPacketsRainView.h"
#import "BTTHomePageViewController.h"
@interface BTTActivityManager()
@property(nonatomic,strong)BTTPopViewModel * popModel;

@end
@implementation BTTActivityManager
static BTTActivityManager * sharedSingleton;

+ (void)initialize {
    static BOOL initialized = NO;
    if (!initialized)
    {
        initialized = YES;
        sharedSingleton = [[BTTActivityManager alloc] init];
        [sharedSingleton setNoti];
    }
}

+ (BTTActivityManager *)sharedInstance {
    return sharedSingleton;
}

- (void)setNoti {

}
- (void)checkTimeRedPacketRainWithCompletion:(RedPacketCallBack _Nullable)redPacketBlock
                       WithDefaultCompletion:(RedPacketCallBack _Nullable)defaultBlock
{
    NSMutableDictionary *params = @{}.mutableCopy;
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:BTTRainInfo paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            weakSelf.redPacketInfoModel = [RedPacketsInfoModel yy_modelWithJSON:result.body];
            [weakSelf serverTime:^(NSString *timeStr) {
                if (timeStr.length > 0)
                {
                    NSArray *duractionArray = [PublicMethod redPacketDuracionCheck];
                    BOOL isBeforeDuration = [duractionArray[0] boolValue];
                    BOOL isActivityDuration = [duractionArray[1] boolValue];
                    if (isBeforeDuration || isActivityDuration)
                    {
                        // 不到时间,预热
                        // 活动期间
                        if (redPacketBlock)
                        {
                            redPacketBlock(isActivityDuration ? @"1" : nil,nil);
                        }
                    }else
                    {
                        // 过了活动期
                        if (defaultBlock)
                        {
                            defaultBlock(nil,nil);
                        }
                    }
                }
            }];
        }
    }];
}
-(void)serverTime:(CheckTimeCompleteBlock)completeBlock {
    NSDate *timeDate = [NSDate new];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    completeBlock([dateFormatter stringFromDate:timeDate]);
}

- (void)checkPopViewWithCompletionBlock:(PopViewCallBack _Nullable)completionBlock {
    //等待正确API参数
    NSMutableDictionary *params = @{}.mutableCopy;
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:BTTCheckPopView paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
//            0723 isshow
//            1. 预热时间内
//            2. 活动时间内
//            3. 不在预热也不在活动, 但有配置 (月工资弹窗)
//            4. 今天不用再弹弹窗 (什么弹窗都不出现了)
            self.popModel = [BTTPopViewModel yy_modelWithJSON:result.body];
            if (self.popModel.isShow)
            {
                int isShowType =[self.popModel.isShow intValue];
                //测试
//                isShowType = 2;
                switch (isShowType) {
                    case 0://没配置任何东西 (月工资弹窗)
                        [weakSelf directToShowYenFenHongPopView];
                        break;
                    case 1://预热彈窗
                        [weakSelf directToShowDefaultPopView];
                        break;
                    case 2://活动彈窗
//                        [weakSelf loadSevenXiData];// 七夕
                        break;
                    case 3://不在预热也不在活动, 但有配置(月工资弹窗)
                        [weakSelf directToShowYenFenHongPopView];
                        break;
                    case 4://今天不用再弹弹窗 (什么弹窗都不出现了)
                        break;
                    default:
                        break;
                }
                if (completionBlock)
                {
                    NSString * isShowString = [NSString stringWithFormat:@"%d",isShowType];
                    completionBlock(isShowString,[error description]);
                }

            } else {
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
- (void)checkTimeForRedPoickets
{
    [self checkTime:^(NSString * _Nonnull timeStr) {
        if (timeStr.length > 0) {
            if ([self checksStartDate:@"10:00" EndDate:@"10:01" serverTime:timeStr])
            {
//                [self showRedPacketsRainView];
            }else if ([self checksStartDate:@"14:00" EndDate:@"14:01" serverTime:timeStr])
            {
//                [self showRedPacketsRainView];
            }else
            {
                /// 不到时间
//                [self showRedPacketsRainView];
            }
        }
    }];
}
-(BOOL)checksStartDate:(NSString *)startTime EndDate:(NSString *)endTime serverTime:(NSString *)serverTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *startDate = [dateFormatter dateFromString:startTime];
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    NSDate *serverDate = [dateFormatter dateFromString:serverTime];
    // 判断是否大于server时间
    if (([startDate earlierDate:serverDate] == startDate) &&
        ([serverDate earlierDate:endDate] == serverDate)) {
        return true;
    } else {
        return false;
    }
}
-(void)checkTime:(CheckTimeCompleteBlock)completeBlock {
    NSDate *timeDate = [NSDate new];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    completeBlock([dateFormatter stringFromDate:timeDate]);
//    [IVNetwork requestPostWithUrl:BTTServerTime paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
//        IVJResponseObject *result = response;
//        if ([result.head.errCode isEqualToString:@"0000"]) {
//            NSDate *timeDate = [[NSDate alloc]initWithTimeIntervalSince1970:[result.body longLongValue]];
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//            completeBlock([dateFormatter stringFromDate:timeDate]);
//        } else {
//            completeBlock(@"");
//        }
//    }];
}

#pragma mark - 七夕
-(void)loadSevenXiData {
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:BTTSevenXiMyData paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            NSNumber * playedNum = [result.body isKindOfClass:[NSArray class]] && [[NSMutableArray alloc] initWithArray:result.body].count==0 ? 0:result.body[@"accumulative"];
            if (playedNum > 0) {
                [weakSelf directToShowSevenXiPopView:playedNum];
            } else {
                [weakSelf directToShowSevenXiPopView:0];
            }
        }
    }];
}
#pragma mark - 检查七夕预热弹窗是否已启用过
-(void)directToShowSevenXiPopView:(NSNumber *)playedNum {
    [self showSevenXiPopView:playedNum];
}

#pragma mark - 检查Default弹窗是否已启用过
-(void)directToShowDefaultPopView {
    [self showDefaultPopView];
}

#pragma mark - 檢查月分彈窗
-(void)directToShowYenFenHongPopView {
    [self loadYenFenHong];
}

- (void)showSevenXiPopView:(NSNumber *)playedNum {
    BTTSevenXiPriHotPopView *alertView = [BTTSevenXiPriHotPopView viewFromXib];
    [alertView configForContent:playedNum];
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
        vc.webConfigModel.url = self.popModel.link;
        vc.title = self.popModel.title;
        [[weakSelf currentViewController].navigationController pushViewController:vc animated:YES];
    };
}

#pragma mark - 基礎彈窗
- (void)showDefaultPopView {
    BTTDefaultPopView *alertView = [BTTDefaultPopView viewFromXib];
    [alertView configForContent:self.popModel.image];
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
        NSArray *duractionArray = [PublicMethod redPacketDuracionCheck];
        BOOL isBeforeDuration = [duractionArray[0] boolValue];
        BOOL isActivityDuration = [duractionArray[1] boolValue];
        BOOL isRainningTime = [duractionArray[2] boolValue];
        if (isBeforeDuration || isActivityDuration)
        {
            [(BTTHomePageViewController *)[weakSelf currentViewController] showRedPacketsRainViewwWithStyle:(isActivityDuration ? (isRainningTime ? RedPocketsViewRainning : RedPocketsViewBegin): RedPocketsViewPrefix)];
        }else
        {
            BTTBaseWebViewController *vc = [BTTBaseWebViewController new];
            vc.webConfigModel.newView = YES;
            vc.webConfigModel.theme = @"outside";
            vc.webConfigModel.url = self.popModel.link;
            vc.title = self.popModel.title;
            [[weakSelf currentViewController].navigationController pushViewController:vc animated:YES];            
        }
    };
}

#pragma mark - 月分紅
-(void)loadYenFenHong {
    [IVNetwork requestPostWithUrl:BTTIsOldMember paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
            BTTYenFenHongModel * model = [BTTYenFenHongModel yy_modelWithJSON:result.body];
            [self showYueFenHong:model];
        }
    }];
}

- (void)showYueFenHong:(BTTYenFenHongModel *)model {
    BTTYueFenHongPopView * customView = [BTTYueFenHongPopView viewFromXib];
    customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    customView.model = model;
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    weakSelf(weakSelf)
    customView.dismissBlock = ^{
        [popView dismiss];
    };
    customView.btnBlock = ^(UIButton * _Nullable btn) {
        [popView dismiss];
        BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
        vc.title = @"博天堂股东 分红月月领～第二季";
        vc.webConfigModel.url = @"/activity_pages/withdraw_gift";
        vc.webConfigModel.newView = YES;
        [[weakSelf currentViewController].navigationController pushViewController:vc animated:YES];
    };
}

- (UIViewController*)topMostWindowController {
    UIWindow *win = [UIApplication sharedApplication].delegate.window;
    UIViewController *topController = [win rootViewController];
    if ([topController isKindOfClass:[UITabBarController class]]) {
        topController = [(UITabBarController *)topController selectedViewController];
    }
    while ([topController presentedViewController])  topController = [topController presentedViewController];
    return topController;
}

- (UIViewController*)currentViewController {
    UIViewController *currentViewController = [self topMostWindowController];
    
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    
    return currentViewController;
}
@end
