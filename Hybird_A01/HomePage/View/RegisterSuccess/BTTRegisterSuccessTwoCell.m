//
//  BTTRegisterSuccessTwoCell.m
//  Hybird_A01
//
//  Created by Domino on 11/12/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTRegisterSuccessTwoCell.h"

@interface BTTRegisterSuccessTwoCell ()

@property (weak, nonatomic) IBOutlet UIButton *changeBtn;


@end

@implementation BTTRegisterSuccessTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"修改密码"];
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString length]}];
    
    [tncString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"007AFF"]  range:NSMakeRange(0,[tncString length])];
    [tncString addAttribute:NSUnderlineColorAttributeName value:[UIColor colorWithHexString:@"007AFF"] range:(NSRange){0,[tncString length]}];
    [self.changeBtn setAttributedTitle:tncString forState:UIControlStateNormal];
}

- (IBAction)changeBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

@end
