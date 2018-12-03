//
//  CNPayWechatTipView.m
//  Hybird_A01
//
//  Created by cean.q on 2018/12/3.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "CNPayWechatTipView.h"

@implementation CNPayWechatTipView

+ (instancetype)tipView {
    return [[NSBundle mainBundle] loadNibNamed:@"CNPayWechatTipView" owner:nil options:nil].firstObject;
}

+ (void)showWechatTip {
    [[CNPayWechatTipView tipView] show];
}

///显示
- (void)show {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.frame = window.bounds;
    [window addSubview:self];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

- (IBAction)closeAction:(UIButton *)sender {
    [self removeFromSuperview];
}
@end
