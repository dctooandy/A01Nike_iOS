//
//  BTTJayPopView.m
//  Hybird_1e3c3b
//
//  Created by Domino on 06/11/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTJayPopView.h"

@implementation BTTJayPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (IBAction)detailBtn:(UIButton *)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}


- (IBAction)closeBtn:(UIButton *)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}


@end
