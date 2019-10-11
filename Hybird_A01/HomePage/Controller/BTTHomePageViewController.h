//
//  BTTHomePageViewController.h
//  Hybird_A01
//
//  Created by Domino on 2018/9/29.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTHomePageViewController : BTTCollectionViewController

@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, assign) BOOL isVIP;

- (void)setupElements;

@end

NS_ASSUME_NONNULL_END
