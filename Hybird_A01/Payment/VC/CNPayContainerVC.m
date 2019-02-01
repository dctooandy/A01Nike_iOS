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




@interface CNPayContainerVC ()



@end

@implementation CNPayContainerVC

- (instancetype)initWithPaymentType:(CNPaymentType)paymentType {
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
    }
}

/**
 根据支付渠道构建具体的支付页面
 @param paymentType 渠道号
 */
- (NSArray<UIViewController *> *)payItemsWithPaymentType:(CNPaymentType)paymentType {
    
    NSMutableArray<UIViewController *> *viewControllers = [NSMutableArray array];
    
    CNPaymentModel *payment = nil;
    for (CNPaymentModel *model  in self.payments) {
        if (model.paymentType == paymentType) {
            payment = model;
            break;
        }
    }
    
    switch (paymentType) {
//        case CNPaymentAliQR:
//        case CNPaymentAliApp:
//        case CNPaymentBQAli:
//        case CNPaymentWechatQR:
//        case CNPaymentWechatApp:
//        case CNPaymentWechatBarCode:
//        case CNPaymentBQWechat:
//        case CNPaymentUnionQR:
//        case CNPaymentUnionApp:
//        case CNPaymentDeposit:
//        case CNPaymentJDQR:
//        case CNPaymentJDApp:
//        case CNPaymentQQQR:
//        case CNPaymentBQFast:
//        case CNPaymentQQApp:
//        case CNPaymentBTC:
//        case CNPaymentCoin:
//        case CNPaymentOnline:
//        {
//            [viewControllers addObjectsFromArray:[self QRPay:payment]];
//        }
//            break;
            
            
        case CNPaymentCard: {
            [viewControllers addObjectsFromArray:[self cardPay:payment]];
        }
            break;
            
        case CNPaymentDeposit: {
            [viewControllers addObjectsFromArray:[self depositPay:payment]];
        }
            break;
            
        case CNPaymentCoin:
        case CNPaymentWechatBarCode:
        case CNPaymentBTC:
        case CNPaymentAliApp:
        case CNPaymentUnionApp:
        case CNPaymentOnline: {
            [viewControllers addObjectsFromArray:[self onlinePay:payment]];
        }
            break;
        case CNPaymentJDQR:
        case CNPaymentAliQR:
        case CNPaymentWechatQR:
        case CNPaymentUnionQR:
        case CNPaymentQQApp:
        case CNPaymentJDApp:
        case CNPaymentWechatApp:
        case CNPaymentQQQR: {
            [viewControllers addObjectsFromArray:[self QRPay:payment]];
        }
            break;
            
        case CNPaymentBQFast:
        case CNPaymentBQWechat:
        case CNPaymentBQAli: {
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
    if (payment.paymentType == CNPaymentWechatApp ||
        payment.paymentType == CNPaymentJDApp ||
        payment.paymentType == CNPaymentQQApp ) {
        CNPayQRVC *step1VC = [[CNPayQRVC alloc] init];
        step1VC.paymentModel = payment;
        step1VC.payments = _payments;
        return @[step1VC];
    }
//    else if (payment.paymentType == CNPaymentBQFast ||
//               payment.paymentType == CNPaymentBQWechat ||
//               payment.paymentType == CNPaymentBQAli) {
//        CNPayQRVC *step1VC = [[CNPayQRVC alloc] init];
//        step1VC.paymentModel = payment;
//        step1VC.payments = _payments;
//        return @[step1VC];
//    }
    CNPayQRVC *step1VC = [[CNPayQRVC alloc] init];
    step1VC.paymentModel = payment;
    // 内部切换数据
    step1VC.payments = _payments;
    return @[step1VC];
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
