//
//  BTTForgetPwdPhoneCell.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 8/12/21.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTForgetPwdPhoneCell.h"
#import "BTTMeMainModel.h"

@interface BTTForgetPwdPhoneCell(){
    dispatch_source_t _timer;
}
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIView *captchaBg;
@end

@implementation BTTForgetPwdPhoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.detailTextField.textColor = [UIColor blackColor];
    self.detailTextField.userInteractionEnabled = false;
    self.captchaBg.layer.cornerRadius = 4.0;
    self.sendSmsBtn.clipsToBounds = true;
    self.sendSmsBtn.layer.cornerRadius = 4.0;
}

- (void)setModel:(BTTMeMainModel *)model {
    _model = model;
    self.detailTextField.placeholder = model.name;
    self.logo.image = [UIImage imageNamed:model.iconName];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_detailTextField.placeholder attributes:
    @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"818791"],
                 NSFontAttributeName:_detailTextField.font
         }];
    self.detailTextField.attributedPlaceholder = attrString;
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
                [self.sendSmsBtn setBackgroundColor:[UIColor colorWithRed: 0.25 green: 0.38 blue: 0.66 alpha: 1.00]];
                [self.sendSmsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
                [self.sendSmsBtn setBackgroundColor:[UIColor colorWithRed: 0.80 green: 0.80 blue: 0.80 alpha: 1.00]];
                [self.sendSmsBtn setTitleColor:[UIColor colorWithRed: 0.40 green: 0.40 blue: 0.40 alpha: 1.00] forState:UIControlStateNormal];
                self.sendSmsBtn.enabled = NO;
                self.detailTextField.userInteractionEnabled = true;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

@end
