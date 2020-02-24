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
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"用户名/手机号" attributes:
        @{NSForegroundColorAttributeName:[UIColor whiteColor],
                     NSFontAttributeName:accountField.font
             }];
        accountField.attributedPlaceholder = attrString;
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
        
        UIView *pwdView = [[UIView alloc]initWithFrame:CGRectMake(36, 60, SCREEN_WIDTH-72, 60)];
        [self addSubview:pwdView];
        
        UIImageView *pwdLeftImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_pwd"]];
        [pwdView addSubview:pwdLeftImg];
        [pwdLeftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(pwdView.mas_left);
            make.top.mas_equalTo(pwdView.mas_top).offset(37);
            make.width.mas_equalTo(16);
            make.height.mas_equalTo(18);
        }];
        UIButton *showPwdBtn = [[UIButton alloc]init];
        [showPwdBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [pwdView addSubview:showPwdBtn];
        [showPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(pwdView.mas_right);
            make.top.mas_equalTo(pwdView.mas_top).offset(30);
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(30);
        }];
        //密码输入框
        UITextField *pwdField = [[UITextField alloc]init];
        pwdField.font = [UIFont systemFontOfSize:16];
        pwdField.textColor = [UIColor whiteColor];
        NSAttributedString *attrStringPwd = [[NSAttributedString alloc] initWithString:@"密码" attributes:
        @{NSForegroundColorAttributeName:[UIColor whiteColor],
                     NSFontAttributeName:pwdField.font
             }];
        pwdField.attributedPlaceholder = attrStringPwd;
        [pwdView addSubview:pwdField];
        [pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(pwdView.mas_right).offset(17);
            make.top.mas_equalTo(pwdView.mas_top).offset(30);
            make.left.mas_equalTo(pwdLeftImg.mas_right).offset(12);
            make.height.mas_equalTo(30);
        }];
        CALayer *pwdLayer = [CALayer new];
        pwdLayer.backgroundColor = [UIColor whiteColor].CGColor;
        pwdLayer.frame = CGRectMake(0, 59.5, SCREEN_WIDTH-72, 0.5);
        [pwdView.layer addSublayer:pwdLayer];
        
        UIButton *forgetPwdBtn = [[UIButton alloc]init];
        [forgetPwdBtn setTitle:@"忘记账号,密码？" forState:UIControlStateNormal];
        [forgetPwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:forgetPwdBtn];
        [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(pwdView.mas_bottom).offset(17);
            make.right.mas_equalTo(pwdView.mas_right);
            make.width.mas_greaterThanOrEqualTo(60);
            make.height.mas_equalTo(15);
        }];
        
        UIButton *loginBtn = [[UIButton alloc]init];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        loginBtn.layer.cornerRadius = 22.5;
        loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        loginBtn.layer.borderWidth = 0.5;
        loginBtn.clipsToBounds = YES;
        [self addSubview:loginBtn];
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(forgetPwdBtn.mas_bottom).offset(31);
            make.width.mas_equalTo(SCREEN_WIDTH-72);
            make.height.mas_equalTo(45);
            make.centerX.mas_equalTo(pwdView.mas_centerX);
        }];
        
        UIButton *registerBtn = [[UIButton alloc]init];
        [registerBtn setTitle:@"急速开户" forState:UIControlStateNormal];
        [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        registerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        registerBtn.layer.cornerRadius = 22.5;
        registerBtn.layer.borderColor = COLOR_RGBA(0, 126, 250, 0.85).CGColor;
        registerBtn.layer.borderWidth = 0.5;
        registerBtn.clipsToBounds = YES;
        registerBtn.backgroundColor = COLOR_RGBA(0, 126, 250, 0.85);
        
        [self addSubview:registerBtn];
        [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(loginBtn.mas_bottom).offset(11);
            make.width.mas_equalTo(SCREEN_WIDTH-72);
            make.height.mas_equalTo(45);
            make.centerX.mas_equalTo(pwdView.mas_centerX);
        }];
        
    }
    return self;
}

@end
