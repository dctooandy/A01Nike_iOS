//
//  BTTLoginInfoView.m
//  Hybird_A01
//
//  Created by Levy on 2/18/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTLoginInfoView.h"

@interface BTTLoginInfoView ()
@property (nonatomic, strong) UITextField *pwdTextField;
@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UITextField *imgCodeField;
@property (nonatomic, strong) UIButton *showPwdBtn;
@property (nonatomic, assign) BOOL isCode;
@property (nonatomic, strong) UIView *pwdView;
@property (nonatomic, strong) UIButton *forgetPwdBtn;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@end

@implementation BTTLoginInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isCode = NO;
        UIView *accountView = [[UIView alloc]initWithFrame:CGRectMake(36, 0, SCREEN_WIDTH - 72, 60)];
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
        accountField.keyboardType = UIKeyboardTypeDefault;
        accountField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        accountField.autocorrectionType = UITextAutocorrectionTypeNo;
        [accountField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"用户名/手机号" attributes:
                                          @{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                             NSFontAttributeName: accountField.font }];
        accountField.attributedPlaceholder = attrString;
        [accountView addSubview:accountField];
        _accountTextField = accountField;
        [accountField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(accountView.mas_right);
            make.top.mas_equalTo(accountView.mas_top).offset(30);
            make.left.mas_equalTo(actLeftImg.mas_right).offset(12);
            make.height.mas_equalTo(30);
        }];
        CALayer *accountLayer = [CALayer new];
        accountLayer.backgroundColor = [UIColor whiteColor].CGColor;
        accountLayer.frame = CGRectMake(0, 59.5, SCREEN_WIDTH - 72, 0.5);
        [accountView.layer addSublayer:accountLayer];

        UIView *pwdView = [[UIView alloc]initWithFrame:CGRectMake(36, 60, SCREEN_WIDTH - 72, 60)];
        [self addSubview:pwdView];
        _pwdView = pwdView;

        UIImageView *pwdLeftImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_pwd"]];
        [pwdView addSubview:pwdLeftImg];
        [pwdLeftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(pwdView.mas_left);
            make.top.mas_equalTo(pwdView.mas_top).offset(37);
            make.width.mas_equalTo(16);
            make.height.mas_equalTo(18);
        }];
        UIButton *showPwdBtn = [[UIButton alloc]init];
        showPwdBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [showPwdBtn setImage:[UIImage imageNamed:@"accountSafe_close"] forState:UIControlStateNormal];
        [showPwdBtn addTarget:self action:@selector(showPwdSecurity) forControlEvents:UIControlEventTouchUpInside];
        [pwdView addSubview:showPwdBtn];
        _showPwdBtn = showPwdBtn;
        [showPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(pwdView.mas_right);
            make.top.mas_equalTo(pwdView.mas_top).offset(35);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        //密码输入框
        UITextField *pwdField = [[UITextField alloc]init];
        pwdField.font = [UIFont systemFontOfSize:16];
        pwdField.textColor = [UIColor whiteColor];
        NSAttributedString *attrStringPwd = [[NSAttributedString alloc] initWithString:@"密码" attributes:
                                             @{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                                NSFontAttributeName: pwdField.font }];
        pwdField.attributedPlaceholder = attrStringPwd;
        pwdField.secureTextEntry = YES;
        [pwdView addSubview:pwdField];
        _pwdTextField = pwdField;
        [pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(showPwdBtn.mas_left);
            make.top.mas_equalTo(pwdView.mas_top).offset(30);
            make.left.mas_equalTo(pwdLeftImg.mas_right).offset(12);
            make.height.mas_equalTo(30);
        }];
        CALayer *pwdLayer = [CALayer new];
        pwdLayer.backgroundColor = [UIColor whiteColor].CGColor;
        pwdLayer.frame = CGRectMake(0, 59.5, SCREEN_WIDTH - 72, 0.5);
        [pwdView.layer addSublayer:pwdLayer];

        UIView *codeImgView = [[UIView alloc]init];
        [self addSubview:codeImgView];
        _codeImgView = codeImgView;
        [self.codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.pwdView.mas_bottom);
            make.centerX.mas_equalTo(self.pwdView);
            make.width.mas_equalTo(300);
            make.height.mas_equalTo(60);
        }];
        
        UIButton * showBtn = [[UIButton alloc] init];
        [showBtn setTitle:@"点此进行验证" forState:UIControlStateNormal];
        [showBtn setImage:[UIImage imageNamed:@"ic_login_show_captcha_icon"] forState:UIControlStateNormal];
        [showBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [showBtn setBackgroundColor:[UIColor whiteColor]];
        showBtn.layer.borderColor = [UIColor brownColor].CGColor;
        showBtn.layer.borderWidth = 2.0;
        showBtn.layer.cornerRadius = 5.0;
        showBtn.clipsToBounds = true;
        _showBtn = showBtn;
        [showBtn addTarget:self action:@selector(regetCodeImage:) forControlEvents:UIControlEventTouchUpInside];
        [codeImgView addSubview:showBtn];
        [showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(codeImgView);
            make.top.equalTo(codeImgView).offset(5);
            make.height.mas_equalTo(50);
        }];
        
        UIButton *forgetPwdBtn = [[UIButton alloc]init];
        [forgetPwdBtn setTitle:@"忘记账号,密码？" forState:UIControlStateNormal];
        [forgetPwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [forgetPwdBtn addTarget:self action:@selector(forgetAccountAndPwd) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:forgetPwdBtn];
        _forgetPwdBtn = forgetPwdBtn;
        [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(pwdView.mas_bottom).offset(60);
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
        [loginBtn addTarget:self action:@selector(loginBtn_click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loginBtn];
        self.loginBtn = loginBtn;
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(forgetPwdBtn.mas_bottom).offset(31);
            make.width.mas_equalTo(SCREEN_WIDTH - 72);
            make.height.mas_equalTo(45);
            make.centerX.mas_equalTo(pwdView.mas_centerX);
        }];

        UIButton *registerBtn = [[UIButton alloc]init];
        [registerBtn setTitle:@"立即开户" forState:UIControlStateNormal];
        [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        registerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        registerBtn.layer.cornerRadius = 22.5;
        registerBtn.layer.borderColor = COLOR_RGBA(0, 126, 250, 0.85).CGColor;
        registerBtn.layer.borderWidth = 0.5;
        registerBtn.clipsToBounds = YES;
        registerBtn.backgroundColor = COLOR_RGBA(0, 126, 250, 0.85);
        [registerBtn addTarget:self action:@selector(registerBtn_click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:registerBtn];
        self.registerBtn = registerBtn;
        [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(loginBtn.mas_bottom).offset(11);
            make.width.mas_equalTo(SCREEN_WIDTH - 72);
            make.height.mas_equalTo(45);
            make.centerX.mas_equalTo(pwdView.mas_centerX);
        }];
    }
    return self;
}

- (void)showPwdSecurity {
    if (!_isCode) {
        _pwdTextField.secureTextEntry = !_pwdTextField.isSecureTextEntry;
        NSString *imgStr = _pwdTextField.isSecureTextEntry ? @"accountSafe_close" : @"accountSafe_Open";
        [_showPwdBtn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    }
}

- (void)regetCodeImage:(UIButton *)sender {
    if (self.refreshCodeImage) {
        self.refreshCodeImage();
    }
}

-(void)setTicketStr:(NSString *)ticketStr {
    _ticketStr = ticketStr;
}

- (void)forgetAccountAndPwd {
    if (self.tapForgetAccountAndPwd) {
        self.tapForgetAccountAndPwd();
    }
}

- (void)loginBtn_click {
    if (_accountTextField.text.length == 0) {
        [MBProgressHUD showError:@"请输入用户名/手机号" toView:nil];
    } else if (_pwdTextField.text.length == 0) {
        NSString *errorMsg = _isCode ? @"请输入验证码" : @"请输入密码";
        [MBProgressHUD showError:errorMsg toView:nil];
    } else if (!self.codeImgView.hidden && self.ticketStr.length == 0) {
        [MBProgressHUD showError:@"请先完成验证" toView:nil];
    } else {
        if (self.tapLogin) {
            self.tapLogin(_accountTextField.text, _pwdTextField.text, _isCode, self.ticketStr);
        }
    }
}

- (void)registerBtn_click {
    if (self.tapRegister) {
        self.tapRegister();
    }
}

- (void)sendSmsCode {
    if (_isCode) {
        if ([PublicMethod isValidatePhone:_accountTextField.text]) {
            if (self.sendSmdCode) {
                [self countDown];
                self.sendSmdCode(_accountTextField.text);
            }
        } else {
            [MBProgressHUD showError:@"请填写正确的手机号" toView:nil];
        }
    }
}

- (void)countDown {
    __block int timeout = 60; // 倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); // 每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) { //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.showPwdBtn.enabled = YES;
                self.showPwdBtn.titleLabel.text = @"重新发送";
                [self.showPwdBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                self.showPwdBtn.backgroundColor = COLOR_RGBA(0, 126, 250, 0.85);
            });
        } else {
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            if (seconds < 10) {
                strTime = [NSString stringWithFormat:@"%.1d", seconds];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.showPwdBtn.titleLabel.text = [NSString stringWithFormat:@"重新发送(%@)", strTime];
                [self.showPwdBtn setTitle:[NSString stringWithFormat:@"重新发送(%@)", strTime] forState:UIControlStateNormal];
                self.showPwdBtn.enabled = NO;
                self.showPwdBtn.backgroundColor = [UIColor lightGrayColor];
            });

            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)textFieldDidChanged:(id)sender {
    _accountTextField.text = [_accountTextField.text lowercaseString];
    NSString *name = _accountTextField.text;
    if (name.length > 11) {
        _accountTextField.text = [name substringToIndex:11];
        name = _accountTextField.text;
    }
    if ([PublicMethod isValidatePhone:name]) {
        if (!_isCode) {
            _isCode = YES;
            _pwdTextField.text = @"";
            _pwdTextField.secureTextEntry = NO;
            NSAttributedString *attrStringPwd = [[NSAttributedString alloc] initWithString:@"验证码" attributes:
                                                 @{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                                    NSFontAttributeName: _pwdTextField.font }];
            _pwdTextField.attributedPlaceholder = attrStringPwd;
            _showPwdBtn.layer.cornerRadius = 12.5;
            _showPwdBtn.backgroundColor = COLOR_RGBA(0, 126, 250, 0.85);
            _showPwdBtn.clipsToBounds = YES;
            _showPwdBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [_showPwdBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            [_showPwdBtn setImage:nil forState:UIControlStateNormal];
            [_showPwdBtn addTarget:self action:@selector(sendSmsCode) forControlEvents:UIControlEventTouchUpInside];
            [_showPwdBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_pwdView.mas_top).offset(30);
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(25);
            }];
        }
    } else {
        if (_isCode) {
            _isCode = NO;
            _pwdTextField.text = @"";
            NSAttributedString *attrStringPwd = [[NSAttributedString alloc] initWithString:@"密码" attributes:
                                                 @{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                                    NSFontAttributeName: _pwdTextField.font }];
            _pwdTextField.attributedPlaceholder = attrStringPwd;
            _pwdTextField.secureTextEntry = YES;
            _showPwdBtn.layer.cornerRadius = 0;
            _showPwdBtn.backgroundColor = [UIColor clearColor];
            [_showPwdBtn setImage:[UIImage imageNamed:@"accountSafe_close"] forState:UIControlStateNormal];
            [_showPwdBtn addTarget:self action:@selector(showPwdSecurity) forControlEvents:UIControlEventTouchUpInside];
            [_showPwdBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_pwdTextField).offset(5);
                make.width.mas_equalTo(20);
                make.height.mas_equalTo(20);
            }];
        }
    }
}

@end
