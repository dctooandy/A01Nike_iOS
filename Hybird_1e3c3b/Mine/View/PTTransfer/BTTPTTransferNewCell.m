//
//  BTTPTTransferCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 26/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTPTTransferNewCell.h"

@interface BTTPTTransferNewCell ()

@end

@implementation BTTPTTransferNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.PTBtn.selected = YES;
    self.useableBtn.userInteractionEnabled = YES;
    self.PTBtn.userInteractionEnabled = YES;
    self.mineSparaterType = BTTMineSparaterTypeNone;
    if (SCREEN_WIDTH == 414) {
        self.userableLabel.font = kFontSystem(20);
        self.PTLabel.font = kFontSystem(20);
    } else {
        self.userableLabel.font = kFontSystem(13);
        self.PTLabel.font = kFontSystem(13);
    }
}

- (IBAction)useableBtnClick:(UIButton *)sender {
    sender.selected = YES;
    self.PTBtn.selected = NO;
    self.arrowImageView.image = ImageNamed(@"transfer_arrow_left");
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}


- (IBAction)PTBtnClick:(UIButton *)sender {
    sender.selected = YES;
    self.useableBtn.selected = NO;
    self.arrowImageView.image = ImageNamed(@"transfer_arrow");
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}


@end
