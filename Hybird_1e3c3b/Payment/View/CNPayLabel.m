//
//  CNPayLabel.m
//  HybirdApp
//
//  Created by cean.q on 2018/10/15.
//  Copyright © 2018年 harden-imac. All rights reserved.
//

#import "CNPayLabel.h"

@implementation CNPayLabel


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
//    self.textColor = [Utility colorWithHex:0x3C3C3C];
    self.font = [UIFont systemFontOfSize:16];
}

@end
