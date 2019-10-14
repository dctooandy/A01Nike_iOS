//
//  BTTThisWeekBtnsCell.m
//  Hybird_A01
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTThisWeekBtnsCell.h"

@implementation BTTThisWeekBtnsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.mineSparaterType = BTTMineSparaterTypeNone;
}

- (IBAction)ximaBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)otherBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)ximaRecordBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
           self.buttonClickBlock(sender);
    }
}
@end
