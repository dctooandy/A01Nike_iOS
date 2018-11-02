//
//  BTTMineViewController+Nav.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/18.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTMineViewController+Nav.h"

@implementation BTTMineViewController (Nav)

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:LoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess:) name:LogoutSuccessNotification object:nil];
}

- (void)loginSuccess:(NSNotification *)notifi {
    [self setupElements];
}

- (void)logoutSuccess:(NSNotification *)notifi {
    [self setupElements];
}

- (void)setupNavBtn {
    self.navigationItem.leftBarButtonItem = nil;
    UIButton *serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    serviceBtn.frame = CGRectMake(0, 0, 24, 24);
    [serviceBtn setImage:ImageNamed(@"homepage_service") forState:UIControlStateNormal];
    serviceBtn.tag = 6001;
    [serviceBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *serviceItem = [[UIBarButtonItem alloc] initWithCustomView:serviceBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = 30;
    
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    messageBtn.frame = CGRectMake(0, 0, 24, 24);
    [messageBtn setImage:ImageNamed(@"homepage_messege") forState:UIControlStateNormal];
    messageBtn.redDotOffset = CGPointMake(2, -1);
    messageBtn.tag = 6002;
    [messageBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *messageItem = [[UIBarButtonItem alloc] initWithCustomView:messageBtn];
    
    self.navigationItem.rightBarButtonItems = @[serviceItem,negativeSpacer,messageItem];
    
    [GJRedDot registNodeWithKey:BTTMineCenterMessage
                      parentKey:BTTMineCenterItemsKey
                    defaultShow:YES];
    [self setRedDotKey:BTTMineCenterMessage refreshBlock:^(BOOL show) {
        messageBtn.showRedDot = show;
    } handler:self];
    [self resetRedDotState:YES forKey:BTTMineCenterMessage];
}

- (void)buttonClick:(UIButton *)button {
    
}

@end
