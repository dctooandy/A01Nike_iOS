//
//  CNPayTipView.m
//  A05_iPhone
//
//  Created by cean.q on 2018/10/3.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayTipView.h"
#import "CNPayConstant.h"

@interface CNPayTipView ()
@property (weak, nonatomic) IBOutlet CNPaySubmitButton *finishPayBtn;
@property (weak, nonatomic) IBOutlet UIImageView *payTypeIV;
@property (weak, nonatomic) IBOutlet UILabel *successTipLb;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@end

@implementation CNPayTipView

+ (instancetype)tipView {
    return [[NSBundle mainBundle] loadNibNamed:@"CNPayTipView" owner:nil options:nil].firstObject;
}

- (NSAttributedString *)addAmountString:(NSString *)amount {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"恭喜您，您的存款申请已提交！存款金额：%@元", amount]];
    NSRange range = NSMakeRange(attrStr.length-amount.length-1, amount.length);
    [attrStr addAttribute:NSForegroundColorAttributeName value:COLOR_HEX(0xF37427) range:range];
    return attrStr;
}

- (void)setAmount:(NSString *)amount {
    _amount = amount;
    _successTipLb.attributedText = [self addAmountString:amount];
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    _payTypeIV.image = icon;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

- (IBAction)submitAction:(UIButton *)sender {
    [self removeFromSuperview];
    if (_btnAcitonBlock) {
        _btnAcitonBlock();
    }
}

- (IBAction)closeAction:(UIButton *)sender {
    [self removeFromSuperview];
}
@end
