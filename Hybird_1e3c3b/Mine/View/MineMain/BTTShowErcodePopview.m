//
//  BTTShowErcodePopview.m
//  Hybird_1e3c3b
//
//  Created by Domino on 02/12/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTShowErcodePopview.h"

@implementation BTTShowErcodePopview

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
}

- (void)tap {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

@end
