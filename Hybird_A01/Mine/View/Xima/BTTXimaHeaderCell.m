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
    self.btnOneType = BTTXimaHeaderBtnOneTypeLastWeekNormal;
    self.btnTwoType = BTTXimaHeaderBtnTwoTypeThisWeekSelect;
    self.btnTwoType = BTTXimaHeaderBtnTwoTypeThisWeekNormal;

}

- (IBAction)lastWeekBtnClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"本周"]) {
        self.btnOneType = BTTXimaHeaderBtnOneTypeLastWeekNormal;
        self.btnTwoType = BTTXimaHeaderBtnTwoTypeThisWeekSelect;
        [self thisWeekBtnClick:self.thisWeekBtn];
    } else {
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
    self.thisWeekBtn.selected = YES;
    self.thisWeekArrow.hidden = !self.thisWeekBtn.selected;
    self.lastWeekBtn.selected = NO;
    self.lastWeekArrow.hidden = !self.lastWeekBtn.selected;
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }

}

- (void)setBtnOneType:(BTTXimaHeaderBtnOneType)btnOneType {
    _btnOneType = btnOneType;
    if (_btnOneType == BTTXimaHeaderBtnOneTypeThisWeekNormal) {
        [self.lastWeekBtn setTitle:@"本周" forState:UIControlStateNormal];
    } else if (_btnOneType == BTTXimaHeaderBtnOneTypeLastWeekSelect) {
        [self.lastWeekBtn setTitle:@"上周" forState:UIControlStateSelected];
    } else if (_btnOneType == BTTXimaHeaderBtnOneTypeThisWeekSelect) {
        [self.lastWeekBtn setTitle:@"本周" forState:UIControlStateSelected];
    } else if (_btnOneType == BTTXimaHeaderBtnOneTypeLastWeekNormal) {
        [self.lastWeekBtn setTitle:@"上周" forState:UIControlStateNormal];
    }
}

- (void)setBtnTwoType:(BTTXimaHeaderBtnTwoType)btnTwoType {
    _btnTwoType = btnTwoType;
    if (_btnTwoType == BTTXimaHeaderBtnTwoTypeThisWeekSelect) {
        [self.thisWeekBtn setTitle:@"本周" forState:UIControlStateSelected];
    } else if (_btnTwoType == BTTXimaHeaderBtnTwoTypeOtherSelect) {
        [self.thisWeekBtn setTitle:@"其他游戏厅" forState:UIControlStateSelected];
    } else if (_btnTwoType == BTTXimaHeaderBtnTwoTypeThisWeekNormal) {
        [self.thisWeekBtn setTitle:@"本周" forState:UIControlStateNormal];
    } else if (_btnTwoType == BTTXimaHeaderBtnTwoTypeOtherNormal) {
        [self.thisWeekBtn setTitle:@"其他游戏厅" forState:UIControlStateNormal];
    }
}

@end
