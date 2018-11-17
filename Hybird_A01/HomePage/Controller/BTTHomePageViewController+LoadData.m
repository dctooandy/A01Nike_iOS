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
#import "BTTGameModel.h"

static const char *noticeStrKey = "noticeStr";

static const char *BTTNextGroupKey = "nextGroup";

@implementation BTTHomePageViewController (LoadData)

- (void)loadDataOfHomePage {
    
    [self loadHeadersData];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoading];
        });
        [self loadMainData];
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadScrollText];
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadOtherData];
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self hideLoading];
        [self endRefreshing];
        
    });
}

- (void)loadScrollText {
    [IVNetwork sendRequestWithSubURL:@"app/getAnnouments" paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",result.data);
        NSArray *data = result.data;
        if (![data isKindOfClass:[NSArray class]]) {
            return;
        }
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
    if ([IVNetwork userInfo]) {
        url = BTTCallBackMemberAPI;
        [params setValue:phone forKey:@"phone"];
        [params setValue:@"memberphone" forKey:@"phone_type"];
    } else {
        url = BTTCallBackCustomAPI;
        [params setValue:phone forKey:@"phone_number"];
    }
    [self showLoading];
    [IVNetwork sendRequestWithSubURL:url paramters:params.copy completionBlock:^(IVRequestResultModel *result, id response) {
        [self hideLoading];
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *date_start = [PublicMethod getCurrentTimesWithFormat:@"YYYY-MM-dd"];
    date_start = [NSString stringWithFormat:@"%@ 00:00:00",date_start];
    [params setObject:date_start forKey:@"date_start"];
    NSString *date_end = [PublicMethod getCurrentTimesWithFormat:@"YYYY-MM-dd HH:mm:ss"];
    [params setObject:date_end forKey:@"date_end"];
    [params setObject:@"50000" forKey:@"min_bet_amount"];
    [params setObject:@"100" forKey:@"page_size"];
    [IVNetwork sendRequestWithSubURL:BTTHomePageNewAPI paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (result.code_http == 200) {
            if (result.data) {
                for (NSDictionary *imageDict in result.data[@"highlights"]) {
                    BTTActivityModel *model = [BTTActivityModel yy_modelWithDictionary:imageDict];
                    [self.Activities addObject:model];
                }
                
                for (NSDictionary *dict in result.data[@"maxRecords"]) {
                    BTTAmountModel *model = [BTTAmountModel yy_modelWithDictionary:dict];
                    [self.amounts addObject:model];
                }
                
                for (NSDictionary *dict in result.data[@"poster"]) {
                    BTTPosterModel *model = [BTTPosterModel yy_modelWithDictionary:dict];
                    [self.posters addObject:model];
                }
                
                for (NSDictionary *dict in result.data[@"promotions"]) {
                    BTTPromotionModel *model = [BTTPromotionModel yy_modelWithDictionary:dict];
                    [self.promotions addObject:model];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        if (result.message.length) {
            [MBProgressHUD showMessagNoActivity:result.message toView:nil];
        }
    }];
}

- (void)loadOtherData {
    [IVNetwork sendRequestWithSubURL:BTTIndexBannerDownloads paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        NSLog(@"%@",response);
        if (result.code_http == 200) {
            if (result.data) {
                for (NSDictionary *dict in result.data[@"banners"]) {
                    BTTBannerModel *model = [BTTBannerModel yy_modelWithDictionary:dict];
                    [self.imageUrls addObject:model.imgurl];
                    [self.banners addObject:model];
                }
                
                for (NSDictionary *dict in result.data[@"downloads"]) {
                    BTTDownloadModel *model = [BTTDownloadModel yy_modelWithDictionary:dict];
                    [self.downloads addObject:model];
                }
                
                for (NSDictionary *dict in result.data[@"games"]) {
                    BTTGameModel *model = [BTTGameModel yy_modelWithDictionary:dict];
                    [self.games addObject:model];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
        if (result.message.length) {
            [MBProgressHUD showMessagNoActivity:result.message toView:nil];
        }
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
