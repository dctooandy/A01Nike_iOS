//
//  BTTXimaSuccessBtnsCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 24/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTXimaSuccessBtnsCell.h"

@interface BTTXimaSuccessBtnsCell ()
@property (weak, nonatomic) IBOutlet UIButton *successLeftBtn;
@property (weak, nonatomic) IBOutlet UIButton *successRightBtn;
@end

@implementation BTTXimaSuccessBtnsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    if ([[IVNetwork savedUserInfo].xmTransferCurrency isEqualToString:@"USDT"]) {
        [self.successLeftBtn setTitle:@"前往洗码转账记录" forState:UIControlStateNormal];
        [self.successRightBtn setTitle:@"切换币多多账户" forState:UIControlStateNormal];
    } else {
        [self.successLeftBtn setTitle:@"继续洗码" forState:UIControlStateNormal];
        [self.successRightBtn setTitle:@"查看洗码记录" forState:UIControlStateNormal];
    }
}

- (IBAction)continueClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
    
}

- (IBAction)ximaRecordClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

@end
