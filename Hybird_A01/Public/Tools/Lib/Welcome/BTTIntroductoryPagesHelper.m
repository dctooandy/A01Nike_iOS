//
//  BTTIntroductoryPagesHelper.m
//  Hybird_A01
//
//  Created by domino on 2018/10/01.
//  Copyright © 2018年 domino. All rights reserved.
//

#import "BTTIntroductoryPagesHelper.h"
#import "BTTIntroductoryPagesView.h"

@interface BTTIntroductoryPagesHelper ()

@property (weak, nonatomic) UIWindow *curWindow;

@property (strong, nonatomic) BTTIntroductoryPagesView *curIntroductoryPagesView;

@end

@implementation BTTIntroductoryPagesHelper

static BTTIntroductoryPagesHelper *shareInstance_ = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance_ = [[BTTIntroductoryPagesHelper alloc] init];
    });
    
    return shareInstance_;
}

+ (void)showIntroductoryPageView:(NSArray<NSString *> *)imageArray {
    if (![BTTIntroductoryPagesHelper shareInstance].curIntroductoryPagesView) {
        [BTTIntroductoryPagesHelper shareInstance].curIntroductoryPagesView = [BTTIntroductoryPagesView pagesViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) images:imageArray];
    }
    
    [BTTIntroductoryPagesHelper shareInstance].curWindow = [UIApplication sharedApplication].keyWindow;
    [[BTTIntroductoryPagesHelper shareInstance].curWindow addSubview:[BTTIntroductoryPagesHelper shareInstance].curIntroductoryPagesView];
    [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:BTTWelcomePage];
}

@end
