//
//  BTTStepTwoContainerController.h
//  Hybird_1e3c3b
//
//  Created by Domino on 28/12/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "CNPayBaseVC.h"
#import "CNPayChannelModel.h"
#import "CNPaymentModel.h"
#import "AMSegmentViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTStepTwoContainerController : CNPayBaseVC

@property (nonatomic, assign) CNPaymentType paymentType;

@property (nonatomic, strong) CNPayBankCardModel *chooseBank;

@property (nonatomic, strong) AMSegmentViewController *segmentVC;

- (instancetype)initWithPaymentType:(CNPaymentType)paymentType;
- (void)setupView;

@end

NS_ASSUME_NONNULL_END
