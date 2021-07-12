//
//  BTTBindNameAndPhonePopView.m
//  Hybird_1e3c3b
//
//  Created by JerryHU on 2021/7/10.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTBindNameAndPhonePopView.h"

@interface BTTBindNameAndPhonePopView()<UITextFieldDelegate>{
    dispatch_source_t _timer;
}
@property (weak, nonatomic) IBOutlet UIView *bgImgView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@end

@implementation BTTBindNameAndPhonePopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap)];
    self.bgImgView.userInteractionEnabled = true;
    [self.bgImgView addGestureRecognizer:bgTap];
    
    //cornerRadius
    [PublicMethod setViewSelectCorner:(UIRectCornerTopRight | UIRectCornerTopLeft) view:self.titleLab cornerRadius:4.0];
    [PublicMethod setViewSelectCorner:(UIRectCornerBottomRight | UIRectCornerBottomLeft) view:self.bgImgView cornerRadius:4.0];
    [PublicMethod setViewSelectCorner:(UIRectCornerBottomRight | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerTopLeft) view:self.commitBtn cornerRadius:4.0];
    
    //TextFieldDelegate
    self.phoneTextField.delegate = self;
    self.captchaTextField.delegate = self;
    [self.phoneTextField addTarget:self action:@selector(textBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    self.captchaTextField.userInteractionEnabled = false;
    
    self.sendSmsBtn.titleLabel.adjustsFontSizeToFitWidth = true;
}

-(void)setNameStr:(NSString *)nameStr {
    _nameStr = nameStr;
    self.nameTextField.text = nameStr;
    if (_nameStr.length) {
        self.nameTextField.backgroundColor = [UIColor colorWithRed: 0.14 green: 0.15 blue: 0.16 alpha: 1.00];
        self.nameTextField.textColor = [UIColor whiteColor];
        self.nameTextField.userInteractionEnabled = false;
    } else {
        self.nameTextField.backgroundColor = [UIColor whiteColor];
        self.nameTextField.textColor = [UIColor blackColor];
        self.nameTextField.userInteractionEnabled = true;
    }
}

-(void)setPhoneStr:(NSString *)phoneStr {
    _phoneStr = phoneStr;
    self.phoneTextField.text = _phoneStr;
}

- (void)countDown {
    __block int timeout = 60; // 倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); // 每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(self->_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
//                设置界面的按钮显示 根据自己需求设置
                self.sendSmsBtn.enabled = YES;
                self.sendSmsBtn.titleLabel.text = @"重新发送";
                [self.sendSmsBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                self.sendSmsBtn.backgroundColor = [UIColor colorWithHexString:@"#287EBA"];
            });
        } else {
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];;
            if (seconds < 10) {
                strTime = [NSString stringWithFormat:@"%.1d", seconds];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
//                设置界面的按钮显示 根据自己需求设置
                self.sendSmsBtn.titleLabel.text = [NSString stringWithFormat:@"重新发送(%@)",strTime];
                [self.sendSmsBtn setTitle:[NSString stringWithFormat:@"重新发送(%@)",strTime] forState:UIControlStateNormal];
                self.sendSmsBtn.backgroundColor = [UIColor colorWithHexString:@"#686868"];
                self.sendSmsBtn.enabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

- (void)textBeginEditing:(UITextField *)textField {
    if (textField == self.phoneTextField && [IVNetwork savedUserInfo].mobileNo.length != 0 && [IVNetwork savedUserInfo].mobileNoBind != 1) {
        textField.text = @"";
        [self.sendSmsBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.sendSmsBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.sendSmsBtn.backgroundColor = [UIColor colorWithHexString:@"#686868"];
        self.sendSmsBtn.enabled = NO;
        
        self.captchaTextField.backgroundColor = [UIColor colorWithRed: 0.14 green: 0.15 blue: 0.16 alpha: 1.00];
        self.captchaTextField.textColor = [UIColor whiteColor];
        self.captchaTextField.userInteractionEnabled = false;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneTextField && textField.text.length >= 11 && string.length > 0) {
        return false;
    } else if (textField == self.captchaTextField && textField.text.length >= 6 && string.length > 0) {
        return false;
    }
    return true;
}

-(void)bgTap {
}

- (IBAction)closeBtnAction:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (IBAction)sendSmsBtnAction:(UIButton *)sender {
    if (!self.phoneTextField.text.length) {
        [MBProgressHUD showError:@"请填写手机号码" toView:nil];
        return;
    }
    if (![PublicMethod isValidatePhone:self.phoneTextField.text]) {
        [MBProgressHUD showError:@"请填写正确的手机号码" toView:nil];
        return;
    }
    self.captchaTextField.userInteractionEnabled = true;
    if (self.sendSmsBtnAction) {
        self.sendSmsBtnAction(self.phoneTextField.text);
    }
}

- (IBAction)commitBtnAction:(UIButton *)sender {
    if (!self.nameTextField.text.length) {
        [MBProgressHUD showError:@"请输入真实姓名" toView:self];
        return;
    }
    if (![PublicMethod isValidatePhone:self.phoneTextField.text] && ![self.phoneTextField.text containsString:@"*"]) {
        [MBProgressHUD showError:@"请填写正确的手机号码" toView:nil];
        return;
    }
    if (!self.captchaTextField.text.length) {
        if (self.sendSmsBtn.isEnabled) {
            [MBProgressHUD showError:@"请输入验证码" toView:nil];
            return;
        } else {
            if (self.captchaTextField.isUserInteractionEnabled) {
                [MBProgressHUD showError:@"请输入验证码" toView:nil];
                return;
            }
        }
    }
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}

@end
