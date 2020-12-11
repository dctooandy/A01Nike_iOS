//
//  BTTXimaRecordButtonsView.m
//  Hybird_1e3c3b
//
//  Created by Domino on 10/10/2019.
//  Copyright © 2019 BTT. All rights reserved.
//

#import "BTTXimaRecordButtonsView.h"

@interface BTTXimaRecordButtonsView ()

@property (weak, nonatomic) IBOutlet UIButton *lastWeekBtn;

@property (weak, nonatomic) IBOutlet UIButton *thisWeekBtn;

@property (weak, nonatomic) IBOutlet UIImageView *thisWeekFlagImageView;

@property (weak, nonatomic) IBOutlet UIImageView *lastWeekFlagImageView;

@end

@implementation BTTXimaRecordButtonsView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.thisWeekFlagImageView.hidden = !self.thisWeekBtn.selected;
    self.lastWeekFlagImageView.hidden = !self.lastWeekBtn.selected;
    
}

- (IBAction)lastWeekBtnClick:(UIButton *)sender {
    sender.selected = YES;
    self.thisWeekBtn.selected = NO;
    self.thisWeekFlagImageView.hidden = !self.thisWeekBtn.selected;
    self.lastWeekFlagImageView.hidden = !self.lastWeekBtn.selected;
    if (_btnClickBlock) {
        _btnClickBlock(sender);
    }
}

- (IBAction)thisWeekBtnClick:(UIButton *)sender {
    sender.selected = YES;
    self.lastWeekBtn.selected = NO;
    self.thisWeekFlagImageView.hidden = !self.thisWeekBtn.selected;
    self.lastWeekFlagImageView.hidden = !self.lastWeekBtn.selected;
    if (_btnClickBlock) {
        _btnClickBlock(sender);
    }
}



@end
