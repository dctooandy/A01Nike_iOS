//
//  BTTVIPClubPageViewController+Nav.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/4/16.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTVIPClubPageViewController.h"
#import "BTTHomePageHeaderView.h"
#import "JXRegisterManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface BTTVIPClubPageViewController (Nav)<JXRegisterManagerDelegate>
@property (nonatomic, strong) BTTHomePageHeaderView *headerView;
- (void)setupNav;
@end

NS_ASSUME_NONNULL_END
