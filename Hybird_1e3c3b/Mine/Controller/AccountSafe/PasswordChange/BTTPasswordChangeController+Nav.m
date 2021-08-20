//
//  BTTPasswordChangeController+Nav.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 7/4/2021.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTPasswordChangeController+Nav.h"
#import "BTTActionSheet.h"

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
    [LiveChat startKeFu:self];
//    [CSVisitChatmanager startWithSuperVC:self finish:^(CSServiceCode errCode) {
//        if (errCode != CSServiceCode_Request_Suc) {
//            [MBProgressHUD showErrorWithTime:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持" toView:nil duration:3];
//        } else {
//
//        }
//    }];
}

@end
