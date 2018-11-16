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

static const char *noticeStrKey = "noticeStr";

static const char *BTTNextGroupKey = "nextGroup";

@implementation BTTHomePageViewController (LoadData)

- (void)loadDataOfHomePage {
    
    [self loadHeadersData];
    
    [self loadActivities];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoading];
        });
        [self loadBannersData];
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadScrollText];
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadAmountsData];
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideLoading];
            [self endRefreshing];
        });
    });
}

#pragma mark - 请求banner数据

- (void)loadBannersData {
    
    [IVNetwork sendRequestWithSubURL:@"app/indexBanner" paramters:nil completionBlock:^(IVRequestResultModel *result, id response) {
        NSString *banners = result.data;
        BTTBannerModel *model = [[BTTBannerModel alloc] initWithString:banners error:nil];
        NSArray *bannerImgUrls = model.index[@"slider_data"];
        if (self.imageUrls.count) {
            [self.imageUrls removeAllObjects];
        }
        NSLog(@"%@",bannerImgUrls);
        for (NSDictionary *dict in bannerImgUrls) {
            NSLog(@"%@",dict);
            NSLog(@"%@",dict[@"action"]);
            BTTBannerImageModel *imageModel = [[BTTBannerImageModel alloc] init];
            imageModel.imgurl = dict[@"imgurl"];
            imageModel.detail = dict[@"action"][@"detail"];
            [self.imageUrls addObject:imageModel.imgurl];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
    }];
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
            BTTNoticeModel *noticeModel = [[BTTNoticeModel alloc] initWithDictionary:dict error:&error];
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

- (void)loadAmountsData {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formatter stringFromDate:date];
    
    NSDictionary *params = @{@"date_start":[NSString stringWithFormat:@"%@ 00:00:00",dateStr],
                             @"min_bet_amount":@"1000",
                             @"page_size":@"100"
                             };
    
    [IVNetwork sendRequestWithSubURL:@"A01/bet/getRecordMax" paramters:params completionBlock:^(IVRequestResultModel *result, id response) {
        NSArray *data = result.data;
        if (![data isKindOfClass:[NSArray class]]) {
            return;
        }
        if (self.amounts.count) {
            [self.amounts removeAllObjects];
        }
        for (NSDictionary *dict in data) {
            BTTAmountModel *model = [[BTTAmountModel alloc] initWithDictionary:dict error:nil];
            [self.amounts addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
}

- (void)loadActivities {
    NSArray *dataArr = @[
                         @{
                             @"title": @"\"飞\"律宾惊喜游艇之旅第一季",
                             @"desc" : @"2017年初夏，博天堂尊贵客户及亲友参加了豪华游艇之旅，实地参观AG贵宾厅进行了现场投注，观赏了世界烟火大赛，乘坐豪华游艇品美酒赏海景，并亲身体验自驾飞机翱翔天际。。。",
                             @"list" : @[@"体验开飞机",@"焰火表演",@"豪华游艇",@"客户体验射击",@"驾船出游",@"客户自驾飞机",@"欢迎晚宴",@"大雅台火山"]
                             },
                         @{
                             @"title": @"2017年阳春三月德荷两国欢乐游",
                             @"desc" : @"2017年3月博天堂客户莅临德国在VIP包厢观赏勒沃库森精彩赛事，参观了宏伟壮观的科隆教堂、奥古斯塔斯堡，游览了贝多芬故居，并乘船游览荷兰羊角村，尽享了德荷欧洲风情！",
                             @"list" : @[@"游览科隆大教堂",@"乘船观赏美景",@"德荷著名奥特莱斯购物",@"勒沃库森教练席留影",@"米其林餐厅接风宴",@"VIP包厢观战",@"观赏莱茵河美景",@"游览荷兰羊角村"]
                             },
                         @{
                             @"title": @"2016年11月德荷两国欢乐游",
                             @"desc" : @"2016年11月，客户德国现场观看勒沃库森与RB莱比锡精彩赛事。客户一行品尝德国啤酒美食，观看了梵高画展，荷兰参观中世纪风情 “荷兰风车村”，体验了性都阿姆斯特丹夜生活，美景美食美人美不胜收。。。",
                             @"list" : @[@"客户浏览风车村",@"客户教练席合影",@"客户勒沃库森俱乐部合影",@"客户VIP包厢观赛合影",@"客户现场观战",@"客户与勒沃库森球员合影",@"客户浏览国王大道"]
                             },
                         @{
                             @"title": @"2016年9月德荷两国欢乐游",
                             @"desc" : @"2016年9月，博天堂亲临德国观看勒沃库森对战多特蒙德。参观了著名拜耳球场，游览科隆大教堂，走过莱茵河上布满爱情锁浪漫“霍亨索伦桥”，贝多芬故居合影，荷兰参观了梵高美术馆。",
                             @"list" : @[@"客户VIP包厢看球赛",@"客户跟勒沃库森球员合影",@"近距离看精彩瞬间",@"美食当前喜不自胜",@"游荷兰风车村",@"游览科隆大教堂",@"霍亨索伦桥迷人夜景",@"霍亨索伦桥上街头艺人互动",@"客户&辣妹共舞"]
                             },
                         @{
                             @"title": @"与尼尔罗伯逊相约菲律宾",
                             @"desc" : @"2016年金秋，20余名VIP会员欢聚菲律宾，跟世界知名斯诺克球手罗伯逊切磋球技，亲身体验了实弹射击；参加豪华热辣游艇party，交朋识友不亦乐乎！",
                             @"list" : @[@"罗伯逊与全部会员合影",@"VIP客户与罗伯逊切磋球技",@"尼尔·罗伯逊签名",@"晚宴与罗伯逊谈笑风生",@"VIP客户与罗伯逊合影",@"游艇party",@"罗伯逊游艇写真",@"罗伯逊与美女同游"]
                             },
                         @{
                             @"title": @"萧敬腾&范玮琪澳门演唱会",
                             @"desc" : @"2016年5月,来自五湖四海90余名博天堂尊贵客户及亲朋在澳门欢聚一堂。晚宴后客户们在VIP坐席观赏了演唱会，并与喜爱的明星合影留念。",
                             @"list" : @[@"博天堂会员感受到现场演唱会的热烈气氛",@"萧敬腾&范玮琪深情对唱",@"绚丽的演唱会现场",@"博天堂会员接受采访",@"博天堂会员们共聚一堂，共进晚宴",@"博天堂VIP会员与萧敬腾合影",@"博天堂会员与范玮琪合影",@"客户签名留念"]
                             },
                         @{
                             @"title": @"博天堂冠名世界经典赛事",
                             @"desc" : @"2016年2月，博天堂尊贵客户及亲朋参加了德国荷兰奢华之旅，参观历史遗迹柏林墙、欧洲最大的红灯区汉堡巷。品尝了地道的德国猪手，白啤酒等当地美食。现场观战斯诺克大师赛后，与获奖选手合影，并获赠世界顶尖选手签名球杆，惊喜万分！",
                             @"list" : @[@"博天堂客户现场观看德国斯诺克大师赛",@"斯诺克德国大师赛精彩瞬间",@"客户近距离观看斯诺克德国大师赛",@"博天堂代表与冠军合影留念",@"获奖后冠军与博天堂客户与观众互动",@"冠军马丁古尔德答谢现场观众"]
                             },
                         @{
                             @"title": @"宝丽金永恒金曲澳门演唱会",
                             @"desc" : @"2015年3月博天堂尊贵客户在演唱会VIP坐席观看了宝丽金演唱会，一睹李克勤等众星风采。客户一行参观了澳门必不可少的“妈阁庙”、全球十大观光塔的“澳门旅游塔”及“大三巴牌坊“，并获得博天堂赠送免费筹码，跟红顶绿一试手气。",
                             @"list" : @[@"博天堂客户们观光大三巴牌坊",@"博天堂客户VIP坐席聆听现场演唱会",@"客户们近距离欣赏宝丽金众星演唱",@"博天堂VIP客户与明星合影",@"博天堂VIP客户与明星合影",@"博天堂VIP客户与李克勤合影"]
                             },
                         @{
                             @"title": @"一路相伴，感谢有您",
                             @"desc" : @"2013年3月博天堂110名尊贵的会员参加了在澳门举办的春茗答谢晚宴，当晚博天堂为贵客们现场送出了价值5万的3组金牌、价值10万的劳力士及价值20万百达翡丽等众多大奖。",
                             @"list" :@[@"答谢晚宴现场",@"晚宴现场透明抽奖箱",@"尊贵VIP客户参与现场小游戏",@"晚会现场互动",@"晚会沙画表演",@"晚宴现场抽奖",@"客户抽中价值10万的劳力士",@"客户抽中价值20万的百达翡丽"]
                             },
                         @{
                             @"title": @"918高尔夫亚巡赛11月23日完美收官",
                             @"desc" : @"2014年11月博天堂尊贵用户们参加了奢华菲律宾之旅，客户一行实地参观了AG厅，进行了现场投注，体验了私人定制的国家级梁文冲高尔夫教学，领略了酒吧街浓郁的异国风情，享受碧海蓝天比基尼海滩的休闲一夏。",
                             @"list" : @[@"高尔夫比赛现场",@"亚巡赛精彩瞬间",@"亚巡赛精彩瞬间",@"高尔夫晚宴现场",@"亚巡赛精彩瞬间",@"尊贵VIP客户与中国选手合影",@"尊贵VIP客户现场中奖",@"尊贵VIP客户与梁文冲合影",@"博天堂高尔夫宝贝风采"]
                             },
                         @{
                             @"title": @"博天堂AV女友荷官周",
                             @"desc" : @"2014年1月博天堂尊贵客户们与波多野结衣等八位顶级女优共聚菲律宾，一起参与博天堂举办AV女优荷官欢乐周。晚宴现场，尊贵的博天堂客户们与女优进行了亲密游戏互动，并合影签名留念。",
                             @"list" : @[@"探班后台近距离接触波多野结衣",@"女优初音实荷官风采",@"女优北条麻妃荷官风采",@"尊贵VIP客户与女优共进晚餐",@"女优给尊贵VIP会员们签名留念",@"尊贵VIP会员与女优游戏互动",@"尊贵VIP客户与女优合影留念",@"尊贵VIP客户与女优合影留念",@"尊贵VIP客户与女优交杯酒",@"尊贵VIP客户与女优合影"]
                             },
                         @{
                             @"title": @"梦幻海岛之旅",
                             @"desc" : @"2017年8月,博天堂尊贵客户欢聚菲律宾参与了“梦幻海岛之旅”！奢华游艇party，参观体验AG现场下注，自驾飞机翱翔天际，驾越野扬沙溅石穿越山地河谷，雨中泛竹筏。。。客户们流连忘返。好几个客户约定下次要带更多朋友再来，不见不散！",
                             @"list" : @[@"自驾越野车刺激体验",@"一路崎岖勇往直前",@"车队穿山越岭",@"驾驶飞机蓝天翱翔",@"畅享驾飞机乐趣",@"客户游艇派对边玩边赚钱",@"客户返乡表示诚挚谢意",@"雨中划竹筏别样体验",@"展示实体赌场战绩"]
                             },
                         @{
                             @"title": @"“飞”律宾长滩暖阳海岛游第四季",
                             @"desc" : @"2017年12月，博天堂尊贵客户相聚长滩。在这世界知名海滩，客户体验了刺激的摩托艇和香蕉船，乘拖曳伞翱翔蓝天，潜水探秘海底奇观。惬意的旅途中，与新结识的朋友们相谈甚欢。下一站，不见不散！",
                             @"list" : @[@"博天堂工作人员热情接待",@"俯瞰长滩岛",@"搭乘螃蟹船跳岛游",@"帅气的悬崖跳水",@"体验浮潜",@"体验拖曳伞",@"客户驾艇乘风破浪",@"香蕉船体验水花四溅",@"客户海底漫步",@"碧海蓝天下合影留念",@"参与越野车比赛",@"接机警车开道",@"体验真枪实弹",@"客户参观博天堂Solaire现场",@"客户举杯欢聚一堂",@"客户在白鲨会馆小憩"]
                             },
                         @{
                             @"title": @"2018年浪漫德法五日游",
                             @"desc" : @"2018年4月勒沃库森旅游季，德法浪漫游再次让博天堂客户欢聚。客户一行感受了法国巴黎的浪漫，香波古堡的文艺；在知名的凯旋门、卢浮宫留下了足迹；埃菲尔铁塔、塞纳河边播洒满欢声笑语。在拜耳球场，客户在VIP包厢现场观战勒沃库森4:1大胜法兰克福，酣畅淋漓！ 下一站，继续与您相约！",
                             @"list" : @[@"巴黎街头合影",@"漫步小镇",@"游览香波古堡",@"异国风情",@"交朋识友相见甚欢",@"巴黎街头烂漫合影",@"夜游埃菲尔铁塔",@"教练席合影",@"奥特莱斯购物游戏",@"球迷呐喊助威",@"与街头艺人合影",@"与球星合影",@"巴黎携手赏花",@"客户VIP包厢观战", @"巴黎春语",@"塞纳河游船及美食"]
                             },
                         @{
                             @"title": @"“菲”去不可  科隆岛浪漫之旅",
                             @"desc" : @"2018年6月，博天堂尊贵客户参加了科隆岛浪漫之旅。客户一行参观了solaire赌场AG厅和电投厅，进行了现场投注，自驾飞机直冲云霄，实弹射击百步穿杨，潜水海底探秘奇观。夏日、阳光、沙滩、比基尼美女，还差一个你！下一站不见不散！",
                             @"list" : @[@"警车开道",@"客户悠闲浮潜",@"客户木屋下自嗨",@"客户品尝新鲜海鲜",@"科隆绝美秘境",@"客户享受露天海水温泉",@"高端水疗后客人享用美食",@"客户海底拍摄美景",@"枪店工作人员讲解",@"客户AG厅前合影",@"客户参观摄影棚赌场",@"驾驶飞机冲上云霄",@"客户探索海底世界",@"高端私人会所晚宴",@"巾帼不让须眉",@"客户海上合影"]
                             },
                         ];
    if (self.Activities.count) {
        [self.Activities removeAllObjects];
    }
    
    for (NSDictionary *dict in dataArr) {
        NSInteger index = [dataArr indexOfObject:dict];
        BTTActivityModel *model = [[BTTActivityModel alloc] init];
        model.title = dict[@"title"];
        model.desc = dict[@"desc"];
        model.list = dict[@"list"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSString *name in model.list) {
            NSInteger num = [model.list indexOfObject:name];
            NSString *url = nil;
            if (index + 1 < 10) {
                url = [NSString stringWithFormat:@"%@static/A01M/_default/__static/__images/app/show_photos/0%@/%@.jpg",[IVNetwork h5Domain],@(index + 1),@(num + 1)];
            } else {
                url = [NSString stringWithFormat:@"%@static/A01M/_default/__static/__images/app/show_photos/%@/%@.jpg",[IVNetwork h5Domain],@(index + 1),@(num + 1)];
            }
            [arr addObject:url];
        }
        model.imageUrls = [arr copy];
        [self.Activities addObject:model];
    }
    self.nextGroup = self.Activities.count - 1;
    [self setupElements];
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

@end
