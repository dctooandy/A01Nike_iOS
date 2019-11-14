//
//  BTTLoginOrRegisterBtsView.m
//  Hybird_A01
//
//  Created by Domino on 13/11/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTLoginOrRegisterBtsView.h"

@implementation BTTLoginOrRegisterBtsView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.image = ImageNamed(@"btns_bg");
}


- (IBAction)registerClick:(UIButton *)sender {
    if (_btnClickBlock) {
        _btnClickBlock(sender);
    }
}

- (IBAction)loginClick:(UIButton *)sender {
    if (_btnClickBlock) {
        _btnClickBlock(sender);
    }
}


@end
