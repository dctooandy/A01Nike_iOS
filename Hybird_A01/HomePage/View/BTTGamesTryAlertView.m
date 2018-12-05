//
//  BTTGamesTryAlertView.m
//  Hybird_A01
//
//  Created by Domino on 04/12/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTGamesTryAlertView.h"

@implementation BTTGamesTryAlertView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
}

- (IBAction)confirmClick:(UIButton *)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}

- (IBAction)loginClick:(UIButton *)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}


@end
