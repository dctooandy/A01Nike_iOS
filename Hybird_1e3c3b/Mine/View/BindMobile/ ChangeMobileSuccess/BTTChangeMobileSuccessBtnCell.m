//
//  BTTChangeMobileSuccessBtnCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 19/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTChangeMobileSuccessBtnCell.h"

@interface BTTChangeMobileSuccessBtnCell()
@property (weak, nonatomic) IBOutlet UIButton *cardInfoBtn;
@end

@implementation BTTChangeMobileSuccessBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.memberCenterBtn.layer.cornerRadius = 4;
    
    [self.cardInfoBtn setTitle:[[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"] ? @"钱包管理":@"银行卡资料" forState:UIControlStateNormal];
}
- (IBAction)backMemberCenter:(id)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

@end
