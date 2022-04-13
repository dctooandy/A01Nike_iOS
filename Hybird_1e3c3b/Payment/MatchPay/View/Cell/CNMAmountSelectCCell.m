//
//  CNMAmountSelectCCell.m
//  Hybird_1e3c3b
//
//  Created by cean on 2/16/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNMAmountSelectCCell.h"

@implementation CNMAmountSelectCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.checkIV.layer.borderWidth = 1;
    self.checkIV.layer.borderColor = kHexColor(0x55AAF5).CGColor;
    self.checkIV.layer.cornerRadius = 4;
    self.checkIV.layer.masksToBounds = YES;
    self.checkIV.hidden = YES;
    self.bgView.backgroundColor = kHexColorAlpha(0x292D36, 0.52);
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = kHexColorAlpha(0xFFFFFF, 0.2).CGColor;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.checkIV.hidden = !selected;
}
@end
