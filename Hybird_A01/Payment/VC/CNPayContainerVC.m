//
//  CNPayContainerVC.m
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayContainerVC.h"
#import "AMSegmentViewController.h"
#import "CNPayOnlineVC.h"
#import "CNPayDepositStep1VC.h"
#import "CNPayDepositStep2VC.h"
#import "CNPayDepositStep3VC.h"
#import "CNPayBQStep1VC.h"
#import "CNPayBQStep2VC.h"
#import "CNPayBQStep2VC2.h"
#import "CNPayBQStep2FastVC.h"
#import "CNPayQRVC.h"
#import "CNPayQRStep2VC.h"
#import "CNPayCardStep1VC.h"
#import "CNPayCardStep2VC.h"




@interface CNPayContainerVC ()

@property (nonatomic, strong) AMSegmentViewController *segmentVC;

@end

@implementation CNPayContainerVC

- (instancetype)initWithPayChannel:(CNPayChannel)payChannel {
    self = [super init];
    if (self) {
        self.payChannel = payChannel;
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
        _segmentVC = [[AMSegmentViewController alloc] initWithItems:[self payItemsWithPayChannel:self.payChannel]];
        _segmentVC.view.frame = self.view.bounds;
        [self.view addSubview:_segmentVC.view];
    }
}

/**
 根据支付渠道构建具体的支付页面
 @param channel 渠道号
 */
- (NSArray<UIViewController *> *)payItemsWithPayChannel:(CNPayChannel)channel {
    
    NSMutableArray<UIViewController *> *viewControllers = [NSMutableArray array];
    
    CNPaymentModel *payment = _payments.firstObject;
    
    switch (channel) {
            
        case CNPayChannelCard: {
            [viewControllers addObjectsFromArray:[self cardPay:payment]];
        }
            break;
            
        case CNPayChannelDeposit: {
            [viewControllers addObjectsFromArray:[self depositPay:payment]];
        }
            break;
            
        case CNPayChannelCoin:
        case CNPayChannelWechatBarCode:
        case CNPayChannelJDApp:
        case CNPayChannelBTC:
        case CNPayChannelAliApp:
        case CNPayChannelUnionApp:
        case CNPayChannelOnline: {
            [viewControllers addObjectsFromArray:[self onlinePay:payment]];
        }
            break;
            
        case CNPayChannelQR: {
            [viewControllers addObjectsFromArray:[self QRPay:payment]];
        }
            break;
            
        case CNPayChannelBQFast:
        case CNPayChannelBQWechat:
        case CNPayChannelBQAli: {
            [viewControllers addObjectsFromArray:[self BQPay:payment]];
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

/// 手工支付
- (NSArray<CNPayBaseVC *> *)depositPay:(CNPaymentModel *)payment {
    CNPayBQStep1VC *step1VC = [[CNPayBQStep1VC alloc] init];
    CNPayDepositStep3VC *step3VC = [[CNPayDepositStep3VC alloc] init];
    step1VC.paymentModel = payment;
    step3VC.paymentModel = payment;
    return @[step1VC, step3VC];
}

/// BQ支付 也叫 quickBank
- (NSArray<CNPayBaseVC *> *)BQPay:(CNPaymentModel *)payment {
    CNPayBQStep1VC *step1VC = [[CNPayBQStep1VC alloc] init];
    CNPayBQStep2VC2 *step2VC = [[CNPayBQStep2VC2 alloc] init];
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
