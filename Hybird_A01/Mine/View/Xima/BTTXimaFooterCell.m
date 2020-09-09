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
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

@end

@implementation BTTXimaFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    
    NSString * firstStr = @"1. 所有游戏厅可随时结算洗码，洗码金额≥";
    NSString * currencyStr = @"￥1元";
    NSString * secondStr = @"可自助提交添加，洗码礼金无上限，可随时申请提款；";
    if ([[IVNetwork savedUserInfo].uiMode isEqualToString:@"CNY"]) {
        currencyStr = @"￥1元";
    } else {
        currencyStr = @"1USDT";
    }
    self.firstLabel.text = [NSString stringWithFormat:@"%@%@%@", firstStr, currencyStr, secondStr];
    
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
