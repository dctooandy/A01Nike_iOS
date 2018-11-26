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

@interface CNPayContainerVC : UIViewController

@property (nonatomic, assign) CNPayChannel payChannel;
@property (nonatomic, strong) NSArray<CNPaymentModel *> *payments;

- (instancetype)initWithPayChannel:(CNPayChannel)payChannel;
- (BOOL)canPopViewController;
@end
