//
//  BTTHomePageViewController.h
//  Hybird_A01
//
//  Created by Domino on 2018/9/29.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

#define BTTNavHeightNotLogin (KIsiPhoneX ? (88 + 49) : 113)
#define BTTNavHeightLogin    (KIsiPhoneX ? 88 : 64)

NS_ASSUME_NONNULL_BEGIN

@interface BTTHomePageViewController : BTTCollectionViewController

@property (nonatomic, assign) BOOL isLogin;

- (void)setupElements;

@end

NS_ASSUME_NONNULL_END
