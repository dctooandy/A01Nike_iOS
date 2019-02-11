//
//  BTTLoginNoRegisterCell.m
//  Hybird_A01
//
//  Created by Domino on 11/02/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTLoginNoRegisterCell.h"

@interface BTTLoginNoRegisterCell ()

@property (weak, nonatomic) IBOutlet UIButton *goRegisterBtn;


@end

@implementation BTTLoginNoRegisterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"极速开户"];
    
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString length]}];
    
    [tncString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"499BF7"]  range:NSMakeRange(0,[tncString length])];
    [tncString addAttribute:NSUnderlineColorAttributeName value:[UIColor colorWithHexString:@"499BF7"] range:(NSRange){0,[tncString length]}];
    [self.goRegisterBtn setAttributedTitle:tncString forState:UIControlStateNormal];
}

- (IBAction)goRegisterClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}


@end
