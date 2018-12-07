//
//  BTTHomePageViewController+LoadData.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/11.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTHomePageViewController+LoadData.h"
#import "BTTBannerModel.h"
#import <objc/runtime.h>
#import "BTTNoticeModel.h"
#import "BTTHomePageHeaderModel.h"
#import "BTTActivityModel.h"
#import "BTTAmountModel.h"
#import "BTTMakeCallSuccessView.h"
#import "BTTPosterModel.h"
#import "BTTPromotionModel.h"
#import "BTTDownloadModel.h"
#import "BTTAGGJViewController.h"
#import "BTTGamesTryAlertView.h"

static const char *noticeStrKey = "noticeStr";

static const char *BTTNextGroupKey = "nextGroup";

@implementation BTTHomePageViewController (LoadData)

- (void)loadDataOfHomePage {
    
    [self loadHeadersData];
    [self loadGamesData];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("homepage.data", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_enter(group);
    [self loadMainData:group];
    
    dispatch_group_enter(group);
    [self loadScrollText:group];
    
    dispatch_group_enter(group);
    [self loadOtherData:group];
    
    dispatch_group_enter(group);
    [self loadHightlightsBrand:group];
    
    dispatch_group_notify(group,queue, ^{
        [self.elementsHight removeAllObjects];
        [self endRefreshing];
        [self setupElements];
    });
}

- (void)refreshDatasOfHomePage {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("homepage.data", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [self loadMainData:group];
    });
    
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [self loadScrollText:group];
    });
    
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [self loadOtherData:group];
    });
    
    dispatch_group_notify(group,queue, ^{
        [self.elementsHight removeAllObjects];
        [self endRefreshing];
        [self setupElements];
     
    });
}

- (void)loadScrollText:(dispatch_group_t)group {
    [IVNetwork sendUseCacheRequestWithSubURL:@"app/getAnnouments" paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",result.data);
        NSArray *data = result.data;
        if (![data isKindOfClass:[NSArray class]]) {
            return;
        }
        self.noticeStr = @"";
        for (NSDictionary *dict in data) {
            NSError *error = nil;
            BTTNoticeModel *noticeModel = [BTTNoticeModel yy_modelWithDictionary:dict];
            NSLog(@"%@",error.description);
            if (self.noticeStr) {
                self.noticeStr  = [NSString stringWithFormat:@"%@%@%@",self.noticeStr,@"                ",noticeModel.content];
            } else {
                self.noticeStr = noticeModel.content;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        dispatch_group_leave(group);
    }];
}

- (void)loadHeadersData {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    NSString *dateStr = [formatter stringFromDate:date];
    NSString *titleStr = [NSString stringWithFormat:@"%@高额及高倍盈利",dateStr];
    if (self.headers.count) {
        [self.headers removeAllObjects];
    }
    NSArray *titles = @[@"热门优惠",@"客户参与品牌活动集锦",titleStr];
    NSArray *btns = @[@"搜索更多",@"查看下一组",@""];
    [self.headers removeAllObjects];
    for (NSString *title in titles) {
        NSInteger index = [titles indexOfObject:title];
        BTTHomePageHeaderModel *model = [BTTHomePageHeaderModel new];
        model.titleStr = title;
        model.detailBtnStr = btns[index];
        [self.headers addObject:model];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}



- (void)makeCallWithPhoneNum:(NSString *)phone {
    NSString *url = nil;
    NSMutableDictionary *params = @{}.mutableCopy;
    if ([IVNetwork userInfo].customerLevel >= 4) {
        url = BTTCallBackMemberAPI;
        [params setValue:phone forKey:@"phone"];
        [params setValue:@"memberphone" forKey:@"phone_type"];
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

- (void)loadGamesData {
    if (self.games.count) {
        [self.games removeAllObjects];
    }
    NSArray *gamesIcons = @[@"AGQJ",@"AGGJ",@"Fishing_king",@"game",@"shaba",@"BTI",@"AS"];
    NSArray *gameNames = @[@"AG旗舰厅",@"AG国际厅",@"捕鱼王",@"电子游戏",@"沙巴体育",@"BTI体育",@"AS"];
    for (NSString *icon in gamesIcons) {
        NSInteger index = [gamesIcons indexOfObject:icon];
        NSString *name = [gameNames objectAtIndex:index];
        BTTGameModel *model = [[BTTGameModel alloc] init];
        model.gameIcon = icon;
        model.name = name;
        [self.games addObject:model];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
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

- (void)showTryAlertViewWithBlock:(BTTBtnBlock)btnClickBlock {
    BTTGamesTryAlertView *customView = [BTTGamesTryAlertView viewFromXib];
    if (SCREEN_WIDTH == 414) {
        customView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 120, 132);
    } else {
        customView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 60, 132);
    }
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    customView.dismissBlock = ^{
        [popView dismiss];
    };
    customView.btnBlock = ^(UIButton *btn) {
        [popView dismiss];
        btnClickBlock(btn);
    };
}


- (void)loadMainData:(dispatch_group_t)group {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *date_start = [PublicMethod getCurrentTimesWithFormat:@"YYYY-MM-dd"];
    date_start = [NSString stringWithFormat:@"%@ 00:00:00",date_start];
    [params setObject:date_start forKey:@"date_start"];
    NSString *date_end = [PublicMethod getCurrentTimesWithFormat:@"YYYY-MM-dd HH:mm:ss"];
    [params setObject:date_end forKey:@"date_end"];
    [params setObject:@"50000" forKey:@"min_bet_amount"];
    [params setObject:@"100" forKey:@"page_size"];
    [IVNetwork sendUseCacheRequestWithSubURL:BTTHomePageNewAPI paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (result.status) {
            if (result.data) {
                if (![result.data[@"maxRecords"] isKindOfClass:[NSNull class]]) {
                    [self.amounts removeAllObjects];
                    for (NSDictionary *dict in result.data[@"maxRecords"]) {
                        BTTAmountModel *model = [BTTAmountModel yy_modelWithDictionary:dict];
                        [self.amounts addObject:model];
                    }
                }
                
                if (![result.data[@"poster"] isKindOfClass:[NSNull class]]) {
                    [self.posters removeAllObjects];
                    for (NSDictionary *dict in result.data[@"poster"]) {
                        BTTPosterModel *model = [BTTPosterModel yy_modelWithDictionary:dict];
                        [self.posters addObject:model];
                    }
                }
                
                if (![result.data[@"promotions"] isKindOfClass:[NSNull class]]) {
                    [self.promotions removeAllObjects];
                    for (NSDictionary *dict in result.data[@"promotions"]) {
                        BTTPromotionModel *model = [BTTPromotionModel yy_modelWithDictionary:dict];
                        [self.promotions addObject:model];
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        dispatch_group_leave(group);
    }];
}

- (void)loadOtherData:(dispatch_group_t)group {
    [IVNetwork sendUseCacheRequestWithSubURL:BTTIndexBannerDownloads paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (result.code_http == 200) {
            if (result.data) {
                if (![result.data[@"banners"] isKindOfClass:[NSNull class]]) {
                    [self.banners removeAllObjects];
                    [self.imageUrls removeAllObjects];
                    for (NSDictionary *dict in result.data[@"banners"]) {
                        BTTBannerModel *model = [BTTBannerModel yy_modelWithDictionary:dict];
                        [self.imageUrls addObject:model.imgurl];
                        [self.banners addObject:model];
                    }
                }
                
                NSLog(@"%@",NSStringFromClass([result.data[@"downloads"] class]));
                if (![result.data[@"downloads"] isKindOfClass:[NSNull class]]) {
                    [self.downloads removeAllObjects];
                    for (NSDictionary *dict in result.data[@"downloads"]) {
                        BTTDownloadModel *model = [BTTDownloadModel yy_modelWithDictionary:dict];
                        [self.downloads addObject:model];
                    }
                }
                
//                if (![result.data[@"games"] isKindOfClass:[NSNull class]]) {
//                    [self.games removeAllObjects];
//                    for (NSDictionary *dict in result.data[@"games"]) {
//                        BTTGameModel *model = [BTTGameModel yy_modelWithDictionary:dict];
//                        [self.games addObject:model];
//                    }
//                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        dispatch_group_leave(group);
    }];
}

- (void)loadHightlightsBrand:(dispatch_group_t)group {
    [IVNetwork sendUseCacheRequestWithSubURL:BTTBrandHighlights paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (result.code_http == 200) {
            if (result.data) {
                [self.Activities removeAllObjects];
                for (NSDictionary *imageDict in result.data) {
                    BTTActivityModel *model = [BTTActivityModel yy_modelWithDictionary:imageDict];
                    [self.Activities addObject:model];
                }
            }
        }
        dispatch_group_leave(group);
    }];
}

#pragma mark - 动态添加属性

- (void)setNextGroup:(NSInteger)nextGroup {
    objc_setAssociatedObject(self, &BTTNextGroupKey, @(nextGroup), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)nextGroup {
    return [objc_getAssociatedObject(self, &BTTNextGroupKey) integerValue];
}

- (NSMutableArray *)imageUrls {
    NSMutableArray *imageUrls = objc_getAssociatedObject(self, _cmd);
    if (!imageUrls) {
        imageUrls = [NSMutableArray array];
        [self setImageUrls:imageUrls];
    }
    return imageUrls;
}

- (void)setImageUrls:(NSMutableArray *)imageUrls {
    objc_setAssociatedObject(self, @selector(imageUrls), imageUrls, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)noticeStr {
    return objc_getAssociatedObject(self, &noticeStrKey);
}

- (void)setNoticeStr:(NSString *)noticeStr {
    objc_setAssociatedObject(self, &noticeStrKey, noticeStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)headers {
    NSMutableArray *headers = objc_getAssociatedObject(self, _cmd);
    if (!headers) {
        headers = [NSMutableArray array];
        [self setHeaders:headers];
    }
    return headers;
}


- (void)setHeaders:(NSMutableArray *)headers {
     objc_setAssociatedObject(self, @selector(headers), headers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)Activities {
    NSMutableArray *Activities = objc_getAssociatedObject(self, _cmd);
    if (!Activities) {
        Activities = [NSMutableArray array];
        [self setActivities:Activities];
    }
    return Activities;
}

- (void)setActivities:(NSMutableArray *)Activities {
    objc_setAssociatedObject(self, @selector(Activities), Activities, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)amounts {
    NSMutableArray *amounts = objc_getAssociatedObject(self, _cmd);
    if (!amounts) {
        amounts = [NSMutableArray array];
        [self setAmounts:amounts];
    }
    return amounts;
}

- (void)setAmounts:(NSMutableArray *)amounts {
    objc_setAssociatedObject(self, @selector(amounts), amounts, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)posters {
    NSMutableArray *posters = objc_getAssociatedObject(self, _cmd);
    if (!posters) {
        posters = [NSMutableArray array];
        [self setPosters:posters];
    }
    return posters;
}

- (void)setPosters:(NSMutableArray *)posters {
    objc_setAssociatedObject(self, @selector(posters), posters, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)promotions {
    NSMutableArray *promotions = objc_getAssociatedObject(self, _cmd);
    if (!promotions) {
        promotions = [NSMutableArray array];
        [self setPromotions:promotions];
    }
    return promotions;
}

- (void)setPromotions:(NSMutableArray *)promotions {
    objc_setAssociatedObject(self, @selector(promotions), promotions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)banners {
    NSMutableArray *banners = objc_getAssociatedObject(self, _cmd);
    if (!banners) {
        banners = [NSMutableArray array];
        [self setBanners:banners];
    }
    return banners;
}

- (void)setBanners:(NSMutableArray *)banners {
    objc_setAssociatedObject(self, @selector(banners), banners, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)downloads {
    NSMutableArray *downloads = objc_getAssociatedObject(self, _cmd);
    if (!downloads) {
        downloads = [NSMutableArray array];
        [self setDownloads:downloads];
    }
    return downloads;
}

- (void)setDownloads:(NSMutableArray *)downloads {
    objc_setAssociatedObject(self, @selector(downloads), downloads, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)games {
    NSMutableArray *games = objc_getAssociatedObject(self, _cmd);
    if (!games) {
        games = [NSMutableArray array];
        [self setGames:games];
    }
    return games;
}

- (void)setGames:(NSMutableArray *)games {
    objc_setAssociatedObject(self, @selector(games), games, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
