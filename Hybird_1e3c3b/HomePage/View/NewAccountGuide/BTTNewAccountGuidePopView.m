//
//  BTTNewAccountGuidePopView.m
//  Hybird_1e3c3b
//
//  Created by Domino on 25/11/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTNewAccountGuidePopView.h"

@implementation BTTNewAccountGuidePopView

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
