//
//  BTTAndroid88PopView.m
//  Hybird_1e3c3b
//
//  Created by Domino on 13/05/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTAndroid88PopView.h"

@implementation BTTAndroid88PopView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (IBAction)detailBtnClick:(UIButton *)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}
@end
