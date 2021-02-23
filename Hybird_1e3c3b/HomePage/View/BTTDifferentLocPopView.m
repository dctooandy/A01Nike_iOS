//
//  BTTDifferentLocPopView.m
//  Hybird_1e3c3b
//
//  Created by JerryHU on 2021/2/23.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTDifferentLocPopView.h"

@interface BTTDifferentLocPopView() {
    dispatch_source_t _timer;
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIButton *sendSmsBtn;

@end

@implementation BTTDifferentLocPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 18.0;
    self.textField.layer.borderWidth = 0.5;
    self.textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.contentLab.font = [UIFont systemFontOfSize:14 * SCREEN_WIDTH/414];
    [self.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.confirmBtn setEnabled:false];
    [self.sendSmsBtn addTarget:self action:@selector(sendSmsBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)textChanged:(UITextField *)textField {
    NSString * str = textField.text;
    if (str.length != 0) {
        [self.confirmBtn setEnabled:true];
        [self.confirmBtn setTitleColor:[UIColor colorWithRed: 0.09 green: 0.46 blue: 1.00 alpha: 1.00] forState:UIControlStateNormal];
    } else {
        [self.confirmBtn setEnabled:false];
                [self.confirmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    if (str.length > 10) {
        str = [str substringWithRange:NSMakeRange(0,10)];
        textField.text = str;
    }
}

- (void)countDown:(NSInteger)num {
    __block int timeout = (int)num; // 倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); // 每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(self->_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.sendSmsBtn.enabled = YES;
                self.sendSmsBtn.titleLabel.text = @"重新发送";
                [self.sendSmsBtn setTitle:@"重新发送" forState:UIControlStateNormal];
            });
        } else {
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];;
            if (seconds < 10) {
                strTime = [NSString stringWithFormat:@"%.1d", seconds];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.sendSmsBtn.titleLabel.text = [NSString stringWithFormat:@"重新发送(%@)",strTime];
                [self.sendSmsBtn setTitle:[NSString stringWithFormat:@"重新发送(%@)",strTime] forState:UIControlStateNormal];
                self.sendSmsBtn.enabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

- (IBAction)confirmBtnAction:(UIButton *)sender {
    if (self.confirmBtnBlock) {
        self.confirmBtnBlock(self.textField.text);
    }
}

- (IBAction)cancelBtnAction:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

-(void)sendSmsBtnAction {
    if (self.sendCodeBtnAction) {
        self.sendCodeBtnAction();
    }
}

@end
