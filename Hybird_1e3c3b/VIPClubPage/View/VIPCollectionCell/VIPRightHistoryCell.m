//
//  VIPRightHistoryCell.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/5/12.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "VIPRightHistoryCell.h"

@interface VIPRightHistoryCell()
@property (weak, nonatomic) IBOutlet UIButton *imageTapBtn;

@end
@implementation VIPRightHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.backgroundColor = [UIColor clearColor];
    // Initialization code
}
- (IBAction)imageTapButtonAction:(id)sender {
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

@end
