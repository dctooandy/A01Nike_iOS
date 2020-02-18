//
//  BTTLoginInfoView.m
//  Hybird_A01
//
//  Created by Levy on 2/18/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTLoginInfoView.h"

@interface BTTLoginInfoView()

@end

@implementation BTTLoginInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *accountView = [[UIView alloc]initWithFrame:CGRectMake(36, 0, SCREEN_WIDTH-72, 60)];
        [self addSubview:accountView];
        
        UITextField *accountField = [[UITextField alloc]init];
        accountField.font = [UIFont systemFontOfSize:16];
        accountField.textColor = [UIColor whiteColor];
        accountField.placeholder = @"用户名/手机号";
        UIImageView *actLeftImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_account"]];
        accountField.leftView = actLeftImg;
        accountField.leftViewMode = UITextFieldViewModeAlways;
        [accountView addSubview:accountField];
        [accountField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(accountView);
            make.height.mas_equalTo(60);
        }];
    }
    return self;
}

@end
