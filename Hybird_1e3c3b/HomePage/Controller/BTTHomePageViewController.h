//
//  BTTHomePageViewController.h
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/9/29.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTCollectionViewController.h"
#import "AssistiveButton.h"
#import "AppdelegateManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTTHomePageViewController : BTTCollectionViewController

@property (nonatomic, strong) AssistiveButton * assistiveButton;
@property (nonatomic, strong) AssistiveButton * redPocketsAssistiveButton;

@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, assign) BOOL isVIP;

@property (nonatomic, assign) BOOL idDisable;

- (void)setupElements;
- (void)showRedPacketsRainViewWithDuration:(int)duration;
@end

NS_ASSUME_NONNULL_END
