//
//  CNPayDepositTipView.m
//  Hybird_A01
//
//  Created by cean.q on 2018/12/4.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "CNPayDepositTipView.h"
#import "CNPayConstant.h"

@interface CNPayDepositTipView ()
@property (nonatomic, copy) dispatch_block_t finishBlock;
@property (weak, nonatomic) IBOutlet UIButton *repayBtn;
@end

@implementation CNPayDepositTipView

+ (instancetype)tipView {
    return [[NSBundle mainBundle] loadNibNamed:@"CNPayDepositTipView" owner:nil options:nil].firstObject;
}

+ (void)showTipViewFinish:(dispatch_block_t)btnAction {
    CNPayDepositTipView *tipView = [CNPayDepositTipView tipView];
    tipView.repayBtn.layer.borderColor = COLOR_HEX(0xD8D8D8).CGColor;
    tipView.repayBtn.layer.borderWidth = 1;
    tipView.finishBlock = btnAction;
    [tipView show];
}

///显示
- (void)show {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.frame = window.bounds;
    [window addSubview:self];
}

- (IBAction)submitAction:(UIButton *)sender {
    [self removeFromSuperview];
    !_finishBlock ?: _finishBlock();
}

- (IBAction)closeAction:(UIButton *)sender {
    [self removeFromSuperview];
}

@end
