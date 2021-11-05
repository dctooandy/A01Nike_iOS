//
//  BTTVIPChangeBtnsCell.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2021/5/4.
//  Copyright © 2021 BTT. All rights reserved.
//

#import "BTTVIPChangeBtnsCell.h"

@interface BTTVIPChangeBtnsCell ()


@property (weak, nonatomic) IBOutlet UIImageView *vipRightIcon;

@property (weak, nonatomic) IBOutlet UIImageView *vipHistoryIcon;

@property (weak, nonatomic) IBOutlet UIImageView *vipActivityIcon;
@end

@implementation BTTVIPChangeBtnsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mineSparaterType = BTTMineSparaterTypeNone;
    self.backgroundColor = [UIColor clearColor];
}



- (IBAction)vipRightBtnClick:(UIButton *)sender {
    sender.selected = YES;
    self.vipHistoryBtn.selected = NO;
    self.vipActivityBtn.selected = NO;
    [self setupArrow];
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}
- (IBAction)vipHistoryBtnClick:(UIButton *)sender {
    sender.selected = YES;
    self.vipRightBtn.selected = NO;
    self.vipActivityBtn.selected = NO;
    [self setupArrow];
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}
- (IBAction)vipActivityBtnClick:(UIButton *)sender {
    sender.selected = YES;
    self.vipRightBtn.selected = NO;
    self.vipHistoryBtn.selected = NO;
    [self setupArrow];
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender);
    }
}

- (void)setupArrow {

    self.vipRightIcon.hidden = !self.vipRightBtn.selected;
    self.vipHistoryIcon.hidden = !self.vipHistoryBtn.selected;
    self.vipActivityIcon.hidden = !self.vipActivityBtn.selected;
}

@end
