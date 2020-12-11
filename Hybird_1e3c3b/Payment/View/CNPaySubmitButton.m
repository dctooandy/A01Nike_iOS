//
//  CNPaySubmitButton.m
//  A05_iPhone
//
//  Created by cean.q on 2018/10/1.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPaySubmitButton.h"
#import "CNPayConstant.h"

@implementation CNPaySubmitButton


- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
//    self.backgroundColor = [Utility colorWithHex:0xF3F3F3];
//    self.layer.cornerRadius = 2.0;
//    self.layer.shadowColor = COLOR_RGBA(0, 0, 0, 0.27).CGColor;
//    self.layer.shadowOffset = CGSizeMake(0, 2);
//    self.layer.shadowOpacity = 1;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    [self setTitleColor:kBlackForgroundColor forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"binding_confirm_enable_normal"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"binding_confirm_enable_press"] forState:UIControlStateHighlighted];
    [self setTitle:@"提交中..." forState:UIControlStateSelected];
}

@end
