//
//  BTTPasswordChangeController+Nav.m
//  Hybird_1e3c3b
//
//  Created by JerryHU on 2021/4/7.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTPasswordChangeController+Nav.h"
#import "BTTActionSheet.h"
#import "CLive800Manager.h"

@implementation BTTPasswordChangeController (Nav)
-(void)setUpNav {
    UIButton * rightBtn = [[UIButton alloc] init];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    rightBtn.adjustsImageWhenHighlighted = false;
    [rightBtn setTitle:@" 咨询客服" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"homepage_service"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(kefuBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

-(void)kefuBtnAction {
    BTTActionSheet *actionSheet = [[BTTActionSheet alloc] initWithTitle:@"请选择问题类型" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"存款问题",@"其他问题"] actionSheetBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [[CLive800Manager sharedInstance] startLive800ChatSaveMoney:self];
        }else if (buttonIndex == 1){
            [[CLive800Manager sharedInstance] startLive800Chat:self];
        }
    }];
    [actionSheet show];
}

@end