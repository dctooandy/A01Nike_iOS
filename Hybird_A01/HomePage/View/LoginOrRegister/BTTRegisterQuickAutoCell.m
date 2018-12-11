//
//  BTTRegisterQuickCell.m
//  Hybird_A01
//
//  Created by Domino on 12/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTRegisterQuickAutoCell.h"

@interface BTTRegisterQuickAutoCell ()

@property (weak, nonatomic) IBOutlet UIButton *normalBtn;

@property (weak, nonatomic) IBOutlet UIButton *quickBtn;

@property (weak, nonatomic) IBOutlet UIButton *autoBtn;

@property (weak, nonatomic) IBOutlet UIButton *manualBtn;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

@implementation BTTRegisterQuickAutoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 4;
    [self.phoneTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [self.verifyCodeBlock addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}



- (IBAction)normalBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}


- (IBAction)quickBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)autoBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}


- (IBAction)manualBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)codeBtnClick:(UIButton *)sender {
    if (!self.phoneTextField.text.length) {
        [MBProgressHUD showError:@"请填写手机号码" toView:nil];
        return;
    }
    NSString *phoneregex = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
    NSPredicate *phonepredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneregex];
    BOOL isphone = [phonepredicate evaluateWithObject:self.phoneTextField.text];
    if (!isphone) {
        [MBProgressHUD showError:@"请填写正确的手机号码" toView:nil];
        return;
    }
    [self countDown];
    if (self.verifyCodeBlock) {
        _verifyCodeBlock(self.phoneTextField.text);
    }
}

- (void)textFieldChange:(UITextField *)textField {
    if (textField.tag == 2010) {
        if (textField.text.length > 10) {
            textField.text = [textField.text substringToIndex:10];
        }
    } else {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
    
}

- (void)countDown {
    __block int timeout = 60; // 倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); // 每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.codeBtn.enabled = YES;
                self.codeBtn.titleLabel.text = @"重新发送";
                [self.codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
            });
        } else {
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];;
            if (seconds < 10) {
                strTime = [NSString stringWithFormat:@"%.1d", seconds];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.codeBtn.titleLabel.text = [NSString stringWithFormat:@"重新发送(%@)",strTime];
                [self.codeBtn setTitle:[NSString stringWithFormat:@"重新发送(%@)",strTime] forState:UIControlStateNormal];
                
                self.codeBtn.enabled = NO;
            });
            
            timeout--;
        }
        
    });
    dispatch_resume(_timer);
    
}

@end
