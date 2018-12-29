//
//  BTTDiscountsViewController.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/1.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTDiscountsViewController.h"
#import "BTTHomePageDiscountCell.h"
#import "BTTHomePageHeaderView.h"
#import "BTTDiscountsViewController+LoadData.h"
#import "BTTPromotionModel.h"
#import "BTTPromotionDetailController.h"
#import "BTTLoginOrRegisterViewController.h"
#import "BTTPopoverView.h"
#import "BTTLive800ViewController.h"
#import "CLive800Manager.h"
#import "BTTTabbarController+VoiceCall.h"
#import "BTTVoiceCallViewController.h"
#import "BTTLoginOrRegisterViewController.h"
#import "BTTMakeCallNoLoginView.h"
#import "BTTMakeCallLoginView.h"
#import "BTTMakeCallSuccessView.h"

@interface BTTDiscountsViewController ()<BTTElementsFlowLayoutDelegate>

@end

@implementation BTTDiscountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠";
    [self setupCollectionView];
    if (self.discountsVCType == BTTDiscountsVCTypeFirst) {
        [self setupNav];
        weakSelf(weakSelf);
        [self pulldownRefreshWithRefreshBlock:^{
            NSLog(@"下拉刷新");
            strongSelf(strongSelf);
            [strongSelf loadMainData];
        }];
    }
    [self showLoading];
    [self loadMainData];
    
}

- (void)setupNav {
    [self.navigationController setNavigationBarHidden:YES];
    BTTHomePageHeaderView *nav = [[BTTHomePageHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KIsiPhoneX ? 88 : 64) withNavType:BTTNavTypeDiscount];
    nav.titleLabel.text = @"优惠";
    [self.view addSubview:nav];
    weakSelf(weakSelf);
    nav.btnClickBlock = ^(UIButton *button) {
        strongSelf(strongSelf);
        switch (button.tag) {
            case 2001:
            {
                [strongSelf rightClick:button];
            }
                break;
                
            case 2002:
            {
                if (![IVNetwork userInfo]) {
                    [MBProgressHUD showError:@"请先登录" toView:nil];
                    BTTLoginOrRegisterViewController *vc = [[BTTLoginOrRegisterViewController alloc] init];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                    return;
                }
                BTTBaseWebViewController *vc = [[BTTBaseWebViewController alloc] init];
                vc.webConfigModel.newView = YES;
                vc.webConfigModel.url = @"customer/letter.htm";
                vc.webConfigModel.theme = @"inside";
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    };
}

- (void)rightClick:(UIButton *)btn {
    
    BTTPopoverAction *action1 = [BTTPopoverAction actionWithImage:ImageNamed(@"onlineService") title:@"在线客服" handler:^(BTTPopoverAction *action) {
        NSString *url = @"https://www.why918.com/chat/chatClient/chatbox.jsp?companyID=8990&configID=21&k=1&codeType=custom";
        BTTLive800ViewController *live800 = [[BTTLive800ViewController alloc] init];
        live800.webConfigModel.url = url;
        live800.webConfigModel.newView = YES;
        [self.navigationController pushViewController:live800 animated:YES];
    }];
    
    BTTPopoverAction *action2 = [BTTPopoverAction actionWithImage:ImageNamed(@"voiceCall") title:@"APP语音通信" handler:^(BTTPopoverAction *action) {
        BTTTabbarController *tabbar = (BTTTabbarController *)self.tabBarController;
        BOOL isLogin = [IVNetwork userInfo] ? YES : NO;
        weakSelf(weakSelf);
        [tabbar loadVoiceCallNumWithIsLogin:isLogin makeCall:^(NSString *uid) {
            if (uid == nil || uid.length == 0) {
                [MBProgressHUD showError:@"拨号失败请重试" toView:nil];
            } else {
                strongSelf(strongSelf);
                [strongSelf registerUID:uid];
            }
        }];
    }];
    int currentHour = [PublicMethod hour:[NSDate date]];
    BOOL isNormalUser = (![IVNetwork userInfo] || [IVNetwork userInfo].customerLevel < 5 || currentHour < 12);
    NSString *callTitle = isNormalUser ? @"电话回拨" : @"VIP经理回拨";
    BTTPopoverAction *action3 = [BTTPopoverAction actionWithImage:ImageNamed(@"callBack") title:callTitle handler:^(BTTPopoverAction *action) {
        if ([IVNetwork userInfo]) {
            [self showCallBackViewLogin];
        } else {
            [self showCallBackViewNoLogin:BTTAnimationPopStyleScale];
        }
    }];
    
    BTTPopoverAction *action4 = [BTTPopoverAction actionWithImage:ImageNamed(@"onlineVoice") title:@"语音聊天" handler:^(BTTPopoverAction *action) {
        [[CLive800Manager sharedInstance] startLive800Chat:self];
    }];
    
    NSString *phoneValue = [IVNetwork getPublicConfigWithKey:@"APP_400_HOTLINE"];
    NSString *normalPhone = nil;
    NSString *vipPhone = nil;
    if (!phoneValue.length) {
        NSArray *phonesArr = [phoneValue componentsSeparatedByString:@"|"];
        normalPhone = phonesArr[1];
        vipPhone = phonesArr[3];
    }
    if (!normalPhone.length) {
        normalPhone = @"400-120-3618";
    }
    if (!vipPhone.length) {
        vipPhone = @"400-120-3616";
    }
    NSString *telUrl = isNormalUser ? [NSString stringWithFormat:@"tel://%@",normalPhone]  : [NSString stringWithFormat:@"tel://%@",vipPhone];
    NSString *title = isNormalUser ? normalPhone : vipPhone;
    title = [NSString stringWithFormat:@"     客服热线\n%@",title];
    BTTPopoverAction *action5 = [BTTPopoverAction actionWithTitle:title detailTitle:title handler:^(BTTPopoverAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
    }];
    BTTPopoverView *popView = [BTTPopoverView PopoverView];
    popView.style = BTTPopoverViewStyleDark;
    popView.arrowStyle = BTTPopoverViewArrowStyleTriangle;
    popView.showShade = YES;
    [popView showToPoint:CGPointMake(SCREEN_WIDTH - 27, KIsiPhoneX ? 88 : 64) withActions:@[action1,action2,action3,action4,action5]];
    
}

- (void)showCallBackViewNoLogin:(BTTAnimationPopStyle)animationPopStyle {
    BTTMakeCallNoLoginView *customView = [BTTMakeCallNoLoginView viewFromXib];
    customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:animationPopStyle dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    customView.dismissBlock = ^{
        [popView dismiss];
    };
    weakSelf(weakSelf);
    customView.callBackBlock = ^(NSString *phone) {
        strongSelf(strongSelf);
        [popView dismiss];
        [strongSelf makeCallWithPhoneNum:phone];
    } ;
}

- (void)showCallBackViewLogin {
    BTTMakeCallLoginView *customView = [BTTMakeCallLoginView viewFromXib];
    customView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:customView popStyle:BTTAnimationPopStyleScale dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    weakSelf(weakSelf);
    customView.dismissBlock = ^{
        [popView dismiss];
    };
    customView.btnBlock = ^(UIButton *btn) {
        strongSelf(strongSelf);
        if (btn.tag == 50010) {
            if (![IVNetwork userInfo].phone.length) {
                [MBProgressHUD showError:@"您未绑定手机, 请选择其他电话" toView:nil];
                return;
            }
            [popView dismiss];
            [strongSelf makeCallWithPhoneNum:[IVNetwork userInfo].phone];
        } else {
            [popView dismiss];
            [self showCallBackViewNoLogin:BTTAnimationPopStyleNO];
        }
    };
}




#pragma mark - JXRegisterManagerDelegate

- (void)registerUID:(NSString *)uid {
    JXRegisterManager *registerManager = [JXRegisterManager sharedInstance];
    registerManager.delegate = self;
    [registerManager registerWithUID:uid];
}

- (void)didRegisterResponse:(NSDictionary *)response {
    NSInteger statusCode = [response[@"code"] integerValue];
    if (statusCode == 200 || statusCode == 409) {//当注册成功或者这个号码在别的手机上注册过
        BTTVoiceCallViewController *vc = (BTTVoiceCallViewController *)[BTTVoiceCallViewController getVCFromStoryboard];
        [self.navigationController pushViewController:vc animated:NO];
    } else {
        NSLog(@"VOIP注册失败");
        [MBProgressHUD showError:@"拨号失败请重试" toView:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.discountsVCType == BTTDiscountsVCTypeFirst) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}


- (void)setupCollectionView {
    [super setupCollectionView];
    if (self.discountsVCType == BTTDiscountsVCTypeFirst) {
        self.collectionView.frame = CGRectMake(0, KIsiPhoneX ? 88 : 64, SCREEN_WIDTH, SCREEN_HEIGHT - (KIsiPhoneX ? 88 : 64));
    }
    [self.collectionView registerNib:[UINib nibWithNibName:@"BTTHomePageDiscountCell" bundle:nil] forCellWithReuseIdentifier:@"BTTHomePageDiscountCell"];
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
    BTTPromotionModel *model = self.sheetDatas.count ? self.sheetDatas[indexPath.row] : nil;
    cell.model = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    BTTPromotionModel *model = self.sheetDatas[indexPath.row];
    BTTPromotionDetailController *vc = [[BTTPromotionDetailController alloc] init];
    vc.webConfigModel.url = model.href;
    vc.webConfigModel.newView = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
    
    NSInteger total = self.sheetDatas.count;
    for (int i = 0; i < total; i++) {
        [self.elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, 130)]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}


@end
