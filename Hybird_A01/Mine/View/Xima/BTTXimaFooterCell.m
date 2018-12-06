//
//  BTTXimaFooterCell.m
//  Hybird_A01
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTXimaFooterCell.h"

@interface BTTXimaFooterCell ()

@property (weak, nonatomic) IBOutlet UIButton *otherBtn;

@end

@implementation BTTXimaFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"会员晋级方法"];
//
//    //设置下划线...
//    /*
//     NSUnderlineStyleNone                                    = 0x00, 无下划线
//     NSUnderlineStyleSingle                                  = 0x01, 单行下划线
//     NSUnderlineStyleThick NS_ENUM_AVAILABLE(10_0, 7_0)      = 0x02, 粗的下划线
//     NSUnderlineStyleDouble NS_ENUM_AVAILABLE(10_0, 7_0)     = 0x09, 双下划线
//     */
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString length]}];

    [tncString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"007AFF"]  range:NSMakeRange(0,[tncString length])];
    [tncString addAttribute:NSUnderlineColorAttributeName value:[UIColor colorWithHexString:@"007AFF"] range:(NSRange){0,[tncString length]}];
    [self.otherBtn setAttributedTitle:tncString forState:UIControlStateNormal];
}

- (IBAction)btnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

@end
