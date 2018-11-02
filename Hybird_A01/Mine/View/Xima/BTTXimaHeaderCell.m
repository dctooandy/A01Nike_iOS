//
//  BTTXimaHeaderCell.m
//  Hybird_A01
//
//  Created by Domino on 29/10/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import "BTTXimaHeaderCell.h"


@interface BTTXimaHeaderCell ()

@property (weak, nonatomic) IBOutlet UIButton *lastWeekBtn;

@property (weak, nonatomic) IBOutlet UIButton *thisWeekBtn;

@property (weak, nonatomic) IBOutlet UIImageView *thisWeekArrow;

@property (weak, nonatomic) IBOutlet UIImageView *lastWeekArrow;



@end

@implementation BTTXimaHeaderCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.thisWeekBtn.selected = YES;
    self.thisWeekArrow.hidden = !self.thisWeekBtn.selected;
}

- (IBAction)lastWeekBtnClick:(UIButton *)sender {
    if (!self.lastWeekBtn.selected) {
        self.thisWeekBtn.selected = NO;
        self.thisWeekArrow.hidden = !self.thisWeekBtn.selected;
        self.lastWeekBtn.selected = YES;
        self.lastWeekArrow.hidden = !self.lastWeekBtn.selected;
        if (self.buttonClickBlock) {
            self.buttonClickBlock(sender);
        }
    }
}


- (IBAction)thisWeekBtnClick:(UIButton *)sender {
    if (!self.thisWeekBtn.selected) {
        self.thisWeekBtn.selected = YES;
        self.thisWeekArrow.hidden = !self.thisWeekBtn.selected;
        self.lastWeekBtn.selected = NO;
        self.lastWeekArrow.hidden = !self.lastWeekBtn.selected;
        if (self.buttonClickBlock) {
            self.buttonClickBlock(sender);
        }
    }
}


@end
