//
//  BTTUSDTButton.m
//  Hybird_A01
//
//  Created by Domino on 25/12/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTUSDTButton.h"

@implementation BTTUSDTButton


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
    [self setTitleEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
}

@end
