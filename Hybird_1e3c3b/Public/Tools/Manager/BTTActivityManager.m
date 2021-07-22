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

@interface BTTActivityManager()
@property(nonatomic,strong)NSString * imageUrlString;
@property(nonatomic,strong)NSString * linkString;
@property(nonatomic,strong)NSString * titleString;
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

- (void)checkPopViewWithCompletionBlock:(PopViewCallBack _Nullable)completionBlock {
    //等待正确API参数
    NSMutableDictionary *params = @{}.mutableCopy;
    weakSelf(weakSelf)
    [IVNetwork requestPostWithUrl:BTTCheckPopView paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        
        IVJResponseObject *result = response;
        if ([result.head.errCode isEqualToString:@"0000"]) {
//            0722 isshow
//            0. 没配置任何东西 (月工资弹窗)
//            1. 预热时间内
//            2. 活动时间内
//            3. 不在预热也不在活动, 但有配置 (月工资弹窗)
//            4. 今天不用再弹弹窗 (什么弹窗都不出现了)
            BTTPopViewModel * model = [BTTPopViewModel yy_modelWithJSON:result.body];
            if (model.isShow)
            {
                if (model.image){
                    weakSelf.imageUrlString = model.image;
                }
                if (model.link){
                    weakSelf.linkString = model.link;
                }
                if (model.title){
                    weakSelf.titleString = model.title;
                }
                int isShowType =[model.isShow intValue];
                //测试
//                isShowType = 1;
                switch (isShowType) {
                    case 0://没配置任何东西 (月工资弹窗)
                        [weakSelf directToShowYenFenHongPopView];
                        break;
                    case 1://预热彈窗
                        [weakSelf directToShowDefaultPopView];
                        break;
                    case 2://活动彈窗
                        [weakSelf loadSevenXiData];// 七夕
                        break;
                    case 3://不在预热也不在活动, 但有配置(月工资弹窗)
                        [weakSelf directToShowYenFenHongPopView];
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

//            if (result.body[@"isShow"])//0 不弹窗,1五重礼,2月分红
//            {
//                if (result.body[@"image"]){
//                    weakSelf.imageUrlString = result.body[@"image"];
//                }
//                if (result.body[@"link"]){
//                    weakSelf.linkString = result.body[@"link"];
//                }
//                NSNumber *iSshowNumber = [result.body valueForKey:@"isShow"];
//                int isShowType = [iSshowNumber intValue];
//                //测试
////                 isShowType = 1;
//                switch (isShowType) {
//                    case 0://不弹窗
//                        break;
//                    case 1://一般彈窗
//                        [weakSelf directToShowDefaultPopView];
//                        break;
//                    case 2://月分红
//                        [weakSelf directToShowYenFenHongPopView];
//                        break;
////                    case 3://七夕
////                        [weakSelf directToShowSevenXiPopView:@""];
//                        break;
//                    default:
//                        break;
//                }
//                if (completionBlock)
//                {
//                    NSString * isShowString = [NSString stringWithFormat:@"%d",isShowType];
//                    completionBlock(isShowString,[error description]);
//                }
//
//            } else {
//                if (completionBlock)
//                {
//                    completionBlock(nil,[error description]);
//                }
//            }
        }else{
            [MBProgressHUD showError:result.head.errMsg toView:nil];
            if (completionBlock)
            {
                completionBlock(nil,result.head.errMsg);
            }
        }
    }];
}

#pragma mark - 七夕
-(void)loadSevenXiData {
//    NSMutableDictionary *params = @{}.mutableCopy;
//    weakSelf(weakSelf)
//    [IVNetwork requestPostWithUrl:BTTSevenXiDataBridge paramters:params completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
//        IVJResponseObject *result = response;
//        if ([result.head.errCode isEqualToString:@"0000"]) {
//            //TODO: 判斷有無局數 有七夕彈窗 沒有走彈窗接口
//            NSString * playedNumStr = result.body[@"下注局數"];
//            if ([playedNumStr integerValue] > 0) {
//                [weakSelf directToShowSevenXiPopView:playedNumStr];
//            } else {
                [self directToShowSevenXiPopView:@""];
//            }
//        } else {
//            [weakSelf checkPopViewWithCompletionBlock:nil];
//        }
//    }];
}
#pragma mark - 检查七夕预热弹窗是否已启用过
-(void)directToShowSevenXiPopView:(NSString *)playedNumStr {
    [self showSevenXiPopView:playedNumStr];
}

#pragma mark - 检查Default弹窗是否已启用过
-(void)directToShowDefaultPopView {
    [self showDefaultPopView];
}

#pragma mark - 檢查月分彈窗
-(void)directToShowYenFenHongPopView {
    [self loadYenFenHong];
}

- (void)showSevenXiPopView:(NSString *)playedNumStr {
    BTTSevenXiPriHotPopView *alertView = [BTTSevenXiPriHotPopView viewFromXib];
    [alertView configForContent:playedNumStr];
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
        vc.webConfigModel.title = @"七夕鹊桥会~918给您搭桥了";
        [[weakSelf currentViewController].navigationController pushViewController:vc animated:YES];
    };
}

#pragma mark - 基礎彈窗
- (void)showDefaultPopView {
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
        vc.webConfigModel.title = self.titleString;
        [[weakSelf currentViewController].navigationController pushViewController:vc animated:YES];
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
