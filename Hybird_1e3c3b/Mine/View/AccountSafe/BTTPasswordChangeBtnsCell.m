//
//  BTTPasswordChangeBtnsCell.m
//  Hybird_1e3c3b
//
//  Created by Domino on 27/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTPasswordChangeBtnsCell.h"

@interface BTTPasswordChangeBtnsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *loginArrowIcon;

@property (weak, nonatomic) IBOutlet UIImageView *withdrawArrowIcon;

@property (weak, nonatomic) IBOutlet UIImageView *PTArrowIcon;

@end

@implementation BTTPasswordChangeBtnsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
}

- (IBAction)loginPwdBtnClick:(UIButton *)sender {
    sender.selected = YES;
    self.withdrawPwdBtn.selected = NO;
    self.PTPwdBtn.selected = NO;
    [self setupArrow];
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)withdrawPwdBtnClick:(UIButton *)sender {
    sender.selected = YES;
    self.loginPwdBtn.selected = NO;
    self.PTPwdBtn.selected = NO;
    [self setupArrow];
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (IBAction)PTPwdBtnClick:(UIButton *)sender {
    sender.selected = YES;
    self.loginPwdBtn.selected = NO;
    self.withdrawPwdBtn.selected = NO;
    [self setupArrow];
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (void)setupArrow {
    self.loginArrowIcon.hidden = !self.loginPwdBtn.selected;
    self.withdrawArrowIcon.hidden = !self.withdrawPwdBtn.selected;
    self.PTArrowIcon.hidden = !self.PTPwdBtn.selected;
}

@end
