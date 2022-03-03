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
- (VIPHistoryModel *)createVIPHistoryData
{
    VIPHistorySideBarModel *sData1 = [[VIPHistorySideBarModel alloc] initWithYearString:@"2013" withImageName:@"logo" withIsSelected:NO withIsFirstData:NO];
    VIPHistorySideBarModel *sData2 = [[VIPHistorySideBarModel alloc] initWithYearString:@"2014" withImageName:@"logo" withIsSelected:NO withIsFirstData:NO];
    VIPHistorySideBarModel *sData3 = [[VIPHistorySideBarModel alloc] initWithYearString:@"2015" withImageName:@"logo" withIsSelected:NO withIsFirstData:NO];
    VIPHistorySideBarModel *sData4 = [[VIPHistorySideBarModel alloc] initWithYearString:@"2016" withImageName:@"logo" withIsSelected:NO withIsFirstData:NO];
    VIPHistorySideBarModel *sData5 = [[VIPHistorySideBarModel alloc] initWithYearString:@"2017" withImageName:@"logo" withIsSelected:NO withIsFirstData:NO];
    VIPHistorySideBarModel *sData6 = [[VIPHistorySideBarModel alloc] initWithYearString:@"2018" withImageName:@"logo" withIsSelected:NO withIsFirstData:NO];
    VIPHistorySideBarModel *sData7 = [[VIPHistorySideBarModel alloc] initWithYearString:@"2019" withImageName:@"logo" withIsSelected:NO withIsFirstData:NO];
    VIPHistorySideBarModel *sData8 = [[VIPHistorySideBarModel alloc] initWithYearString:@"2020" withImageName:@"logo" withIsSelected:NO withIsFirstData:NO];
    VIPHistorySideBarModel *sData9 = [[VIPHistorySideBarModel alloc] initWithYearString:@"2021" withImageName:@"logo" withIsSelected:YES withIsFirstData:YES];
    
    VIPHistoryImageModel *iData9 = [[VIPHistoryImageModel alloc] initWithYearString:@"2021" WithMonthString:@"9"
                                                                      withImageName:@"img210901"
                                                                            withUrl:@"activity_pages/anniversary"
                                                                 withTopTitleString:@"博天堂周年庆典" withSubTitleString:@"周年庆圆满结束"
                                                                    withIsFirstData:YES withIsDetails:YES];
    VIPHistoryImageModel *iData91 = [[VIPHistoryImageModel alloc] initWithYearString:@"2021" WithMonthString:@"8"
                                                                       withImageName:@"img210802"
                                                                             withUrl:@"activity_pages/wish_tree"
                                                                  withTopTitleString:@"918周年许愿树"
                                                                  withSubTitleString:@"许愿圆满结束礼品已经发货" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData92 = [[VIPHistoryImageModel alloc] initWithYearString:@"2021" WithMonthString:@"8"
                                                                       withImageName:@"img210801"
                                                                             withUrl:@"activity_pages/valentine2021_ready"
                                                                  withTopTitleString:@"博天堂七夕鹊桥会"
                                                                  withSubTitleString:@"活动圆满结束小哥哥小姐姐已经送出" withIsFirstData:NO withIsDetails:YES];
    
    VIPHistoryImageModel *iData8 = [[VIPHistoryImageModel alloc] initWithYearString:@"2020" WithMonthString:@"12"
                                                                      withImageName:@"img45"
                                                                            withUrl:@"http://fm.918rr.com/activity_pages/usdt_free_betting"
                                                                 withTopTitleString:@"USDT投注送华为、顶配手机等您来"
                                                                 withSubTitleString:@"活动圆满结束" withIsFirstData:YES withIsDetails:YES];
    VIPHistoryImageModel *iData81 = [[VIPHistoryImageModel alloc] initWithYearString:@"2020" WithMonthString:@"11"
                                                                       withImageName:@"img46" withUrl:@"http://fm.918rr.com/activity_pages/usdt150"
                                                                 withTopTitleString:@"USDT笔笔存送 150万 豪礼等您领" withSubTitleString:@"金额赠送完毕活动圆满结束" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData82 = [[VIPHistoryImageModel alloc] initWithYearString:@"2020" WithMonthString:@"2"
                                                                       withImageName:@"img47" withUrl:@"http://fm.918rr.com/www/mt_rules_2020/index.html"
                                                                 withTopTitleString:@"赌神赛" withSubTitleString:@"活动圆满结束" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData83 = [[VIPHistoryImageModel alloc] initWithYearString:@"2020" WithMonthString:@"1"
                                                                       withImageName:@"img48" withUrl:@"http://fm.918rr.com/activity_pages/win_champions"
                                                                 withTopTitleString:@"连赢争霸赛" withSubTitleString:@"活动圆满结束" withIsFirstData:NO withIsDetails:YES];
        
    VIPHistoryImageModel *iData1 = [[VIPHistoryImageModel alloc] initWithYearString:@"2019" WithMonthString:@"10"
                                                                      withImageName:@"img44" withUrl:@"www/promo_av_201910/index.html"
                                                                 withTopTitleString:@"我和三上悠亚有个约会" withSubTitleString:@"与三上悠亚的浪漫邂逅圆满结束" withIsFirstData:YES withIsDetails:YES];
    VIPHistoryImageModel *iData11 = [[VIPHistoryImageModel alloc] initWithYearString:@"2019" WithMonthString:@"02"
                                                                       withImageName:@"img43" withUrl:@"www/yacht_tour_201902/index.html"
                                                                  withTopTitleString:@"四天三夜浪漫游艇邂逅之旅" withSubTitleString:@"浪漫游艇邂逅之旅圆满结束" withIsFirstData:NO withIsDetails:YES];
    
    VIPHistoryImageModel *iData2 = [[VIPHistoryImageModel alloc] initWithYearString:@"2018" WithMonthString:@"10"
                                                                      withImageName:@"img42" withUrl:@"www/f1_race_2018_3/index.html"
                                                                 withTopTitleString:@"五天四夜F1日本之旅" withSubTitleString:@"观战F1&日本关西韵味之旅活动圆满收官" withIsFirstData:YES withIsDetails:YES];
    VIPHistoryImageModel *iData21 = [[VIPHistoryImageModel alloc] initWithYearString:@"2018" WithMonthString:@"09"
                                                                       withImageName:@"img41" withUrl:@"www/yacht_bunny2/index.html"
                                                                  withTopTitleString:@"三天两夜兔女郎豪华游艇游" withSubTitleString:@"豪华游艇邂逅兔女郎主题旅游活动圆满结束" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData22 = [[VIPHistoryImageModel alloc] initWithYearString:@"2018" WithMonthString:@"06"
                                                                       withImageName:@"img40" withUrl:@"www/dream_island_trip2/index.html"
                                                                  withTopTitleString:@"“菲”去不可  科隆岛浪漫之旅" withSubTitleString:@"阳光、沙滩、海岛、比基尼美女，好玩到不想走！" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData23 = [[VIPHistoryImageModel alloc] initWithYearString:@"2018" WithMonthString:@"04"
                                                                       withImageName:@"img_39" withUrl:@"www/bayer_travel_4thquarter2/index.html" withTopTitleString:@"激情观战勒沃库森旅游" withSubTitleString:@"2018年4月勒沃库森旅游季，德法浪漫游再次让博天堂客户欢聚" withIsFirstData:NO withIsDetails:YES];
    
    VIPHistoryImageModel *iData3 = [[VIPHistoryImageModel alloc] initWithYearString:@"2017" WithMonthString:@"12"
                                                                      withImageName:@"img_38" withUrl:@"www/ph_tour/index.html"
                                                                 withTopTitleString:@"“飞”律宾第四季" withSubTitleString:@"长滩岛遇见博天堂 完美收官" withIsFirstData:YES withIsDetails:YES];
    VIPHistoryImageModel *iData31 = [[VIPHistoryImageModel alloc] initWithYearString:@"2017" WithMonthString:@"8"
                                                                       withImageName:@"img37" withUrl:@"www/dream_island_trip/index.html"
                                                                  withTopTitleString:@"“飞”律宾第三季" withSubTitleString:@"梦幻海岛之旅" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData32 = [[VIPHistoryImageModel alloc] initWithYearString:@"2017" WithMonthString:@"06"
                                                                       withImageName:@"img_as" withUrl:@""
                                                                  withTopTitleString:@"新增AS电玩城" withSubTitleString:@"AS厅首创实时实体赌场数据开牌，社交化在线博彩。" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData33 = [[VIPHistoryImageModel alloc] initWithYearString:@"2017" WithMonthString:@"05"
                                                                       withImageName:@"img38" withUrl:@"www/yacht_tour2/index.html"
                                                                  withTopTitleString:@"“飞”律宾第二季" withSubTitleString:@"欢乐翱翔之旅" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData34 = [[VIPHistoryImageModel alloc] initWithYearString:@"2017" WithMonthString:@"02"
                                                                       withImageName:@"img39" withUrl:@"www/yacht_tour/index.html"
                                                                  withTopTitleString:@"“飞”律宾第一季" withSubTitleString:@"惊喜游艇之旅" withIsFirstData:NO withIsDetails:YES];
    
//    VIPHistoryImageModel *iData4 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"10"
//                                                                      withImageName:@"img1" withUrl:@""
//                                                                 withTopTitleString:@"AG旗舰厅新增贵宾百万投注桌台" withSubTitleString:@"～百万单注想投就投 盈利机会不容错过～" withIsFirstData:YES withIsDetails:NO];
    VIPHistoryImageModel *iData4 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"10"
                                                                      withImageName:@"img1" withUrl:@""
                                                                 withTopTitleString:@"旗舰厅新增贵宾百万投注桌台" withSubTitleString:@"～百万单注想投就投 盈利机会不容错过～" withIsFirstData:YES withIsDetails:NO];
    VIPHistoryImageModel *iData41 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"09"
                                                                       withImageName:@"img2" withUrl:@"www/bayer_tab4/index.html"
                                                                  withTopTitleString:@"德荷两国欢乐游 现场观战勒 | 沃库森" withSubTitleString:@"观看精彩刺激球赛 尊享贵宾奢华待遇" withIsFirstData:NO withIsDetails:YES];
//    VIPHistoryImageModel *iData42 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"09"
//                                                                       withImageName:@"img34" withUrl:@""
//                                                                  withTopTitleString:@"AG旗舰厅新增30万盘口" withSubTitleString:@"AG旗舰厅真人单注30万盘口火热开启" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData42 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"09"
                                                                       withImageName:@"img34" withUrl:@""
                                                                  withTopTitleString:@"旗舰厅新增30万盘口" withSubTitleString:@"旗舰厅真人单注30万盘口火热开启" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData43 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"09"
                                                                       withImageName:@"img3" withUrl:@""
                                                                  withTopTitleString:@"真人娱乐开设50、100万盘口，单日提款限额提升至1000万" withSubTitleString:@"50万盘口开设无任何要求,1000万提款工作日1小时到账" withIsFirstData:NO withIsDetails:NO];
//    VIPHistoryImageModel *iData44 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"09"
//                                                                       withImageName:@"img4" withUrl:@""
//                                                                  withTopTitleString:@"AG旗舰豪华厅正式上线"
//                                                                  withSubTitleString:@"亚洲新坐标 全球首推" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData44 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"09"
                                                                       withImageName:@"img4" withUrl:@""
                                                                  withTopTitleString:@"旗舰豪华厅正式上线"
                                                                  withSubTitleString:@"亚洲新坐标 全球首推" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData45 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"08"
                                                                       withImageName:@"img5" withUrl:@""
                                                                  withTopTitleString:@"与尼尔·罗伯逊相约菲律宾活动"
                                                                  withSubTitleString:@"博天堂客户欢聚菲律宾，参加豪华游艇party" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData46 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"07"
                                                                       withImageName:@"img6" withUrl:@""
                                                                  withTopTitleString:@"博天堂专属手机APP"
                                                                  withSubTitleString:@"畅享极速体验" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData47 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"07"
                                                                       withImageName:@"img7" withUrl:@""
                                                                  withTopTitleString:@"博天堂签约赞助"
                                                                  withSubTitleString:@"德甲知名球队勒沃库森" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData48 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"07"
                                                                       withImageName:@"img8" withUrl:@""
                                                                  withTopTitleString:@"BSG火热上线"
                                                                  withSubTitleString:@"无限惊喜  尽在3D视频老虎机" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData49 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"05"
                                                                       withImageName:@"img9" withUrl:@""
                                                                  withTopTitleString:@"博天堂鼎力赞助"
                                                                  withSubTitleString:@"萧敬腾＆范玮琪澳门演唱会" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData410 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"02"
                                                                        withImageName:@"img10" withUrl:@""
                                                                  withTopTitleString:@"斯诺克知名选手"
                                                                  withSubTitleString:@"尼尔‧罗伯逊代言博天堂" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData411 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"02"
                                                                        withImageName:@"img11" withUrl:@""
                                                                  withTopTitleString:@"博天堂冠名世界经典赛事"
                                                                  withSubTitleString:@"博天堂独家冠名赞助2016斯诺克德国大师赛" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData412 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"01"
                                                                        withImageName:@"img12" withUrl:@""
                                                                  withTopTitleString:@"博天堂雀神麻将正式上线"
                                                                  withSubTitleString:@"特色广东麻将 玩家对战 血战到底更有趣" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData413 = [[VIPHistoryImageModel alloc] initWithYearString:@"2016" WithMonthString:@"01"
                                                                        withImageName:@"img13" withUrl:@""
                                                                  withTopTitleString:@"博天堂助力西甲"
                                                                  withSubTitleString:@"巴萨成功卫冕西甲冠军 博天堂倾情同贺再创辉煌" withIsFirstData:NO withIsDetails:NO];
    
    VIPHistoryImageModel *iData5 = [[VIPHistoryImageModel alloc] initWithYearString:@"2015" WithMonthString:@"07"
                                                                      withImageName:@"img14" withUrl:@""
                                                                  withTopTitleString:@"博天堂全新推出GPI彩票游戏"
                                                                  withSubTitleString:@"世界首创60秒极速开奖超级快乐彩" withIsFirstData:YES withIsDetails:NO];
    VIPHistoryImageModel *iData51 = [[VIPHistoryImageModel alloc] initWithYearString:@"2015" WithMonthString:@"07"
                                                                       withImageName:@"img15" withUrl:@""
                                                                  withTopTitleString:@"博天堂棋牌室隆重登场"
                                                                  withSubTitleString:@"24小时在线 真人对战 其乐无穷" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData52 = [[VIPHistoryImageModel alloc] initWithYearString:@"2015" WithMonthString:@"07"
                                                                       withImageName:@"img16" withUrl:@""
                                                                  withTopTitleString:@"日提款限额人民币800万"
                                                                  withSubTitleString:@"网站单日提款金额上限从600万调升至800万" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData53 = [[VIPHistoryImageModel alloc] initWithYearString:@"2015" WithMonthString:@"07"
                                                                       withImageName:@"img17" withUrl:@""
                                                                  withTopTitleString:@"博天堂全新呈现HG真人游戏"
                                                                  withSubTitleString:@"HG平台闪亮登场 美女荷官现场互动" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData54 = [[VIPHistoryImageModel alloc] initWithYearString:@"2015" WithMonthString:@"04"
                                                                       withImageName:@"img18" withUrl:@"www/h_helpspanish/index.html"
                                                                  withTopTitleString:@"博天堂助力西甲"
                                                                  withSubTitleString:@"博天堂力捧巴萨卫冕西甲冠军，再创辉煌" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData55 = [[VIPHistoryImageModel alloc] initWithYearString:@"2015" WithMonthString:@"03"
                                                                       withImageName:@"img19" withUrl:@"www/h_polygramconcert/index.html"
                                                                  withTopTitleString:@"博天堂集团独家冠名赞助"
                                                                  withSubTitleString:@"宝丽金永恒金曲澳门演唱会，博天堂上百名客户聚首澳门" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData56 = [[VIPHistoryImageModel alloc] initWithYearString:@"2015" WithMonthString:@"03"
                                                                       withImageName:@"img20" withUrl:@"www/h_thankyou/index.html"
                                                                  withTopTitleString:@"“一路相伴 感谢有您”"
                                                                  withSubTitleString:@"博天堂澳门春茗答谢晚宴 派送百万豪礼" withIsFirstData:NO withIsDetails:YES];
    
    VIPHistoryImageModel *iData6 = [[VIPHistoryImageModel alloc] initWithYearString:@"2014" WithMonthString:@"11"
                                                                      withImageName:@"img21" withUrl:@"www/h_golfpackage/index.html"
                                                                  withTopTitleString:@"918.com高尔夫亚巡赛完美收官"
                                                                  withSubTitleString:@"新加坡老将马玛（Mardan Mamat）喜获冠军" withIsFirstData:YES withIsDetails:YES];
    VIPHistoryImageModel *iData61 = [[VIPHistoryImageModel alloc] initWithYearString:@"2014" WithMonthString:@"10"
                                                                       withImageName:@"img22" withUrl:@""
                                                                  withTopTitleString:@"互动咪牌百家乐正式上线"
                                                                  withSubTitleString:@"互动咪牌百家乐正式上线，LED超清视觉效果 游戏进程尽在掌控" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData62 = [[VIPHistoryImageModel alloc] initWithYearString:@"2014" WithMonthString:@"10"
                                                                       withImageName:@"img23" withUrl:@"www/h_golftour/index.html"
                                                                  withTopTitleString:@"博天堂冠名2014高尔夫亚巡赛"
                                                                  withSubTitleString:@"10月10日举办南木球场高球友谊赛及马尼拉站媒体见面会" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData63 = [[VIPHistoryImageModel alloc] initWithYearString:@"2014" WithMonthString:@"7"
                                                                       withImageName:@"img24" withUrl:@"www/h_golfconference/index.html"
                                                                  withTopTitleString:@"“918.com亚巡大师杯”高尔夫赛新闻发布会"
                                                                  withSubTitleString:@"在菲律宾最知名赌场“resorts world”召开新闻发布会" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData64 = [[VIPHistoryImageModel alloc] initWithYearString:@"2014" WithMonthString:@"7"
                                                                       withImageName:@"img25" withUrl:@""
                                                                  withTopTitleString:@"手机投注全面上线"
                                                                  withSubTitleString:@"随时随地畅享投注赢利爆棚" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData65 = [[VIPHistoryImageModel alloc] initWithYearString:@"2014" WithMonthString:@"5"
                                                                       withImageName:@"img26" withUrl:@""
                                                                  withTopTitleString:@"博天堂正式更换LOGO"
                                                                  withSubTitleString:@"918博天堂 博彩天堂" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData66 = [[VIPHistoryImageModel alloc] initWithYearString:@"2014" WithMonthString:@"1"
                                                                       withImageName:@"img27" withUrl:@"www/h_lotusofficer/index.html"
                                                                  withTopTitleString:@"博天堂AV女优荷官周"
                                                                  withSubTitleString:@"一睹波多野结衣等著名AV女优荷官发牌风采" withIsFirstData:NO withIsDetails:YES];
    
    VIPHistoryImageModel *iData7 = [[VIPHistoryImageModel alloc] initWithYearString:@"2013" WithMonthString:@"12"
                                                                      withImageName:@"img28" withUrl:@""
                                                                  withTopTitleString:@"博天堂引领博彩业潮流"
                                                                  withSubTitleString:@"正式开通比特币充值游戏" withIsFirstData:YES withIsDetails:NO];
    VIPHistoryImageModel *iData71 = [[VIPHistoryImageModel alloc] initWithYearString:@"2013" WithMonthString:@"11"
                                                                       withImageName:@"img29" withUrl:@"www/h_industrytrend/index.html"
                                                                  withTopTitleString:@"博天堂爱心捐赠"
                                                                  withSubTitleString:@"博天堂全体爱心捐赠100万peso" withIsFirstData:NO withIsDetails:YES];
    VIPHistoryImageModel *iData72 = [[VIPHistoryImageModel alloc] initWithYearString:@"2013" WithMonthString:@"11"
                                                                       withImageName:@"img30" withUrl:@""
                                                                  withTopTitleString:@"博天堂通过博彩监管机构 “FCLRC”"
                                                                  withSubTitleString:@"正式开通比特币充值游戏" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData73 = [[VIPHistoryImageModel alloc] initWithYearString:@"2013" WithMonthString:@"11"
                                                                       withImageName:@"img31" withUrl:@""
                                                                  withTopTitleString:@"博天堂单日提款限额升至600万"
                                                                  withSubTitleString:@"网站开通各澳门知名赌场赌厅最高单日提款2000万" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData74 = [[VIPHistoryImageModel alloc] initWithYearString:@"2013" WithMonthString:@"2"
                                                                       withImageName:@"img32" withUrl:@""
                                                                  withTopTitleString:@"包桌咪牌百家乐正式上线"
                                                                  withSubTitleString:@"打造线上赌场贵宾厅" withIsFirstData:NO withIsDetails:NO];
    VIPHistoryImageModel *iData75 = [[VIPHistoryImageModel alloc] initWithYearString:@"2013" WithMonthString:@"2"
                                                                       withImageName:@"img33" withUrl:@""
                                                                  withTopTitleString:@"首创六张牌先发"
                                                                  withSubTitleString:@"将在线博彩的公平性展现到极致" withIsFirstData:NO withIsDetails:NO];
    
    
    
    NSMutableArray *dArray = [NSMutableArray arrayWithObjects:sData9,sData8,sData7,sData6,sData5,sData4,sData3,sData2,sData1, nil];
    NSMutableArray *iArray = [NSMutableArray arrayWithObjects:iData9,iData91,iData92,iData8,iData81,iData82,iData83,iData1,iData11,iData2,iData21,iData22,iData23,iData3,iData31,iData32,iData33,iData34,iData4,iData41,iData42,iData43,iData44,iData45,iData46,iData47,iData48,iData49,iData410,iData411,iData412,iData413,iData5,iData51,iData52,iData53,iData54,iData55,iData56,iData6,iData61,iData62,iData63,iData64,iData65,iData66,iData7,iData71,iData72,iData73,iData74,iData75, nil];
    VIPHistoryModel * tempModel = [[VIPHistoryModel alloc] initWithSideBarData:dArray withImageModel:iArray];
    return tempModel;
}
@end
