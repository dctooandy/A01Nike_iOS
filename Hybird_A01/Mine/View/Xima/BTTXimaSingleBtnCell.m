//
//  BTTXimaSingleBtnCell.m
//  Hybird_A01
//
//  Created by Domino on 22/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTXimaSingleBtnCell.h"

@implementation BTTXimaSingleBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
}


- (IBAction)otherBtn:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}


@end
