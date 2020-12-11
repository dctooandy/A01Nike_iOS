//
//  BTTForgetPasswordCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 12/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTForgetPasswordCell.h"

@implementation BTTForgetPasswordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"忘记账号、密码?"];
    
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString length]}];
    
    [tncString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"818791"]  range:NSMakeRange(0,[tncString length])];
    [tncString addAttribute:NSUnderlineColorAttributeName value:[UIColor colorWithHexString:@"818791"] range:(NSRange){0,[tncString length]}];
    [self.forgotLabel setAttributedTitle:tncString forState:UIControlStateNormal];
}


- (IBAction)forgetClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

@end
