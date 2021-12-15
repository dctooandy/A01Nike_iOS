//
//  BTTVideoFastRegisterView.m
//  Hybird_1e3c3b
//
//  Created by Levy on 2/26/20.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTVideoFastRegisterView.h"

@interface BTTVideoFastRegisterView ()
@property (nonatomic, strong) UITextField *accountField;

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
        accountField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        accountField.autocorrectionType = UITextAutocorrectionTypeNo;
        [accountField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:
        @{NSForegroundColorAttributeName:[UIColor whiteColor],
                     NSFontAttributeName:accountField.font
             }];
        accountField.attributedPlaceholder = attrString;
        accountField.keyboardType = UIKeyboardTypeDefault;
        [accountView addSubview:accountField];
        _accountField = accountField;
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
        
        UIButton *msgCodeBtn = [[UIButton alloc]init];
        msgCodeBtn.layer.cornerRadius = 15;
        msgCodeBtn.backgroundColor = COLOR_RGBA(0, 126, 250, 0.85);
        msgCodeBtn.clipsToBounds = YES;
        msgCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [msgCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [msgCodeBtn setImage:nil forState:UIControlStateNormal];
        [msgCodeBtn addTarget:self action:@selector(sendSmsCode) forControlEvents:UIControlEventTouchUpInside];
        [pwdView addSubview:msgCodeBtn];
        _msgCodeBtn = msgCodeBtn;
        [_msgCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(pwdView.mas_right);
            make.top.mas_equalTo(pwdView.mas_top).offset(25);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(30);
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
        [pwdField setEnabled:false];
        [pwdView addSubview:pwdField];
        _imgCodeField = pwdField;
        [pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_msgCodeBtn.mas_left);
            make.top.mas_equalTo(pwdView.mas_top).offset(30);
            make.left.mas_equalTo(pwdLeftImg.mas_right).offset(12);
            make.height.mas_equalTo(30);
        }];
        CALayer *pwdLayer = [CALayer new];
        pwdLayer.backgroundColor = [UIColor whiteColor].CGColor;
        pwdLayer.frame = CGRectMake(0, 59.5, SCREEN_WIDTH-72, 0.5);
        [pwdView.layer addSublayer:pwdLayer];
        
//        UIView *askInputView = [[UIView alloc]initWithFrame:CGRectMake(36, 120, SCREEN_WIDTH-72, 60)];
//        [self addSubview:askInputView];
//
//        UIImageView *askInputLeftImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"askInput"]];
//        [askInputView addSubview:askInputLeftImg];
//        [askInputLeftImg mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(askInputView.mas_left);
//            make.top.mas_equalTo(askInputView.mas_top).offset(37);
//            make.width.mas_equalTo(16);
//            make.height.mas_equalTo(18);
//        }];
     
        //邀请码输入框
//        UITextField *askInputField = [[UITextField alloc]init];
//        askInputField.font = [UIFont systemFontOfSize:16];
//        askInputField.textColor = [UIColor whiteColor];
//        NSAttributedString *attrStringASK = [[NSAttributedString alloc] initWithString:@"请输入您的邀请码(选填)" attributes:
//        @{NSForegroundColorAttributeName:[UIColor whiteColor],
//                     NSFontAttributeName:askInputField.font
//             }];
//        askInputField.attributedPlaceholder = attrStringASK;
//        [askInputField setEnabled:YES];
//        [askInputView addSubview:askInputField];
//        _askInputCodeField = askInputField;
//        [askInputField mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(askInputView.mas_right);
//            make.top.mas_equalTo(askInputView.mas_top).offset(30);
//            make.left.mas_equalTo(askInputLeftImg.mas_right).offset(12);
//            make.height.mas_equalTo(30);
//        }];
//        CALayer *askInputLayer = [CALayer new];
//        askInputLayer.backgroundColor = [UIColor whiteColor].CGColor;
//        askInputLayer.frame = CGRectMake(0, 59.5, SCREEN_WIDTH-72, 0.5);
//        [askInputView.layer addSublayer:askInputLayer];
        
        
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
        [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(pwdView.mas_bottom).offset(30);
            make.width.mas_equalTo(SCREEN_WIDTH-72);
            make.height.mas_equalTo(45);
            make.centerX.mas_equalTo(pwdView.mas_centerX);
        }];
        
        UIButton *oneKeyBtn = [[UIButton alloc]init];
        [oneKeyBtn setTitle:@"一键生成账号密码" forState:UIControlStateNormal];
        [oneKeyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        oneKeyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        oneKeyBtn.layer.cornerRadius = 22.5;
        oneKeyBtn.layer.borderColor = COLOR_RGBA(243, 130, 50, 0.85).CGColor;
        oneKeyBtn.layer.borderWidth = 0.5;
        oneKeyBtn.clipsToBounds = YES;
        oneKeyBtn.backgroundColor = COLOR_RGBA(243, 130, 50, 0.85);
        [oneKeyBtn addTarget:self action:@selector(onekeyRegisterBtn_click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:oneKeyBtn];
        [oneKeyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(registerBtn.mas_bottom).offset(12);
            make.width.mas_equalTo(SCREEN_WIDTH-72);
            make.height.mas_equalTo(45);
            make.centerX.mas_equalTo(pwdView.mas_centerX);
        }];
        
    }
    return self;
}

- (void)textFieldDidChanged:(id)sender {
    NSString *name = _accountField.text;
    if (name.length > 11) {
        _accountField.text = [name substringToIndex:11];
    }
}

- (void)onekeyRegisterBtn_click{
    if (self.tapOneKeyRegister) {
        self.tapOneKeyRegister();
    }
}

- (void)registerBtn_click{
    if (![PublicMethod isValidatePhone:_accountField.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号码" toView:nil];
    }else if (_imgCodeField.text.length<4||[_imgCodeField.text isEqualToString:@""]){
        [MBProgressHUD showError:@"请输入正确的验证码" toView:nil];
    }else{
        if (self.tapRegister) {
            // 隐藏邀请码
            self.tapRegister(_accountField.text, _imgCodeField.text , @"");
//            _askInputCodeField.text = @"";
        }
    }
}

- (void)sendSmsCode {
    if ([PublicMethod isValidatePhone:_accountField.text]) {
        if (self.sendSmdCode) {
            [self countDown];
            self.sendSmdCode(_accountField.text);
        }
    } else {
        [MBProgressHUD showError:@"请填写正确的手机号" toView:nil];
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
                self.msgCodeBtn.enabled = YES;
                self.msgCodeBtn.titleLabel.text = @"重新发送";
                [self.msgCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                self.msgCodeBtn.backgroundColor = COLOR_RGBA(0, 126, 250, 0.85);
            });
        } else {
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            if (seconds < 10) {
                strTime = [NSString stringWithFormat:@"%.1d", seconds];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.msgCodeBtn.titleLabel.text = [NSString stringWithFormat:@"重新发送(%@)", strTime];
                [self.msgCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%@)", strTime] forState:UIControlStateNormal];
                self.msgCodeBtn.enabled = NO;
                self.msgCodeBtn.backgroundColor = [UIColor lightGrayColor];
            });

            timeout--;
        }
    });
    dispatch_resume(_timer);
}


@end
