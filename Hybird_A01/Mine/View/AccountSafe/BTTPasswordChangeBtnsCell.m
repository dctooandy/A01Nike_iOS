//
//  BTTPasswordChangeBtnsCell.m
//  Hybird_A01
//
//  Created by Domino on 27/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTPasswordChangeBtnsCell.h"

@interface BTTPasswordChangeBtnsCell ()

@property (weak, nonatomic) IBOutlet UIButton *loginPwdBtn;

@property (weak, nonatomic) IBOutlet UIButton *PTPwdBtn;

@property (weak, nonatomic) IBOutlet UIImageView *loginArrowIcon;

@property (weak, nonatomic) IBOutlet UIImageView *PTArrowIcon;

@end

@implementation BTTPasswordChangeBtnsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.loginPwdBtn.selected = YES;
    [self setupArrow];
}


- (IBAction)loginPwdBtnClick:(UIButton *)sender {
    sender.selected = YES;
    self.PTPwdBtn.selected = NO;
    [self setupArrow];
}


- (IBAction)PTPwdBtnClick:(UIButton *)sender {
    sender.selected = YES;
    self.loginPwdBtn.selected = NO;
    [self setupArrow];
}

- (void)setupArrow {
    self.loginArrowIcon.hidden = !self.loginPwdBtn.selected;
    self.PTArrowIcon.hidden = !self.PTPwdBtn.selected;
}

@end
