//
//  BTTThisWeekBtnsCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTThisWeekBtnsCell.h"
@interface BTTThisWeekBtnsCell()
@property (weak, nonatomic) IBOutlet UIButton *customerBtn;

@end
@implementation BTTThisWeekBtnsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"212229"];
    self.mineSparaterType = BTTMineSparaterTypeNone;
}

- (void)configForExtraCustomerBtn:(BOOL)sender
{
    [_customerBtn setHidden:!sender];
}

- (IBAction)ximaBtnClick:(UIButton *)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)customerServiceClick:(UIButton *)sender {
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
