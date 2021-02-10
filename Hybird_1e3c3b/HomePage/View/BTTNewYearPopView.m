//
//  BTTNewYearPopView.m
//  Hybird_1e3c3b
//
//  Created by JerryHU on 2021/2/10.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTNewYearPopView.h"

@interface BTTNewYearPopView()

@end

@implementation BTTNewYearPopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)btnAction:(UIButton *)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}

- (IBAction)closeBtnAction:(UIButton *)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

@end
