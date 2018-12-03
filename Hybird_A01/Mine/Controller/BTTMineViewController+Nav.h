//
//  BTTMineViewController+Nav.h
//  Hybird_A01
//
//  Created by Domino on 2018/10/18.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTMineViewController.h"
#import "BTTHomePageHeaderView.h"
#import "JXRegisterManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTMineViewController (Nav)<JXRegisterManagerDelegate>

@property (nonatomic, strong) BTTHomePageHeaderView *headerView;

- (void)setupNav;

- (void)registerNotification;

@end

NS_ASSUME_NONNULL_END
