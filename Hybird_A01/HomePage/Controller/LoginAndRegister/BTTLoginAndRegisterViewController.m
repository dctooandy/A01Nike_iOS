//
//  BTTLoginAndRegisterViewController.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/17.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTLoginAndRegisterViewController.h"

@interface BTTLoginAndRegisterViewController ()

@end

@implementation BTTLoginAndRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self registerNotification];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotification) name:LogoutSuccessNotification object:nil];
    
}

- (void)logoutNotification {
    [self.webView stringByEvaluatingJavaScriptFromString:@"localStorage.clear()"];
}

@end
