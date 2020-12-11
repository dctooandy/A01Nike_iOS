//
//  BTTBJLPopView.m
//  Hybird_1e3c3b
//
//  Created by Jairo on 14/08/2020.
//  Copyright © 2020 BTT. All rights reserved.
//

#import "BTTBJLPopView.h"

@implementation BTTBJLPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
}

-(void)tap {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (IBAction)closeBtn:(UIButton *)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

@end
