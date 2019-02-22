//
//  CNPayContainerVC.h
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNPayChannelModel.h"
#import "CNPaymentModel.h"
#import "AMSegmentViewController.h"

@interface CNPayContainerVC : UIViewController

@property (nonatomic, assign) CNPaymentType paymentType;
@property (nonatomic, strong) NSArray<CNPaymentModel *> *payments;

@property (nonatomic, strong) AMSegmentViewController *segmentVC;

- (instancetype)initWithPaymentType:(CNPaymentType)payChannel;
- (BOOL)canPopViewController;
- (void)setupView;
@end
