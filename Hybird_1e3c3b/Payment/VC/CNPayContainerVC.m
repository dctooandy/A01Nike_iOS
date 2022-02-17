//
//  CNPayContainerVC.m
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayContainerVC.h"

#import "CNPayOnlineVC.h"
#import "CNPayDepositStep1VC.h"
#import "CNPayDepositStep2VC.h"
#import "CNPayDepositStep3VC.h"
#import "CNPayBQStep1VC.h"
#import "CNPayBQStep2VC.h"
#import "CNPayQRVC.h"
#import "CNPayQRStep2VC.h"
#import "CNPayCardStep1VC.h"
#import "CNPayCardStep2VC.h"
#import "BTTPayBQAliStep2VC.h"
#import "CNPayUSDTStep1VC.h"
#import "CNPayUSDTQRSecondVC.h"
#import "BTTBishangStep1VC.h"
#import "BTTBiFuBaoController.h"
#import "BTTDcboxPayController.h"
#import "BTTVipPaymentController.h"
#import "CNMFastPayVC.h"

@interface CNPayContainerVC ()



@end

@implementation CNPayContainerVC

- (instancetype)initWithPaymentType:(NSInteger)paymentType {
    self = [super init];
    if (self) {
        self.paymentType = paymentType;
    }
    return self;
}

- (BOOL)canPopViewController {
    if (self.segmentVC.currentDisplayItemIndex > 0) {
        [self.segmentVC transitionItemsToIndex:(self.segmentVC.currentDisplayItemIndex-1) complteBlock:nil];
        return NO;
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    if (_payments && _payments.count > 0) {
        /// 切换容器
        _segmentVC = [[AMSegmentViewController alloc] initWithItems:[self payItemsWithPaymentType:self.paymentType]];
        _segmentVC.view.frame = self.view.bounds;
        [self.view addSubview:_segmentVC.view];
    } else if (self.paymentType == CNPaymentVip) {
        BTTVipPaymentController * vc = [[BTTVipPaymentController alloc] init];
        _segmentVC = [[AMSegmentViewController alloc] initWithItems:@[vc]];
        _segmentVC.view.frame = self.view.bounds;
        [self.view addSubview:_segmentVC.view];
    }
}

/**
 根据支付渠道构建具体的支付页面
 @param paymentType 渠道号
 */
- (NSArray<UIViewController *> *)payItemsWithPaymentType:(NSInteger)paymentType {
    
    NSMutableArray<UIViewController *> *viewControllers = [NSMutableArray array];
    
    CNPaymentModel *payment = nil;
    for (CNPaymentModel *model  in self.payments) {
        if (model.payType == paymentType) {
            payment = model;
            break;
        }
    }
    
    switch (paymentType) {

        case CNPaymentCard: {
            [viewControllers addObjectsFromArray:[self cardPay:payment]];
        }
            break;

        case 0: {
            [viewControllers addObjectsFromArray:[self depositPay:payment]];
        }
            break;

        case CNPaymentCoin:
        case CNPaymentWechatBarCode:
        case CNPaymentBTC:
        case CNPaymentUnionApp:
        case CNPaymentOnline:
        {
            [viewControllers addObjectsFromArray:[self onlinePay:payment]];
        }
            break;
        case CNPaymentAliQR:
        case CNPaymentWechatQR:
        case CNPaymentUnionQR:
        case CNPaymentJDQR:
        case CNPaymentQQQR:
        case CNPaymentYSFQR:
        case CNPaymentWechatApp:
        case CNPaymentJDApp:
        case CNPaymentAliApp:
        case 19:
        case CNPaymentQQApp:{
            [viewControllers addObjectsFromArray:[self QRPay:payment]];
        }
            break;

//        case CNPaymentAliApp:
//        {
//            BOOL timeMoreTen = [[[NSUserDefaults standardUserDefaults] objectForKey:BTTSaveMoneyTimesKey] integerValue]>10;
//            if (timeMoreTen) {
//                [viewControllers addObjectsFromArray:[self QRPay:payment]];
//            } else {
//                [viewControllers addObjectsFromArray:[self onlinePay:payment]];
//            }
//        }
//            break;
        case CNPaymentBQFast:
        case CNPaymentBQWechat:
        case CNPaymentBQAli:
        case 100: {
            [viewControllers addObjectsFromArray:[self BQPay:payment]];
        }
            break;
        case CNPaymentUSDT:{
            CNPayUSDTStep1VC *vc1 = [[CNPayUSDTStep1VC alloc]init];
            vc1.payments = self.payments;
            CNPayUSDTQRSecondVC *vc2 = [[CNPayUSDTQRSecondVC alloc]init];
            [viewControllers addObjectsFromArray:@[vc1,vc2]];
        }
            break;
        case CNPaymentBFB:{
            BTTBiFuBaoController *vc1 = [[BTTBiFuBaoController alloc]init];
            [viewControllers addObjectsFromArray:@[vc1]];
        }
            break;
        case CNPaymentDCBOX:{
            BTTDcboxPayController *vc1 = [[BTTDcboxPayController alloc]init];
            [viewControllers addObjectsFromArray:@[vc1]];
        }
            break;
        case CNPaymentFast:{
            CNMFastPayVC *vc = [[CNMFastPayVC alloc] init];
            vc.paymentModel = payment;
            [viewControllers addObjectsFromArray:@[vc]];
        }
            break;
    }
    
    
    return viewControllers;
}

/// 在线支付
- (NSArray<CNPayBaseVC *> *)onlinePay:(CNPaymentModel *)payment {
    CNPayOnlineVC *step1VC = [[CNPayOnlineVC alloc] init];
    step1VC.paymentModel = payment;
    return @[step1VC];
}

/// 币商支付
- (NSArray<CNPayBaseVC *> *)BSPay:(CNPaymentModel *)payment {
    BTTBishangStep1VC *step1VC = [[BTTBishangStep1VC alloc] init];
    step1VC.paymentModel = payment;
    return @[step1VC];
}

/// 手工支付
- (NSArray<CNPayBaseVC *> *)depositPay:(CNPaymentModel *)payment {
    CNPayDepositStep1VC *step1VC = [[CNPayDepositStep1VC alloc] init];
    CNPayDepositStep2VC *step2VC = [[CNPayDepositStep2VC alloc] init];
    CNPayDepositStep3VC *step3VC = [[CNPayDepositStep3VC alloc] init];
    step1VC.paymentModel = payment;
    step2VC.paymentModel = payment;
    step3VC.paymentModel = payment;
    return @[step1VC, step2VC, step3VC];
}

/// BQ支付 也叫 quickBank
- (NSArray<CNPayBaseVC *> *)BQPay:(CNPaymentModel *)payment {
    
    CNPayBQStep1VC *step1VC = [[CNPayBQStep1VC alloc] init];
    CNPayBQStep2VC *step2VC = [[CNPayBQStep2VC alloc] init];
    step1VC.paymentModel = payment;
    step2VC.paymentModel = payment;
    return @[step1VC, step2VC];
}

/// QR支付
- (NSArray<CNPayBaseVC *> *)QRPay:(CNPaymentModel *)payment {

    CNPayQRVC *step1VC = [[CNPayQRVC alloc] init];
    CNPayQRStep2VC *step2VC = [[CNPayQRStep2VC alloc] init];
    step1VC.paymentModel = payment;
    step2VC.paymentModel = payment;
    // 内部切换数据
    step1VC.payments = _payments;
    return @[step1VC, step2VC];
}

/// 点卡支付
- (NSArray<CNPayBaseVC *> *)cardPay:(CNPaymentModel *)payment {
    CNPayCardStep1VC *step1VC = [[CNPayCardStep1VC alloc] init];
    CNPayCardStep2VC *step2VC = [[CNPayCardStep2VC alloc] init];
    step1VC.paymentModel = payment;
    step2VC.paymentModel = payment;
    return @[step1VC, step2VC];
}

@end
