//
//  BTTBindingMobileTwoCell.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBindingMobileTwoCell.h"
#import "BTTMeMainModel.h"

@interface BTTBindingMobileTwoCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation BTTBindingMobileTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_textField setValue:[UIColor colorWithHexString:@"818791"] forKeyPath:@"_placeholderLabel.textColor"];
    _textField.textColor = [UIColor whiteColor];
    _textField.delegate = self;
    [_textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    if (SCREEN_WIDTH == 320) {
        self.textField.font = kFontSystem(13);
        self.nameLabel.font = kFontSystem(14);
        self.sendBtn.titleLabel.font = kFontSystem(14);
    }
    
}

- (void)setModel:(BTTMeMainModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.textField.placeholder = model.iconName;
}

- (IBAction)sendBtnClick:(UIButton *)sender {
    [self countDown];
}


- (void)countDown {
    [[NSNotificationCenter defaultCenter] postNotificationName:BTTVerifyCodeSendNotification object:nil];
    __block int timeout = 60; // 倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); // 每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.sendBtn.enabled = YES;
                self.sendBtn.titleLabel.text = @"重新发送";
                [self.sendBtn setTitle:@"重新发送" forState:UIControlStateNormal];
            });
        } else {
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];;
            if (seconds < 10) {
                strTime = [NSString stringWithFormat:@"%.1d", seconds];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.sendBtn.titleLabel.text = [NSString stringWithFormat:@"重新发送(%@)",strTime];
                [self.sendBtn setTitle:[NSString stringWithFormat:@"重新发送(%@)",strTime] forState:UIControlStateNormal];
                
                self.sendBtn.enabled = NO;
            });
            
            timeout--;
        }
        
    });
    dispatch_resume(_timer);
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    return YES;
}

- (void)textFieldChange:(UITextField *)textField {
    NSLog(@"%@",textField.text);
    if (textField.text.length >= 6) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BTTVerifyCodeEnableNotification object:@"verifycode"];
        textField.text = [textField.text substringToIndex:6];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:BTTVerifyCodeDisableNotification object:@"verifycode"];
    }
}


@end
