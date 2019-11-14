//
//  BTTHomePageViewController+Nav.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/17.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTHomePageViewController.h"
#import "BTTHomePageHeaderView.h"
#import "JXRegisterManager.h"
#import "BTTLoginOrRegisterBtsView.h"

@class BTTBannerModel;

NS_ASSUME_NONNULL_BEGIN

@interface BTTHomePageViewController (Nav)<JXRegisterManagerDelegate>



@property (nonatomic, strong) BTTHomePageHeaderView *headerView;

@property (nonatomic, strong) BTTLoginOrRegisterBtsView *loginAndRegisterBtnsView;

- (void)setupNav;

- (void)registerNotification;

- (void)showPopViewWithNum:(NSString *)num;

- (void)bannerToGame:(BTTBannerModel *)model;

- (void)showJay;

- (void)setupLoginAndRegisterBtnsView ;

@end

NS_ASSUME_NONNULL_END
