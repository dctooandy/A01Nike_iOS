//
//  CNPayOnePixView.m
//  A05_iPhone
//
//  Created by cean.q on 2018/9/28.
//  Copyright © 2018年 WRD. All rights reserved.
//

#import "CNPayOnePixView.h"
#import "CNPayConstant.h"

@implementation CNPayOnePixView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    UIView *onePixView = [[UIView alloc] init];
    onePixView.backgroundColor = COLOR_HEX(0x36364C);
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:onePixView];
    [onePixView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.right.mas_equalTo(self).offset(0);
        make.height.mas_equalTo(0.8);
        make.centerY.mas_equalTo(self);
    }];
}

@end
