//
//  BTTStepTwoContainerController.m
//  Hybird_1e3c3b
//
//  Created by Domino on 28/12/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTStepTwoContainerController.h"
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

@implementation BTTStepTwoContainerController

- (instancetype)initWithPaymentType:(CNPaymentType)paymentType {
    self = [super init];
    if (self) {
        self.paymentType = paymentType;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    if (self.payments && self.payments.count > 0) {
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
    
//    CNPaymentModel *payment = nil;
//    for (CNPaymentModel *model  in self.payments) {
//        if (model.paymentType == paymentType) {
//            payment = model;
//            break;
//        }
//    }
//    self.title = payment.paymentTitle;
//    switch (paymentType) {
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
//
//        case CNPaymentCard: {
//            [viewControllers addObjectsFromArray:[self cardPay:payment]];
//        }
//            break;
//    }
    return viewControllers;
}

/// QR支付
- (NSArray<CNPayBaseVC *> *)QRPay:(CNPaymentModel *)payment {
//    if (payment.paymentType == CNPaymentDeposit) {
//        CNPayDepositStep2VC *step2VC = [[CNPayDepositStep2VC alloc] init];
//        CNPayDepositStep3VC *step3VC = [[CNPayDepositStep3VC alloc] init];
//        step2VC.paymentModel = payment;
//        step3VC.paymentModel = payment;
//        step2VC.writeModel = self.writeModel;
//        return @[step2VC,step3VC];
//    } else if (payment.paymentType == CNPaymentBQFast ||
//               payment.paymentType == CNPaymentBQWechat ||
//               payment.paymentType == CNPaymentBQAli) {
//
//        CNPayBQStep2VC *step2VC = [[CNPayBQStep2VC alloc] init];
//        step2VC.paymentModel = payment;
//        step2VC.writeModel = self.writeModel;
//        return @[step2VC];
//    }
    CNPayQRStep2VC *step2VC = [[CNPayQRStep2VC alloc] init];
    step2VC.writeModel = self.writeModel;
    return @[step2VC];
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
