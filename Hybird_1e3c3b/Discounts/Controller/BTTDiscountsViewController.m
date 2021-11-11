//
//  BTTDiscountsViewController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/1.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTDiscountsViewController.h"
#import "BTTHomePageDiscountCell.h"
#import "BTTDiscountsViewController+LoadData.h"
#import "BTTDiscountsViewController+Nav.h"
#import "BTTPromotionModel.h"
#import "BTTPromotionDetailController.h"
#import "BTTLoginOrRegisterViewController.h"
#import "BTTVideoGamesListController.h"
#import "BTTAGQJViewController.h"
#import "BTTAGGJViewController.h"
#import "BTTGamesTryAlertView.h"
#import "UIView+MJExtension.h"

@interface BTTDiscountsViewController ()<BTTElementsFlowLayoutDelegate, UIScrollViewDelegate>
{
    UIButton *nextYear;
}
@end

@implementation BTTDiscountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠";
    self.btnIndex = 0;
    [self setupCollectionView];
    [self setupNav];
    weakSelf(weakSelf);
    [self pulldownRefreshWithRefreshBlock:^{
        NSLog(@"下拉刷新");
        strongSelf(strongSelf);
        [strongSelf loadMainData];
    }];
    [self loadMainData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllData) name:@"CHANGE_MODE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:LogoutSuccessNotification object:nil];
}

-(void)removeAllData {
    [self.elementsHight removeAllObjects];
    [self.collectionView reloadData];
}

-(void)reloadData {
    self.btnIndex = 0;
    [self changeToHistoryPage:self.btnIndex];
    [self loadMainData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:!self.inProgressView.isHidden animated:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [nextYear.imageView setContentMode:UIViewContentModeScaleToFill];
    nextYear.subviews.firstObject.contentMode = UIViewContentModeScaleToFill;
}

- (void)setupCollectionView {
    [super setupCollectionView];
    if (self.inProgressView == nil) {
        self.inProgressView = [[UIView alloc] init];
        self.inProgressView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.inProgressView];
        [self.inProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset((KIsiPhoneX ? 88 : 64));
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.height.offset(44);
        }];
        
        UILabel * lab = [[UILabel alloc] init];
        lab.text = @"正在进行";
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:14];
        [self.inProgressView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.left.equalTo(self.inProgressView);
            make.height.offset(24);
        }];
        
        UIButton * btn = [[UIButton alloc] init];
        [btn setTitle:@" 查看历史优惠" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#417DDA"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"ic_discounts_history"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(historyBtnAction) forControlEvents:UIControlEventTouchUpInside];
        btn.adjustsImageWhenHighlighted = false;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.inProgressView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.right.equalTo(self.inProgressView);
            make.height.offset(24);
        }];
        
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"#454C5A"];
        [self.inProgressView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(1);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.inProgressView);
        }];
    }
    
    if (self.yearsScrollView == nil) {
        self.yearsScrollView = [[UIScrollView alloc] init];
        self.yearsScrollView.backgroundColor = [UIColor clearColor];
        self.yearsScrollView.delegate = self;
        self.yearsScrollView.alwaysBounceHorizontal = true;
        self.yearsScrollView.showsHorizontalScrollIndicator = false;
        self.yearsScrollView.hidden = true;
        [self.view addSubview:self.yearsScrollView];
        [self.yearsScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(-1);
            make.left.right.equalTo(self.view);
            make.height.offset(45);
        }];
    }
    if (nextYear == nil)
    {
        nextYear = [UIButton buttonWithType:UIButtonTypeCustom];
        nextYear.frame = CGRectMake(0, 0, 18, 45);
        nextYear.backgroundColor = [UIColor clearColor];
//        nextYear.titleLabel.font = [UIFont systemFontOfSize:20.0];
//        [nextYear setTitle:@">>" forState:UIControlStateNormal];
//        [nextYear setTitleColor:[UIColor colorWithHexString:@"#417DDA"] forState:UIControlStateNormal];
//        [nextYear.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [nextYear setImage:ImageNamed(@"historyArrow") forState:UIControlStateNormal];
        [nextYear setBackgroundImage:ImageNamed(@"squer") forState:UIControlStateNormal];
        [self.view addSubview:nextYear];
        [nextYear mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.yearsScrollView);
            make.right.right.equalTo(self.yearsScrollView);
            make.height.offset(45);
            make.width.offset(18);
        }];
        weakSelf(weakSelf);
        [nextYear addTarget:weakSelf action:@selector(nextYearPageAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageDiscountCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageDiscountCell"];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inProgressView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
        make.width.offset(SCREEN_WIDTH);
    }];
}

-(void)historyBtnAction {
    [self setUpHistoryNav];
    [self changeToHistoryPage:self.btnIndex];
}

-(void)yearsBtnAction:(UIButton *)btn {
//    for (UIView * view in self.yearsScrollView.subviews) {
//        if ([view isKindOfClass:[UIButton class]]) {
//            UIButton * yearBtn = (UIButton *)view;
//            yearBtn.selected = yearBtn.tag == btn.tag;
//            yearBtn.backgroundColor = yearBtn.tag == btn.tag ? [UIColor colorWithHexString:@"#3082EF"]:[UIColor clearColor];
//        }
//    }
//    [self changeToHistoryPage:btn.tag];
    [self moveScrollViewWithTag:btn.tag];
}
-(void)yearsBtnActionWithTag:(NSInteger )tag {
    for (UIView * view in self.yearsScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * yearBtn = (UIButton *)view;
            yearBtn.selected = yearBtn.tag == tag;
            yearBtn.backgroundColor = yearBtn.tag == tag ? [UIColor colorWithHexString:@"#3082EF"]:[UIColor clearColor];
        }
    }
    [self changeToHistoryPage:tag];

}

-(void)nextYearPageAction
{
    [self moveScrollViewWithTag:self.btnIndex + 1];
}
- (void)moveScrollViewWithTag:(NSInteger)currtneTag
{
    //可出現右邊雙箭號的距離單位,0 代表小於4顆,不出現雙箭號
    NSUInteger moveTagX = ((_yearsBtnTitle.count >= 4) ? (_yearsBtnTitle.count - 4) : 0);
    // 目前 scrollview 的 x,y
    CGPoint offset = self.yearsScrollView.contentOffset;
    
    // 判斷上方導航欄要不要移動
    // 點到的按鈕 小於等於 最大數目,可移動距離超過0單位
    if (((currtneTag) <= _yearsBtnTitle.count - 1) && moveTagX > 0)
    {
        // 目前scrollview的 x 有沒有超過 可移動距離單位
        if (offset.x >= moveTagX * (SCREEN_WIDTH/4))
        {//超過,所以雙箭號隱藏
            [nextYear setHidden:YES];
        }else
        {//沒超過,判斷點擊按鈕tag 有沒有超過 可點選距離
            if (currtneTag >= moveTagX)
            {//超過,隱藏雙箭號
                offset.x = moveTagX * (SCREEN_WIDTH/4);
                [nextYear setHidden:YES];
            }else
            {// 沒超過,算出移動到該按鈕的預設x,雙箭號不隱藏
                offset.x = currtneTag * (SCREEN_WIDTH/4);
                [nextYear setHidden:NO];
            }
        }
        // 移動scrollview
        [self.yearsScrollView setContentOffset:offset animated:YES];
        // vc跳轉
        [self yearsBtnActionWithTag:currtneTag];
    }else
    {
        //可移動距離沒有超過 0 ,年份單位少於4 ,雙箭號隱藏,不移動
//        offset.x = moveTagX * (SCREEN_WIDTH/4);
        [nextYear setHidden:YES];
//        [self.yearsScrollView setContentOffset:offset animated:YES];
        [self yearsBtnActionWithTag:currtneTag];
    }
}
-(void)changeToHistoryPage:(NSInteger)index {
    self.btnIndex = index;
    [self.sheetDatas removeAllObjects];
    for (NSDictionary * dict in [self.model.history valueForKey:self.yearsBtnTitle[index]]) {
        BTTPromotionProcessModel * item = [BTTPromotionProcessModel yy_modelWithJSON:dict];
        [self.sheetDatas addObject:item];
    }
    [self setupElements];
}

-(void)setYearsBtnTitle {
    for (UIView * view in self.yearsScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * yearBtn = (UIButton *)view;
            [yearBtn removeFromSuperview];
        }
    }
    for (int i = 0; i < _yearsBtnTitle.count; i++) {
        UIButton * yearBtn = [[UIButton alloc] init];
        yearBtn.layer.borderColor = [UIColor colorWithHexString:@"#454C5A"].CGColor;
        yearBtn.layer.borderWidth = 1.0;
        [yearBtn setTitle:_yearsBtnTitle[i] forState:UIControlStateNormal];
        [yearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [yearBtn setTitleColor:[UIColor colorWithHexString:@"#6E778B"] forState:UIControlStateNormal];
        yearBtn.backgroundColor = i==self.btnIndex ? [UIColor colorWithHexString:@"#3082EF"]:[UIColor clearColor];
        yearBtn.selected = i==self.btnIndex ? true:false;
        yearBtn.tag = i;
        [yearBtn addTarget:self action:@selector(yearsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        yearBtn.adjustsImageWhenHighlighted = false;
        yearBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.yearsScrollView addSubview:yearBtn];
        [yearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.yearsScrollView).offset(i*SCREEN_WIDTH/4);
            make.top.height.equalTo(self.yearsScrollView);
            make.width.offset(SCREEN_WIDTH/4);
        }];
    }
    if (_yearsBtnTitle.count < 5)
    {
        [nextYear setHidden:YES];
    }else
    {
        [nextYear setHidden:NO];
    }
    self.yearsScrollView.contentSize = CGSizeMake(_yearsBtnTitle.count * SCREEN_WIDTH / 4, 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elementsHight.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BTTHomePageDiscountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTTHomePageDiscountCell" forIndexPath:indexPath];
    if (indexPath.row == self.elementsHight.count - 1) {
        cell.mineSparaterType = BTTMineSparaterTypeNone;
    } else {
        cell.mineSparaterType = BTTMineSparaterTypeSingleLine;
    }
    BTTPromotionProcessModel *model = self.sheetDatas.count ? self.sheetDatas[indexPath.row] : nil;
    cell.model = model;
    cell.isShowOverView = self.yearsScrollView.isHidden;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    BTTPromotionProcessModel *model = self.sheetDatas[indexPath.row];
    if ([model.href containsString:@"htm"]||[model.href containsString:@"activity_pages"]) {
        BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
        vc.title = model.name;
        vc.webConfigModel.url = [model.href stringByReplacingOccurrencesOfString:@" " withString:@""];
        vc.webConfigModel.newView = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSRange gameIdRange = [model.href rangeOfString:@"gameId"];
        if (gameIdRange.location != NSNotFound) {
            NSArray *arr = [model.href componentsSeparatedByString:@":"];
            NSString *gameid = arr[1];
            if ([gameid isEqualToString:BTTAGQJKEY]) {
                if ([IVNetwork savedUserInfo]) {
                    BTTAGQJViewController *vc = [BTTAGQJViewController new];
                    vc.platformLine = [IVNetwork savedUserInfo].uiMode;
                    [CNTimeLog startRecordTime:CNEventAGQJLaunch];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    [self showTryAlertViewWithBlock:^(UIButton * _Nonnull btn) {
                        if (btn.tag == 1090) {
                            BTTAGQJViewController *vc = [BTTAGQJViewController new];
                            vc.platformLine = @"CNY";
                            [CNTimeLog startRecordTime:CNEventAGQJLaunch];
                            [self.navigationController pushViewController:vc animated:YES];
                        } else {
                            [MBProgressHUD showError:@"请先登录" toView:nil];
                            BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }];
                }
            } else if ([gameid isEqualToString:BTTAGGJKEY]) {
                BTTAGGJViewController *vc = [BTTAGGJViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        NSRange andRange = [model.href rangeOfString:@"&"];
        if (andRange.location != NSNotFound) {
            NSArray *andArr = [model.href componentsSeparatedByString:@"&"];
            NSArray *providerArr = [andArr[0] componentsSeparatedByString:@":"];
            NSString *provider = providerArr[1];
            NSArray *gameKindArr = [andArr[1] componentsSeparatedByString:@":"];
            NSString *gameKind = gameKindArr[1];
            IVGameModel *model = [[IVGameModel alloc] init];
            if ([provider isEqualToString:@"AGIN"] && [gameKind isEqualToString:@"8"]) { // 捕鱼王
                model = [[IVGameModel alloc] init];
                model.cnName =  kFishCnName;
                model.enName =  kFishEnName;
                model.provider = kAGINProvider;
                model.gameId = model.gameCode;
                model.gameType = kFishType;
                [[IVGameManager sharedManager] forwardToGameWithModel:model controller:self];
            } else if ([provider isEqualToString:@"SHAB"] && [gameKind isEqualToString:@"1"]) { // 沙巴体育
                model = [[IVGameModel alloc] init];
                model.cnName = @"沙巴体育";
                model.enName =  kASBEnName;
                model.provider =  kShaBaProvider;
            } else if ([provider isEqualToString:@"BTI"] && [gameKind isEqualToString:@"1"]) {  // BTIi体育
                model = [[IVGameModel alloc] init];
                model.cnName = @"BTI体育";
                model.enName =  @"SBT_BTI";
                model.provider =  @"SBT";
            } else if ([provider isEqualToString:kYSBProvider] && [gameKind isEqualToString:@"1"]) {  // YSB体育
                model = [[IVGameModel alloc] init];
                model.cnName = @"YSB体育";
                model.enName =  @"YSB";
                model.provider = kYSBProvider;
            } else if ([provider isEqualToString:@"MG"] ||
                       [provider isEqualToString:@"AGIN"] ||
                       [provider isEqualToString:@"PT"] ||
                       [provider isEqualToString:@"TTG"] ||
                       [provider isEqualToString:@"PP"] ||
                       [provider isEqualToString:@"PS"]) {
                BTTVideoGamesListController *videoGamesVC = [BTTVideoGamesListController new];
                NSString *subProvider = nil;
                if ([provider isEqualToString:@"AGIN"]) {
                    subProvider = @"AG";
                } else {
                    subProvider = provider;
                }
                videoGamesVC.provider = subProvider;
                [self.navigationController pushViewController:videoGamesVC animated:YES];
            }
        } else {
            NSRange providerRange = [model.href rangeOfString:@"provider"];
            if (providerRange.location != NSNotFound) {
                NSArray *arr = [model.href componentsSeparatedByString:@":"];
                NSString *provider = arr[1];
                UIViewController *vc = nil;
                if ([provider isEqualToString:@"AGQJ"]) {
                    vc = [BTTAGQJViewController new];
                    [self.navigationController pushViewController:vc animated:YES];
                } else if ([provider isEqualToString:@"AGIN"]) {
                    vc = [BTTAGGJViewController new];
                    [self.navigationController pushViewController:vc animated:YES];
                } else if ([provider isEqualToString:@"AS"]) {
                    IVGameModel *model = [[IVGameModel alloc] init];
                    model.cnName = @"AS真人棋牌";
                    model.enName =  kASSlotEnName;
                    model.provider = kASSlotProvider;
                }
            }
        }
    }
}

#pragma mark - LMJCollectionViewControllerDataSource

- (UICollectionViewLayout *)collectionViewController:(BTTCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView {
    BTTCollectionViewFlowlayout *elementsFlowLayout = [[BTTCollectionViewFlowlayout alloc] initWithDelegate:self];
    
    return elementsFlowLayout;
}

#pragma mark - LMJElementsFlowLayoutDelegate

- (CGSize)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.elementsHight[indexPath.item].CGSizeValue;
}

- (UIEdgeInsets)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView {
    return UIEdgeInsetsMake(0, 0, KIsiPhoneX ? 83 : 49, 0);
}

/**
 *  列间距, 默认10
 */
- (CGFloat)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView columnsMarginForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

/**
 *  行间距, 默认10
 */
- (CGFloat)waterflowLayout:(BTTCollectionViewFlowlayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (void)setupElements {
    if (self.elementsHight.count) {
        [self.elementsHight removeAllObjects];
    }
    NSMutableArray *elementsHight = [NSMutableArray array];
    NSInteger total = self.sheetDatas.count;
    for (int i = 0; i < total; i++) {
        BTTPromotionProcessModel *model = self.sheetDatas[i];
        UILabel * lab = [[UILabel alloc] init];
        lab.text = model.name;
        lab.font = [UIFont systemFontOfSize:18];
        CGSize size = [lab sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        if (size.width > SCREEN_WIDTH - 15 * 3 - BTTDiscountIconWidth) {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, BTTDiscountDefaultCellHeight + size.height - 21.5 + 15)]];
        } else {
            [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, BTTDiscountDefaultCellHeight)]];
        }
    }
    self.elementsHight = elementsHight.mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
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
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_yearsBtnTitle.count > 4)
    {
        if (scrollView.contentOffset.x >= (_yearsBtnTitle.count - 4) * (SCREEN_WIDTH/4)) {
            [nextYear setHidden:YES];
        }else
        {
            [nextYear setHidden:NO];
        }
    }
}
@end
