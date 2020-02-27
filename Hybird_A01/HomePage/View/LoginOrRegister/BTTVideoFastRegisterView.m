//
//  BTTVideoFastRegisterView.m
//  Hybird_A01
//
//  Created by Levy on 2/26/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTVideoFastRegisterView.h"

@interface BTTVideoFastRegisterView ()
@property (nonatomic, strong) UITextField *accountField;
@property (nonatomic, strong) UITextField *imgCodeField;
@property (nonatomic, strong) UIButton *imgCodeBtn;
@end

@implementation BTTVideoFastRegisterView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *accountView = [[UIView alloc]initWithFrame:CGRectMake(36, 0, SCREEN_WIDTH-72, 60)];
//        accountView.backgroundColor = [UIColor yellowColor];
        [self addSubview:accountView];
        
        UIImageView *actLeftImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_phone"]];
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
        [accountField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:
        @{NSForegroundColorAttributeName:[UIColor whiteColor],
                     NSFontAttributeName:accountField.font
             }];
        accountField.attributedPlaceholder = attrString;
        [accountView addSubview:accountField];
        accountField = accountField;
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
        
        UIImageView *pwdLeftImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_verify"]];
        [pwdView addSubview:pwdLeftImg];
        [pwdLeftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(pwdView.mas_left);
            make.top.mas_equalTo(pwdView.mas_top).offset(37);
            make.width.mas_equalTo(16);
            make.height.mas_equalTo(18);
        }];
        
        UIButton *imgCodeBtn = [[UIButton alloc]init];
        imgCodeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [pwdView addSubview:imgCodeBtn];
        _imgCodeBtn = imgCodeBtn;
        [imgCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(pwdView.mas_right);
            make.top.mas_equalTo(pwdView.mas_top).offset(35);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        //密码输入框
        UITextField *pwdField = [[UITextField alloc]init];
        pwdField.font = [UIFont systemFontOfSize:16];
        pwdField.textColor = [UIColor whiteColor];
        NSAttributedString *attrStringPwd = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:
        @{NSForegroundColorAttributeName:[UIColor whiteColor],
                     NSFontAttributeName:pwdField.font
             }];
        pwdField.attributedPlaceholder = attrStringPwd;
        pwdField.secureTextEntry = YES;
        [pwdView addSubview:pwdField];
        _imgCodeField = pwdField;
        [pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(imgCodeBtn.mas_left);
            make.top.mas_equalTo(pwdView.mas_top).offset(30);
            make.left.mas_equalTo(pwdLeftImg.mas_right).offset(12);
            make.height.mas_equalTo(30);
        }];
        CALayer *pwdLayer = [CALayer new];
        pwdLayer.backgroundColor = [UIColor whiteColor].CGColor;
        pwdLayer.frame = CGRectMake(0, 59.5, SCREEN_WIDTH-72, 0.5);
        [pwdView.layer addSublayer:pwdLayer];
        
        UIButton *registerBtn = [[UIButton alloc]init];
        [registerBtn setTitle:@"点击获取游戏账号" forState:UIControlStateNormal];
        [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        registerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        registerBtn.layer.cornerRadius = 22.5;
        registerBtn.layer.borderColor = COLOR_RGBA(0, 126, 250, 0.85).CGColor;
        registerBtn.layer.borderWidth = 0.5;
        registerBtn.clipsToBounds = YES;
        registerBtn.backgroundColor = COLOR_RGBA(0, 126, 250, 0.85);
        [registerBtn addTarget:self action:@selector(registerBtn_click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:registerBtn];
        [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(pwdView.mas_bottom).offset(20);
            make.width.mas_equalTo(SCREEN_WIDTH-72);
            make.height.mas_equalTo(45);
            make.centerX.mas_equalTo(pwdView.mas_centerX);
        }];
        
        NSString *normalStr = @"点击账号密码开户";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",normalStr]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]range:NSMakeRange(0,2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor]range:NSMakeRange(3,normalStr.length-1)];
        
        UIButton *normalRegisterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [normalRegisterButton setAttributedTitle:str forState:UIControlStateNormal];
        normalRegisterButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [normalRegisterButton addTarget:self action:@selector(normalRegisterBtn_click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:normalRegisterButton];
        
    }
    return self;
}

- (void)textFieldDidChanged:(id)sender {
    NSString *name = _accountField.text;
    if (name.length > 11) {
        _accountField.text = [name substringToIndex:11];
    }
}

- (void)normalRegisterBtn_click{
    
}

- (void)registerBtn_click{
    
}

- (void)setCodeImage:(UIImage *)codeImg{
    [self.imgCodeBtn setImage:codeImg forState:UIControlStateNormal];
}

@end
