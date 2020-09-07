//
//  BTTAccountBlanceHeaderCell.m
//  Hybird_A01
//
//  Created by Domino on 2018/10/19.
//  Copyright © 2018年 BTT. All rights reserved.
//

#import "BTTAccountBlanceHeaderCell.h"

@interface BTTAccountBlanceHeaderCell ()
@property (weak, nonatomic) IBOutlet UILabel *topTipLabel;

@end

@implementation BTTAccountBlanceHeaderCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.trasferToLocal.enabled = YES;
    if ([[IVNetwork savedUserInfo].uiMode isEqualToString:@"USDT"]) {
        self.topTipLabel.text = @"总余额(USDT)";
    }else{
        self.topTipLabel.text = @"总余额(元)";
    }
}


- (IBAction)totalBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

@end
