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
//        accountView.backgroundColor = [UIColor yellowColor];
        [self addSubview:accountView];
        
        UIImageView *actLeftImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_account"]];
        [accountView addSubview:actLeftImg];
        [actLeftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(accountView.mas_left);
            make.top.mas_equalTo(accountView.mas_top).offset(37);
            make.width.mas_equalTo(16);
            make.height.mas_equalTo(18);
        }];
        //用户名输入框
        UITextField *accountField = [[UITextField alloc]init];
        accountField.font = [UIFont systemFontOfSize:16];
        accountField.textColor = [UIColor whiteColor];
        accountField.placeholder = @"用户名/手机号";
        [accountView addSubview:accountField];
        [accountField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(accountView.mas_right);
            make.top.mas_equalTo(accountView.mas_top).offset(30);
            make.left.mas_equalTo(actLeftImg.mas_right).offset(12);
            make.height.mas_equalTo(30);
        }];
        CALayer *accountLayer = [CALayer new];
        accountLayer.backgroundColor = [UIColor whiteColor].CGColor;
        accountLayer.frame = CGRectMake(0, 59.5, SCREEN_WIDTH-72, 0.5);
        [accountView.layer addSublayer:accountLayer];
    }
    return self;
}

@end
