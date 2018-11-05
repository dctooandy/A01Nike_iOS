//
//  BTTBaseWebViewController.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/2.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBaseWebViewController.h"

@interface BTTBaseWebViewController ()

@end

@implementation BTTBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.scrollView.bounces = YES;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
}

#pragma mark --------------------加载框-----------------------------------------
- (void)showLoading {
    dispatch_main_async_safe((^{
        //       self.hud = [BTTProgressHUD showLoadingCircletoView:self.view];
        self.hud = [BTTProgressHUD showOnlyHUDOrCustom:BTTProgressHUDCustom images:@[@"dropdown_loading_01",@"dropdown_loading_02",@"dropdown_loading_03"] toView:self.view];
    }));
    
}

- (void)hideLoading {
    dispatch_main_async_safe(^{
        [self.hud dismiss];
    });
    
}

@end
