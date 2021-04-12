//
//  BTTBindingMobileTwoCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 2018/10/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTBindingMobileTwoCell.h"
#import "BTTMeMainModel.h"

@interface BTTBindingMobileTwoCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (assign, nonatomic) int timeOut;
@end

@implementation BTTBindingMobileTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _timeOut = 60;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_textField.placeholder attributes:
    @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"818791"],
                 NSFontAttributeName:_textField.font
         }];
    _textField.attributedPlaceholder = attrString;
    _textField.textColor = [UIColor whiteColor];
    _textField.delegate = self;
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
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}
- (void)cancelCountDown
{
    self.timeOut = -1001;
    self.sendBtn.enabled = NO;
    self.sendBtn.titleLabel.text = @"发送验证码";
    [self.sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
}
- (void)countDown
{
    self.timeOut = 60;
    [[NSNotificationCenter defaultCenter] postNotificationName:BTTVerifyCodeSendNotification object:nil];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); // 每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (self.timeOut <= -100) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.timeOut = 60;
                self.sendBtn.enabled = YES;
                self.sendBtn.titleLabel.text = @"发送验证码";
                [self.sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            });
        }
        else if(self.timeOut <= 0 && self.timeOut > -100){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.timeOut = 60;
                self.sendBtn.enabled = YES;
                self.sendBtn.titleLabel.text = @"重新发送";
                [self.sendBtn setTitle:@"重新发送" forState:UIControlStateNormal];
            });
        }
        else {
            int seconds = self.timeOut;
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
            
            self.timeOut--;
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

@end
