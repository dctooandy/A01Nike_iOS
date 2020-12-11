//
//  CNPayWechatTipView.m
//  Hybird_1e3c3b
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
    CNPayWechatTipView *tipView = [CNPayWechatTipView tipView];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    tipView.frame = window.bounds;
    [window addSubview:tipView];
}

- (IBAction)closeAction:(UIButton *)sender {
    [self removeFromSuperview];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.pageC.currentPage = index;
}

@end
